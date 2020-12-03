//
//  FilWithdrawController.swift
//  HuoTuiVideo
//
//  Created by 小唐 on 2020/6/8.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  DSTT/USDT/ETH提币界面

import UIKit
import TZImagePickerController

class FilWithdrawController: BaseViewController
{
    // MARK: - Internal Property
    
    // MARK: - Private Property
    
    fileprivate let assetModel: WalletFilInfoModel
    fileprivate var configModel: WithdrawConfigModel? = nil
    
    fileprivate let statusNavBarView: AppHomeNavStatusView = AppHomeNavStatusView()
    fileprivate let scrollView: UIScrollView = UIScrollView.init()
    fileprivate let headerView: FilWithdrawHeaderView = FilWithdrawHeaderView.init()
    fileprivate let doneBtn: GradientLayerButton = GradientLayerButton.init(type: .custom)
    fileprivate let tipsLabel: UILabel = UILabel.init()
    
    fileprivate let lrMargin: CGFloat = 15
    fileprivate let topMargin: CGFloat = 12
    
    fileprivate let doneBtnHeight: CGFloat = 44
    fileprivate let doneBtnTopMargin: CGFloat = 22
    fileprivate let tipsTopMargin: CGFloat = 30
    
    fileprivate var limitSingleMinNum: Double = 1
    fileprivate var limitSingleMaxNum: Double = Double(Int.max)
    
    fileprivate var currentText: String?
    
    // MARK: - Initialize Function
    
    init(assetModel: WalletFilInfoModel) {
        self.assetModel = assetModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override Property
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
}

// MARK: - Internal Function

// MARK: - LifeCircle & Override Function
extension FilWithdrawController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.getConfigModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}

// MARK: - UI
extension FilWithdrawController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.init(hex: 0xF5F5F5)
         // 1. navigationbar
        self.view.addSubview(self.statusNavBarView)
        self.statusNavBarView.backgroundColor = UIColor.white
        self.statusNavBarView.delegate = self
        self.statusNavBarView.title = "提现"
        self.statusNavBarView.titleLabel.textColor = UIColor.init(hex: 0x333333)
        self.statusNavBarView.leftItem.setImage(UIImage.init(named: "IMG_navbar_back"), for: .normal)
        self.statusNavBarView.rightItem.isHidden = true
        self.statusNavBarView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(kNavigationStatusBarHeight)
        }
        // scrollView
        self.view.addSubview(self.scrollView)
        self.initialScrollView(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.statusNavBarView.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    fileprivate func initialScrollView(_ scrollView: UIScrollView) -> Void {
        // scrollView
        scrollView.showsVerticalScrollIndicator = false
        // 1. headerView
        scrollView.addSubview(self.headerView)
        self.headerView.delegate = self
//        self.headerView.set(cornerRadius: 10)
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.topMargin)
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.width.equalTo(kScreenWidth - self.lrMargin * 2.0)
            make.height.equalTo(FilWithdrawHeaderView.viewHeight)
        }
        // 2. doneBtn
        scrollView.addSubview(self.doneBtn)
        self.doneBtn.set(title: "立即提现", titleColor: UIColor.white, for: .normal)
        self.doneBtn.set(title: "立即提现", titleColor: UIColor.white, for: .highlighted)
        self.doneBtn.set(font: UIFont.pingFangSCFont(size: 18, weight: .medium), cornerRadius: self.doneBtnHeight * 0.5)
        self.doneBtn.backgroundColor = UIColor.init(hex: 0xDDDDDD)
        self.doneBtn.gradientLayer.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth - self.lrMargin * 2.0, height: self.doneBtnHeight)
        self.doneBtn.isEnabled = false
        self.doneBtn.gradientLayer.isHidden = !self.doneBtn.isEnabled
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.headerView.snp.bottom).offset(self.doneBtnTopMargin)
            make.height.equalTo(self.doneBtnHeight)
        }
        // 3. tips
        scrollView.addSubview(self.tipsLabel)
        self.tipsLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12), textColor: UIColor.init(hex: 0x999999))
        self.tipsLabel.numberOfLines = 0
        self.tipsLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.doneBtn.snp.bottom).offset(self.tipsTopMargin)
            make.bottom.lessThanOrEqualToSuperview().offset(-self.tipsTopMargin)
        }
        // tips
        let tips: String = "温馨提示：\n1.请仔细核对您的提现信息，未进行微信认证的用户造成的现金无法到账问题，责任自负，不予退还。\n2.一天只能提现一次。\n3.单次最多可提现金XXX元。\n4.预约提现需要3到5个工作日确认，为保障您的资金安全，还望谅解。"
        self.tipsLabel.text = tips
    }

}

// MARK: - Data(数据处理与加载)
extension FilWithdrawController {
    /// 默认数据加载
    fileprivate func getConfigModel() -> Void {
        AssetNetworkManager.walletWithdrawalConfig { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            guard status, let model = model?.filWithdrawConfigModel else {
                Toast.showToast(title: msg)
                return
            }
            self.configModel = model
            self.initialDataSource()
        }
    }
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        guard let configModel = self.configModel else {
            return
        }
        self.headerView.configModel = configModel
        self.headerView.assetInfoModel = self.assetModel
        let balance: String = assetModel.withdrawable
        self.limitSingleMaxNum = Double(balance) ?? 0.0
        self.tipsLabel.text = "温馨提示：\n" + configModel.instr
        self.limitSingleMinNum = configModel.user_min
        self.couldDoneProcess()
    }

    fileprivate func couldDone() -> Bool {
        var couldDone = false
        guard let priceText = self.currentText, !priceText.isEmpty, !((Double(priceText) ?? 0.00) > self.limitSingleMaxNum), (Double(priceText) ?? 0.00) >= self.limitSingleMinNum else {
            return false
        }
        couldDone = true
        return couldDone
    }
    fileprivate func couldDoneProcess() -> Void {
        self.doneBtn.isEnabled = self.couldDone()
        self.doneBtn.gradientLayer.isHidden = !self.couldDone()
        //  判断是否显示error 显示实际到账金额
        if let priceText = self.currentText, !priceText.isEmpty, ((Double(priceText) ?? 0.00) > self.limitSingleMaxNum) {
            self.headerView.numTipsLabel.isHidden = false
        } else {
            self.headerView.numTipsLabel.isHidden = true
        }
    }
}

// MARK: - 网络请求
extension FilWithdrawController {
    /// 获取结果
    func submitRequest(_ view: InputPasswordWithKeyBoardView, password: String) {
        guard let inputText = self.currentText, !inputText.isEmpty else {
            return
        }
        AssetNetworkManager.filWithdrawal(amount: inputText, pay_pass: password) { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            guard status, let model = model else {
                Toast.showToast(title: msg)
                return
            }
            self.enterWithdrawResultPage(model)
            NotificationCenter.default.post(name: AppNotificationName.Fil.refresh, object: nil)
        }
    }

}


// MARK: - Event(事件响应)
extension FilWithdrawController {
    /// 确定按钮点击
    @objc fileprivate func doneBtnClick(_ doneBtn: UIButton) -> Void {
        // 1. 支付前置判断: 实名认证 + 支付密码
        guard let user = AccountManager.share.currentAccountInfo?.userInfo else {
            return
        }
        // 1.1 未认证/未通过认证
//        if user.certStatus != .certified {
//            self.showRealNameAlert()
//            return
//        }
        // 1.2 未初始化支付密码
        if !user.payPwdStatus {
            self.showPayPwdInitialAlert()
            return
        }
        // 2. 支付密码输入弹窗
        let inputView: InputPasswordWithKeyBoardView = InputPasswordWithKeyBoardView()
        inputView.delegate = self
        inputView.tag = 5_000
        UIApplication.shared.keyWindow?.addSubview(inputView)
        inputView.snp.makeConstraints({ (make) in
            make.top.left.right.bottom.equalToSuperview()
        })
    }

}

// MARK: - Enter Page
extension FilWithdrawController {
    /// 提现结果页
    fileprivate func enterWithdrawResultPage(_ model: WalletWithdrawResultModel) -> Void {
        let resultVC = WalletWithdrawResultController.init(result: model)
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    /// 支付密码重置界面
    fileprivate func enterPayPwdPage() -> Void {
        let verifyVC = PhoneVerityController.init(type: .payPwdReset)
        self.enterPageVC(verifyVC)
    }
    /// 进入实名认证界面
    fileprivate func enterRealNameCertPage() -> Void {
//        let certVC = RealNameCertController.init()
//        self.enterPageVC(certVC)
    }
}

// MARK: - Alert
extension FilWithdrawController {
    /// 实名认证弹框
    fileprivate func showRealNameAlert() -> Void {
        CommonAlertUtil.showCustomAlert(title: "需要实名认证", message: "您还未完成实名认证，请先完成！", subMessage: "完成实名认证可获得能量奖励，\n并解禁链聊各功能使用权限！", leftTitle: "我再想想", rightTitle: "立即认证", leftTitleColor: UIColor.init(hex: 0x8997ae), rightTitleColor: UIColor.init(hex: 0x00c1d5)) { [weak self](btnTitle) in
            guard let `self` = self else {
                return
            }
            if btnTitle == "我再想想" {
            } else if btnTitle == "立即认证" {
                self.enterRealNameCertPage()
            }
        }
    }
    /// 支付密码设置弹窗
    fileprivate func showPayPwdInitialAlert() -> Void {
        let alertVC = UIAlertController.init(title: "请设置支付密码", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "取消", style: .default, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "去设置", style: .default, handler: { [weak self](action) in
            guard let `self` = self else {
                return
            }
            let verifyVC = PhoneVerityController.init(type: .payPwdInitial)
            self.enterPageVC(verifyVC)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }

    /// 图片图片预览界面
    fileprivate func showQrcodePreviewPage() -> Void {
        guard let user = AccountManager.share.currentAccountInfo?.userInfo else {
            return
        }
//        let previewVC = WithdrawQrcodePreviewController.init(type: .networkImage)
//        previewVC.networkImage = user.withdraw_address_qr
//        self.present(previewVC, animated: false, completion: nil)
    }
    /// 进入客服界面
    fileprivate func enterKefuPage() -> Void {
//        let strUrl = UrlManager.kefuUrl
//        let webVC = XDWKWebViewController.init(type: XDWebViwSourceType.strUrl(strUrl: strUrl))
//        self.enterPageVC(webVC)
//        AppUtil.enterKefuContactPage()
    }
    
}


// MARK: - Notification
extension FilWithdrawController {
    
}

// MARK: - Extension Function
extension FilWithdrawController {
    
}

// MARK: - Delegate Function

// MARK: - <AssetExchangeHeaderViewProtocol>
extension FilWithdrawController: FilWithdrawHeaderViewProtocol {
    func headerView(_ view: FilWithdrawHeaderView, _ currentNum: String?) {
        self.currentText = currentNum
        self.couldDoneProcess()
    }
    /// 二维码点击回调
    func headerView(_ view: FilWithdrawHeaderView, didClickedQrcode qrcodView: UIView) {
        self.view.endEditing(true)
        self.showQrcodePreviewPage()
    }
    /// 联系客服点击回调
    func headerView(_ view: FilWithdrawHeaderView, didClickedKefu kefuView: UIView) {
        self.enterKefuPage()
    }

}
// MARK: - AppHomeNavStatusViewProtocol
extension FilWithdrawController: AppHomeNavStatusViewProtocol {
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedLeftItem itemView: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedRightItem itemView: UIButton) {

    }
}
extension FilWithdrawController: InputPayPasswordViewProtocol {
    func inputPayView(_ view: InputPasswordWithKeyBoardView, cancel button: UIButton) {
        view.removeFromSuperview()
    }

    func inputPayView(_ view: InputPasswordWithKeyBoardView, finish text: String) {
        view.removeFromSuperview()
        /// 发起提现接口
        self.submitRequest(view, password: text)
    }

    func inputPayView(_ view: InputPasswordWithKeyBoardView, forget button: UIButton) {
        /// 跳转忘记密码
        self.enterPayPwdPage()
    }
}
