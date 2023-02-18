//
//  RegisterView.swift
//  iMeet
//
//  Created by 小唐 on 2019/3/11.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  注册视图
//  注：所有输入框中的中清理按钮图标都不显示；

import UIKit
import ObjectMapper
import ChainOneKit

protocol RegisterViewProtocol: class {
    func registerView(_ registerView: RegisterView, didCliedkedAgreement agreementBtn: UIButton) -> Void
    func registerView(_ registerView: RegisterView, didCliedkedRegister registerBtn: UIButton, account: String, password: String, confirmPwd: String, smsCode: String, inviteCode: String?) -> Void
}

class RegisterView: UIView {

    // MARK: - Internal Property

    static let viewHeight: CGFloat = 425

    /// 回调
    weak var delegate: RegisterViewProtocol?

    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var verifyCodeView: UIView!
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var confirmPwdView: UIView!
    @IBOutlet weak var inviteCodeView: UIView!
    @IBOutlet weak var registerBtn: CommonDoneBtn!
    @IBOutlet weak var agreementView: UIView!

    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var areaCodeBtn: UIButton!
    @IBOutlet weak var verifyCodeField: UITextField!
    @IBOutlet weak var sendCodeBtn: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var pwdSecurityBtn: UIButton!
    @IBOutlet weak var confirmPwdField: UITextField!
    @IBOutlet weak var confirmPwdCorrectBtn: UIButton!
    @IBOutlet weak var inviteCodeField: UITextField!
    /// 是否选中协议圆圈按钮
    @IBOutlet weak var agreeBtn: UIButton!
    /// 协议名称按钮
    @IBOutlet weak var agreementBtn: UIButton!
    /// 协议同意描述
    @IBOutlet weak var agreePromptLabel: UILabel!
    
    fileprivate let coverBtn = UIButton.init(type: .custom)
    
    fileprivate var captchaView: DXCaptchaView!

    // MARK: - Private Property

    /// 倒计时
    fileprivate let countdownLabel: UILabel = UILabel()

    fileprivate let registerBtnLrMargin: CGFloat = 12
    fileprivate let registerBtnH: CGFloat = 44
    fileprivate let sendCodeBtnH: CGFloat = 28
    fileprivate let sendCodeBtnW: CGFloat = 84

    fileprivate let accountLen: Int = 11
    fileprivate let passwordMaxLen: Int = 20
    fileprivate let passwordMinLen: Int = 10
    fileprivate let smsCodeMaxLen: Int = 6
    fileprivate let smsCodeMinLen: Int = 4
    fileprivate let inputMaxLen: Int = Int.max

    /// 定时器相关
    fileprivate let maxLeftSecond: Int = 60
    fileprivate var leftSecond: Int = 60
    fileprivate var timer: Timer? = nil

    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
        self.initialUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialUI()
        //fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.stopTimer()
    }

}

// MARK: - Internal Function
extension RegisterView {
    class func loadXib() -> RegisterView? {
        return Bundle.main.loadNibNamed("RegisterView", owner: nil, options: nil)?.first as? RegisterView
    }
}

// MARK: - LifeCircle Function
extension RegisterView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension RegisterView {

    /// 界面布局
    fileprivate func initialUI() -> Void {

    }

}
// MARK: - Private UI Xib加载后处理
extension RegisterView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        self.backgroundColor = UIColor.clear
        // accountField
        let accountClearBtn: UIButton = UIButton.init(type: .custom)
        accountClearBtn.setImage(UIImage.init(named: "IMG_login_input_clear"), for: .normal)
        accountClearBtn.bounds = CGRect.init(x: 0, y: 0, width: 22, height: 30)
        accountClearBtn.addTarget(self, action: #selector(accountClearBtnClick(_:)), for: .touchUpInside)
        self.accountField.rightView = accountClearBtn
        self.accountField.rightViewMode = .never    // 右侧清除按钮暂不显示
        self.accountField.addTarget(self, action: #selector(accountFieldValueChanged(_:)), for: .editingChanged)
        self.accountField.attributedPlaceholder = NSAttributedString.init(string: "input.placeholder.phone".localized, attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        // smsCodeField
        self.verifyCodeField.addTarget(self, action: #selector(smsCodeFieldValueChanged(_:)), for: .editingChanged)
        //self.verifyCodeField.clearButtonMode = .whileEditing      // 右侧清除按钮暂不显示
        self.verifyCodeField.attributedPlaceholder = NSAttributedString.init(string: "input.placeholder.smscode".localized, attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        // passwordField
        let passwordClearBtn: UIButton = UIButton.init(type: .custom)
        passwordClearBtn.setImage(UIImage.init(named: "IMG_login_input_clear"), for: .normal)
        passwordClearBtn.bounds = CGRect.init(x: 0, y: 0, width: 22, height: 30)
        passwordClearBtn.addTarget(self, action: #selector(passwordClearBtnClick(_:)), for: .touchUpInside)
        self.passwordField.rightView = passwordClearBtn
        self.passwordField.rightViewMode = .never    // 右侧清除按钮暂不显示
        self.passwordField.isSecureTextEntry = true
        self.passwordField.addTarget(self, action: #selector(passwordFieldValueChanged(_:)), for: .editingChanged)
        self.passwordField.attributedPlaceholder = NSAttributedString.init(string: "input.placeholder.loginpwd.desc".localized, attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        // pwdSecurityBtn
        self.pwdSecurityBtn.isSelected = false
        // confirmPwdField
        let confirmPwdClearBtn: UIButton = UIButton.init(type: .custom)
        confirmPwdClearBtn.setImage(UIImage.init(named: "IMG_login_input_clear"), for: .normal)
        confirmPwdClearBtn.bounds = CGRect.init(x: 0, y: 0, width: 22, height: 30)
        confirmPwdClearBtn.addTarget(self, action: #selector(confirmPwdClearBtnClick(_:)), for: .touchUpInside)
        self.confirmPwdField.rightView = confirmPwdClearBtn
        self.confirmPwdField.rightViewMode = .never    // 右侧清除按钮暂不显示
        self.confirmPwdField.isSecureTextEntry = true
        self.confirmPwdField.addTarget(self, action: #selector(confirmPwdFieldValueChanged(_:)), for: .editingChanged)
        self.confirmPwdField.addTarget(self, action: #selector(confirmPwdFieldBeginEditing(_:)), for: .editingDidBegin)
        self.confirmPwdField.attributedPlaceholder = NSAttributedString.init(string: "input.placeholder.repassword".localized, attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        // confirmPwdCorrectBtn
        self.confirmPwdCorrectBtn.isUserInteractionEnabled = false
        self.confirmPwdCorrectBtn.contentMode = .right
        self.confirmPwdCorrectBtn.isHidden = true   // 默认隐藏
        // registerBtn
        self.registerBtn.backgroundColor = UIColor.clear
        self.registerBtn.gradientLayer.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth - self.registerBtnLrMargin * 2.0, height: self.registerBtnH)
        self.registerBtn.set(cornerRadius: 5)
        self.registerBtn.setTitle("donebtn.register".localized, for: .normal)
        // agreeBtn
        self.agreeBtn.isSelected = false
        // sendSmsBtn
        self.sendCodeBtn.set(font: UIFont.systemFont(ofSize: 12), cornerRadius: 5, borderWidth: 0.5, borderColor: AppColor.theme)
        self.sendCodeBtn.setTitle("smscode.send".localized, for: .normal)
        self.sendCodeBtn.setTitleColor(AppColor.theme, for: .normal)
        self.sendCodeBtn.backgroundColor = UIColor.init(hex: 0xFFFFFF)
        // countdownLabel
        self.addSubview(self.countdownLabel)
        self.countdownLabel.set(text: nil, font: UIFont.systemFont(ofSize: 12), textColor: AppColor.minorText, alignment: .center)
        self.countdownLabel.set(cornerRadius: 5, borderWidth: 1, borderColor: AppColor.minorText)
        self.countdownLabel.isHidden = true // 默认隐藏
        self.countdownLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self.sendCodeBtn)
        }
        // inviteCodeField
        self.inviteCodeField.addTarget(self, action: #selector(inviteCodeFieldValueChanged(_:)), for: .editingChanged)
        self.inviteCodeField.attributedPlaceholder = NSAttributedString.init(string: "input.placeholder.register.invitecode".localized, attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        // agreement
        self.agreeBtn.isSelected = true     // 默认勾选协议同意 
        self.agreePromptLabel.text = "register.agreement.agree".localized
        self.agreementBtn.setTitle("register.agreement".localized, for: .normal)
        self.agreementBtn.set(title: "register.agreement".localized, titleColor: AppColor.theme, for: .normal)
        self.agreementBtn.addLineWithSide(.outBottom, color: AppColor.theme, thickness: 1, margin1: 0, margin2: 0)
        // 版本适配
        if #available(iOS 11.0, *) {
            self.passwordField.textContentType = UITextContentType.name
            self.confirmPwdField.textContentType = UITextContentType.name
        }

        // couldDone
        self.couldDoneProcess()
    }

}

// MARK: - Data Function
extension RegisterView {

    fileprivate func couldDone() -> Bool {
        var flag: Bool = false
        guard let account = self.accountField.text, let verifyCode = self.verifyCodeField.text, let password = self.passwordField.text, let confirmPwd = self.confirmPwdField.text, let inviteCode = self.inviteCodeField.text else {
            return flag
        }
        flag = (!account.isEmpty && !verifyCode.isEmpty && self.agreeBtn.isSelected && !password.isEmpty && !confirmPwd.isEmpty && !inviteCode.isEmpty)
        return flag
    }
    fileprivate func couldDoneProcess() -> Void {
        self.registerBtn.isEnabled = self.couldDone()
    }

    /// 确认密码一致性处理 isConfirmPwdEditing 是否确认密码输入
    fileprivate func confirmPwdCorrectProcess(isConfirmPwdEditing: Bool = false) -> Void {
        guard let password = self.passwordField.text, let confirmPwd = self.confirmPwdField.text else {
            self.confirmPwdCorrectBtn.isSelected = false
            self.confirmPwdCorrectBtn.isHidden = true
            return
        }
        self.confirmPwdCorrectBtn.isHidden = isConfirmPwdEditing ? false : confirmPwd.isEmpty
        self.confirmPwdCorrectBtn.isSelected = (password == confirmPwd && !password.isEmpty)
    }

}

// MARK: - Event Function
extension RegisterView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.endEditing(true)
    }

    /// 协议是否同意按钮点击响应
    @IBAction func agreeBtnClick(_ sender: UIButton) {
        self.endEditing(true)
        sender.isSelected = !sender.isSelected
        self.couldDoneProcess()
    }

    /// 注册按钮点击
    @IBAction func registerBtnClick(_ sender: GradientLayerButton) {
        self.endEditing(true)
        guard let account = self.accountField.text, let smsCode = self.verifyCodeField.text, let password = self.passwordField.text, let confirmPwd = self.confirmPwdField.text, let inviteCode = self.inviteCodeField.text else {
            return
        }
        self.delegate?.registerView(self, didCliedkedRegister: sender, account: account, password: password, confirmPwd: confirmPwd, smsCode: smsCode, inviteCode: inviteCode)
    }

    /// 协议按钮点击
    @IBAction func agreementBtnClick(_ sender: UIButton) {
        self.endEditing(true)
        self.delegate?.registerView(self, didCliedkedAgreement: sender)
    }

    /// 密码输入的安全性按钮点击
    @IBAction func pwdSecurityBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.passwordField.isSecureTextEntry = !sender.isSelected
    }

    /// 账号清除按钮点击
    @objc fileprivate func accountClearBtnClick(_ button: UIButton) -> Void {
        self.accountField.text = nil
        self.couldDoneProcess()
    }
    /// 密码清除按钮点击
    @objc fileprivate func passwordClearBtnClick(_ button: UIButton) -> Void {
        self.passwordField.text = nil
        self.couldDoneProcess()
        self.confirmPwdCorrectProcess()
    }
    /// 确认密码清除按钮点击
    @objc fileprivate func confirmPwdClearBtnClick(_ button: UIButton) -> Void {
        self.confirmPwdField.text = nil
        self.couldDoneProcess()
        self.confirmPwdCorrectProcess(isConfirmPwdEditing: true)
    }

    /// 验证码按钮点击响应
    @IBAction func sendCodeBtnClick(_ button: UIButton) -> Void {
        self.endEditing(true)
        guard let account = self.accountField.text, !account.isEmpty else {
            return
        }
        
        // 顶象验证
        self.coverBtn.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.coverBtn.addTarget(self, action: #selector(coverBtnClick(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(self.coverBtn)
        self.coverBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let appId: String = "fc939e1ccf39d5533743d748d566f345"
        let config: [String: Any] = ["appId": appId]
        let captchaFrame: CGRect = CGRect.init(x: kScreenWidth * 0.5 - 150, y: kScreenHeight * 0.5 - 100, width: 300, height: 200)
        //let captchaView: DXCaptchaView = DXCaptchaView.init(appId: appId, delegate: self, frame: captchaFrame)
        self.captchaView = DXCaptchaView.init(config: config, delegate: self, frame: captchaFrame)
        UIApplication.shared.keyWindow?.addSubview(self.captchaView)
        
        // 发送验证码请求
//        self.sendSmsCodeRequest(account: account, ticket: "", randStr: "")
    }

    /// 账号输入框输入监听
    @objc fileprivate func accountFieldValueChanged(_ textField: UITextField) -> Void {
        TextFieldHelper.limitTextField(textField, withMaxLen: self.accountLen)
        self.couldDoneProcess()
    }
    /// 验证码输入框监听
    @objc fileprivate func smsCodeFieldValueChanged(_ textField: UITextField) -> Void {
        self.couldDoneProcess()
    }
    /// 密码输入框监听
    @objc fileprivate func passwordFieldValueChanged(_ textField: UITextField) -> Void {
        TextFieldHelper.limitTextField(textField, withMaxLen: self.passwordMaxLen)
        self.couldDoneProcess()
        self.confirmPwdCorrectProcess()
    }
    /// 确认密码输入框监听
    @objc fileprivate func confirmPwdFieldValueChanged(_ textField: UITextField) -> Void {
        TextFieldHelper.limitTextField(textField, withMaxLen: self.passwordMaxLen)
        self.couldDoneProcess()
        self.confirmPwdCorrectProcess(isConfirmPwdEditing: true)
    }
    /// 确认密码输入框开始编辑时响应
    @objc fileprivate func confirmPwdFieldBeginEditing(_ textField: UITextField) -> Void {
        self.confirmPwdCorrectProcess(isConfirmPwdEditing: true)
    }
    /// 邀请码输入框监听
    @objc fileprivate func inviteCodeFieldValueChanged(_ textField: UITextField) -> Void {
        self.couldDoneProcess()
    }

}

// MARK: - Extension Function
extension RegisterView {
    /// 遮罩点击
    @objc func coverBtnClick(_ button: UIButton) -> Void {
        self.coverBtn.removeFromSuperview()
        self.captchaView.removeFromSuperview()
    }
}

extension RegisterView {
    /// 发送短信验证码请求
    fileprivate func sendSmsCodeRequest(account: String, ticket: String, randStr: String, token: String) -> Void {
        self.isUserInteractionEnabled = false
        AccountNetworkManager.sendSMSCode(account: account, scene: .register, ticket: ticket, randStr: randStr, token: token) { [weak self] (status, msg) in
            guard let `self` = self else {
                return
            }
            //self.sendSmsCodeBtn.setTitle("重新发送验证码", for: .normal)
            self.isUserInteractionEnabled = true
            guard status else {
                Toast.showToast(title: msg)
                return
            }
            Toast.showToast(title: "验证码已经发送到您的手机")
            self.startTimer()
        }
    }
}

// MARK: - 倒计时相关
extension RegisterView {
    /// 开启计时器
    fileprivate func startTimer() -> Void {
        // 相关控件设置
        self.sendCodeBtn.isHidden = true
        self.countdownLabel.isHidden = false
        self.countdownLabel.text = "\(self.maxLeftSecond)" + "smscode.countdown.sufix".localized
        self.leftSecond = self.maxLeftSecond
        // 开启倒计时
        self.stopTimer()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(countdown), object: nil)
        let timer = XDPackageTimer.timerWithInterval(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        timer.fire()
        self.timer = timer
    }
    /// 停止计时器
    fileprivate func stopTimer() -> Void {
        self.timer?.invalidate()
        self.timer = nil
    }
    /// 计时器回调 - 倒计时
    @objc fileprivate func countdown() -> Void {
        if self.leftSecond - 1 > 0 {
            self.leftSecond -= 1
            self.countdownLabel.text = "\(self.leftSecond)" + "smscode.countdown.sufix".localized
        } else {
            self.stopTimer()
            self.sendCodeBtn.setTitle("smscode.resend".localized, for: .normal)
            self.countdownLabel.isHidden = true
            self.sendCodeBtn.isHidden = false
        }
    }

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension RegisterView {

}

// MARK: - <DXCaptchaDelegate>
extension RegisterView: DXCaptchaDelegate {
    func captchaView(_ view: DXCaptchaView!, didReceive eventType: DXCaptchaEventType, arg dict: [AnyHashable : Any]!) {
        print("RegisterView captchaView didReceive arg")
        switch eventType {
        case DXCaptchaEventSuccess:
            guard let token = dict["token"] as? String, let account = self.accountField.text else {
                ToastUtil.showToast(title: "验证失败")
                view.removeFromSuperview()
                self.coverBtn.removeFromSuperview()
                return
            }
            view.removeFromSuperview()
            self.coverBtn.removeFromSuperview()
            // 发送验证码请求
            self.sendSmsCodeRequest(account: account, ticket: "", randStr: "", token: token)
        case DXCaptchaEventFail:
            break
        default:
            break
        }
    }

}
