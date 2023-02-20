//
//  LockDetailController.swift
//  MallProject
//
//  Created by zhaowei on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  锁仓线性收益

import Foundation
import UIKit

class LockDetailController: BaseViewController
{
    // MARK: - Internal Property
    
    fileprivate let id: Int?
    fileprivate let zone: ProductZone
    
    // MARK: - Private Property
    fileprivate let topBgView: UIImageView = UIImageView()
    fileprivate let navBar: AppHomeNavStatusView = AppHomeNavStatusView.init()
    let scrollView: UIScrollView = UIScrollView.init()
    fileprivate let headerView: LockDetailHeaderView = LockDetailHeaderView.init()
    fileprivate let itemContainer: UIView = UIView.init()
    
    fileprivate var detail: LockDetailListModel?
    fileprivate var sourceList: [LockDetailLogModel] = []
    fileprivate var offset: Int = 0
    fileprivate let limit: Int = 20
    
    fileprivate let topBgHeight: CGFloat = CGSize.init(width: 375, height: 205).scaleAspectForWidth(kScreenWidth).height
    fileprivate let headerHeight: CGFloat = LockDetailHeaderView.viewHeight
    fileprivate let headerViewTopMargin: CGFloat = 0
    
    fileprivate let lrMargin: CGFloat = 12
    
    fileprivate let itemContainerTopMargin: CGFloat = 12
    fileprivate let itemVerMargin: CGFloat = 0
    fileprivate let itemBottomMargin: CGFloat = 12
    fileprivate let itemTopMargin: CGFloat = 12     // -header.bottom
    fileprivate let itemViewTagBase: Int = 250

    // MARK: - Initialize Function
    init(id: Int? = nil, zone: ProductZone = .ipfs) {
        self.id = id
        self.zone = zone
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return UIStatusBarStyle.lightContent
//    }
}

// MARK: - Internal Function
extension LockDetailController {
}

// MARK: - LifeCircle/Override Function
extension LockDetailController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
    }

    /// 控制器的view将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.initialDataSource()
    }
    /// 控制器的view即将消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

// MARK: - UI Function
extension LockDetailController {
    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.pageBg
        // 0.topBgView
        self.view.addSubview(self.topBgView)
        self.topBgView.set(cornerRadius: 0)
        self.topBgView.image = UIImage.init(named: "IMG_sb_top_bg")
        self.topBgView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.topBgHeight)
        }
        // 1.nav
        self.view.addSubview(self.navBar)
        self.navBar.titleLabel.set(text: "锁仓\(self.zone.rawValue.uppercased())-线性收益", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor.init(hex: 0x333333), alignment: .center)
        self.navBar.leftItem.setImage(UIImage.init(named: "IMG_navbar_back"), for: .normal)
        self.navBar.delegate = self
        self.navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(kNavigationStatusBarHeight)
        }
        // 3. scrollView
        self.view.addSubview(self.scrollView)
        self.initialScrollView(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
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
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.headerHeight)
            make.width.equalTo(kScreenWidth)
        }
        // 2. itemContainer
        scrollView.addSubview(self.itemContainer)
        self.itemContainer.backgroundColor = UIColor.white
        self.itemContainer.set(cornerRadius: 12)
        self.itemContainer.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.headerView.snp.bottom).offset(self.itemContainerTopMargin)
            make.bottom.equalToSuperview()
        }
    }
    
    /// 数据加载
    fileprivate func setupItemContainer(with models: [LockDetailLogModel]) -> Void {
        self.itemContainer.removeAllSubviews()
        var topView: UIView = self.itemContainer
        for (index, model) in models.enumerated() {
            let itemView = LockDetailItemView.init()
            self.itemContainer.addSubview(itemView)
            itemView.model = model
            //itemView.isFirst = index == 0
            itemView.showBottomLine = true //(index != models.count - 1)
            itemView.tag = self.itemViewTagBase + index
            itemView.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(0)
                make.trailing.equalToSuperview().offset(0)
                //make.height.equalTo(LockDetailItemView.viewHeight)
                if 0 == index {
                    make.top.equalToSuperview().offset(self.itemTopMargin)
                } else {
                    make.top.equalTo(topView.snp.bottom).offset(self.itemVerMargin)
                }
                if index == models.count - 1 {
                    make.bottom.equalToSuperview().offset(-self.itemBottomMargin)
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
extension LockDetailController {

    // MARK: - Private  数据处理与加载
    fileprivate func initialDataSource() -> Void {
        self.headerView.zone = self.zone
        self.scrollView.mj_header.beginRefreshing()
        //self.setupAsDemo()
    }
    ///
    fileprivate func setupAsDemo() -> Void {
        //
        let model = LockDetailListModel.init()
        var logs: [LockDetailLogModel] = []
        for index in 0...10 {
            let model = LockDetailLogModel.init()
            model.amount = 0.2342
            model.created_at = Date.init(timeInterval: -24.0 * 3600.0 * 5, since: Date.init())
            logs.append(model)
        }
        model.logs = logs
        //
        self.detail = model
        self.headerView.model = model
        self.sourceList = model.logs
        self.setupItemContainer(with: self.sourceList)
        self.offset = self.sourceList.count
        self.scrollView.mj_footer.isHidden = model.logs.count < self.limit
    }

}

// MARK: - Event Function
extension LockDetailController {

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
        guard tapGR.state == .recognized, let tapView = tapGR.view as? LockDetailItemView, let model = tapView.model else {
            return
        }
    }
    
}

// MARK: - Request Function
extension LockDetailController {

    /// 下拉刷新请求
    fileprivate func refreshRequest(complete: ((_ status: Bool, _ msg: String?, _ models: [EquipmentListModel]?) -> Void)? = nil) -> Void {
        EquipmentNetworkManager.getEquipLinearRelease(id: self.id, offset: 0, limit: self.limit) { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            self.scrollView.mj_header.endRefreshing()
            self.scrollView.mj_footer.state = .idle
            guard status, let model = model else {
                Toast.showToast(title: msg)
                return
            }
            self.detail = model
            self.headerView.model = model
            self.sourceList = model.logs
            self.setupItemContainer(with: self.sourceList)
            self.offset = self.sourceList.count
            self.scrollView.mj_footer.isHidden = model.logs.count < self.limit
        }
    }
    
    /// 上拉加载更多请求
    fileprivate func loadMoreRequest() -> Void {
        EquipmentNetworkManager.getEquipLinearRelease(id: self.id, offset: self.offset, limit: self.limit) { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            self.scrollView.mj_footer.endRefreshing()
            guard status, let model = model else {
                Toast.showToast(title: msg)
                self.scrollView.mj_footer.endRefreshingWithWeakNetwork()
                return
            }
            self.sourceList.append(contentsOf: model.logs)
            self.setupItemContainer(with: self.sourceList)
            self.offset = self.sourceList.count
            if model.logs.isEmpty {
                self.scrollView.mj_footer.endRefreshingWithNoMoreData()
            }
        }
    }

}

// MARK: - Enter Page
extension LockDetailController {
    /// 设备详情
    fileprivate func enterEquipmentDetailPage() -> Void {
        
    }
    /// 挖坑明细
    fileprivate func enterOreDetailPage() -> Void {
        
    }
}

// MARK: - Notification Function
extension LockDetailController {
    
}

// MARK: - Extension Function
extension LockDetailController {

}

// MARK: - Delegate Function

// MARK: - <UIScrollViewDelegate>
//extension LockDetailController: UIScrollViewDelegate {
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
extension LockDetailController: AppHomeNavStatusViewProtocol {
    /// 导航栏左侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedLeftItem itemView: UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    /// 导航栏右侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedRightItem itemView: UIButton) -> Void {
    }
}
