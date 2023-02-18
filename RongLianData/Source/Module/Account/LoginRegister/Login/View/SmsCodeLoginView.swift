//
//  SmsCodeLoginView.swift
//  ChuangYe
//
//  Created by 小唐 on 2020/8/14.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  验证码登录视图

import UIKit
import ChainOneKit

class SmsCodeLoginView: UIView {

    // MARK: - Internal Property

    var model: String? {
        didSet {
            self.setupWithModel(model)
        }
    }

    var inputChangedAction: ((_ inputView: SmsCodeLoginView) -> Void)?

    var account: String? {
        return self.phoneView.textField.text
    }
    var smsCode: String? {
        return self.smsCodeView.textField.text
    }

    // MARK: - Private Property

    let mainView: UIView = UIView()
    let phoneView: LoginPhoneInputView = LoginPhoneInputView.init()
    let smsCodeView: LoginSmsCodeInputView = LoginSmsCodeInputView.init()

    fileprivate let infoHeight: CGFloat = LoginNormalInputView.viewHeight
    fileprivate let accountMaxLen: Int = 11
    fileprivate let codeMaxLen: Int = 6


    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        //fatalError("init(coder:) has not been implemented")
    }

    /// 通用初始化：UI、配置、数据等
    func commonInit() -> Void {
        self.initialUI()
    }

}

// MARK: - Internal Function
extension SmsCodeLoginView {
    class func loadXib() -> SmsCodeLoginView? {
        return Bundle.main.loadNibNamed("SmsCodeLoginView", owner: nil, options: nil)?.first as? SmsCodeLoginView
    }

    func couldDone() -> Bool {
        var flag: Bool = false
        guard let account = self.phoneView.textField.text, let code = self.smsCodeView.textField.text else {
            return flag
        }
        flag = !account.isEmpty && !code.isEmpty
        return flag
    }

}

// MARK: - LifeCircle Function
extension SmsCodeLoginView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }

    /// 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()

    }

}
// MARK: - Private UI 手动布局
extension SmsCodeLoginView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. phone
        mainView.addSubview(self.phoneView)
        self.phoneView.textField.addTarget(self, action: #selector(textFieldValueChainge(_:)), for: .editingChanged)
        self.phoneView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.infoHeight)
        }
        // 2. smscode
        mainView.addSubview(self.smsCodeView)
        self.smsCodeView.textField.addTarget(self, action: #selector(textFieldValueChainge(_:)), for: .editingChanged)
        self.smsCodeView.codeBtn.addTarget(self, action: #selector(sendCodeBtnClick(_:)), for: .touchUpInside)
        self.smsCodeView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.phoneView.snp.bottom)
            make.height.equalTo(self.infoHeight)
        }
    }

}
// MARK: - Private UI Xib加载后处理
extension SmsCodeLoginView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension SmsCodeLoginView {
    /// 数据加载
    fileprivate func setupWithModel(_ model: String?) -> Void {
        guard let _ = model else {
            return
        }
        // 子控件数据加载
    }

}

// MARK: - Event Function
extension SmsCodeLoginView {
    /// 输入框输入值变更
    @objc fileprivate func textFieldValueChainge(_ textField: UITextField) -> Void {
        switch textField {
        case self.phoneView.textField:
            TextFieldHelper.limitTextField(textField, withMaxLen: self.accountMaxLen)
            self.inputChangedAction?(self)
        case self.smsCodeView.textField:
            TextFieldHelper.limitTextField(textField, withMaxLen: self.codeMaxLen)
            self.inputChangedAction?(self)
        default:
            break
        }
    }

    /// 账号清除按钮点击
    @objc fileprivate func accountClearBtnClick(_ textField: UITextField) -> Void {
//        self.accountField.text = nil
//        self.inputChangedAction?(self)
    }

    /// 发送验证码点击
    @objc fileprivate func sendCodeBtnClick(_ button: UIButton) -> Void {
        self.endEditing(true)
        guard let account = self.phoneView.textField.text, !account.isEmpty else {
            Toast.showToast(title: "请先输入手机号")
            return
        }
        self.sendSmsCodeRequest(account: account)
    }

}

// MARK: - Request
extension SmsCodeLoginView {
    /// 发送短信验证码请求
    fileprivate func sendSmsCodeRequest(account: String) -> Void {
        self.smsCodeView.codeBtn.isUserInteractionEnabled = false
        AccountNetworkManager.sendSMSCode(account: account, scene: .login, ticket: "", randStr: "") { [weak self](status, msg) in
            guard let `self` = self else {
                return
            }
            //self.smsCodeView.codeBtn.setTitle("重新发送验证码", for: .normal)
            self.smsCodeView.codeBtn.isUserInteractionEnabled = true
            guard status else {
                Toast.showToast(title: msg)
                return
            }
            Toast.showToast(title: "验证码已发送")
            self.smsCodeView.startTimer()
        }
    }

}

// MARK: - Extension Function
extension SmsCodeLoginView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension SmsCodeLoginView {

}
