//
//  AssetHomeController.swift
//  iMeet
//
//  Created by 小唐 on 2019/5/29.
//  Copyright © 2019 iMeet. All rights reserved.
//
//  资产主页界面、矿石主页界面
//  1. 当前界面可以下拉刷新(横向滚动、点击标题、切换时 取消刷新展示)；

import MonkeyKing

class AssetHomeController: BaseViewController {
    // MARK: - Internal Property

    var currency: String
    var currencyType: AssetCurrencyType = .none
    var assetModel: AssetInfoModel?
    var incomeModel: FPYesterdayIncomeModel?
    var priceModel: FPIncreaseModel?

    // MARK: - Private Property

    fileprivate let nestView: XDNestScrollContainerView = XDNestScrollContainerView()
    fileprivate let headerView: AssetHomeHeaderView = AssetHomeHeaderView.init()
    fileprivate let selectView: AssetHomeTitleView = AssetHomeTitleView.init()

    /// 明细列表
    fileprivate let detailView: UIView = UIView()
    fileprivate let horScrollView: UIScrollView = UIScrollView()

    fileprivate let bottomView = AssetHomeBottomView()

    fileprivate let headerViewHeight: CGFloat = AssetHomeHeaderView.viewHeight
    fileprivate let selectViewHeight: CGFloat = AssetHomeTitleView.viewHeight
    fileprivate var selectedIndex: Int = 0 {
        didSet {
            if oldValue == selectedIndex {
                return
            }
            self.selectView.selectedIndex = selectedIndex
            self.horScrollView.setContentOffset(CGPoint(x: CGFloat(selectedIndex) * kScreenWidth, y: 0), animated: false)
        }
    }
    /// childVC列表
    fileprivate var childVCList: [AssetListController] = []

    /// 内容是否可以滑动
    fileprivate var canContentScroll: Bool = false

    fileprivate var isWithdrawBtnClick: Bool = false

    fileprivate var bottomViewH: CGFloat = AssetHomeBottomView.viewHeight

    // MARK: - Initialize Function

    init(currency: String) {
        self.currency = currency
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Internal Function

// MARK: - LifeCircle Function
extension AssetHomeController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
        NotificationCenter.default.addObserver(self, selector: #selector(userRefreshNotificationProcess(_:)), name: AppNotificationName.Asset.withdrawAdress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(assetRefreshNotificationProcess(_:)), name: AppNotificationName.Asset.refresh, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.hiddenNavBarShadow()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.showNavBarShadow(color: AppColor.navShadow)
    }
}

// MARK: - UI
extension AssetHomeController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        // navigation
//        self.navigationItem.title = "我的"
        // 1. bottomView
        self.view.addSubview(self.bottomView)
        self.bottomView.delegate = self
        self.bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp_bottomMargin)
            make.height.equalTo(self.bottomViewH)
        }
        // 2. nestView
        self.view.addSubview(self.nestView)
        self.initialNestView(self.nestView)
        self.nestView.delegate = self
        self.nestView.containerScrollHeight = AssetHomeHeaderView.viewHeight
        self.nestView.canScroll = true
        self.nestView.container.mj_header = XDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        self.nestView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.bottomView.snp.top)
            make.top.equalTo(self.view.snp_topMargin)
        }
        self.canContentScroll = true
    }

    fileprivate func initialNestView(_ nestView: XDNestScrollContainerView) -> Void {
        let detailViewH: CGFloat = kScreenHeight - kNavigationStatusBarHeight - kBottomHeight - self.selectViewHeight - self.bottomViewH
        // 1. header
        nestView.container.addSubview(self.headerView)
        self.headerView.delegate = self
        self.headerView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.headerViewHeight)
            make.width.equalTo(kScreenWidth)
        }
        // 2. titleSelect
        nestView.container.addSubview(self.selectView)
        self.selectView.delegate = self
        self.selectView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.height.equalTo(self.selectViewHeight)
        }
        // 3. detailView
        nestView.container.addSubview(self.detailView)
        let childViews = self.initialBottomDetailView(self.detailView)
        self.detailView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.selectView.snp.bottom)
            make.height.equalTo(detailViewH)
            make.width.equalTo(kScreenWidth)
        }
        nestView.allowViews = childViews
    }

    /// 底部明细视图
    fileprivate func initialBottomDetailView(_ bottomView: UIView) -> [UIView] {
        let childViewH: CGFloat = kScreenHeight - kNavigationStatusBarHeight - kBottomHeight - self.selectViewHeight - self.bottomViewH
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
        let childs: [AssetListController] = [AssetListController.init(currency: self.currency, type: .all),
                                                  AssetListController.init(currency: self.currency, type: .income),
                                                  AssetListController.init(currency: self.currency, type: .outcome)]
        var childTableViews: [UITableView] = []
        for (index, childVC) in childs.enumerated() {
            let childView: UIView = UIView()
            self.horScrollView.addSubview(childView)
            childView.snp.makeConstraints { (make) in
                make.width.equalTo(kScreenWidth)
                make.height.equalTo(childViewH)
                make.top.bottom.equalToSuperview()
                let leftMargin: CGFloat = CGFloat(index) * kScreenWidth
                make.leading.equalToSuperview().offset(leftMargin)
                if index == childs.count - 1 {
                    make.trailing.equalToSuperview()
                }
            }
            // childVC
            self.addChild(childVC)
            childVC.delegate = self
            self.childVCList.append(childVC)
            childView.addSubview(childVC.view)
            childTableViews.append(childVC.tableView)
            childVC.view.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        return childTableViews
    }
}

// MARK: - Data(数据处理与加载)
extension AssetHomeController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
//        self.getCurrentAsset()
//        self.headerView.model = self.assetModel
//        self.bottomView.model = self.assetModel
        self.childVCList.forEach { (listVC) in
            listVC.updateCurrency = self.currency
        }
        self.refreshRequest(headerAnimation: true)
    }
}

// MARK: - Request
extension AssetHomeController {
    fileprivate func refreshRequest(headerAnimation: Bool = false) -> Void {
        /// 不是头部的下拉刷新，则直接请求
        if !headerAnimation {
            self.childVCList[self.selectedIndex].refreshData()
            self.getCurrentAsset()
            return
        }
        /// 下拉刷新
        let group = DispatchGroup()
        group.enter()
        self.getCurrentAsset { (status, msg, model) in
            group.leave()
        }
        group.enter()
        self.childVCList[self.selectedIndex].refreshData { (status, msg, models) in
            group.leave()
        }
        group.enter()
        self.getIncomes { (status, msg, model) in
            group.leave()
        }
        group.enter()
        self.getIncreases { (status, msg, model) in
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            self.nestView.container.mj_header?.endRefreshing()
            self.headerView.priceModel = self.priceModel
            self.headerView.incomeModel = self.incomeModel
        }
    }

    /// 获取当前总资产
    fileprivate func getCurrentAsset(complete: ((_ status: Bool, _ msg: String?, _ model: AssetInfoModel?) -> Void)? = nil) -> Void {
        AssetNetworkManager.getAssetInfo(self.currency) { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            guard status, let model = model else {
                complete?(status, msg, nil)
                return
            }
            self.assetModel = model
            self.headerView.model = model
            self.bottomView.model = model
            complete?(status, msg, model)
        }
    }
    /// 昨日收益
    fileprivate func getIncomes(complete: @escaping((_ status: Bool, _ msg: String?, _ model: FPYesterdayIncomeModel?) -> Void)) -> Void {
        FirstPageNetworkManager.getIncomes { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            guard status, let model = model else {
                complete(status, msg, nil)
                return
            }
            self.incomeModel = model
            complete(status, msg, model)
        }
    }
    fileprivate func getIncreases(complete: @escaping((_ status: Bool, _ msg: String?, _ model: FPIncreaseModel?) -> Void)) -> Void {
        FirstPageNetworkManager.getIncreases { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            guard status, let model = model else {
                complete(status, msg, nil)
                return
            }
            self.priceModel = model
            complete(status, msg, model)
        }
    }
}

// MARK: - Event(事件响应)
extension AssetHomeController {
    @objc fileprivate func headerRefresh() -> Void {
        self.refreshRequest(headerAnimation: true)
    }
}

// MARK: - Notification
extension AssetHomeController {
    /// 个人提币信息刷新通知处理
    @objc fileprivate func userRefreshNotificationProcess(_ notification: Notification) {
        AppUtil.refreshCurrentUserInfo()
    }
    // 提币/兑换/转账 成功之后刷新
    @objc fileprivate func assetRefreshNotificationProcess(_ notification: Notification) {
        self.refreshRequest(headerAnimation: true)
    }

}

// MARK: - Alert
extension AssetHomeController {
    /// 显示绑定提币地址弹窗
    fileprivate func showBindWithdrawAddressAlert() -> Void {
        let popView = WithdrawBindAddressPopView.init()
        popView.delegate = self
        PopViewUtil.showPopView(popView)
    }
}

// MARK: - Extension Function
extension AssetHomeController {
    /// 进入转账页
    fileprivate func enterTransferPage() -> Void {
//        self.enterPageVC(TransferSearchController())
    }
    fileprivate func enterRechargeProcess() -> Void {
        guard let assetModel = self.assetModel else {
            return
        }
        
        self.enterRechargePage()
    }
    /// 进入充值页
    fileprivate func enterRechargePage() -> Void {
        guard let assetModel = self.assetModel else {
            return
        }
//        let rechargeVC = RechargeHomeController.init(assetModel: assetModel)
//        self.enterPageVC(rechargeVC)
    }
    /// 提币按钮点击判断处理
    func enterWithdrawalProcess(assetModel: AssetInfoModel) {
        // 只有usdt弹框选择 其他直接判断地址
        self.enterWithdrawalAddressProcess()
    }
    /// 提币地址判断
    func enterWithdrawalAddressProcess() {
        guard let assetModel = self.assetModel else {
            return
        }
        // 1. 地址绑定判断
        if assetModel.isBindWithdrawAddress {
            self.enterWithdrawPage(assetModel: assetModel)
        } else {
            self.showBindWithdrawAddressAlert()
        }
    }
    /// 进入提币地址绑定界面
    fileprivate func enterWithdrawAddressBindPage(assetModel: AssetInfoModel) -> Void {
        let bindVC = WithdrawAddressBindingController.init(currency: "", assetModel: assetModel)
        self.enterPageVC(bindVC)
    }
    /// 进入提现页
    fileprivate func enterWithdrawPage(assetModel: AssetInfoModel) -> Void {
        let withdrawVC = WithdrawController.init(assetModel: assetModel)
        self.enterPageVC(withdrawVC)
    }
    /// 进入兑换页
    fileprivate func enterExchangePage(assetModel: AssetInfoModel) -> Void {

    }

}

// MARK: - Delegate Function

// MARK: - <AssetTopTitleSelectViewProtocol>
extension AssetHomeController: AssetHomeTitleViewProtocol {
    func titleView(_ titleView: AssetHomeTitleView, didClickedAt index: Int, with title: String) -> Void {
        self.selectedIndex = index
    }
}

// MARK: - <UIScrollViewDelegate>
extension AssetHomeController: UIScrollViewDelegate, BaseTableViewControllerProtocol {
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
// MARK: - <AssetHomeHeaderViewProtocol>
extension AssetHomeController: AssetHomeHeaderViewProtocol {
    func assetHeaderView(_ headerView: AssetHomeHeaderView, didClickedChangeType btn: UIButton) {

    }
}
// MARK: - <AssetHomeBottomViewProtocol>
extension AssetHomeController: AssetHomeBottomViewProtocol {
    func bottomView(_ bottomView: AssetHomeBottomView, didClickedWithdraw withdrawView: UIButton, with model: AssetInfoModel) {
        self.isWithdrawBtnClick = true
        self.enterWithdrawalProcess(assetModel: model)
    }
    func bottomView(_ bottomView: AssetHomeBottomView, didClickedRecharge rechargeView: UIButton, with model: AssetInfoModel) {
        self.isWithdrawBtnClick = false
        self.enterRechargeProcess()
    }
    func bottomView(_ bottomView: AssetHomeBottomView, didClickedExchange exchangeView: UIButton, with model: AssetInfoModel) {
        self.enterExchangePage(assetModel: model)
    }
}
// MARK: - <WithdrawBindAddressPopViewProtocol>
extension AssetHomeController: WithdrawBindAddressPopViewProtocol {
    /// 确定点击/去绑定点击
    func popView(_ popView: WithdrawBindAddressPopView, didClickedBind bindBtn: UIButton) -> Void {
        guard let model = self.assetModel else {
            return
        }
        self.enterWithdrawAddressBindPage(assetModel: model)
    }
    /// 遮罩点击 - 可选
    func popView(_ popView: WithdrawBindAddressPopView, didClickedCover cover: UIButton) -> Void {}
    /// 取消点击 - 可选
    func popView(_ popView: WithdrawBindAddressPopView, didClickedCancel cancelBtn: UIButton) -> Void {}

}

// MARK: - <XDNestScrollContainerViewProtocol>
extension AssetHomeController: XDNestScrollContainerViewProtocol {
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
