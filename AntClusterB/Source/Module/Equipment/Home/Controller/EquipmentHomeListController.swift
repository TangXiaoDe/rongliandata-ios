//
//  EquipmentHomeListController.swift
//  MallProject
//
//  Created by zhaowei on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import Foundation
import UIKit

class EquipmentHomeListController: BaseViewController {
    // MARK: - Internal Property
    fileprivate var zone: ProductZone
    
    override var isSelected: Bool {
        didSet {
            self.firstLoadData()
        }
    }
    
    
    // MARK: - Private Property
    fileprivate let emptyDefaultView: ListEmptyPlaceHolderView = ListEmptyPlaceHolderView()
//    fileprivate let statusBar: UIView = UIView.init()
    let scrollView: UIScrollView = UIScrollView.init()
    fileprivate let headerView: EquipmentHomeHeaderView = EquipmentHomeHeaderView.init()
    fileprivate let itemContainer: UIView = UIView.init()

    fileprivate var sourceList: [EquipmentListModel] = []
    fileprivate var offset: Int = 0
    fileprivate let limit: Int = 20

    fileprivate let headerHeight: CGFloat = EquipmentHomeHeaderView.viewHeight
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let itemVerMargin: CGFloat = 12
    fileprivate let itemTopMargin: CGFloat = 219 - 200
    fileprivate let itemBottomMargin: CGFloat = 12
    fileprivate let itemViewTagBase: Int = 250


    // MARK: - Initialize Function
    init(zone: ProductZone) {
        self.zone = zone
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

// MARK: - Internal Function
extension EquipmentHomeListController {
    
    /// 第一次加载数据
    fileprivate func firstLoadData() -> Void {
        if self.isFirstLoading {
            self.isFirstLoading = false
            self.scrollView.mj_header?.beginRefreshing()
        }
    }
    
    func refreshData(complete: ((_ status: Bool, _ msg: String?, _ models: [EquipmentListModel]?) -> Void)? = nil) -> Void {
        self.refreshRequest(complete: complete)
    }

}

// MARK: - LifeCircle/Override Function
extension EquipmentHomeListController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        //self.initialDataSource()
    }

    /// 控制器的view将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    /// 控制器的view即将消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

// MARK: - UI Function
extension EquipmentHomeListController {
    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.clear
        // 3. scrollView
        self.view.addSubview(self.scrollView)
        self.initialScrollView(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp_bottomMargin)
        }
        // 顶部位置 的版本适配
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else if #available(iOS 9.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    ///
    fileprivate func initialScrollView(_ scrollView: UIScrollView) -> Void {
        scrollView.showsVerticalScrollIndicator = false
//        scrollView.delegate = self
        scrollView.mj_header = XDRefreshHeader.init(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        scrollView.mj_footer = XDRefreshFooter.init(refreshingTarget: self, refreshingAction: #selector(footerLoadMore))
        scrollView.mj_header.isHidden = false
        scrollView.mj_footer.isHidden = true
        // 1. headerView
        scrollView.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.headerHeight)
            make.width.equalTo(kScreenWidth)
        }
        // 2. itemContainer
        scrollView.addSubview(self.itemContainer)
        self.itemContainer.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom).offset(-self.itemTopMargin)
            make.bottom.lessThanOrEqualToSuperview().offset(-itemBottomMargin)
        }
        scrollView.addSubview(self.emptyDefaultView)
        self.emptyDefaultView.isHidden = true
        self.emptyDefaultView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.top.equalTo(self.headerView.snp.bottom).offset(-self.itemTopMargin)
            make.height.equalTo(kScreenWidth)
            make.bottom.lessThanOrEqualToSuperview().offset(-itemBottomMargin)
        }
    }

    /// 数据加载
    fileprivate func setupItemContainer(with models: [EquipmentListModel]) -> Void {
        self.itemContainer.removeAllSubviews()
        var topView: UIView = self.itemContainer
        for (index, model) in models.enumerated() {
            let itemView = EquipmentHomeItemView.init()
            self.itemContainer.addSubview(itemView)
            itemView.model = model
            itemView.delegate = self
            itemView.set(cornerRadius: 10)
            itemView.tag = self.itemViewTagBase + index
            itemView.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(self.lrMargin)
                make.trailing.equalToSuperview().offset(-self.lrMargin)
                if 0 == index {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(topView.snp.bottom).offset(self.itemVerMargin)
                }
                if index == models.count - 1 {
                    make.bottom.equalToSuperview().offset(-self.itemVerMargin)
                }
            }
            topView = itemView
            // tapGR
            let tapGR: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGRProcess(_:)))
            itemView.addGestureRecognizer(tapGR)
        }
        self.view.layoutIfNeeded()
    }

}

// MARK: - Data Function
extension EquipmentHomeListController {

    // MARK: - Private  数据处理与加载
    fileprivate func initialDataSource() -> Void {
        self.scrollView.mj_header.beginRefreshing()
//        self.setupAsDemo()
    }
    ///
    fileprivate func setupAsDemo() -> Void {
//        for index in 0...20 {
//            let model = EquipmentListModel.init(no: "202039\(index)")
//            self.sourceList.append(model)
//        }
//        self.setupItemContainer(with: self.sourceList)
    }

}

// MARK: - Event Function
extension EquipmentHomeListController {

    /// 顶部刷新
    @objc fileprivate func headerRefresh() -> Void {
        self.refreshRequest()
    }
    /// 底部记载更多
    @objc fileprivate func footerLoadMore() -> Void {
        self.loadMoreRequest()
    }

    ///
    @objc fileprivate func tapGRProcess(_ tapGR: UITapGestureRecognizer) -> Void {
        guard tapGR.state == .recognized, let tapView = tapGR.view as? EquipmentHomeItemView, let model = tapView.model else {
            return
        }
    }

}

// MARK: - Request Function
extension EquipmentHomeListController {

    /// 下拉刷新请求
    fileprivate func refreshRequest(complete: ((_ status: Bool, _ msg: String?, _ models: [EquipmentListModel]?) -> Void)? = nil) -> Void {
        EquipmentNetworkManager.getEquipmentHomeData(zone: self.zone, offset: 0, limit: self.limit) { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            complete?(status, msg, model?.list)
            self.scrollView.mj_header?.endRefreshing()
            self.scrollView.mj_footer?.state = .idle  // 网络错误、没有更多数据时重置
            guard status, let model = model else {
                ToastUtil.showToast(title: msg)
                return
            }            
            self.headerView.model = model
            self.sourceList = model.list
            self.offset = self.sourceList.count
            self.setupItemContainer(with: self.sourceList)
            self.scrollView.mj_footer?.isHidden = model.list.count < self.limit
            self.emptyDefaultView.isHidden = !self.sourceList.isEmpty
        }
    }

    /// 上拉加载更多请求
    fileprivate func loadMoreRequest() -> Void {
        EquipmentNetworkManager.getEquipmentHomeData(zone: self.zone, offset: self.offset, limit: self.limit) { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            self.scrollView.mj_footer?.endRefreshing()
            guard status, let model = model else {
                ToastUtil.showToast(title: msg)
                return
            }
            self.headerView.model = model
            self.sourceList.append(contentsOf: model.list)
            self.offset = self.sourceList.count
            self.setupItemContainer(with: self.sourceList)
            self.scrollView.mj_footer?.isHidden = model.list.count < self.limit
        }
    }
}

// MARK: - Enter Page
extension EquipmentHomeListController {
    /// 设备详情
    fileprivate func enterEquipmentDetailPage(model: EquipmentListModel) -> Void {
        let equipDetailVC = EquipmentDetailController.init(model: model)
        self.enterPageVC(equipDetailVC)
    }
    /// 挖坑明细
    fileprivate func enterOreDetailPage(_ model: EquipmentListModel) -> Void {
        let oreDetailVC = OreDetailController.init(listModel: model)
        self.enterPageVC(oreDetailVC)
    }

}

// MARK: - Notification Function
extension EquipmentHomeListController {

}

// MARK: - Extension Function
extension EquipmentHomeListController {

}

// MARK: - Delegate Function

// MARK: - <UIScrollViewDelegate>
//extension EquipmentHomeListController: UIScrollViewDelegate {
//
//    ///
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset
//        if offset.y > self.headerHeight - self.itemTopMargin - kStatusBarHeight {
//            self.statusBar.backgroundColor = AppColor.theme
//        } else {
//            self.statusBar.backgroundColor = UIColor.clear
//        }
//    }
//
//}
// MARK: - Delegate Function
extension EquipmentHomeListController: AppHomeNavStatusViewProtocol {
    /// 导航栏左侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedLeftItem itemView: UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    /// 导航栏右侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedRightItem itemView: UIButton) -> Void {
    }
}
// MARK: - <UIScrollViewDelegate>


extension EquipmentHomeListController: EquipmentHomeItemViewProtocol {
    /// 设备
    func itemView(_ view: EquipmentHomeItemView, didClickEquipmentDetail btn: UIButton) {
        guard let model = view.model else {
            return
        }
        self.enterEquipmentDetailPage(model: model)
    }
    /// 挖坑
    func itemView(_ view: EquipmentHomeItemView, didClickOreDetail btn: UIButton) {
        guard let model = view.model else {
            return
        }
        self.enterOreDetailPage(model)
    }
}
