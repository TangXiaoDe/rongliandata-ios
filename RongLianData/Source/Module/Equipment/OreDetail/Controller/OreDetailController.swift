//
//  OreDetailController.swift
//  MallProject
//
//  Created by zhaowei on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  挖坑明细
    
import Foundation
import UIKit
import ChainOneKit

class OreDetailController: BaseViewController
{
    // MARK: - Internal Property
    fileprivate var listModel: EquipmentListModel
    // MARK: - Private Property
    fileprivate let topBgView: UIImageView = UIImageView()
    fileprivate let navBar: AppHomeNavStatusView = AppHomeNavStatusView.init()
    let scrollView: UIScrollView = UIScrollView.init()
    fileprivate let headerView: OreDetailHeaderView = OreDetailHeaderView.init()
    fileprivate let itemContainer: UIView = UIView.init()
    
    fileprivate var sourceList: [AssetListModel] = []
    fileprivate var offset: Int = 0
    fileprivate let limit: Int = 20
    
    fileprivate let topBgHeight: CGFloat = CGSize.init(width: 375, height: 205).scaleAspectForWidth(kScreenWidth).height
    fileprivate let headerViewNoGroupHeight: CGFloat = OreDetailHeaderView.noGroupViewHeight
    fileprivate let headerViewHasGroupHeight: CGFloat = OreDetailHeaderView.hasGroupViewHeight
    fileprivate let headerViewHeight: CGFloat = OreDetailHeaderView.viewHeight
    fileprivate let headerViewTopMargin: CGFloat = 12
    fileprivate let lrMargin: CGFloat = 12
    
    fileprivate let itemContainerTopMargin: CGFloat = 12
    fileprivate let itemVerMargin: CGFloat = 0
    fileprivate let itemBottomMargin: CGFloat = 0//12
    fileprivate let itemTopMargin: CGFloat = 0 //12     // -header.bottom
    fileprivate let itemViewTagBase: Int = 250

    // MARK: - Initialize Function
    init(listModel: EquipmentListModel) {
        self.listModel = listModel
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
extension OreDetailController {
}

// MARK: - LifeCircle/Override Function
extension OreDetailController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
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
extension OreDetailController {
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
        self.navBar.titleLabel.set(text: "收益明细", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.mainText, alignment: .center)
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
        self.headerView.backgroundColor = UIColor.white
        self.headerView.set(cornerRadius: 10)
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.headerViewTopMargin)
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            //let height: CGFloat = self.listModel.group.isEmpty ? self.headerViewNoGroupHeight : self.headerViewHasGroupHeight
            make.height.equalTo(self.headerViewHeight)
        }
        // 2. itemContainer
        scrollView.addSubview(self.itemContainer)
        self.itemContainer.backgroundColor = AppColor.white
        self.itemContainer.set(cornerRadius: 12)
        self.itemContainer.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenWidth - self.lrMargin * 2.0)
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.headerView.snp.bottom).offset(self.itemContainerTopMargin)
            make.bottom.equalToSuperview()
            let minHeight: CGFloat = kScreenHeight - kNavigationStatusBarHeight - self.headerViewHeight - self.headerViewTopMargin - self.itemContainerTopMargin
            make.height.greaterThanOrEqualTo(minHeight)
        }
    }
    
    /// 数据加载
    fileprivate func setupItemContainer(with models: [AssetListModel]) -> Void {
        //
        self.itemContainer.removeAllSubviews()
        //
        var topView: UIView = self.itemContainer
        for (index, model) in models.enumerated() {
            let itemView = OreDetailItemView.init()
            self.itemContainer.addSubview(itemView)
            itemView.model = model
            //itemView.type = self.listModel.zhiya_type
            //itemView.set(cornerRadius: 10)
            itemView.tag = self.itemViewTagBase + index
            itemView.showTopMargin = index == 0
            itemView.showBottomMargin = index == models.count - 1
            itemView.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(0)
                make.trailing.equalToSuperview().offset(-0)
                if 0 == index {
                    make.top.equalToSuperview().offset(self.itemTopMargin)
                } else {
                    make.top.equalTo(topView.snp.bottom).offset(self.itemVerMargin)
                }
                if index == models.count - 1 {
                    make.bottom.lessThanOrEqualToSuperview().offset(-self.itemBottomMargin)
                }
            }
            topView = itemView
            // tapGR
            //let tapGR: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGRProcess(_:)))
            //itemView.addGestureRecognizer(tapGR)
        }
        self.view.layoutIfNeeded()
    }

}

// MARK: - Data Function
extension OreDetailController {

    // MARK: - Private  数据处理与加载
    fileprivate func initialDataSource() -> Void {
        self.scrollView.mj_header.beginRefreshing()
        self.headerView.model = self.listModel
        //self.setupAsDemo()
    }
    ///
    fileprivate func setupAsDemo() -> Void {
        for index in 0...1 {
            let model = AssetListModel.init()
            self.sourceList.append(model)
        }
        self.headerView.model = nil
        self.setupItemContainer(with: self.sourceList)
        self.scrollView.mj_footer?.isHidden = true
    }

}

// MARK: - Event Function
extension OreDetailController {

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
        guard tapGR.state == .recognized, let tapView = tapGR.view as? OreDetailItemView, let model = tapView.model else {
            return
        }
    }
    
}

// MARK: - Request Function
extension OreDetailController {

    /// 下拉刷新请求
    fileprivate func refreshRequest(complete: ((_ status: Bool, _ msg: String?, _ models: [AssetListModel]?) -> Void)? = nil) -> Void {
        EquipmentNetworkManager.getEquipAssetDetail(order_id: self.listModel.id, action: .all, type: .fil_issue, offset: 0, limit: self.limit) { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            self.scrollView.mj_header?.endRefreshing()
            self.scrollView.mj_footer?.state = .idle  // 网络错误、没有更多数据时重置
            guard status, let models = models else {
                ToastUtil.showToast(title: msg)
                return
            }
            for model in models {
                model.zone = self.listModel.zone
            }
            self.sourceList = models
            self.offset = self.sourceList.count
            self.setupItemContainer(with: self.sourceList)
            self.scrollView.mj_footer?.isHidden = models.count < self.limit
        }
    }
    
    /// 上拉加载更多请求
    fileprivate func loadMoreRequest() -> Void {
        EquipmentNetworkManager.getEquipAssetDetail(order_id: self.listModel.id, action: .all, type: .fil_issue, offset: self.offset, limit: self.limit) { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            self.scrollView.mj_footer?.endRefreshing()
            guard status, let models = models else {
                ToastUtil.showToast(title: msg)
                return
            }
            for model in models {
                model.zone = self.listModel.zone
            }
            self.sourceList.append(contentsOf: models)
            self.offset = self.sourceList.count
            self.setupItemContainer(with: self.sourceList)
            self.scrollView.mj_footer?.isHidden = models.count < self.limit
        }
    }
}

// MARK: - Enter Page
extension OreDetailController {
    /// 设备详情
    fileprivate func enterEquipmentDetailPage() -> Void {
        
    }
    /// 挖坑明细
    fileprivate func enterOreDetailPage() -> Void {
        
    }
}

// MARK: - Notification Function
extension OreDetailController {
    
}

// MARK: - Extension Function
extension OreDetailController {

}

// MARK: - Delegate Function

// MARK: - <UIScrollViewDelegate>
//extension OreDetailController: UIScrollViewDelegate {
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
extension OreDetailController: AppHomeNavStatusViewProtocol {
    /// 导航栏左侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedLeftItem itemView: UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    /// 导航栏右侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedRightItem itemView: UIButton) -> Void {
    }
}
