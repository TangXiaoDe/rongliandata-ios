//
//  EquipmentHomeController.swift
//  AntClusterB
//
//  Created by 小唐 on 2020/12/3.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  设备主页、设备列表页

import UIKit

typealias EquipmentListController = EquipmentHomeController
class EquipmentHomeController: BaseViewController
{

    // MARK: - Internal Property

    // MARK: - Private Property
    
    //fileprivate let statusBar: UIView = UIView.init()
    fileprivate let navBar: AppHomeNavStatusView = AppHomeNavStatusView.init()
    
    fileprivate let topBgView: UIImageView = UIImageView.init()
    
    fileprivate let scrollView: UIScrollView = UIScrollView.init()
    fileprivate let headerView: EquipmentHomeHeaderView = EquipmentHomeHeaderView.init()
    fileprivate let itemContainer: UIView = UIView.init()
    fileprivate let footerView: EquipmentHomeFooterView = EquipmentHomeFooterView.init()
    
    fileprivate var sourceList: [String] = []
    fileprivate var model: EquipmentHomeModel = EquipmentHomeModel.init()
    fileprivate var offset: Int = 0
    fileprivate let limit: Int = 20
    
    fileprivate let topBgViewHeight: CGFloat = CGSize.init(width: 375, height: 194).scaleAspectForWidth(kScreenWidth).height
    
    fileprivate let headerHeight: CGFloat = EquipmentHomeHeaderView.viewHeight
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let itemHeight: CGFloat = EquipmentHomeItemView.viewHeight
    fileprivate let itemVerMargin: CGFloat = 12
    //fileprivate let itemTopMargin: CGFloat = EquipmentHomeHeaderView.valueBottomMargin     // -header.bottom
    fileprivate let itemTopMargin: CGFloat = 0
    fileprivate let itemViewTagBase: Int = 250

    fileprivate let footerHeight: CGFloat = 44


    
    // MARK: - Initialize Function
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle/Override Function
extension EquipmentHomeController {

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
extension EquipmentHomeController {
    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.pageBg
        // 1. topBg
        self.view.addSubview(self.topBgView)
        self.topBgView.image = UIImage.init(named: "IMG_sb_top_bg")
        //self.topBgView.backgroundColor = UIColor.init(hex: 0x282E42)
        //self.topBgView.setupCorners(UIRectCorner.init([UIRectCorner.bottomLeft, UIRectCorner.bottomRight]), selfSize: CGSize.init(width: kScreenWidth, height: self.topBgViewHeight), cornerRadius: 50)
        self.topBgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.topBgViewHeight)
        }
        // 2. navBar
        self.view.addSubview(self.navBar)
        self.navBar.titleLabel.set(text: "设备列表", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor.init(hex: 0x333333), alignment: .center)
        self.navBar.leftItem.isHidden = true
        self.navBar.rightItem.isHidden = true
        self.navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(kNavigationStatusBarHeight)
        }
        // 2. scrollView
        self.view.addSubview(self.scrollView)
        self.initialScrollView(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.navBar.snp.bottom)
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
        scrollView.delegate = self
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
        }
        // 3. footerView
        scrollView.addSubview(self.footerView)
        self.footerView.model = "没有更多数据"
        self.footerView.isHidden = true     // 默认隐藏
        self.footerView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.itemContainer.snp.bottom).offset(0)
            make.height.equalTo(self.footerHeight)
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
                make.height.equalTo(self.itemHeight)
                if 0 == index {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(topView.snp.bottom).offset(self.itemVerMargin)
                }
                if index == models.count - 1 {
                    make.bottom.equalToSuperview()
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
extension EquipmentHomeController {

    // MARK: - Private  数据处理与加载
    fileprivate func initialDataSource() -> Void {
        self.scrollView.mj_header.beginRefreshing()
        //self.setupAsDemo()
        //self.headerView.model = nil
    }
    ///
    fileprivate func setupAsDemo() -> Void {
        for i in 0...25 {
            self.sourceList.append("\(i)")
        }
        //self.setupItemContainer(with: self.sourceList)
    }

}

// MARK: - Event Function
extension EquipmentHomeController {

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
//        self.enterDetailPage(with: model)
        //self.enterMiningDetailPage(with: model)
        self.enterEquipmentDetailPage(with: model)
    }
    
}

// MARK: - Request Function
extension EquipmentHomeController {

    /// 下拉刷新请求
    fileprivate func refreshRequest() -> Void {
        EquipmentNetworkManager.getHomeData(offset: 0, limit: self.limit) { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            self.scrollView.mj_header.endRefreshing()
            self.scrollView.mj_footer.state = .idle
            guard status, let model = model else {
                ToastUtil.showToast(title: msg)
                return
            }
            self.model = model
            self.offset = self.model.list.count
            self.headerView.model = self.model
            self.setupItemContainer(with: self.model.list)
            self.footerView.isHidden = model.list.isEmpty || model.list.count >= self.limit
            self.scrollView.mj_footer.isHidden = model.list.count < self.limit
        }
    }
    
    /// 上拉加载更多请求
    fileprivate func loadMoreRequest() -> Void {
        EquipmentNetworkManager.getHomeData(offset: self.offset, limit: self.limit) { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            self.scrollView.mj_footer.endRefreshing()
            guard status, let model = model else {
                ToastUtil.showToast(title: msg)
                return
            }
            self.model.list.append(contentsOf: model.list)
            self.offset = self.model.list.count
            self.headerView.model = self.model
            self.setupItemContainer(with: self.model.list)
            if model.list.isEmpty || model.list.count >= self.limit {
                self.footerView.isHidden = false
                self.scrollView.mj_footer.isHidden = true
            } else {
                self.footerView.isHidden = true
                self.scrollView.mj_footer.isHidden = false
            }
        }
    }

}

// MARK: - Enter Page
extension EquipmentHomeController {
    /// 老版本挖坑明细
//    fileprivate func enterOreDetailPage(with model: EquipmentListModel) -> Void {
//        let detailVC = MiningDetailController.init(model: model)
//        self.enterPageVC(detailVC)
//    }
    /// 挖坑明细
    fileprivate func enterOreDetailPage(with model: EquipmentListModel) -> Void {
        let oreDetailVC = OreDetailController.init(listModel: model)
        self.enterPageVC(oreDetailVC)
    }
    /// 设备详情页
    fileprivate func enterEquipmentDetailPage(with model: EquipmentListModel) -> Void {
        let detailVC = EquipmentDetailController.init(model: model)
        self.enterPageVC(detailVC)
    }
}

// MARK: - Notification Function
extension EquipmentHomeController {
    
}

// MARK: - Extension Function
extension EquipmentHomeController {
    
}

// MARK: - Delegate Function

// MARK: - <UIScrollViewDelegate>
extension EquipmentHomeController: UIScrollViewDelegate {

    ///
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset
//        if offset.y > self.headerHeight - self.itemTopMargin - kStatusBarHeight {
//            self.statusBar.backgroundColor = AppColor.theme
//        } else {
//            self.statusBar.backgroundColor = UIColor.clear
//        }
    }

}
extension EquipmentHomeController: EquipmentHomeItemViewProtocol {
    /// 设备
    func itemView(_ view: EquipmentHomeItemView, didClickEquipmentDetail btn: UIButton) {
        guard let model = view.model else {
            return
        }
        self.enterEquipmentDetailPage(with: model)
    }
    /// 挖坑
    func itemView(_ view: EquipmentHomeItemView, didClickOreDetail btn: UIButton) {
        guard let model = view.model else {
            return
        }
        self.enterOreDetailPage(with: model)
    }
}
