//
//  EquipmentHomeController.swift
//  AntClusterB
//
//  Created by 小唐 on 2020/12/3.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  设备主页、设备列表页

import UIKit
import MonkeyKing

class EquipmentHomeController: BaseViewController {
    
    // MARK: - Internal Property

    let showTabbar: Bool
    
    var defaultSelectedIndex: Int = 0

    // MARK: - Private Property
    fileprivate let topBgView: UIImageView = UIImageView()
    fileprivate let navBar: AppHomeNavStatusView = AppHomeNavStatusView.init()
    fileprivate let nestView: XDNestScrollContainerView = XDNestScrollContainerView()
    
    fileprivate let types: [ProductZone] = [.ipfs, .chia]
    fileprivate lazy var titleView: EquipmentHomeTitleView = {
        var titles: [String] = []
        self.types.forEach { (item) in
            titles.append(item.title)
        }
        return EquipmentHomeTitleView.init(titles: titles)
    }()

    /// 明细列表
    fileprivate let detailView: UIView = UIView()
    fileprivate let horScrollView: UIScrollView = UIScrollView()

    fileprivate let topBgHeight: CGFloat = CGSize.init(width: 375, height: 219).scaleAspectForWidth(kScreenWidth).height
    fileprivate let titleViewHeight: CGFloat = EquipmentHomeTitleView.viewHeight
    fileprivate var selectedIndex: Int = 0 {
        didSet {
            if oldValue == selectedIndex {
                return
            }
            self.titleView.selectedIndex = selectedIndex
            self.horScrollView.setContentOffset(CGPoint(x: CGFloat(selectedIndex) * kScreenWidth, y: 0), animated: true)
            self.childVCList[oldValue].isSelected = false
            self.childVCList[selectedIndex].isSelected = true
        }
    }
    /// childVC列表
    fileprivate var childVCList: [EquipmentHomeListController] = []

    /// 内容是否可以滑动
    fileprivate var canContentScroll: Bool = false

    // MARK: - Initialize Function

    init(showTabbar: Bool = false) {
        self.showTabbar = showTabbar
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

// MARK: - LifeCircle Function
extension EquipmentHomeController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - UI
extension EquipmentHomeController {
    /// 页面布局
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
//        self.navBar.titleLabel.set(text: "FIL", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor.white, alignment: .center)
        self.navBar.delegate = self
        self.navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(kNavigationStatusBarHeight)
        }
        self.navBar.titleView.addSubview(self.titleView)
        self.titleView.delegate = self
        self.titleView.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(self.navBar.leftItem.snp.right)
            make.right.lessThanOrEqualTo(self.navBar.rightItem.snp.left)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(self.titleViewHeight)
        }
        // 2. nestView
        self.view.addSubview(self.nestView)
        self.initialNestView(self.nestView)
        //self.nestView.delegate = self
        //self.nestView.containerScrollHeight = self.topBgHeight - 66
        self.nestView.containerScrollHeight = 0
        self.nestView.canScroll = false
        self.nestView.container.mj_header = XDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        self.nestView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp_bottomMargin)
            //make.top.equalTo(self.view.snp_topMargin)
            make.top.equalTo(self.navBar.snp.bottom)
        }
        self.canContentScroll = true
        self.view.bringSubviewToFront(self.navBar)
    }

    fileprivate func initialNestView(_ nestView: XDNestScrollContainerView) -> Void {
        let detailViewH: CGFloat = kScreenHeight - kNavigationStatusBarHeight - (showTabbar ? kTabBarHeight : kBottomHeight)
        // 3. detailView
        nestView.container.addSubview(self.detailView)
        let childViews = self.initialBottomDetailView(self.detailView)
        self.detailView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.titleView.snp.bottom)
            make.height.equalTo(detailViewH)
            make.width.equalTo(kScreenWidth)
        }
        nestView.allowViews = childViews
    }

    /// 底部明细视图
    fileprivate func initialBottomDetailView(_ bottomView: UIView) -> [UIView] {
        let childViewH: CGFloat = kScreenHeight - kNavigationStatusBarHeight - (showTabbar ? kTabBarHeight : kBottomHeight)
        // 1. horScroll
        bottomView.addSubview(self.horScrollView)
        self.horScrollView.isPagingEnabled = true
        self.horScrollView.showsHorizontalScrollIndicator = false
        self.horScrollView.delegate = self
        self.horScrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(childViewH)
        }
        // 2. childs
        var childTableViews: [UIScrollView] = []
        for (index, type) in self.types.enumerated() {
            let childVC = EquipmentHomeListController.init(zone: type)
            let childView: UIView = UIView()
            self.horScrollView.addSubview(childView)
            childView.snp.makeConstraints { (make) in
                make.width.equalTo(kScreenWidth)
                make.height.equalTo(childViewH)
                make.top.bottom.equalToSuperview()
                let leftMargin: CGFloat = CGFloat(index) * kScreenWidth
                make.leading.equalToSuperview().offset(leftMargin)
                if index == self.types.count - 1 {
                    make.trailing.equalToSuperview()
                }
            }
            // childVC
            self.addChild(childVC)
            self.childVCList.append(childVC)
            childView.addSubview(childVC.view)
            childTableViews.append(childVC.scrollView)
            childVC.view.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        return childTableViews
    }
}

// MARK: - Data(数据处理与加载)
extension EquipmentHomeController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        //  同步价格接口
        FirstPageNetworkManager.getIncreases { (status, msg, model) in

        }
        FirstPageNetworkManager.getUsdtToRmb { (status, msg, price) in

        }
        //
        if self.defaultSelectedIndex != self.selectedIndex {
            self.selectedIndex = self.defaultSelectedIndex
        } else {
            self.titleView.selectedIndex = self.selectedIndex
            self.horScrollView.setContentOffset(CGPoint(x: CGFloat(self.selectedIndex) * kScreenWidth, y: 0), animated: false)
            self.childVCList[self.selectedIndex].isSelected = true
        }
        //self.refreshRequest(headerAnimation: true)
    }
}

// MARK: - Request
extension EquipmentHomeController {
    fileprivate func refreshRequest(headerAnimation: Bool = false) -> Void {
//        /// 不是头部的下拉刷新，则直接请求
//        if !headerAnimation {
//            self.childVCList[self.selectedIndex].refreshData()
//            return
//        }
//        /// 下拉刷新
//        let group = DispatchGroup()
//        group.enter()
//        self.childVCList[self.selectedIndex].refreshData { (status, msg, models) in
//            group.leave()
//        }
//        group.notify(queue: DispatchQueue.main) {
//            self.nestView.container.mj_header?.endRefreshing()
//        }
    }


}

// MARK: - Event(事件响应)
extension EquipmentHomeController {
    @objc fileprivate func headerRefresh() -> Void {
        self.refreshRequest(headerAnimation: true)
    }
}

// MARK: - Notification
extension EquipmentHomeController {

}

// MARK: - Alert
extension EquipmentHomeController {

}

// MARK: - Extension Function
extension EquipmentHomeController {


}

// MARK: - Delegate Function

// MARK: - <EquipmentHomeTitleViewProtocol>
extension EquipmentHomeController: EquipmentHomeTitleViewProtocol {
    func titleView(_ titleView: EquipmentHomeTitleView, didClickedAt index: Int, with title: String) -> Void {
        self.selectedIndex = index
    }
}

// MARK: - <UIScrollViewDelegate>
extension EquipmentHomeController: UIScrollViewDelegate {
    /// 滑动结束 回调
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.horScrollView {
            let scrollIndex: Int = Int(scrollView.contentOffset.x / kScreenWidth)
            self.selectedIndex = scrollIndex
        }
    }
    /// 滑动回调
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.horScrollView {
            return
        }
        if !self.canContentScroll {
            // 这里通过固定contentOffset，来实现不滚动
            scrollView.contentOffset = CGPoint.zero
        } else if scrollView.contentOffset.y <= -0.1 {  // 不取0，因为有bounces效果可能导致不显示。
            self.canContentScroll = false
            // 通知容器可以开始滚动
            self.nestView.canScroll = true
            scrollView.contentOffset = CGPoint.zero
        }
    }

}

// MARK: - <XDNestScrollContainerViewProtocol>
extension EquipmentHomeController: XDNestScrollContainerViewProtocol {
    // 当内容可以滚动时会调用
    func nestingViewContentCanScroll(_ nestView: XDNestScrollContainerView) -> Void {
        self.canContentScroll = true
        // 当内容可以滚动时，关闭容器的状态栏点击滚动到顶部开关
        nestView.container.scrollsToTop = false
    }

    // 当容器可以滚动时会调用
    func nestingViewContainerCanScroll(_ nestView: XDNestScrollContainerView) -> Void {
        // 当容器开始可以滚动时，将所有内容设置回到顶部

        // 当容器可以滚动时，打开容器的状态栏点击滚动到顶部开关
        nestView.container.scrollsToTop = true
    }

    // 当容器正在滚动时调用，参数scrollView就是充当容器
    func nestingViewDidContainerScroll(_ scrollView: UIScrollView) -> Void {
        // 监听容器的滚动，来设置NavigationBar的透明度
    }
}
extension EquipmentHomeController: AppHomeNavStatusViewProtocol {
    /// 导航栏左侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedLeftItem itemView: UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    /// 导航栏右侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedRightItem itemView: UIButton) -> Void {
    }
}
