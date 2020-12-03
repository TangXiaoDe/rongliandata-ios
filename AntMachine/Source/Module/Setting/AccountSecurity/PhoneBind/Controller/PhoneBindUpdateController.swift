//
//  PhoneBindUpdateController.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/9.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  更换绑定手机号界面

import UIKit
import ChainOneKit
import ObjectMapper

/// 更换绑定手机号界面
class PhoneBindUpdateController: BaseViewController {
    // MARK: - Internal Property

    /// originalPhoneCode
    let oriPhoneCode: String

    // MARK: - Private Property

    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var codeSendBtn: UIButton!

    @IBOutlet weak var smsCodeView: UIView!
    @IBOutlet weak var codeField: UITextField!

    @IBOutlet weak var updateBtn: UIButton!

    fileprivate let updateBtnLayer: CAGradientLayer = AppUtil.commonGradientLayer()

    fileprivate let codeSendBtnSize: CGSize = CGSize.init(width: 84, height: 28)
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let updateBtnHeight: CGFloat = 44

    fileprivate let phoneLen: Int = 11
    fileprivate let codeLen: Int = 6

    /// 定时器相关
    fileprivate let maxLeftSecond: Int = 60
    fileprivate var leftSecond: Int = 60
    fileprivate var timer: Timer? = nil
    fileprivate let countdownLabel: UILabel = UILabel()


    // MARK: - Initialize Function

    init(oriPhoneCode: String) {
        self.oriPhoneCode = oriPhoneCode
        super.init(nibName: "PhoneBindUpdateController", bundle: nil)
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
extension PhoneBindUpdateController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

}

// MARK: - UI
extension PhoneBindUpdateController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.white
        // navbar
        self.navigationItem.title = "更换手机号"
        // xib
        self.phoneView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 1, margin1: 0, margin2: 0)
        self.smsCodeView.addLineWithSide(.inBottom, color: AppColor.theme, thickness: 1, margin1: 0, margin2: 0)
        self.codeSendBtn.set(title: "发送验证码", titleColor: AppColor.theme, image: nil, bgImage: UIImage.imageWithColor(UIColor.white), for: .normal)
        self.codeSendBtn.set(title: "发送验证码", titleColor: AppColor.theme, image: nil, bgImage: UIImage.imageWithColor(UIColor.white), for: .highlighted)
        self.codeSendBtn.set(font: UIFont.pingFangSCFont(size: 12), cornerRadius: 5, borderWidth: 1, borderColor: AppColor.theme)
        self.phoneField.set(placeHolder: nil, text: nil, font: UIFont.pingFangSCFont(size: 18), textColor: AppColor.mainText)
        self.codeField.set(placeHolder: nil, text: nil, font: UIFont.pingFangSCFont(size: 18), textColor: AppColor.theme)
        self.phoneField.attributedPlaceholder = NSAttributedString.init(string: "手机号", attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        self.codeField.attributedPlaceholder = NSAttributedString.init(string: "验证码", attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        self.phoneField.addTarget(self, action: #selector(phoneFieldValueChanged(_:)), for: .editingChanged)
        self.codeField.addTarget(self, action: #selector(codeFieldValueChanged(_:)), for: .editingChanged)
        self.updateBtn.set(font: UIFont.pingFangSCFont(size: 18), cornerRadius: 5)
        self.updateBtn.set(title: "确认更改", titleColor: UIColor.white, image: nil, bgImage: UIImage.imageWithColor(UIColor.init(hex: 0xD9DCE4)), for: .disabled)
        self.updateBtn.set(title: "确认更改", titleColor: UIColor.white, image: nil, bgImage: UIImage.imageWithColor(UIColor.clear), for: .normal)
        self.updateBtn.isEnabled = false
        self.updateBtn.layer.insertSublayer(self.updateBtnLayer, below: nil)
        self.updateBtnLayer.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth - self.lrMargin * 2.0, height: self.updateBtnHeight)
        //self.updateBtnLayer.colors = [UIColor.init(hex: 0x169CFF).cgColor, AppColor.theme.cgColor]
        self.updateBtnLayer.isHidden = true
        // countLabel
        self.view.addSubview(self.countdownLabel)
        self.countdownLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.theme, alignment: .center)
        self.countdownLabel.set(cornerRadius: 5, borderWidth: 1, borderColor: AppColor.theme)
        self.countdownLabel.isHidden = true // 默认隐藏
        self.countdownLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self.codeSendBtn)
        }
    }
}

// MARK: - Data(数据处理与加载)
extension PhoneBindUpdateController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {

    }

    /// doneBtn是否可用
    fileprivate func couldDone() -> Bool {
        var flag: Bool = false
        guard let phone = self.phoneField.text, let code = self.codeField.text else {
            return flag
        }
        flag = (!phone.isEmpty && !code.isEmpty)
        return flag
    }
    fileprivate func couldDoneProcess() -> Void {
        self.updateBtn.isEnabled = self.couldDone()
        self.updateBtnLayer.isHidden = !self.couldDone()
    }

}

// MARK: - Request
extension PhoneBindUpdateController {

    /// 显示验证码腾讯防水墙
    fileprivate func showCodeTencentCaptcha(phone: String) -> Void {
        // 发送验证码请求
        self.sendCodeRequest(phone: phone, ticket: "", randStr: "")
    }
    /// 发送验证码请求
    fileprivate func sendCodeRequest(phone: String, ticket: String, randStr: String) -> Void {
//        self.view.isUserInteractionEnabled = false
//        AccountNetworkManager.sendSMSCode(account: phone, scene: SMSCodeUnAuthScene.phoneBind, ticket: ticket, randStr: randStr) { [weak self](status, msg) in
//            guard let `self` = self else {
//                return
//            }
//            Toast.showToast(title: msg)
//            self.view.isUserInteractionEnabled = true
//            guard status else {
//                return
//            }
//            self.startTimer()
//        }
    }

    /// 换绑请求
    fileprivate func phoneBindUpdateRequest(phone: String, code: String) -> Void {
        // 注：换绑成功会重置token，需重新登录
        self.view.isUserInteractionEnabled = false
        AccountNetworkManager.updateBindPhone(oriCode: self.oriPhoneCode, newPhone: phone, newCode: code) { [weak self](status, msg) in
            guard let `self` = self else {
                return
            }
            Toast.showToast(title: msg)
            self.view.isUserInteractionEnabled = true
            guard status else {
                return
            }
            AppUtil.logoutProcess(isAuthValid: false)
        }
    }

}

// MARK: - Event(事件响应)
extension PhoneBindUpdateController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func updateBtnClick(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let phone = self.phoneField.text, let code = self.codeField.text else {
            return
        }
        self.phoneBindUpdateRequest(phone: phone, code: code)
    }
    @IBAction func codeSendBtnClick(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let phone = self.phoneField.text, !phone.isEmpty else {
            return
        }
        self.showCodeTencentCaptcha(phone: phone)
    }

    @objc fileprivate func phoneFieldValueChanged(_ textField: UITextField) -> Void {
        TextFieldHelper.limitTextField(textField, withMaxLen: self.phoneLen)
        self.couldDoneProcess()
    }
    @objc fileprivate func codeFieldValueChanged(_ textField: UITextField) -> Void {
        TextFieldHelper.limitTextField(textField, withMaxLen: self.codeLen)
        self.couldDoneProcess()
    }

}

// MARK: - Timer
extension PhoneBindUpdateController {
    /// 开启计时器
    fileprivate func startTimer() -> Void {
        // 相关控件设置
        self.codeSendBtn.isHidden = true
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
            self.codeSendBtn.setTitle("smscode.resend".localized, for: .normal)
            self.countdownLabel.isHidden = true
            self.codeSendBtn.isHidden = false
        }
    }
}

// MARK: - Enter Page
extension PhoneBindUpdateController {

}

// MARK: - Notification
extension PhoneBindUpdateController {

}

// MARK: - Extension Function
extension PhoneBindUpdateController {

}

// MARK: - Delegate Function

// MARK: - <>
extension PhoneBindUpdateController {

}
