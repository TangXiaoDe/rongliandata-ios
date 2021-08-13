//
//  PreReturnInputController.swift
//  SassProject
//
//  Created by 小唐 on 2021/7/27.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  提前还币输入页

import UIKit

class PreReturnInputController: BaseViewController {

    // MARK: - Internal Property
    
    var type: PreReturnType
    let model: EquipmentDetailModel
    var totalFil: Double = 0
    
    // MARK: - Private Property
    
    fileprivate let scrollView: UIScrollView = UIScrollView.init()
    fileprivate let mainView: UIView = UIView.init()
    
    fileprivate let typeView: IconTitleValueControl = IconTitleValueControl.init()
    fileprivate let centerView: PreReturnInputMainView = PreReturnInputMainView.init()
    
    fileprivate let doneBtn: UIButton = UIButton.init(type: .custom)
    fileprivate let tipsLabel: UILabel = UILabel.init()

    fileprivate let lrMargin: CGFloat = 12
    fileprivate let verMargin: CGFloat = 12
    fileprivate let typeViewHeight: CGFloat = 56

    fileprivate let doneBtnTopMargin: CGFloat = 40  // centerView.bottom
    fileprivate let doneBtnHeight: CGFloat = 44
    fileprivate let tipsTopMargin: CGFloat = 20     // doneBtn.bottom
    
    
    // MARK: - Initialize Function
    
    init(type: PreReturnType, model: EquipmentDetailModel) {
        self.type = type
        self.model = model
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
extension PreReturnInputController {
    
}

// MARK: - LifeCircle/Override Function
extension PreReturnInputController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    /// 控制器的view将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        // 添加键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotificationProcess(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotificationProcess(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    /// 控制器的view即将消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 移除键盘通知
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

// MARK: - UI Function
extension PreReturnInputController {

    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.pageBg
        // 1. navBar
        self.navigationItem.title = "提前还币"
        // scrollView
        self.view.addSubview(self.scrollView)
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.bounces = false
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 2. mainView
        self.scrollView.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.leading.trailing.width.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    ///
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. typView
        mainView.addSubview(self.typeView)
        self.typeView.backgroundColor = UIColor.white
        self.typeView.set(cornerRadius: 10)
        self.typeView.addTarget(self, action: #selector(typeViewClick(_:)), for: .touchUpInside)
        self.typeView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalToSuperview().offset(self.verMargin)
            make.height.equalTo(self.typeViewHeight)
        }
        self.typeView.titleLabel.set(text: "还币类型", font: UIFont.pingFangSCFont(size: 15), textColor: AppColor.detailText)
        self.typeView.titleLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(self.lrMargin)
        }
        self.typeView.iconView.image = UIImage.init(named: "IMG_equip_next_black")
        self.typeView.iconView.set(cornerRadius: 0)
        self.typeView.iconView.snp.remakeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 6, height: 11))
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.lrMargin)
        }
        self.typeView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.mainText, alignment: .right)
        self.typeView.valueLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.typeView.iconView.snp.leading).offset(-5)
        }
        // 2. centerView
        mainView.addSubview(self.centerView)
        self.centerView.delegate = self
        self.centerView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.typeView.snp.bottom).offset(self.verMargin)
        }
        // 3. doneBtn
        mainView.addSubview(self.doneBtn)
        self.doneBtn.set(title: "确认还币", titleColor: UIColor.white, for: .normal)
        self.doneBtn.set(title: "确认还币", titleColor: UIColor.white, for: .highlighted)
        self.doneBtn.set(font: UIFont.systemFont(ofSize: 18, weight: .medium), cornerRadius: self.doneBtnHeight * 0.5)
        self.doneBtn.backgroundColor = AppColor.disable
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.height.equalTo(self.doneBtnHeight)
            make.top.equalTo(self.centerView.snp.bottom).offset(self.doneBtnTopMargin)
        }
        // 4. tipsLabel
        mainView.addSubview(self.tipsLabel)
        self.tipsLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.grayText)
        self.tipsLabel.numberOfLines = 0
        self.tipsLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self.doneBtn.snp.bottom).offset(self.tipsTopMargin)
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.bottom.lessThanOrEqualToSuperview().offset(-self.tipsTopMargin)
        }
    }

}

// MARK: - Data Function
extension PreReturnInputController {

    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        //
        let tips: String = "温馨提示：\n输入还Fil本金，当还Fil类型有利息时，则本次归还数量为输入本金的本息总计。欠款利息部分不再计算利息。"
        self.tipsLabel.text = tips
        self.centerView.model = self.model
        self.setupWithType(self.type)
        self.requestForFilAsset()
        self.couldDoneProcess()
    }

    ///
    fileprivate func setupWithType(_ type: PreReturnType) -> Void {
        self.typeView.valueLabel.text = type.title
        self.centerView.type = type
    }
    
    ///
    fileprivate func couldDone() -> Bool {
        return self.centerView.couldDone
    }
    ///
    fileprivate func couldDoneProcess() -> Void {
        self.doneBtn.isEnabled = self.couldDone()
        self.doneBtn.backgroundColor = self.doneBtn.isEnabled ? AppColor.theme : AppColor.disable
    }
    
    ///
    fileprivate func doneBtnClickProcess() -> Void {
        guard let inputValue = self.centerView.inputValue, let user = AccountManager.share.currentAccountInfo?.userInfo else {
            return
        }
        // 1. 认证判断
        // 2. 密码设置判断
        if !user.payPwdStatus {
            self.showPayPwdInitialAlert(account: user.phone)
            return
        }
        // 3. 弹出密码输入框
        let inputView: InputPasswordWithKeyBoardView = InputPasswordWithKeyBoardView()
        inputView.delegate = self
        inputView.tag = 5_000
        UIApplication.shared.keyWindow?.addSubview(inputView)
        inputView.snp.makeConstraints({ (make) in
            make.top.left.right.bottom.equalToSuperview()
        })
    }

}

// MARK: - Event Function
extension PreReturnInputController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    ///
    @objc fileprivate func typeViewClick(_ typeView: UIControl) -> Void {
        self.view.endEditing(true)
        self.enterTypeSelectPage()
    }

    ///
    @objc fileprivate func doneBtnClick(_ button: UIButton) -> Void {
        self.view.endEditing(true)
        self.doneBtnClickProcess()
    }
    
}

// MARK: - Request Function
extension PreReturnInputController {
    
    /// FIL资产请求
    fileprivate func requestForFilAsset() -> Void {
        AssetNetworkManager.getWalletAllInfo { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            guard status, let models = models else {
                Toast.showToast(title: msg)
                return
            }
            models.forEach { (model) in
                if model.currencyType == .fil {
                    self.totalFil = model.lfwithdrawable
                    self.centerView.totalFil = self.totalFil
                    self.couldDoneProcess()
                }
            }
        }
    }
    
    /// 获取结果
    fileprivate func submitRequest(with password: String) {
        guard let inputValue = self.centerView.inputValue else {
            return
        }
        EquipmentNetworkManager.preReturn(orderId: "\(self.model.id)", returnType: self.type, amount: inputValue.decimalValidDigitsProcess(digits: 8), payPwd: password) { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            guard status, let model = model else {
                Toast.showToast(title: msg)
                return
            }
            self.enterResultPage(with: model)
        }
    }
    
}

// MARK: - Enter Page
extension PreReturnInputController {
    
    /// 显示支付密码初始化弹窗(未设置支付密码时的弹窗)
    fileprivate func showPayPwdInitialAlert(account: String) -> Void {
        let alertVC = UIAlertController.init(title: nil, message: "您还没有设置支付密码，无法完成此笔交易！", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "前往设置", style: UIAlertAction.Style.destructive, handler: { (action) in
            self.enterPayPwdSetPage(account: account)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /// 进入支付密码设置界面——未设置支付密码时使用
    fileprivate func enterPayPwdSetPage(account: String) -> Void {
        let verifyVC = PhoneVerityController.init(type: PhoneVerifyType.payPwdInitial)
        let verifyNC = BaseNavigationController.init(rootViewController: verifyVC)
        verifyNC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(verifyNC, animated: false, completion: nil)
    }

    ///
    fileprivate func enterTypeSelectPage() -> Void {
        let selectVC = PreReturnTypeSelectController.init()
        selectVC.delegate = self
        self.present(selectVC, animated: false, completion: nil)
    }
    
    ///
    fileprivate func enterResultPage(with model: PreReturnResultModel) -> Void {
        let resultVC = PreReturnResultController.init(model: model)
        self.enterPageVC(resultVC)
    }
    
    /// 支付密码重置界面
    fileprivate func enterPayPwdPage() -> Void {
        let verifyVC = PhoneVerityController.init(type: .payPwdReset)
        self.enterPageVC(verifyVC)
    }
    
}

// MARK: - Notification Function
extension PreReturnInputController {
    
    /// 键盘将要显示
    @objc fileprivate func keyboardWillShowNotificationProcess(_ notification: Notification) -> Void {
        let confirmMaxY: CGFloat = self.doneBtn.convert(CGPoint.init(x: 0, y: self.doneBtnHeight), to: nil).y + 5
        guard let userInfo = notification.userInfo, let kdBounds = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        let kbH: CGFloat = kdBounds.size.height
        let bottomMargin = kScreenHeight - confirmMaxY
        if bottomMargin < kbH {
            let margin: CGFloat = kbH - bottomMargin
            let transform = CGAffineTransform.init(translationX: 0, y: -margin)
            UIView.animate(withDuration: duration, animations: {
                self.view.transform = transform
            }, completion: nil)
        }
    }

    /// 键盘将要消失
    @objc fileprivate func keyboardWillHideNotificationProcess(_ notification: Notification) -> Void {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform.identity
        }, completion: nil)
    }

}

// MARK: - Extension Function
extension PreReturnInputController {
    
}

// MARK: - Delegate Function

// MARK: - <PreReturnTypeSelectControllerProtocol>
extension PreReturnInputController: PreReturnTypeSelectControllerProtocol {

    ///
    func returnTypeSelectVC(_ selectVC: PreReturnTypeSelectController, didSelected type: PreReturnType) -> Void {
        self.type = type
        self.setupWithType(self.type)
        self.couldDoneProcess()
    }
    
}

// MARK: - <PreReturnInputMainViewProtocol>
extension PreReturnInputController: PreReturnInputMainViewProtocol {
    
    ///
    func didUpdateDoneBtnEnable(with inputMainView: PreReturnInputMainView) -> Void {
        self.couldDoneProcess()
    }

}

// MARK: - <InputPayPasswordViewProtocol>
extension PreReturnInputController: InputPayPasswordViewProtocol {
    
    func inputPayView(_ view: InputPasswordWithKeyBoardView, cancel button: UIButton) {
        view.removeFromSuperview()
    }

    func inputPayView(_ view: InputPasswordWithKeyBoardView, finish text: String) {
        view.removeFromSuperview()
        /// 发起请求
        self.submitRequest(with: text)
    }

    func inputPayView(_ view: InputPasswordWithKeyBoardView, forget button: UIButton) {
        view.removeFromSuperview()
        /// 跳转忘记密码
        self.enterPayPwdPage()
    }

}
