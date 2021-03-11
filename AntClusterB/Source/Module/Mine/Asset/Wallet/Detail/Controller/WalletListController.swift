//
//  WalletListController.swift
//  JXProject
//
//  Created by zhaowei on 2020/10/15.
//  Copyright © 2020 ChainOne. All rights reserved.
//

import UIKit
import MJRefresh


/// 钱包流水界面
class WalletListController: BaseTableViewController {

    // MARK: - Internal Property

    let actionType: AssetActionType

    // MARK: - Private Property

    fileprivate var sourceList: [AssetListModel] = []

    // MARK: - Initialize Function
    init(type: AssetListType) {
        self.actionType = type
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension WalletListController {
    func refreshData(complete: ((_ status: Bool, _ msg: String?, _ models: [AssetListModel]?) -> Void)? = nil) -> Void {
        self.refreshDataRequest(complete: complete)
    }

}

// MARK: - LifeCircle Function
extension WalletListController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.hiddenNavBarShadow()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.showNavBarShadow(color: AppColor.navShadow)
    }
}

// MARK: - UI
extension WalletListController {
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
extension WalletListController {
    // MARK: - Private  数据处理与加载
    override func initialDataSource() -> Void {
        self.refreshRequest()
    }

}

// MARK: - Event(事件响应)
extension WalletListController {

}

// MARK: - Request(网络请求)
extension WalletListController {
    /// 下拉刷新请求 - 子类重写实现
    override func refreshRequest() -> Void {
        self.refreshDataRequest()
    }
    /// 上拉加载更多请求 - 子类重写实现
    override func loadMoreRequest() -> Void {
        self.loadmoreDataRequest()
    }

    fileprivate func refreshDataRequest(complete: ((_ status: Bool, _ msg: String?, _ models: [AssetListModel]?) -> Void)? = nil) -> Void {
        AssetNetworkManager.getAssetLogs("fil", action: self.actionType, limit: self.limit, offset: 0) { [weak self](status, msg, models) in
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
        AssetNetworkManager.getAssetLogs("fil", action: self.actionType, limit: self.limit, offset: self.offset) { [weak self](status, msg, models) in
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
extension WalletListController {
    /// 进入FIL提现详情页
    fileprivate func enterFilWithdrawalDetailPage(with model: AssetListModel) -> Void {
        let result = WalletWithdrawResultModel.init(model: model, currency: CurrencyType.fil.rawValue)
        let detailVC = WalletWithdrawResultController.init(result: result)
        self.enterPageVC(detailVC)
    }

}

// MARK: - Notification
extension WalletListController {

}

// MARK: - Extension
extension WalletListController {

}

// MARK: - Delegate Function

// MARK: - <UITableViewDataSource>
extension WalletListController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AssetListCell.cellInTableView(tableView)
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
extension WalletListController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidScroll(scrollView)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableView.automaticDimension
        return AssetListCell.cellHeight
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt\(indexPath.row)")
    }

}
