//
//  AssetDetailNewHomeController.swift
//  RongLianData
//
//  Created by 小唐 on 2023/2/19.
//  Copyright © 2023 ChainOne. All rights reserved.
//

import UIKit
import ChainOneKit

class AssetDetailNewHomeController: BaseViewController {
    
    // MARK: - Internal Property
    
    fileprivate let model: EquipmentDetailModel
    
    // MARK: - Private Property

    
    fileprivate let titleView = AssetDetailTitleView.init(themeColor: AppColor.theme)
    fileprivate let cateView: AsssetDetailCateView = AsssetDetailCateView.init()
    fileprivate let tableView: BaseTableView = BaseTableView(frame: CGRect.zero, style: .plain)
    
    
    /// 分类：全部(all)、抵押(fil_pawn)、锁仓(fil_lock)、可用(fil_available)
    fileprivate var cateList: [EquipmentAssetType] = [EquipmentAssetType.all, EquipmentAssetType.fil_pawn, EquipmentAssetType.fil_lock, EquipmentAssetType.fil_available]
    
    
    fileprivate let titleViewH: CGFloat = AssetDetailTitleView.viewHeight
    fileprivate let cateViewH: CGFloat = AsssetDetailCateView.viewHeight

    
    fileprivate let limit: Int = 20
    fileprivate var offset: Int = 0

    
    fileprivate var sourceList: [AssetListModel] = []
    
    fileprivate var selectType: AssetListType = .all
    fileprivate var selectCate: EquipmentAssetType = .all


    // MARK: - Initialize Function

    init(model: EquipmentDetailModel, type: AssetListType = .all, cate: EquipmentAssetType = .all) {
        self.model = model
        self.selectType = type
        self.selectCate = cate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Internal Function

// MARK: - LifeCircle Function
extension AssetDetailNewHomeController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - UI
extension AssetDetailNewHomeController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.pageBg
        // navigation
        self.navigationItem.title = "资产明细"
        // 1. titleView
        self.view.addSubview(self.titleView)
        self.titleView.delegate = self
        self.titleView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.titleViewH)
        }
        self.titleView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: 0, margin2: 0)
        // 2. cateView
        self.view.addSubview(self.cateView)
        self.cateView.delegate = self
        self.cateView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.titleView.snp.bottom)
            make.height.equalTo(self.cateViewH)
        }
        // 3. tableView
        self.view.addSubview(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 250
        self.tableView.backgroundColor = AppColor.pageBg
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        self.tableView.mj_header = XDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        self.tableView.mj_footer = XDRefreshFooter(refreshingTarget: self, refreshingAction: #selector(footerLoadMore))
        self.tableView.mj_header.isHidden = false
        self.tableView.mj_footer.isHidden = true
        self.tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.cateView.snp.bottom)
        }
    }

}

// MARK: - Data(数据处理与加载)
extension AssetDetailNewHomeController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        self.cateView.models = self.cateList
        self.tableView.mj_header.beginRefreshing()
        //self.setupAsDemo()
    }
    
    ///
    fileprivate func setupAsDemo() -> Void {
        for i in 0...4 {
            self.sourceList.append(AssetListModel.init())
        }
        self.tableView.reloadData()
    }
        
}

// MARK: - Event(事件响应)
extension AssetDetailNewHomeController {

    /// 下拉刷新
    @objc fileprivate func headerRefresh() -> Void {
        self.refreshRequest()
    }
    /// 上拉加载更多
    @objc fileprivate func footerLoadMore() -> Void {
        self.loadMoreRequest()
    }
    
}

// MARK: - Request
extension AssetDetailNewHomeController {
    
    
    fileprivate func refreshRequest() -> Void {
        EquipmentNetworkManager.getEquipAssetDetail(order_id: self.model.id, action: self.selectType, type: self.selectCate, offset: 0, limit: self.limit) { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.state = .idle  // 网络错误、没有更多数据时重置
            guard status, let models = models else {
                Toast.showToast(title: msg)
                self.tableView.showDefaultEmpty = self.sourceList.isEmpty
                return
            }
            self.sourceList = models
            self.offset = models.count
            self.tableView.mj_footer?.isHidden = models.count < self.limit
            self.tableView.showDefaultEmpty = self.sourceList.isEmpty
            self.tableView.reloadData()
        }
    }

    fileprivate func loadMoreRequest() -> Void {
        EquipmentNetworkManager.getEquipAssetDetail(order_id: self.model.id, action: self.selectType, type: self.selectCate, offset: self.offset, limit: self.limit) { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            self.tableView.mj_footer?.endRefreshing()
            guard status, let models = models else {
                return
            }
            self.sourceList.append(contentsOf: models)
            self.offset = self.sourceList.count
            if models.count < self.limit {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            self.tableView.reloadData()
        }
    }

    
}

// MARK: - EnterPage
extension AssetDetailNewHomeController {

}

// MARK: - Notification
extension AssetDetailNewHomeController {

}

// MARK: - Extension Function
extension AssetDetailNewHomeController {

}

// MARK: - Delegate Function

// MARK: - <AssetDetailTitleViewProtocol>
extension AssetDetailNewHomeController: AssetDetailTitleViewProtocol {
    func titleView(_ titleView: AssetDetailTitleView, didClickedAt index: Int, with title: String) {
        switch title {
        case "全部":
            self.selectType = .all
        case "收入":
            self.selectType = .income
        case "支出":
            self.selectType = .outcome
        default:
            break
        }
        self.tableView.mj_header.beginRefreshing()
    }
}

// MARK: - <AsssetDetailCateViewProtocol>
extension AssetDetailNewHomeController: AsssetDetailCateViewProtocol {

    ///
    func titleView(_ titleView: AsssetDetailCateView, didClickedAt index: Int, with cate: EquipmentAssetType) -> Void {
        self.selectCate = cate
        self.tableView.mj_header.beginRefreshing()
    }
    
}


// MARK: - <UITableViewDataSource>
extension AssetDetailNewHomeController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AssetDetailListCell.cellInTableView(tableView)
        cell.model = self.sourceList[indexPath.row]
        cell.isFirst = indexPath.row == 0
        return cell
    }

}

// MARK: - <UITableViewDelegate>
extension AssetDetailNewHomeController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //return AssetDetailListCell.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt\(indexPath.row)")
    }

}


