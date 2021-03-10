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
    
    fileprivate let detailView: EquipmentDetailView = EquipmentDetailView.init()
    
    fileprivate let topBgViewHeight: CGFloat = CGSize.init(width: 375, height: 194).scaleAspectForWidth(kScreenWidth).height
    
    fileprivate let topViewHeight: CGFloat = EquipDetailHeaderView.viewHeight
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

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
        self.navBar.titleLabel.set(text: "设备详情", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor.white, alignment: .center)
        self.navBar.leftItem.isHidden = false
        self.navBar.leftItem.setImage(UIImage.init(named: "IMG_icon_nav_back_white"), for: .normal)
        self.navBar.leftItem.setImage(UIImage.init(named: "IMG_icon_nav_back_white"), for: .highlighted)
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
            make.height.equalTo(self.topViewHeight)
        }
        // 2. detailView
        scrollView.addSubview(self.detailView)
        self.detailView.delegate = self
        self.detailView.backgroundColor = UIColor.white
        self.detailView.snp.makeConstraints { (make) in
            make.leading.trailing.width.bottom.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom).offset(self.detailViewTopMargin)
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
//        self.scrollView.mj_header.endRefreshing()
        
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
            self.detailView.model = self.detail
            self.detailView.returns = self.returns
            //self.footerView.isHidden = model.list.isEmpty || model.list.count >= self.limit
            //self.scrollView.mj_footer.isHidden = model.list.count < self.limit
        }
    }
    ///
    @objc fileprivate func footerLoadMore() -> Void {
        self.scrollView.mj_footer.endRefreshing()
        
//        EquipmentNetworkManager.getHomeData(offset: self.offset, limit: self.limit) { [weak self](status, msg, model) in
//            guard let `self` = self else {
//                return
//            }
//            self.scrollView.mj_footer.endRefreshing()
//            guard status, let model = model else {
//                ToastUtil.showToast(title: msg)
//                return
//            }
//            self.model.list.append(contentsOf: model.list)
//            self.offset = self.model.list.count
//            self.headerView.model = self.model
//            self.setupItemContainer(with: self.model.list)
//            if model.list.isEmpty || model.list.count >= self.limit {
//                self.footerView.isHidden = false
//                self.scrollView.mj_footer.isHidden = true
//            } else {
//                self.footerView.isHidden = true
//                self.scrollView.mj_footer.isHidden = false
//            }
//        }

    }
    
}

// MARK: - Enter Page
extension EquipmentDetailController {
    /// 资产明细
    fileprivate func enterAssetDetail(with model: EquipmentDetailModel) {
        let assetVC = AssetDetailHomeController.init(model: model)
        self.enterPageVC(assetVC)
    }
    /// 锁仓明细
    fileprivate func enterLockDetail() {
        
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
        print("EquipmentDetailController detailView didClickedLockDetail")
        self.enterLockDetail()
    }

}


