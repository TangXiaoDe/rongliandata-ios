//
//  EquipmentHomeController.swift
//  AntMachine
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
    fileprivate let statusBar: UIView = UIView.init()
    fileprivate let scrollView: UIScrollView = UIScrollView.init()
    fileprivate let headerView: EquipmentHomeHeaderView = EquipmentHomeHeaderView.init()
    fileprivate let itemContainer: UIView = UIView.init()
    fileprivate let footerView: EquipmentHomeFooterView = EquipmentHomeFooterView.init()
    
    fileprivate var sourceList: [String] = []
    fileprivate var offset: Int = 0
    fileprivate let limit: Int = 20
    
    fileprivate let headerHeight: CGFloat = EquipmentHomeHeaderView.viewHeight
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let itemHeight: CGFloat = 125
    fileprivate let itemVerMargin: CGFloat = 12
    fileprivate let itemTopMargin: CGFloat = 68     // -header.bottom

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
        // 1. statusBar
        self.view.addSubview(self.statusBar)
        self.statusBar.backgroundColor = UIColor.clear
        self.statusBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(kStatusBarHeight)
        }
        // 2. scrollView
        self.view.addSubview(self.scrollView)
        self.initialScrollView(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 顶部位置 的版本适配
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else if #available(iOS 9.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        // view Hierarchy
        self.view.bringSubviewToFront(self.statusBar)
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
            itemView.set(cornerRadius: 10)
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
    
}

// MARK: - Request Function
extension EquipmentHomeController {

    /// 下拉刷新请求
    fileprivate func refreshRequest() -> Void {
        EquipmentNetworkManager.getHomeData { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            self.scrollView.mj_header.endRefreshing()
            guard status, let model = model else {
                ToastUtil.showToast(title: msg)
                return
            }
            self.headerView.model = model
            self.setupItemContainer(with: model.list)
        }
    }
    
    /// 上拉加载更多请求
    fileprivate func loadMoreRequest() -> Void {
//        MessageNetworkManager.getMessageList(offset: self.offset, limit: self.limit) { [weak self](status, msg, models) in
//            guard let `self` = self else {
//                return
//            }
//            self.tableView.mj_footer.endRefreshing()
//            guard status, let models = models else {
//                self.tableView.mj_footer.endRefreshingWithWeakNetwork()
//                return
//            }
//            if models.count < self.limit {
//                self.tableView.mj_footer.endRefreshingWithNoMoreData()
//            }
//            self.sourceList += models
//            self.offset = self.sourceList.count
//            self.tableView.reloadData()
//        }
    }

}

// MARK: - Enter Page
extension EquipmentHomeController {
    
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
        let offset = scrollView.contentOffset
        if offset.y > self.headerHeight - self.itemTopMargin - kStatusBarHeight {
            self.statusBar.backgroundColor = AppColor.theme
        } else {
            self.statusBar.backgroundColor = UIColor.clear
        }
    }

}
