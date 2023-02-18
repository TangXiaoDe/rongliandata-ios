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
    
    
    fileprivate let navBar: AppHomeNavBar = AppHomeNavBar.init()
    fileprivate let bgView: UIImageView = UIImageView.init()
    
    fileprivate let mainView: UIView = UIView.init()
    fileprivate let mainBgView: UIImageView = UIImageView.init()
    
    fileprivate let logoView: UIImageView = UIImageView.init()
    fileprivate let inputContainer: UIView = UIView.init()
    fileprivate let phoneView: LoginPhoneInputView = LoginPhoneInputView.init()
    fileprivate let smsCodeView: LoginSmsCodeInputView = LoginSmsCodeInputView.init()
    fileprivate let setPwdView: LoginPasswordInputView = LoginPasswordInputView.init()
    fileprivate let ensurePwdView: LoginPasswordInputView = LoginPasswordInputView.init()
    fileprivate let doneBtn: GradientLayerButton = GradientLayerButton.init(type: .custom)
    fileprivate let tipsLabel: UILabel = UILabel.init()


    fileprivate let mainTopMargin: CGFloat = kNavigationStatusBarHeight + 5
    fileprivate let mainBgSize: CGSize = CGSize.init(width: 349, height: 582)
    
    fileprivate let mainLrMargin: CGFloat = 13
    fileprivate let lrMargin: CGFloat = 34
    
    fileprivate let logoTopMargin: CGFloat = 147
    fileprivate let logoSize: CGSize = CGSize.init(width: 83.5, height: 24.5)
    fileprivate let registerBtnSize: CGSize = CGSize.init(width: 68, height: 28)
    //fileprivate let loginTypeBtnSize: CGSize = CGSize.init(width: 90, height: 28)
    fileprivate let loginTypeBtnBottomMargin: CGFloat = 32
    
    fileprivate let inputContainerTopMargin: CGFloat = 28   // logo.bottom
    fileprivate let singleInfoHeight: CGFloat = LoginNormalInputView.viewHeight
    fileprivate let infoVerMargin: CGFloat = LoginNormalInputView.verMargin
//    fileprivate lazy var inputContainerHeight: CGFloat = {
//        return self.singleInfoHeight * 2.0 + LoginNormalInputView.verMargin
//    }()
    fileprivate let tipsTopMargin: CGFloat = 15     // doneBtn.bottom
    fileprivate let doneBtnHeight: CGFloat = 44
    fileprivate let doneBtnTopMargin: CGFloat = 42  // inputContainer.bottom


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
        self.smsCodeView.stopTimer()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
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
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        // 添加键盘通知
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 移除键盘通知
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

// MARK: - UI
extension LoginPwdResetController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.pageBg
        // navBar
        self.view.addSubview(self.navBar)
        self.navBar.titleLabel.set(text: "重置密码", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.white, alignment: .center)
        self.navBar.delegate = self
        self.navBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(kNavigationStatusBarHeight)
        }
        // bgView
        self.view.addSubview(self.bgView)
        self.bgView.image = UIImage.init(named: "IMG_signin_img_bg")
        self.bgView.set(cornerRadius: 0)
        self.bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // mainView
        self.view.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { make in
            make.size.equalTo(self.mainBgSize)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(self.mainTopMargin)
        }
        //
        self.view.bringSubviewToFront(self.navBar)
    }
    
    //
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // bgView
        mainView.addSubview(self.mainBgView)
        self.mainBgView.image = UIImage.init(named: "IMG_signin_img_bg_white")
        self.mainBgView.set(cornerRadius: 0)
        self.mainBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // logoView
        mainView.addSubview(self.logoView)
        self.logoView.set(cornerRadius: 0)
        self.logoView.image = UIImage.init(named: "IMG_signin_img_logo")
        self.logoView.snp.makeConstraints { (make) in
            make.size.equalTo(self.logoSize)
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.top.equalToSuperview().offset(self.logoTopMargin)
        }
        // inputContainer
        mainView.addSubview(self.inputContainer)
        self.initialInputContainer(self.inputContainer)
        self.inputContainer.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.logoView.snp.bottom).offset(self.inputContainerTopMargin)
            //make.height.equalTo(self.inputContainerHeight)
        }
        // 2. tips
//        mainView.addSubview(self.tipsLabel)
//        self.tipsLabel.set(text: "*限6-20个字符以内，建议使用数字字母组合，区分大小写", font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.grayText)
//        self.tipsLabel.numberOfLines = 2
//        self.tipsLabel.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(self.tipsLrMargin)
//            make.trailing.equalToSuperview().offset(-self.tipsLrMargin)
//            make.top.equalTo(self.inputContainer.snp.bottom).offset(self.tipsTopMargin)
//        }
        // 3. doneBtn
        mainView.addSubview(self.doneBtn)
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.set(title: "重置密码", titleColor: AppColor.white, bgImage: nil, for: .normal)
        self.doneBtn.set(title: "重置密码", titleColor: AppColor.white, bgImage: nil, for: .highlighted)
        self.doneBtn.set(title: "重置密码", titleColor: AppColor.white, bgImage: nil, for: .disabled)
        self.doneBtn.set(font: UIFont.pingFangSCFont(size: 18, weight: .medium), cornerRadius: self.doneBtnHeight * 0.5, borderWidth: 0, borderColor: UIColor.clear)
        self.doneBtn.backgroundColor = AppColor.disable
        //self.doneBtn.gradientLayer.colors = [AppColor.theme.cgColor, AppColor.theme.cgColor]
        self.doneBtn.gradientLayer.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth - self.mainLrMargin * 2.0 - self.lrMargin * 2.0, height: self.doneBtnHeight)
        self.doneBtn.gradientLayer.isHidden = !self.doneBtn.isEnabled
        self.doneBtn.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.height.equalTo(self.doneBtnHeight)
            make.top.equalTo(self.inputContainer.snp.bottom).offset(self.doneBtnTopMargin)
            //make.bottom.lessThanOrEqualToSuperview()
        }
    }
    ///
    fileprivate func initialInputContainer(_ container: UIView) -> Void {
        // 1. phone
        container.addSubview(self.phoneView)
        self.phoneView.textField.addTarget(self, action: #selector(textFieldValueChainge(_:)), for: .editingChanged)
        self.phoneView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.singleInfoHeight)
        }
        // 2. smsCode
        container.addSubview(self.smsCodeView)
        //self.smsCodeView.delegate = self
        self.smsCodeView.textField.addTarget(self, action: #selector(textFieldValueChainge(_:)), for: .editingChanged)
        self.smsCodeView.codeBtn.addTarget(self, action: #selector(sendSmsCodeBtnClick(_:)), for: .touchUpInside)
        self.smsCodeView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.phoneView.snp.bottom).offset(self.infoVerMargin)
            make.height.equalTo(self.singleInfoHeight)
        }
        // 2. setPwd
        container.addSubview(self.setPwdView)
        self.setPwdView.title = "设置密码"
        self.setPwdView.placeholder = "请设置登录密码"
        self.setPwdView.textField.addTarget(self, action: #selector(textFieldValueChainge(_:)), for: .editingChanged)
        self.setPwdView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.smsCodeView.snp.bottom).offset(self.infoVerMargin)
            make.height.equalTo(self.singleInfoHeight)
        }
        // 3. ensurePwd
        container.addSubview(self.ensurePwdView)
        self.ensurePwdView.title = "确认密码"
        self.ensurePwdView.placeholder = "请再次输入密码"
        self.ensurePwdView.textField.addTarget(self, action: #selector(textFieldValueChainge(_:)), for: .editingChanged)
        self.ensurePwdView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.setPwdView.snp.bottom).offset(self.infoVerMargin)
            make.height.equalTo(self.singleInfoHeight)
            make.bottom.equalToSuperview()
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
        guard let account = self.phoneView.textField.text, let smscode = self.smsCodeView.textField.text, let password = self.setPwdView.textField.text, let ensurePwd = self.ensurePwdView.textField.text else {
            return flag
        }
        flag = (!account.isEmpty && !smscode.isEmpty && !password.isEmpty && !ensurePwd.isEmpty)
        return flag
    }
    /// 操作按钮(确定、登录、下一步...)的可用性判断
    fileprivate func couldDoneProcess() -> Void {
        self.doneBtn.isEnabled = self.couldDone()
        self.doneBtn.gradientLayer.isHidden = !self.doneBtn.isEnabled
    }

}

// MARK: - Event(事件响应)
extension LoginPwdResetController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    /// 输入框内容变更响应
    @objc fileprivate func textFieldValueChanged(_ textField: UITextField) -> Void {
        switch textField {
        case self.phoneView.textField:
            TextFieldHelper.limitTextField(textField, withMaxLen: self.accountMaxLen)
        case self.smsCodeView.textField:
            TextFieldHelper.limitTextField(textField, withMaxLen: self.smsCodeMaxLen)
        case self.setPwdView.textField:
            TextFieldHelper.limitTextField(textField, withMaxLen: self.passwordMaxLen)
        case self.ensurePwdView.textField:
            TextFieldHelper.limitTextField(textField, withMaxLen: self.passwordMaxLen)
//            if let password = self.setPwdView.textField.text, let ensurePwd = self.ensurePwdView.textField.text, !ensurePwd.isEmpty, password != ensurePwd {
//                self.tipsLabel.set(text: "*请输入一致的新密码", font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.themeRed)
//            } else {
//                self.tipsLabel.set(text: "*限6-20个字符以内，建议使用数字字母组合，区分大小写", font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.grayText)
//            }
        default:
            break
        }
        self.couldDoneProcess()
    }

    /// 发送验证码按钮点击
    @objc fileprivate func sendSmsCodeBtnClick(_ button: UIButton) -> Void {
        self.view.endEditing(true)
        guard let account = self.phoneView.textField.text, !account.isEmpty else {
            Toast.showToast(title: "请先输入手机号")
            return
        }
//        // 顶象验证
//        self.coverBtn.backgroundColor = UIColor.black.withAlphaComponent(0)
//        self.coverBtn.addTarget(self, action: #selector(coverBtnClick(_:)), for: .touchUpInside)
//        UIApplication.shared.keyWindow?.addSubview(self.coverBtn)
//        self.coverBtn.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//        let appId: String = "fc939e1ccf39d5533743d748d566f345"
//        let config: [String: Any] = ["appId": appId]
//        let captchaFrame: CGRect = CGRect.init(x: kScreenWidth * 0.5 - 150, y: kScreenHeight * 0.5 - 100, width: 300, height: 200)
//        //let captchaView: DXCaptchaView = DXCaptchaView.init(appId: appId, delegate: self, frame: captchaFrame)
//        self.captchaView = DXCaptchaView.init(config: config, delegate: self, frame: captchaFrame)
//        UIApplication.shared.keyWindow?.addSubview(self.captchaView)
        // 发送验证码请求
        self.sendSmsCodeRequest(account: account, ticket: "", randStr: "")
    }

    /// 设置密码按钮点击
    @objc fileprivate func doneBtnClick(_ button: UIButton) -> Void {
        guard let account = self.phoneView.textField.text, let code = self.smsCodeView.textField.text, let newPwd = self.setPwdView.textField.text, let confirmPwd = self.ensurePwdView.textField.text else {
            return
        }
        if newPwd != confirmPwd {
            Toast.showToast(title: "两次密码不一致")
            return
        }
        self.resetLoginPwdRequest(account: account, smsCode: code, newPwd: newPwd, confirmPwd: confirmPwd)
    }
}

// MARK: - Notification
extension LoginPwdResetController {
    /// 键盘将要显示
    @objc fileprivate func keyboardWillShowNotification(_ notification: Notification) -> Void {
        if !self.setPwdView.textField.isFirstResponder && !self.ensurePwdView.textField.isFirstResponder {
            return
        }
        guard let userInfo = notification.userInfo else {
            return
        }
        let kbBounds = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let kbH: CGFloat = kbBounds.size.height
        let confirmMaxY = self.ensurePwdView.convert(CGPoint.init(x: 0, y: self.ensurePwdView.bounds.size.height), to: nil).y
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
