//
//  BrandBonusListController.swift
//  RongLianData
//
//  Created by 小唐 on 2021/7/26.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  渠道分红列表页

import UIKit

class BrandBonusListController: BaseTableViewController {
    // MARK: - Internal Property
    fileprivate var type: CurrencyType
    fileprivate var brand_id: Int

    override var isSelected: Bool {
        didSet {
            self.firstLoadData()
        }
    }

    // MARK: - Private Property
    fileprivate let emptyDefaultView: ListEmptyPlaceHolderView = ListEmptyPlaceHolderView()
    fileprivate let headerView: BrandBonusListHeaderView = BrandBonusListHeaderView.init()
    fileprivate let itemContainer: UIView = UIView.init()

    fileprivate var sourceList: [BrandBonusListModel] = []

    fileprivate let headerHeight: CGFloat = BrandBonusListHeaderView.viewHeight
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let itemVerMargin: CGFloat = 12
    fileprivate let itemTopMargin: CGFloat = 0
    fileprivate let itemBottomMargin: CGFloat = 12
    fileprivate let itemViewTagBase: Int = 250


    // MARK: - Initialize Function
    init(type: CurrencyType, brand_id: Int) {
        self.type = type
        self.brand_id = brand_id
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
extension BrandBonusListController {
    /// 第一次加载数据
    fileprivate func firstLoadData() -> Void {
        if self.isFirstLoading {
            self.isFirstLoading = false
            self.tableView.mj_header?.beginRefreshing()
        }
    }
}

// MARK: - LifeCircle/Override Function
extension BrandBonusListController {

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
extension BrandBonusListController {
    override func initialUI() {
        super.initialUI()
        self.view.backgroundColor = .clear

        self.view.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.headerHeight)
        }

        self.tableView.set(cornerRadius: 15)
        self.tableView.backgroundColor = .white
        self.tableView.mj_header.isHidden = false
        self.tableView.snp.remakeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        // 顶部位置 的版本适配
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else if #available(iOS 9.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        self.view.addSubview(self.emptyDefaultView)
        self.emptyDefaultView.isHidden = true
        self.emptyDefaultView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.tableView)
        }
    }
}

// MARK: - Data Function
extension BrandBonusListController {

    // MARK: - Private  数据处理与加载
    override func initialDataSource() -> Void {
        self.tableView.mj_header.beginRefreshing()
    }
}

// MARK: - Event Function
extension BrandBonusListController {
    ///
    @objc fileprivate func tapGRProcess(_ tapGR: UITapGestureRecognizer) -> Void {
        guard tapGR.state == .recognized, let tapView = tapGR.view as? EquipmentHomeItemView, let model = tapView.model else {
            return
        }
    }
}

// MARK: - Request Function
extension BrandBonusListController {

    /// 下拉刷新请求
    override func refreshRequest() {
        BrandNetworkManager.getBrandDetailList(brand_id: self.brand_id, currency: self.type, offset: 0, limit: self.limit) { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.state = .idle  // 网络错误、没有更多数据时重置
            guard status, let model = model else {
                ToastUtil.showToast(title: msg)
                return
            }
            self.headerView.model = model
            self.sourceList = model.logs
            self.offset = self.sourceList.count
            self.tableView.reloadData()
            self.tableView.mj_footer?.isHidden = model.logs.count < self.limit
            self.emptyDefaultView.isHidden = !self.sourceList.isEmpty
        }
    }

    /// 上拉加载更多请求
    override func loadMoreRequest() -> Void {
        BrandNetworkManager.getBrandDetailList(brand_id: self.brand_id, currency: self.type, offset: self.offset, limit: self.limit) { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            self.tableView.mj_footer?.endRefreshing()
            guard status, let model = model else {
                ToastUtil.showToast(title: msg)
                return
            }
            self.headerView.model = model
            self.sourceList.append(contentsOf: model.logs)
            self.offset = self.sourceList.count
            self.tableView.reloadData()
            self.tableView.mj_footer?.isHidden = model.logs.count < self.limit
        }
    }
}

// MARK: - Enter Page
extension BrandBonusListController {

}

// MARK: - Notification Function
extension BrandBonusListController {

}

// MARK: - Extension Function
extension BrandBonusListController {

}

// MARK: - Delegate Function
extension BrandBonusListController: AppHomeNavStatusViewProtocol {
    /// 导航栏左侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedLeftItem itemView: UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    /// 导航栏右侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedRightItem itemView: UIButton) -> Void {
    }
}

// MARK: - tableView delegate
extension BrandBonusListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BrandBonusListCell.cellInTableView(tableView)
        cell.model = self.sourceList[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        let titleLabel = UILabel()
        titleLabel.set(text: "分红明细", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.minorText)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        let unitLabel = UILabel()
        unitLabel.set(text: "(个)", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.minorText)
        view.addSubview(unitLabel)
        unitLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-14)
        }
        view.addLineWithSide(.inBottom, color: UIColor(hex: 0xCCCCCC), thickness: 0.5, margin1: 12, margin2: 12)
        return view
    }
}

// MARK: - tableView dataSource
extension BrandBonusListController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
