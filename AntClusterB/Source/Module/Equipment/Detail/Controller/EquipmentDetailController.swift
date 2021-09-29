//
//  EquipmentDetailController.swift
//  MallProject
//
//  Created by zhaowei on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import Foundation

class EquipmentDetailController: BaseViewController
{
    // MARK: - Internal Property
    
    let id: Int
    let model: EquipmentListModel
    
    // MARK: - Private Property

    fileprivate let topBgView: UIImageView = UIImageView.init()
    fileprivate let navBar: AppHomeNavStatusView = AppHomeNavStatusView.init()
    
    fileprivate let scrollView: UIScrollView = UIScrollView.init()

    fileprivate let topView: EquipDetailHeaderView = EquipDetailHeaderView.init()
    fileprivate let infoView: EquipDetailTermInfoView = EquipDetailTermInfoView.init()
    
    fileprivate let detailView: EquipmentDetailView = EquipmentDetailView.init()
    
    fileprivate let topBgViewHeight: CGFloat = CGSize.init(width: 375, height: 194).scaleAspectForWidth(kScreenWidth).height
    
    fileprivate let topViewNoGroupHeight: CGFloat = EquipDetailHeaderView.noGroupViewHeight
    fileprivate let topViewHasGroupHeight: CGFloat = EquipDetailHeaderView.hasGroupViewHeight
    fileprivate let topViewLrMargin: CGFloat = 12
    fileprivate let topViewTopMargin: CGFloat = 20
    
    fileprivate let detailViewTopMargin: CGFloat = 12
    
    
    fileprivate var detail: EquipmentDetailModel?
    fileprivate var returns: [EDAssetReturnListModel] = []
    
    fileprivate var offset: Int = 0
    fileprivate let limit: Int = 20
    
    
    
    
    // MARK: - Initialize Function
    
    init(model: EquipmentListModel) {
        self.model = model
        self.id = model.id
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

// MARK: - LifeCircle & Override Function
extension EquipmentDetailController {
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

// MARK: - UI
extension EquipmentDetailController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        //
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
        self.navBar.titleLabel.set(text: "设备详情", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor.init(hex: 0x333333), alignment: .center)
        self.navBar.leftItem.isHidden = false
        self.navBar.leftItem.setImage(UIImage.init(named: "IMG_navbar_back"), for: .normal)
        self.navBar.leftItem.setImage(UIImage.init(named: "IMG_navbar_back"), for: .highlighted)
        self.navBar.rightItem.isHidden = true
        self.navBar.delegate = self
        self.navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(kNavigationStatusBarHeight)
        }
        // 3. scrollView
        self.view.addSubview(self.scrollView)
        self.initialScrollView(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.navBar.snp.bottom)
        }
    }
    ///
    fileprivate func initialScrollView(_ scrollView: UIScrollView) -> Void {
        scrollView.delegate = self
        //scrollView.backgroundColor = AppColor.pageBg
        scrollView.showsVerticalScrollIndicator = false
        scrollView.mj_header = XDRefreshHeader.init(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        scrollView.mj_footer = XDRefreshFooter.init(refreshingTarget: self, refreshingAction: #selector(footerLoadMore))
        scrollView.mj_header.isHidden = false
        scrollView.mj_footer.isHidden = true
        // 顶部位置 的版本适配
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else if #available(iOS 9.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        // 1. topView
        scrollView.addSubview(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.topViewLrMargin)
            make.trailing.equalToSuperview().offset(-self.topViewLrMargin)
            make.top.equalToSuperview().offset(self.topViewTopMargin)
            let height: CGFloat = self.model.group.isEmpty ? self.topViewNoGroupHeight : self.topViewHasGroupHeight
            make.height.equalTo(height)
        }
        // 2. infoView
        scrollView.addSubview(self.infoView)
        self.infoView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.topView)
            make.top.equalTo(self.topView.snp.bottom)
        }
        // 3. detailView
        scrollView.addSubview(self.detailView)
        self.detailView.delegate = self
        self.detailView.backgroundColor = UIColor.white
        self.detailView.snp.makeConstraints { (make) in
            make.leading.trailing.width.bottom.equalToSuperview()
            make.top.equalTo(self.infoView.snp.bottom).offset(self.detailViewTopMargin)
        }
    }

}

// MARK: - Data(数据处理与加载)
extension EquipmentDetailController {
    
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        self.topView.model = self.model
        self.scrollView.mj_header.beginRefreshing()
    }

}

// MARK: - Event(事件响应)
extension EquipmentDetailController {
    ///
    @objc fileprivate func headerRefresh() -> Void {
        EquipmentNetworkManager.refreshEquipmentDetailData(id: self.id, offset: 0, limit: self.limit) { [weak self](status, msg, data) in
            guard let `self` = self else {
                return
            }
            self.scrollView.mj_header.endRefreshing()
            self.scrollView.mj_footer.state = .idle
            guard status, let data = data else {
                ToastUtil.showToast(title: msg)
                return
            }
            self.detail = data.detail
            self.returns = data.returns
            self.topView.model = self.model
            self.infoView.model = self.detail?.extend
            self.detailView.model = self.detail
            self.detailView.returns = self.returns
            self.offset = data.returns.count
            self.scrollView.mj_footer.isHidden = data.returns.count < self.limit
        }
    }
    ///
    @objc fileprivate func footerLoadMore() -> Void {
        EquipmentNetworkManager.getAssetBackList(order_id: self.id, offset: self.offset, limit: self.limit) { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            self.scrollView.mj_footer.endRefreshing()
            guard status, let models = models else {
                ToastUtil.showToast(title: msg)
                self.scrollView.mj_footer.endRefreshingWithWeakNetwork()
                return
            }
            self.returns.append(contentsOf: models)
            self.offset = self.returns.count
            self.detailView.returns = self.returns
            if models.isEmpty {
                self.scrollView.mj_footer.endRefreshingWithNoMoreData()
            }
        }
    }
    
}
extension EquipmentDetailController {
    
    ///
    fileprivate func preReturnClickProcess() -> Void {
        //
        guard let model = self.detail, model.zone == .ipfs, let _ = model.assets else {
            return
        }
        //
        switch model.pkg_status {
        case .deploying, .doing, .closed:
            Toast.showToast(title: "当前封装未完成，\n暂时无法提前归还")
        case .done:
            // 第一次 则显示引导视图
            if !NoviceGuideManager.share.isGuideComplete(for: .equipPreReturn) {
                self.enterPreReturnGuidePage()
                return
            }
            self.enterPreReturnPage(with: model)
        }
    }
    
}

// MARK: - Enter Page
extension EquipmentDetailController {

 
    /// 进入锁仓详情页
    fileprivate func enterEquipLockDetailPage(with id: Int) -> Void {
        guard let detail = self.detail else {
            return
        }
        let detailVC = LockDetailController.init(id: id, zone: detail.zone)
        self.enterPageVC(detailVC)
    }

    /// 资产明细
    fileprivate func enterAssetDetail(with model: EquipmentDetailModel) {
        let assetVC = AssetDetailHomeController.init(model: model)
        self.enterPageVC(assetVC)
    }
    
    /// 提前归还界面
    fileprivate func enterPreReturnPage(with model: EquipmentDetailModel) -> Void {
        let returnVC = PreReturnHomeController.init(model: model)
        self.enterPageVC(returnVC)
    }

    /// 归还流水界面
    fileprivate func enterReturnListPage() -> Void {
        let detailVC = ReturnListController.init()
        self.enterPageVC(detailVC)
    }
    
    // 引导弹窗
    fileprivate func enterPreReturnGuidePage() -> Void {
        let guideVC = PreReturnGuideController.init()
        guideVC.delegate = self
        self.present(guideVC, animated: false, completion: nil)
    }

}

// MARK: - Notification
extension EquipmentDetailController {

    
}

// MARK: - Extension Function
extension EquipmentDetailController {
    
}

// MARK: - Delegate Function

// MARK: - <UIScrollViewDelegate>
extension EquipmentDetailController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}

// MARK: - <AppHomeNavStatusViewProtocol>
extension EquipmentDetailController: AppHomeNavStatusViewProtocol {
    /// 导航栏左侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedLeftItem itemView: UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    /// 导航栏右侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedRightItem itemView: UIButton) -> Void {
        
    }

}

// MARK: - <EquipmentDetailViewProtocol>
extension EquipmentDetailController: EquipmentDetailViewProtocol {
    /// 资产明细入口点击
    func detailView(_ detailView: EquipmentDetailView, didClickedAssetDetail addetDetailView: UIView) -> Void {
        print("EquipmentDetailController detailView didClickedAssetDetail")
        guard let model = detailView.model else {
            return
        }
        self.enterAssetDetail(with: model)
    }
    /// 锁仓详情入口点击
    func detailView(_ detailView: EquipmentDetailView, didClickedLockDetail lockDetailView: UIView) -> Void {
        //print("EquipmentDetailController detailView didClickedLockDetail")
//        guard let model = detailView.model else {
//            return
//        }
        self.enterEquipLockDetailPage(with: self.id)
    }
    
    /// 提前归还点击回调
    func detailView(_ detailView: EquipmentDetailView, didClickedPreReturn returnView: UIView) -> Void {
        self.preReturnClickProcess()
    }
    
    /// 归还流水点击回调
    func detailView(_ detailView: EquipmentDetailView, didClickedReturnDetail returnDetailView: UIView) -> Void {
        print("EquipmentDetailController detailView didClickedReturnDetail")
        self.enterReturnListPage()
    }


}

// MARK: - <PreReturnGuideControllerProtocol>
extension EquipmentDetailController: PreReturnGuideControllerProtocol {

    /// skip / close
    func guideVC(_ guideVC: PreReturnGuideController, didClickedSkip skipView: UIButton) -> Void {
        guard let model = self.detail, model.zone == .ipfs, let asset = model.assets, asset.wait_total > 0 else {
            return
        }
        self.enterPreReturnPage(with: model)
    }
    /// done
    func guideVC(_ guideVC: PreReturnGuideController, didClickedDone doneView: UIButton) -> Void {
        guard let model = self.detail, model.zone == .ipfs, let asset = model.assets, asset.wait_total > 0 else {
            return
        }
        self.enterPreReturnPage(with: model)
    }
    
}
