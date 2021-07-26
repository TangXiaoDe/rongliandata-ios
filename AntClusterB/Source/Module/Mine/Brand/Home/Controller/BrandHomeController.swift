//
//  BrandHomeController.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/6/28.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  我的品牌商页面

import UIKit

class BrandHomeController: BaseViewController
{
    
    // MARK: - Internal Property

    // MARK: - Private Property
    
    fileprivate let tableView: BaseTableView = BaseTableView(frame: CGRect.zero, style: .plain)
    
    fileprivate var sourceList: [BrandModel] = []
    fileprivate var offset: Int = 0
    fileprivate let limit: Int = 20
    
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
extension BrandHomeController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    /// 控制器的view将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    /// 控制器的view即将消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

// MARK: - UI Function
extension BrandHomeController {
    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.pageBg
        // 1. navBar
        self.navigationItem.title = "我的品牌商"
        // 2. tableView
        self.view.addSubview(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 250
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.backgroundColor = AppColor.pageBg
        self.tableView.mj_header = XDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        self.tableView.mj_footer = XDRefreshFooter(refreshingTarget: self, refreshingAction: #selector(footerLoadMore))
        self.tableView.mj_header.isHidden = false
        self.tableView.mj_footer.isHidden = true
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 顶部位置 的版本适配
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else if #available(iOS 9.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

}

// MARK: - Data Function
extension BrandHomeController {

    // MARK: - Private  数据处理与加载
    fileprivate func initialDataSource() -> Void {
        self.tableView.mj_header.beginRefreshing()
        //self.setupAsDemo()
    }
    ///
    fileprivate func setupAsDemo() -> Void {
//        for i in 0...25 {
//            self.sourceList.append("\(i)")
//        }
//        self.tableView.reloadData()
    }

}

// MARK: - Event Function
extension BrandHomeController {

    /// 导航栏 左侧按钮点击响应
    @objc fileprivate func navBarLeftItemClick() -> Void {
        print("TemplateUIViewController navBarLeftItemClick")
        self.navigationController?.popViewController(animated: true)
    }
    /// 导航栏 右侧侧按钮点击响应
    @objc fileprivate func navBarRightItemClick() -> Void {
        print("TemplateUIViewController navBarRightItemClick")
    }

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
extension BrandHomeController {

    /// 下拉刷新请求
    fileprivate func refreshRequest() -> Void {
        BrandNetworkManager.getBrandList(offset: 0, limit: self.limit) { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.state = .idle
            guard status, let models = models else {
                ToastUtil.showToast(title: msg)
                self.tableView.showDefaultEmpty = self.sourceList.isEmpty
                return
            }
            self.sourceList = models
            self.offset = self.sourceList.count
            self.tableView.mj_footer.isHidden = models.count < self.limit
            self.tableView.showDefaultEmpty = self.sourceList.isEmpty
            self.tableView.reloadData()
        }
    }
    
    /// 上拉加载更多请求
    fileprivate func loadMoreRequest() -> Void {
        BrandNetworkManager.getBrandList(offset: self.offset, limit: self.limit) { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            self.tableView.mj_footer.endRefreshing()
            guard status, let models = models else {
                self.tableView.mj_footer.endRefreshingWithWeakNetwork()
                return
            }
            if models.count < self.limit {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            self.sourceList += models
            self.offset = self.sourceList.count
            self.tableView.reloadData()
        }
    }

}

// MARK: - Enter Page
extension BrandHomeController {
    
    /// 进入渠道分红页
    fileprivate func enterBonusPage(with model: BrandModel, at index: Int = 0) -> Void {
        let bonusVC = BrandBonusHomeController.init()
        bonusVC.brand_id = model.id
        self.enterPageVC(bonusVC)
    }
    
}

// MARK: - Notification Function
extension BrandHomeController {
    
}

// MARK: - Extension Function
extension BrandHomeController {
    
}

// MARK: - Delegate Function

// MARK: - <UITableViewDataSource>
extension BrandHomeController: UITableViewDataSource {

    ///
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceList.count
    }

    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BrandListCell.cellInTableView(tableView, at: indexPath)
        cell.model = self.sourceList[indexPath.row]
        cell.showTopMargin = true
        cell.showBottomMargin = true
        cell.showBottomLine = false
        cell.delegate = self
        return cell
    }
    
}

// MARK: - <UITableViewDelegate>
extension BrandHomeController: UITableViewDelegate {

    ///
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //return 44
    }

    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt\(indexPath.row)")
    }
    
}

// MARK: - <BrandListCellProtocol>
extension BrandHomeController: BrandListCellProtocol {

    /// 渠道分红点击回调
    func brandCell(_ cell: BrandListCell, didClickedBonus bonusView: UIView, with model: BrandModel) -> Void {
        self.enterBonusPage(with: model, at: 0)
    }
    
}


