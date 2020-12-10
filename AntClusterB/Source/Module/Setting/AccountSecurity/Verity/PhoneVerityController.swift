//
//  PhoneVerityController.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/9.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  手机号验证界面

import UIKit
import ChainOneKit
import ObjectMapper

enum PhoneVerifyType {
    /// 绑定
    case phoneBind
    /// 支付密码设置/初始化
    case payPwdInitial
    /// 支付密码重置
    case payPwdReset
}

///手机号验证界面
class PhoneVerityController: BaseViewController {
    // MARK: - Internal Property

    let type: PhoneVerifyType
    let scene: SMSCodeScene

    // MARK: - Private Property

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var smsCodeView: UIView!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var sendSmsBtn: UIButton!
    @IBOutlet weak var nextBtn: GradientLayerButton!

    fileprivate let lrMargin: CGFloat = 12
    fileprivate let smsCodeSize: CGSize = CGSize.init(width: 84, height: 28)
    fileprivate let nextBtnHeight: CGFloat = 44

    fileprivate let codeLen: Int = 6

    /// 定时器相关
    fileprivate let maxLeftSecond: Int = 60
    fileprivate var leftSecond: Int = 60
    fileprivate var timer: Timer? = nil
    fileprivate let countdownLabel: UILabel = UILabel()
    fileprivate let btnLrMargin: CGFloat = 12
    

    // MARK: - Initialize Function

    init(type: PhoneVerifyType) {
        self.type = type
        switch type {
        case .phoneBind:
            self.scene = SMSCodeScene.loginPwd
        case .payPwdInitial:
            fallthrough
        case .payPwdReset:
            self.scene = SMSCodeScene.payPwd
        }
        super.init(nibName: "PhoneVerityController", bundle: nil)
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

// MARK: - LifeCircle & Override Function
extension PhoneVerityController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

}

// MARK: - UI
extension PhoneVerityController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.white
        // navbar
        self.navigationItem.title = "验证手机号"
        // xib
        //self.smsCodeView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 1, margin1: 0, margin2: 0)
        self.codeField.set(placeHolder: nil, text: nil, font: UIFont.pingFangSCFont(size: 18), textColor: AppColor.mainText)
        self.codeField.attributedPlaceholder = NSAttributedString.init(string: "请输入验证码", attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        self.codeField.addTarget(self, action: #selector(codeFieldValueChanged(_:)), for: .editingChanged)
        self.codeField.keyboardType = .asciiCapable
        self.sendSmsBtn.set(font: UIFont.pingFangSCFont(size: 12), cornerRadius: 5, borderWidth: 1, borderColor: AppColor.theme)
        self.sendSmsBtn.set(title: "获取验证码", titleColor: AppColor.theme, image: nil, bgImage: UIImage.imageWithColor(UIColor.white), for: .normal)
        self.sendSmsBtn.set(title: "获取验证码", titleColor: AppColor.theme, image: nil, bgImage: UIImage.imageWithColor(UIColor.white), for: .highlighted)
        self.nextBtn.backgroundColor = UIColor.clear
        self.nextBtn.set(font: UIFont.pingFangSCFont(size: 18), cornerRadius: 5)
        self.nextBtn.set(title: "下一步", titleColor: UIColor.white, image: nil, bgImage: UIImage.imageWithColor(AppColor.theme), for: .normal)
        self.nextBtn.set(title: "下一步", titleColor: UIColor.white, image: nil, bgImage: UIImage.imageWithColor(AppColor.theme), for: .highlighted)
        self.nextBtn.set(title: "下一步", titleColor: UIColor.white, image: nil, bgImage: UIImage.imageWithColor(AppColor.disable), for: .disabled)
        // countLabel
        self.view.addSubview(self.countdownLabel)
        self.countdownLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.minorText, alignment: .center)
        self.countdownLabel.set(cornerRadius: 5, borderWidth: 1, borderColor: AppColor.minorText)
        self.countdownLabel.isHidden = true // 默认隐藏
        self.countdownLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self.sendSmsBtn)
        }
    }
}

// MARK: - Data(数据处理与加载)
extension PhoneVerityController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        self.couldDoneProcess()
        self.phoneLabel.text = AccountManager.share.currentAccountInfo?.userInfo?.phone
    }

    fileprivate func couldDone() -> Bool {
        var doneFlag: Bool = false
        guard let code = self.codeField.text else {
            return doneFlag
        }
        doneFlag = !code.isEmpty
        return doneFlag
    }
    fileprivate func couldDoneProcess() -> Void {
        self.nextBtn.isEnabled = self.couldDone()
    }

}

// MARK: - Request
extension PhoneVerityController {

    /// 显示验证码腾讯防水墙
    fileprivate func showCodeTencentCaptcha() -> Void {
        // 发送验证码请求
        self.sendCodeRequest(ticket: "", randStr: "")
    }
    /// 发送验证码请求
    fileprivate func sendCodeRequest(ticket: String, randStr: String) -> Void {
        self.view.isUserInteractionEnabled = false
        AccountNetworkManager.sendSMSCode(account: nil, scene: self.scene, ticket: ticket, randStr: randStr) { [weak self](status, msg) in
            guard let `self` = self else {
                return
            }
            Toast.showToast(title: msg)
            self.view.isUserInteractionEnabled = true
            guard status else {
                return
            }
            self.startTimer()
        }
    }

    /// 验证码验证请求
    fileprivate func codeVerifyRequest(_ code: String) -> Void {
        self.view.isUserInteractionEnabled = false
        AccountNetworkManager.validSMSCode(account: nil, scene: self.scene, code: code) { [weak self](status, msg) in
            guard let `self` = self else {
                return
            }
            self.view.isUserInteractionEnabled = true
            guard status else {
                Toast.showToast(title: msg)
                return
            }
            self.codeVerifyCompleted()
        }
    }
    /// 验证完成处理
    fileprivate func codeVerifyCompleted() -> Void {
        guard let code = self.codeField.text, !code.isEmpty else {
            return
        }
        switch self.type {
        case .phoneBind:
            let bindUpdateVC = PhoneBindUpdateController.init(oriPhoneCode: code)
            self.enterPageVC(bindUpdateVC)
        case .payPwdInitial:
            let payPwdSetVC = PayPwdSetController.init(type: PayPwdSetType.initial(smsCode: code))
            self.enterPageVC(payPwdSetVC)
        case .payPwdReset:
            let payPwdSetVC = PayPwdSetController.init(type: PayPwdSetType.reset(smsCode: code))
            self.enterPageVC(payPwdSetVC)
        }
    }

}

// MARK: - Event(事件响应)
extension PhoneVerityController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func sendSmsBtnClick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.showCodeTencentCaptcha()
    }

    @IBAction func nextBtnClick(_ sender: GradientLayerButton) {
        self.view.endEditing(true)
        guard let code = self.codeField.text, !code.isEmpty else {
            return
        }
        self.codeVerifyRequest(code)
    }

    @objc fileprivate func codeFieldValueChanged(_ textField: UITextField) -> Void {
        TextFieldHelper.limitTextField(textField, withMaxLen: self.codeLen)
        self.couldDoneProcess()
    }

}

// MARK: - Enter Page
extension PhoneVerityController {

}

// MARK: - Notification
extension PhoneVerityController {

}

// MARK: - Extension Function
extension PhoneVerityController {

}

// MARK: - Timer
extension PhoneVerityController {
    /// 开启计时器
    fileprivate func startTimer() -> Void {
        // 相关控件设置
        self.sendSmsBtn.isHidden = true
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
            self.sendSmsBtn.setTitle("smscode.resend".localized, for: .normal)
            self.countdownLabel.isHidden = true
            self.sendSmsBtn.isHidden = false
        }
    }
}

// MARK: - Delegate Function

// MARK: - <>
extension PhoneVerityController {
    
}
