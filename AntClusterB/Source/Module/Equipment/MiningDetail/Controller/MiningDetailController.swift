//
//  MiningDetailController.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/1/12.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  挖矿明细界面

import UIKit

class MiningDetailController: BaseViewController
{
    
    // MARK: - Internal Property

    let model: EquipmentListModel
    
    // MARK: - Private Property
    
    fileprivate let topBgView: UIImageView = UIImageView.init()
    fileprivate let navBar: AppHomeNavStatusView = AppHomeNavStatusView.init()
    fileprivate let headerView: MiningDetailHeaderView = MiningDetailHeaderView.init()
    fileprivate let tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    fileprivate var sourceList: [AssetListModel] = []
    fileprivate var offset: Int = 0
    fileprivate let limit: Int = 20
    fileprivate var showFooter: Bool = false
    
    fileprivate let headerHeight: CGFloat = MiningDetailHeaderView.viewHeight
    fileprivate let topBgSize: CGSize = CGSize.init(width: 375, height: 194).scaleAspectForWidth(kScreenWidth)
    
    // MARK: - Initialize Function
    init(model: EquipmentListModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle/Override Function
extension MiningDetailController {

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
extension MiningDetailController {
    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.pageBg
        // 0. topBg
        self.view.addSubview(self.topBgView)
        self.topBgView.set(cornerRadius: 0)
        self.topBgView.image = UIImage.init(named: "IMG_sb_top_bg")
        self.topBgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.topBgSize.height)
        }
        // 1. navBar
        self.view.addSubview(self.navBar)
        self.navBar.title = "挖矿明细"
        self.navBar.leftItem.setImage(UIImage.init(named: "IMG_icon_nav_back_white"), for: .normal)
        self.navBar.leftItem.isHidden = false
        self.navBar.rightItem.isHidden = true
        self.navBar.delegate = self
        self.navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(kNavigationStatusBarHeight)
        }
        // 2. tableView
        self.view.addSubview(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 250
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.mj_header = XDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        self.tableView.mj_footer = XDRefreshFooter(refreshingTarget: self, refreshingAction: #selector(footerLoadMore))
        self.tableView.mj_header.isHidden = false
        self.tableView.mj_footer.isHidden = true
        self.tableView.frame = self.view.bounds
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        // tableHeaderView
        self.headerView.bounds = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.headerHeight)
        self.tableView.tableHeaderView = self.headerView
        self.headerView.model = self.model
    }

}

// MARK: - Data Function
extension MiningDetailController {

    // MARK: - Private  数据处理与加载
    fileprivate func initialDataSource() -> Void {
        self.tableView.mj_header.beginRefreshing()
        //self.setupAsDemo()
    }
    ///
    fileprivate func setupAsDemo() -> Void {
        for i in 0...25 {
            //self.sourceList.append("\(i)")
        }
        self.tableView.reloadData()
    }

}

// MARK: - Event Function
extension MiningDetailController {

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
extension MiningDetailController {

    /// 下拉刷新请求
    fileprivate func refreshRequest() -> Void {
        EquipmentNetworkManager.getMiningLogs(id: self.model.id, offset: 0, limit: self.limit) { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.state = .idle
            guard status, let models = models else {
                ToastUtil.showToast(title: msg)
                return
            }
            self.sourceList = models
            self.offset = self.sourceList.count
            self.tableView.mj_footer.isHidden = models.count < self.limit
            self.showFooter = models.count < self.limit
            self.tableView.reloadData()
        }
    }
    
    /// 上拉加载更多请求
    fileprivate func loadMoreRequest() -> Void {
        EquipmentNetworkManager.getMiningLogs(id: self.model.id, offset: self.offset, limit: self.limit) { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            self.tableView.mj_footer.endRefreshing()
            guard status, let models = models else {
                self.tableView.mj_footer.endRefreshingWithWeakNetwork()
                return
            }
            if models.count < self.limit {
                //self.tableView.mj_footer.endRefreshingWithNoMoreData()
                self.tableView.mj_footer.isHidden = true
                self.showFooter = true
            }
            self.sourceList += models
            self.offset = self.sourceList.count
            self.tableView.reloadData()
        }
    }

}

// MARK: - Enter Page
extension MiningDetailController {
    
}

// MARK: - Notification Function
extension MiningDetailController {
    
}

// MARK: - Extension Function
extension MiningDetailController {
    
}

// MARK: - Delegate Function

// MARK: - <UITableViewDataSource>
extension MiningDetailController: UITableViewDataSource {

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
        let cell = MiningDetailListCell.cellInTableView(tableView, at: indexPath)
        cell.model = self.sourceList[indexPath.row]
        return cell
    }
    
}

// MARK: - <UITableViewDelegate>
extension MiningDetailController: UITableViewDelegate {

    ///
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //return 44
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height: CGFloat = self.showFooter ? CommonNoMoreDataFooterView.viewHeight : 0.01
        return height
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var view: UIView? = UIView.init()
        if self.showFooter {
            let footerView = CommonNoMoreDataFooterView.footerInTableView(tableView)
            footerView.title = "没有更多数据"
            view = footerView
        }
        return view
    }
    
    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt\(indexPath.row)")
    }
    
}

// MARK: - <AppHomeNavStatusViewProtocol>
extension MiningDetailController: AppHomeNavStatusViewProtocol {
    /// 导航栏左侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedLeftItem itemView: UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    /// 导航栏右侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedRightItem itemView: UIButton) -> Void {
        
    }

}
