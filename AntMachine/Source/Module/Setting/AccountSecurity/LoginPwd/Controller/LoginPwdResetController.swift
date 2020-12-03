//
//  LoginPwdResetController.swift
//  iMeet
//
//  Created by 小唐 on 2019/1/17.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  登录密码重置界面——使用验证码

import UIKit
import ObjectMapper
import ChainOneKit

/// 登录密码忘记场景
enum LoginPwdForgetScene {
    /// 登录场景
    case login
    /// 设置场景
    case setting
}

typealias ForgetLoginPwdController = LoginPwdResetController
typealias LoginPwdForgetController = LoginPwdResetController
class LoginPwdResetController: BaseViewController {
    // MARK: - Internal Property

    let scene: LoginPwdForgetScene

    // MARK: - Private Property
    fileprivate let coverBtn = UIButton.init(type: .custom)
    fileprivate var captchaView: DXCaptchaView!

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var areaCodeBtn: UIButton!
    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var verifyCodeField: UITextField!
    @IBOutlet weak var sendSmsBtn: UIButton!
    @IBOutlet weak var confirmPwdField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var resetPwdBtn: CommonDoneBtn!
    @IBOutlet weak var confirmPwdView: UIView!
    @IBOutlet weak var resetBtnTopMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var pwdSecurityBtn: UIButton!
    @IBOutlet weak var confirmPwdCorrectBtn: UIButton!

    fileprivate let countdownLabel: UILabel = UILabel()

    fileprivate let doneBtnLrMargin: CGFloat = 12
    fileprivate let doenBtnH: CGFloat = 44
    fileprivate let sendCodeBtnH: CGFloat = 28

    /// 定时器相关
    fileprivate let maxLeftSecond: Int = 60
    fileprivate var leftSecond: Int = 60
    fileprivate var timer: Timer? = nil

    /// 长度限制
    fileprivate let accountLen: Int = 11
    fileprivate let passwordMaxLen: Int = 20
    fileprivate let passwordMinLen: Int = 6
    fileprivate let smsCodeMaxLen: Int = 6
    fileprivate let smsCodeMinLen: Int = 4

    // MARK: - Initialize Function

    init(scene: LoginPwdForgetScene) {
        self.scene = scene
        super.init(nibName: "LoginPwdResetController", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.stopTimer()
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle Function
extension LoginPwdResetController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 添加键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 移除键盘通知
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - UI
extension LoginPwdResetController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.white
        // navigationbar
        self.navigationItem.title = "忘记密码"
        // accountField
        let accountClearBtn: UIButton = UIButton.init(type: .custom)
        accountClearBtn.bounds = CGRect.init(x: 0, y: 0, width: 22, height: 22)
        accountClearBtn.setImage(UIImage(named: "IMG_login_input_clear"), for: .normal)
        accountClearBtn.addTarget(self, action: #selector(accountClearBtnClick(_:)), for: .touchUpInside)
        self.accountField.rightView = accountClearBtn
        self.accountField.rightViewMode = .whileEditing
        self.accountField.addTarget(self, action: #selector(accountFieldValueChanged(_:)), for: .editingChanged)
        self.accountField.attributedPlaceholder = NSAttributedString.init(string: "input.placeholder.phone".localized, attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        // verifyCodeField
        self.verifyCodeField.addTarget(self, action: #selector(verifyCodeFieldValueChanged(_:)), for: .editingChanged)
        self.verifyCodeField.attributedPlaceholder = NSAttributedString.init(string: "input.placeholder.smscode".localized, attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        // passwordField
        let pwdClearBtn: UIButton = UIButton.init(type: .custom)
        pwdClearBtn.bounds = CGRect.init(x: 0, y: 0, width: 22, height: 22)
        pwdClearBtn.setImage(UIImage(named: "IMG_login_input_clear"), for: .normal)
        pwdClearBtn.addTarget(self, action: #selector(pwdClearBtnClick(_:)), for: .touchUpInside)
        self.passwordField.rightView = pwdClearBtn
        self.passwordField.rightViewMode = .whileEditing
        self.passwordField.isSecureTextEntry = true
        self.pwdSecurityBtn.isSelected = true
        self.passwordField.addTarget(self, action: #selector(passwordFieldValueChanged(_:)), for: .editingChanged)
        self.passwordField.attributedPlaceholder = NSAttributedString.init(string: "input.placeholder.loginpwd.desc".localized, attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        // confirmField
        let confirmPwdClearBtn: UIButton = UIButton.init(type: .custom)
        confirmPwdClearBtn.bounds = CGRect.init(x: 0, y: 0, width: 22, height: 22)
        confirmPwdClearBtn.setImage(UIImage(named: "IMG_login_input_clear"), for: .normal)
        confirmPwdClearBtn.addTarget(self, action: #selector(confirmPwdClearBtnClick(_:)), for: .touchUpInside)
        confirmPwdClearBtn.isSelected = true
        self.confirmPwdField.rightView = confirmPwdClearBtn
        self.confirmPwdField.rightViewMode = .whileEditing
        self.confirmPwdField.isSecureTextEntry = true
        self.confirmPwdField.addTarget(self, action: #selector(confirmPwdFieldValueChanged(_:)), for: .editingChanged)
        self.confirmPwdField.addTarget(self, action: #selector(confirmPwdFieldBeginEditing(_:)), for: .editingDidBegin)
        self.confirmPwdField.attributedPlaceholder = NSAttributedString.init(string: "input.placeholder.repassword".localized, attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        // confirmPwdCorrectBtn
        self.confirmPwdCorrectBtn.isHidden = true
        // resetPwdBtn
        self.resetPwdBtn.backgroundColor = UIColor.clear
        self.resetPwdBtn.gradientLayer.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth - self.doneBtnLrMargin * 2.0, height: self.doenBtnH)
        self.resetPwdBtn.set(cornerRadius: 5)
        self.resetPwdBtn.setTitle("donebtn.resetpwd".localized, for: .normal)
        // areaCodeBtn
        self.areaCodeBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        self.areaCodeBtn.setTitle("+86", for: .normal)
        // sendSmsBtn
        self.sendSmsBtn.set(font: UIFont.systemFont(ofSize: 12), cornerRadius: 5, borderWidth: 0.5, borderColor: AppColor.theme)
        self.sendSmsBtn.setTitleColor(AppColor.theme, for: .normal)
        self.sendSmsBtn.backgroundColor = UIColor.init(hex: 0xFFFFFF)
        // countdownLabel
        self.view.addSubview(self.countdownLabel)
        self.countdownLabel.set(text: nil, font: UIFont.systemFont(ofSize: 12), textColor: AppColor.minorText, alignment: .center)
        self.countdownLabel.set(cornerRadius: 5, borderWidth: 1, borderColor: AppColor.minorText)
        //self.countdownLabel.backgroundColor = UIColor.white
        self.countdownLabel.isHidden = true // 默认隐藏
        self.countdownLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self.sendSmsBtn)
        }
        // 版本适配
        if #available(iOS 11.0, *) {
            self.passwordField.textContentType = UITextContentType.name
            self.confirmPwdField.textContentType = UITextContentType.name
        }
        // iPhone5
        if UIDevice.current.isiPhone5series() {
            self.resetBtnTopMarginConstraint.constant = 40
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Data(数据处理与加载)
extension LoginPwdResetController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        self.couldDoneProcess()
    }

    /// 判断当前操作按钮(确定、登录、下一步...)是否可用
    fileprivate func couldDone() -> Bool {
        var flag: Bool = false
        guard let account = self.accountField.text, let verifyCode = self.verifyCodeField.text, let password = self.passwordField.text, let confirmPwd = self.confirmPwdField.text else {
            return flag
        }
        flag = (!account.isEmpty && !verifyCode.isEmpty && !password.isEmpty && !confirmPwd.isEmpty && (password == confirmPwd))
        return flag
    }
    /// 操作按钮(确定、登录、下一步...)的可用性判断
    fileprivate func couldDoneProcess() -> Void {
        self.resetPwdBtn.isEnabled = self.couldDone()
    }

    /// 密码一致性处理
    fileprivate func pwdCorrectProcess(isConfirmPwdEditing: Bool = false) -> Void {
        guard let password = self.passwordField.text, let confirmPwd = self.confirmPwdField.text else {
            self.confirmPwdCorrectBtn.isSelected = false
            self.confirmPwdCorrectBtn.isHidden = true
            return
        }
        self.confirmPwdCorrectBtn.isHidden = isConfirmPwdEditing ? false : confirmPwd.isEmpty
        self.confirmPwdCorrectBtn.isSelected = (!password.isEmpty && password == confirmPwd)
    }
}

// MARK: - Event(事件响应)
extension LoginPwdResetController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    @IBAction func pwdSecurityBtnClick(_ button: UIButton) {
        button.isSelected = !button.isSelected
        self.passwordField.isSecureTextEntry = button.isSelected
    }

    @objc fileprivate func accountClearBtnClick(_ button: UIButton) -> Void {
        self.accountField.text = nil
        self.couldDoneProcess()
    }
    @objc fileprivate func pwdClearBtnClick(_ button: UIButton) -> Void {
        self.passwordField.text = nil
        self.couldDoneProcess()
        self.pwdCorrectProcess()
    }
    @objc fileprivate func confirmPwdClearBtnClick(_ button: UIButton) -> Void {
        self.passwordField.text = nil
        self.couldDoneProcess()
        self.pwdCorrectProcess(isConfirmPwdEditing: true)
    }

    @objc fileprivate func accountFieldValueChanged(_ textField: UITextField) -> Void {
        TextFieldHelper.limitTextField(textField, withMaxLen: self.accountLen)
        self.couldDoneProcess()
    }
    @objc fileprivate func passwordFieldValueChanged(_ textField: UITextField) -> Void {
        TextFieldHelper.limitTextField(textField, withMaxLen: self.passwordMaxLen)
        self.couldDoneProcess()
        self.pwdCorrectProcess()
    }
    @objc fileprivate func confirmPwdFieldValueChanged(_ textField: UITextField) -> Void {
        TextFieldHelper.limitTextField(textField, withMaxLen: self.passwordMaxLen)
        self.couldDoneProcess()
        self.pwdCorrectProcess(isConfirmPwdEditing: true)
    }
    @objc fileprivate func verifyCodeFieldValueChanged(_ textField: UITextField) -> Void {
        TextFieldHelper.limitTextField(textField, withMaxLen: self.smsCodeMaxLen)
        self.couldDoneProcess()
    }
    @objc fileprivate func confirmPwdFieldBeginEditing(_ textField: UITextField) -> Void {
        self.pwdCorrectProcess(isConfirmPwdEditing: true)
    }

    @IBAction func areaCodeBtnClick(_ sender: UIButton) {

    }

    @IBAction func sendSmsBtnClick(_ sender: UIButton) {
        self.view.endEditing(true)
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

    @IBAction func resetPwdBtnClick(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let account = self.accountField.text, let code = self.verifyCodeField.text, let newPwd = self.passwordField.text, let confirmPwd = self.confirmPwdField.text else {
            return
        }
        self.resetLoginPwdRequest(account: account, smsCode: code, newPwd: newPwd, confirmPwd: confirmPwd)
    }
}

// MARK: - Notification
extension LoginPwdResetController {
    /// 键盘将要显示
    @objc fileprivate func keyboardWillShowNotification(_ notification: Notification) -> Void {
        if !self.confirmPwdField.isFirstResponder && !self.passwordField.isFirstResponder {
            return
        }
        guard let userInfo = notification.userInfo else {
            return
        }
        let kbBounds = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let kbH: CGFloat = kbBounds.size.height
        let confirmMaxY = self.confirmPwdView.convert(CGPoint.init(x: 0, y: self.confirmPwdView.bounds.size.height), to: nil).y
        let bottomMargin = kScreenHeight - confirmMaxY
        if bottomMargin < kbH + 25.0 {
            let margin: CGFloat = kbH + 25.0 - bottomMargin
            let transform = CGAffineTransform.init(translationX: 0, y: -margin)
            UIView.animate(withDuration: duration, animations: {
                self.view.transform = transform
            }, completion: nil)
        }
    }

    /// 键盘将要消失
    @objc fileprivate func keyboardWillHideNotification(_ notification: Notification) -> Void {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform.identity
        }, completion: nil)
    }

}

// MARK: - Extension Function
extension LoginPwdResetController {
    /// 发送短信验证码请求
    fileprivate func sendSmsCodeRequest(account: String, ticket: String, randStr: String, token: String) -> Void {
        self.view.isUserInteractionEnabled = false
        AccountNetworkManager.sendSMSCode(account: account, scene: SMSCodeScene.loginPwd, ticket: ticket, randStr: randStr, token: token) { [weak self](status, msg) in
            guard let `self` = self else {
                return
            }
            //self.sendSmsBtn.setTitle("重新发送验证码", for: .normal)
            self.view.isUserInteractionEnabled = true
            guard status else {
                Toast.showToast(title: msg)
                return
            }
            Toast.showToast(title: "验证码已经发送到您的手机")
            self.startTimer()
        }
    }

}

extension LoginPwdResetController {
    // 重置登录密码请求
    fileprivate func resetLoginPwdRequest(account: String, smsCode: String, newPwd: String, confirmPwd: String) -> Void {
        self.view.isUserInteractionEnabled = false
        let indicator = AppLoadingView.init()
        indicator.show()
        PasswordNetworkManager.forgetLoginPwd(phone: account, code: smsCode, newPwd: newPwd, confirmPwd: confirmPwd) { [weak self](status, msg) in
            guard let `self` = self else {
                return
            }
            self.view.isUserInteractionEnabled = true
            indicator.dismiss()
            Toast.showToast(title: msg)
            guard status else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                switch self.scene {
                case .login:
                    self.navigationController?.popViewController(animated: true)
                case .setting:
                    AppUtil.logoutProcess()
                }
            })
        }
    }

}

extension LoginPwdResetController {
    /// 开启计时器
    fileprivate func startTimer() -> Void {
        // 相关控件设置
        self.sendSmsBtn.isHidden = true
        self.countdownLabel.isHidden = false
        self.countdownLabel.text = "\(self.maxLeftSecond)秒后重发"
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
            self.countdownLabel.text = "\(self.leftSecond)秒后重发"
        } else {
            self.stopTimer()
            self.sendSmsBtn.setTitle("重新获取", for: .normal)
            self.countdownLabel.isHidden = true
            self.sendSmsBtn.isHidden = false
        }
    }

}
// MARK: - Extension Function
extension LoginPwdResetController {
    /// 遮罩点击
    @objc func coverBtnClick(_ button: UIButton) -> Void {
        self.coverBtn.removeFromSuperview()
        self.captchaView.removeFromSuperview()
    }
}

// MARK: - Delegate Function

// MARK: - <>
extension LoginPwdResetController {

}
// MARK: - <DXCaptchaDelegate>
extension LoginPwdResetController: DXCaptchaDelegate {
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
//            self.sendSmsCodeRequest(account: account, ticket: "", randStr: "", token: token)
            self.sendSmsCodeRequest(account: account, ticket: "", randStr: "", token: token)
        case DXCaptchaEventFail:
            break
        default:
            break
        }
    }

}
