//
//  AssetDetailHomeListController.swift
//  MallProject
//
//  Created by zhaowei on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit
import MJRefresh

/// 资产明细流水界面
class AssetDetailHomeListController: BaseTableViewController {

    // MARK: - Internal Property

    fileprivate var model: EquipmentDetailModel
    fileprivate let actionType: AssetActionType
    fileprivate var assetType: EquipmentAssetType = .all

    // MARK: - Private Property

    fileprivate var sourceList: [AssetListModel] = []

    // MARK: - Initialize Function
    init(type: AssetListType, model: EquipmentDetailModel) {
        self.actionType = type
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension AssetDetailHomeListController {
    func refreshData(complete: ((_ status: Bool, _ msg: String?, _ models: [AssetListModel]?) -> Void)? = nil) -> Void {
        self.refreshDataRequest(complete: complete)
    }

}

// MARK: - LifeCircle Function
extension AssetDetailHomeListController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(assetRefreshNotificationProcess(_:)), name: AppNotificationName.Equipment.assetTypeChange, object: nil)
    }

}

// MARK: - UI
extension AssetDetailHomeListController {
    override func initialUI() -> Void {
        super.initialUI()
        self.view.backgroundColor = UIColor.white
        // 1. navigationbar
        // 2. tableView
        self.tableView.backgroundColor = UIColor.white
        self.tableView.mj_header?.isHidden = false
        // 顶部位置 的版本适配
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else if #available(iOS 9.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

}

// MARK: - Data(数据处理与加载)
extension AssetDetailHomeListController {
    // MARK: - Private  数据处理与加载
    override func initialDataSource() -> Void {
        self.refreshRequest()
    }

}

// MARK: - Event(事件响应)
extension AssetDetailHomeListController {

}

// MARK: - Request(网络请求)
extension AssetDetailHomeListController {
    /// 下拉刷新请求 - 子类重写实现
    override func refreshRequest() -> Void {
        self.refreshDataRequest()
    }
    /// 上拉加载更多请求 - 子类重写实现
    override func loadMoreRequest() -> Void {
        self.loadmoreDataRequest()
    }

    fileprivate func refreshDataRequest(complete: ((_ status: Bool, _ msg: String?, _ models: [AssetListModel]?) -> Void)? = nil) -> Void {
        EquipmentNetworkManager.getEquipAssetDetail(order_id: self.model.id, action: self.actionType, type: self.assetType, offset: 0, limit: self.limit) { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.state = .idle  // 网络错误、没有更多数据时重置
            guard status, let models = models else {
                Toast.showToast(title: msg)
                self.tableView.showDefaultEmpty = self.sourceList.isEmpty
                complete?(status, msg, nil)
                return
            }
            self.sourceList = models
            self.offset = models.count
            self.tableView.mj_footer?.isHidden = models.count < self.limit
            self.tableView.showDefaultEmpty = self.sourceList.isEmpty
            self.tableView.reloadData()
            complete?(status, msg, models)
        }
    }

    fileprivate func loadmoreDataRequest(complete: ((_ status: Bool, _ msg: String?, _ models: [AssetListModel]?) -> Void)? = nil) -> Void {
        EquipmentNetworkManager.getEquipAssetDetail(order_id: self.model.id, action: self.actionType, type: self.assetType, offset: self.offset, limit: self.limit) { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            self.tableView.mj_footer?.endRefreshing()
            guard status, let models = models else {
                complete?(status, msg, nil)
                return
            }
            self.sourceList.append(contentsOf: models)
            self.offset = self.sourceList.count
            if models.count < self.limit {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            self.tableView.reloadData()
            complete?(status, msg, models)
        }
    }

}

// MARK: - Enter Page
extension AssetDetailHomeListController {

}

// MARK: - Notification
extension AssetDetailHomeListController {
    /// 资产刷新通知处理
    @objc fileprivate func assetRefreshNotificationProcess(_ notification: Notification) {
        guard let type = notification.object as? EquipmentAssetType else {
            return
        }
        self.assetType = type
        self.tableView.mj_header.beginRefreshing()
    }
}

// MARK: - Extension
extension AssetDetailHomeListController {

}

// MARK: - Delegate Function

// MARK: - <UITableViewDataSource>
extension AssetDetailHomeListController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AssetDetailListCell.cellInTableView(tableView)
        cell.model = self.sourceList[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 0.01))
        return header
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 0.01))
        return footer
    }
}

// MARK: - <UITableViewDelegate>
extension AssetDetailHomeListController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidScroll(scrollView)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableView.automaticDimension
        return AssetDetailListCell.cellHeight
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt\(indexPath.row)")
    }

}
