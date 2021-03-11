//
//  WalletHomeController.swift
//  JXProject
//
//  Created by zhaowei on 2020/10/15.
//  Copyright © 2020 ChainOne. All rights reserved.
//
// Fil首页

import UIKit
import ChainOneKit

class WalletHomeController: BaseViewController {
    // MARK: - Internal Property
    fileprivate let navBar: AppHomeNavStatusView = AppHomeNavStatusView.init()
    // MARK: - Initialize Function
    fileprivate let mainView: WalletHomeMainView = WalletHomeMainView()

    init() {
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
extension WalletHomeController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
        NotificationCenter.default.addObserver(self, selector: #selector(assetRefreshNotificationProcess(_:)), name: AppNotificationName.Fil.refresh, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(assetRefreshNotificationProcess(_:)), name: AppNotificationName.Fil.withdrawAdress, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - UI
extension WalletHomeController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        // navigation
        // 1.nav
        self.view.addSubview(self.navBar)
        self.navBar.titleLabel.set(text: "FIL", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor.white, alignment: .center)
        self.navBar.leftItem.setImage(UIImage.init(named: "IMG_icon_nav_back_white"), for: .normal)
        self.navBar.rightItem.setTitle("FIL明细", for: .normal)
        self.navBar.rightItem.setTitleColor(UIColor.white, for: .normal)
        self.navBar.rightItem.set(font: UIFont.pingFangSCFont(size: 16))
        self.navBar.rightItem.snp.remakeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 64, height: 44))
        }
        self.navBar.delegate = self
        self.navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(kNavigationStatusBarHeight)
        }
        self.view.addSubview(self.mainView)
        self.mainView.delegate = self
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.view.bringSubviewToFront(self.navBar)
    }


}

// MARK: - Data(数据处理与加载)
extension WalletHomeController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        AssetNetworkManager.refreshHomeList { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            guard status, let model = model else {
                return
            }
            self.mainView.model = model
        }
        // 同步充值记录
        AssetNetworkManager.getRechargeRecords(currency: CurrencyType.fil.rawValue) { (status, msg) in
            
        }
    }
}

// MARK: - Request
extension WalletHomeController {
    fileprivate func refreshRequest() -> Void {
        
    }

}

// MARK: - Event(事件响应)
extension WalletHomeController {
    @objc fileprivate func headerRefresh() -> Void {
        
    }
}

// MARK: - Notification
extension WalletHomeController {
    /// 资产刷新通知处理
    @objc fileprivate func assetRefreshNotificationProcess(_ notification: Notification) {
        self.initialDataSource()
    }
}

// MARK: - Extension Function
extension WalletHomeController {

}

// MARK: - EnterPage
extension WalletHomeController {
    func enterWalletDetailPage() {
        self.enterPageVC(WalletDetailHomeController())
    }
    /// 提币按钮点击判断处理
    func enterWithdrawalProcess(assetModel: WalletFilInfoModel) {
        // 1. 地址绑定判断
        if assetModel.isBindWithdrawAddress {
            self.enterWalletWithdrawPage(assetModel: assetModel)
        } else {
            self.showBindWithdrawAddressAlert()
        }
    }
    /// 显示绑定提币地址弹窗
    fileprivate func showBindWithdrawAddressAlert() -> Void {
        let popView = WithdrawBindAddressPopView.init()
        popView.delegate = self
        PopViewUtil.showPopView(popView)
    }
    /// 进入提币地址绑定界面
    fileprivate func enterWithdrawAddressBindPage() -> Void {
        let bindVC = WithdrawAddressBindingController.init(currency: CurrencyType.fil.rawValue)
        self.enterPageVC(bindVC)
    }
    /// 进入Wallet提币界面
    fileprivate func enterWalletWithdrawPage(assetModel: WalletFilInfoModel) -> Void {
        let withdrawVC = FilWithdrawController.init(assetModel: assetModel)
        self.enterPageVC(withdrawVC)
    }
    /// 进入Wallet充币界面
    fileprivate func enterWalletRecharPage(assetModel: WalletFilInfoModel) -> Void {
        let withdrawVC = RechargeHomeController.init(currency: "FIL", address: assetModel.address)
        self.enterPageVC(withdrawVC)
    }
    /// 进入锁仓明细页
    fileprivate func enterLockDetail() -> Void {
//        let lockDetailVC = LockDetailController.init(currency: CurrencyType.fil)
//        self.enterPageVC(lockDetailVC)
    }
}
// MARK: - Delegate Function
extension WalletHomeController: AppHomeNavStatusViewProtocol {
    /// 导航栏左侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedLeftItem itemView: UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    /// 导航栏右侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedRightItem itemView: UIButton) -> Void {
        self.enterWalletDetailPage()
    }
}
// MARK: - WalletHomeMainViewProtocol
extension WalletHomeController: WalletHomeMainViewProtocol {
    func mainView(view: WalletHomeMainView, didClickLockDetailBtn btn: UIButton) {
        self.enterLockDetail()
    }
    func mainView(view: WalletHomeMainView, didClickWithdrwalBtn btn: UIButton) {
        print("didClickWithdrwalBtn")
        guard let model = view.model else {
            return
        }
        self.enterWithdrawalProcess(assetModel: model)
    }
    func mainView(view: WalletHomeMainView, didClickRechargeBtn btn: UIButton) {
        print("didClickRechargeBtn")
        guard let model = view.model else {
            return
        }
        self.enterWalletRecharPage(assetModel: model)
    }
}
// MARK: - <WithdrawBindAddressPopViewProtocol>
extension WalletHomeController: WithdrawBindAddressPopViewProtocol {
    /// 确定点击/去绑定点击
    func popView(_ popView: WithdrawBindAddressPopView, didClickedBind bindBtn: UIButton) -> Void {
        self.enterWithdrawAddressBindPage()
    }
    /// 遮罩点击 - 可选
    func popView(_ popView: WithdrawBindAddressPopView, didClickedCover cover: UIButton) -> Void {}
    /// 取消点击 - 可选
    func popView(_ popView: WithdrawBindAddressPopView, didClickedCancel cancelBtn: UIButton) -> Void {}

}
