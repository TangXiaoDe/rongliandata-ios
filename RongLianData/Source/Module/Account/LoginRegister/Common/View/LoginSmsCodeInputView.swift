//
//  LoginSmsCodeInputView.swift
//  ChuangYe
//
//  Created by 小唐 on 2020/8/17.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  登录相关中验证码输入界面包装，仅做UI封装，不对控件的响应做任何处理；

import UIKit
import ChainOneKit

protocol LoginSmsCodeInputViewDelegate: AnyObject {
    func smsCodeView(_ view: LoginSmsCodeInputView, checkSuccessResult: [AnyHashable: Any])
}

typealias CommonSmsCodeInputView = LoginSmsCodeInputView
class LoginSmsCodeInputView: UIView {

    // MARK: - Internal Property
    weak var delegate: LoginSmsCodeInputViewDelegate?
    static let viewHeight: CGFloat = 50

    var model: String? {
        didSet {
            self.setupWithModel(model)
        }
    }

    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    var icon: UIImage? {
        didSet {
            self.iconView.image = icon
        }
    }
    var placeholder: String = "" {
        didSet {
            self.textField.setPlaceHolder(placeholder, font: UIFont.pingFangSCFont(size: 18, weight: .medium), color: AppColor.inputPlaceHolder)
        }
    }
//    fileprivate var demoAsyncTask: DemoAsyncTask?
//    lazy var gt3CaptchaManager: GT3CaptchaManager = {
//
//        let demoAsyncTask = DemoAsyncTask()
//        demoAsyncTask.api1 = JiYanConfigModel.api_1
//        demoAsyncTask.api2 = JiYanConfigModel.api_2
//        self.demoAsyncTask = demoAsyncTask // 在 manager 内是弱引用，为避免在后续使用时 asyncTask 不会已被提前释放，建议在外部将其保持到全局
//        let manager = GT3CaptchaManager(api1: nil, api2: nil, timeout: 10.0)
//        manager?.delegate = self as GT3CaptchaManagerDelegate
//        manager?.viewDelegate = self as GT3CaptchaManagerViewDelegate
//        // 开启日志和Debug模式
//        manager?.enableDebugMode(true)
//        GT3CaptchaManager.setLogEnabled(true)
//        manager?.registerCaptcha(withCustomAsyncTask: demoAsyncTask, completion: nil)
//        return manager!
//    }()

    // MARK: - Private Property

    let mainView: UIView = UIView()
    let iconView: UIImageView = UIImageView.init()
    let titleLabel: UILabel = UILabel.init()
    let fieldContainer: UIView = UIView.init()
    let textField: UITextField = UITextField.init()
    let codeBtn: GradientLayerButton = GradientLayerButton.init()
    let countdownView: TitleContainer = TitleContainer()

    
    fileprivate let lrMargin: CGFloat = 0
    
    fileprivate let iconLeftMargin: CGFloat = 16        // super.left
    fileprivate let titleLeftMargin: CGFloat = 16       // super.left
    fileprivate let iconCenterYTopMargin: CGFloat = 24 + 9.0  // super.top
    
    let fieldHeight: CGFloat = 50
    fileprivate let codeRightMargin: CGFloat = 16
    
    fileprivate let fieldBottomMargin: CGFloat = 0
    fileprivate let fieldLeftMargin: CGFloat = 16
    fileprivate let fieldRightMargin: CGFloat = 80 + 16  //154
    fileprivate let codeBtnSize: CGSize = CGSize.init(width: 100, height: 50)

    /// 定时器相关
    fileprivate let maxLeftSecond: Int = 60
    fileprivate var leftSecond: Int = 60
    fileprivate var timer: Timer? = nil


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
    deinit {
        self.stopTimer()
        NotificationCenter.default.removeObserver(self)
    }

    /// 通用初始化：UI、配置、数据等
    func commonInit() -> Void {
//        let demoAsyncTask = DemoAsyncTask()
//        demoAsyncTask.api1 = JiYanConfigModel.api_1
//        demoAsyncTask.api2 = JiYanConfigModel.api_2
//        gt3CaptchaManager.registerCaptcha(withCustomAsyncTask: demoAsyncTask, completion: nil)
//        self.demoAsyncTask = demoAsyncTask // 在 manager 内是弱引用，为避免在后续使用时 asyncTask 不会已被提前释放，建议在外部将其保持到全局
        self.initialUI()
//        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: NSNotification.Name.NetWork.reachabilityChanged, object: nil)
    }

}

// MARK: - Internal Function
extension LoginSmsCodeInputView {
    class func loadXib() -> LoginSmsCodeInputView? {
        return Bundle.main.loadNibNamed("LoginSmsCodeInputView", owner: nil, options: nil)?.first as? LoginSmsCodeInputView
    }
}

// MARK: - 倒计时相关
extension LoginSmsCodeInputView {
    /// 开启计时器 60 = self.maxLeftSecond
    func startTimer(leftSecond: Int = 60) -> Void {
        // 相关控件设置
        self.codeBtn.isHidden = true
        self.countdownView.isHidden = false
        self.countdownView.label.text = "\(leftSecond)" + "smscode.countdown.sufix".localized
        self.leftSecond = leftSecond
        // 开启倒计时
        self.stopTimer()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(countdown), object: nil)
        let timer = XDPackageTimer.timerWithInterval(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        timer.fire()
        self.timer = timer
    }
    /// 停止计时器
    func stopTimer() -> Void {
        self.timer?.invalidate()
        self.timer = nil
    }
    /// 计时器回调 - 倒计时
    @objc fileprivate func countdown() -> Void {
        if self.leftSecond - 1 > 0 {
            self.leftSecond -= 1
            self.countdownView.label.text = "\(self.leftSecond)" + "smscode.countdown.sufix".localized
        } else {
            self.stopTimer()
            self.codeBtn.setTitle("smscode.resend".localized, for: .normal)
            self.countdownView.isHidden = true
            self.codeBtn.isHidden = false
        }
    }

}

// MARK: - LifeCircle Function
extension LoginSmsCodeInputView {
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
extension LoginSmsCodeInputView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
//        // 1. iconView
//        mainView.addSubview(self.iconView)
//        self.iconView.set(cornerRadius: 0)
//        self.iconView.isHidden = true
//        //self.iconView.image = UIImage.init(named: "IMG_login_icon_validation")
//        //self.iconView.image = UIImage.getIconFontImage(code: IconFont.login_verification, fontSize: 12, color: AppColor.theme)
//        self.iconView.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview().offset(self.iconLeftMargin)
//            make.centerY.equalTo(mainView.snp.top).offset(self.iconCenterYTopMargin)
//        }
//        // 2. titleLabel
//        mainView.addSubview(self.titleLabel)
//        self.titleLabel.set(text: "验证码", font: UIFont.pingFangSCFont(size: 16), textColor: AppColor.minorText)
//        self.titleLabel.snp.makeConstraints { (make) in
//            make.centerY.equalTo(self.iconView)
//            make.leading.equalToSuperview().offset(self.titleLeftMargin)
//        }
        // 3. fieldContainer
        mainView.addSubview(self.fieldContainer)
        self.fieldContainer.backgroundColor = AppColor.inputBg.withAlphaComponent(0.5)
        self.fieldContainer.set(cornerRadius: self.fieldHeight * 0.5, borderWidth: 0, borderColor: AppColor.dividing)
        self.fieldContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.bottom.equalToSuperview()
        }
        // textField
        self.fieldContainer.addSubview(self.textField)
        //self.textField.backgroundColor = AppColor.inputBg.withAlphaComponent(0.5)
        //self.textField.set(cornerRadius: 8, borderWidth: 0.5, borderColor: AppColor.dividing)
        //self.textField.set(placeHolder: nil, font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.mainText)
        self.textField.setPlaceHolder("请输入验证码", font: UIFont.pingFangSCFont(size: 18, weight: .medium), color: AppColor.inputPlaceHolder)
        self.textField.clearButtonMode = .whileEditing
        self.textField.keyboardType = .numberPad
        self.textField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.fieldRightMargin)
            make.top.bottom.equalToSuperview()
        }
        self.textField.leftViewMode = .always
        self.textField.leftView = UIView.init(frame: CGRect.init(origin: .zero, size: .init(width: 24, height: 0)))
        let clearButton: UIButton = self.textField.value(forKey: "_clearButton") as! UIButton
        clearButton.setImage(UIImage(named: "IMG_login_icon_close"), for: .normal)
        clearButton.setImage(UIImage(named: "IMG_login_icon_close"), for: .highlighted)
        // codeBtn
        self.fieldContainer.addSubview(self.codeBtn)
        self.codeBtn.set(title: "获取验证码", titleColor: AppColor.theme, bgImage: nil, for: .normal)
        self.codeBtn.set(title: "获取验证码", titleColor: AppColor.theme, bgImage: nil, for: .disabled)
        self.codeBtn.set(font: UIFont.pingFangSCFont(size: 14, weight: .medium), cornerRadius: 0)
        //self.codeBtn.backgroundColor = AppColor.inputBg.withAlphaComponent(0.5)
        self.codeBtn.contentHorizontalAlignment = .right
        self.codeBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.codeRightMargin)
        }
        // countLabel
        self.fieldContainer.addSubview(self.countdownView)
        self.countdownView.isHidden = true // 默认隐藏
        //self.countdownView.set(cornerRadius: 8)
        //self.countdownView.backgroundColor = AppColor.inputBg.withAlphaComponent(0.5)
        self.countdownView.snp.makeConstraints { (make) in
            make.centerY.trailing.equalTo(self.codeBtn)
        }
        self.countdownView.label.set(text: nil, font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.minorText, alignment: .right)
        self.countdownView.label.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        //self.countdownView.co.gradientLayer.colors = AppColor.themeGradientColors
        //self.countdownView.co.gradientLayer.frame = CGRect.init(origin: CGPoint.zero, size: self.codeBtnSize)
        //self.countdownView.co.gradientLayer.isHidden = false
        //let countdownCover: UIView = UIView.init(bgColor: UIColor.init(hex: 0x2E2B2A).withAlphaComponent(0.5))
        //self.countdownView.addSubview(countdownCover)
        //countdownCover.snp.makeConstraints { make in
        //    make.edges.equalToSuperview()
        //}
    }

}
// MARK: - Private UI Xib加载后处理
extension LoginSmsCodeInputView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }

}

// MARK: - Data Function
extension LoginSmsCodeInputView {
    /// 数据加载
    fileprivate func setupWithModel(_ model: String?) -> Void {
        guard let _ = model else {
            return
        }
        // 子控件数据加载
    }

}

// MARK: - Event Function
extension LoginSmsCodeInputView {
//    @objc fileprivate func reachabilityChanged(_ notifi: Notification) {
//        guard let conn = notifi.object as? AppReachability.Connection else {
//            return
//        }
//        switch conn {
//        case .wifi:
//            fallthrough
//        case .cellular:
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { // 加2秒延迟，有时网络变化了，但是手机还没连上网
//                let demoAsyncTask = DemoAsyncTask()
//                demoAsyncTask.api1 = JiYanConfigModel.api_1
//                demoAsyncTask.api2 = JiYanConfigModel.api_2
//                self.demoAsyncTask = demoAsyncTask // 在 manager 内是弱引用，为避免在后续使用时 asyncTask 不会已被提前释放，建议在外部将其保持到全局
//                let manager = GT3CaptchaManager(api1: nil, api2: nil, timeout: 10.0)
//                manager?.delegate = self as GT3CaptchaManagerDelegate
//                manager?.viewDelegate = self as GT3CaptchaManagerViewDelegate
//                manager?.registerCaptcha(withCustomAsyncTask: demoAsyncTask, completion: nil)
//                self.gt3CaptchaManager = manager!
//            }
//        case .none:
//            break
//        }
//    }
}

// MARK: - Extension Function
extension LoginSmsCodeInputView {
//    func closeGTView() {
//        self.gt3CaptchaManager.resetGTCaptcha()
//        self.gt3CaptchaManager.closeGTViewIfIsOpen()
//    }
}

// MARK: - Delegate Function
//extension LoginSmsCodeInputView: GT3CaptchaManagerDelegate, GT3CaptchaManagerViewDelegate {
//
//    // MARK: GT3CaptchaManagerDelegate
//
//    func gtCaptcha(_ manager: GT3CaptchaManager, errorHandler error: GT3Error) {
//        print("error code: \(error.code)")
//        print("error desc: \(error.error_code) - \(error.gtDescription)")
//
//        // 处理验证中返回的错误
//        if error.code == -999 {
//            // 请求被意外中断, 一般由用户进行取消操作导致
//        } else if error.code == -10 {
//            // 预判断时被封禁, 不会再进行图形验证
//        } else if error.code == -20 {
//            // 尝试过多
//        } else {
//            // 网络问题或解析失败, 更多错误码参考开发文档
//        }
//    }
//
//    func gtCaptcha(_ manager: GT3CaptchaManager, didReceiveSecondaryCaptchaData data: Data?, response: URLResponse?, error: GT3Error?, decisionHandler: ((GT3SecondaryCaptchaPolicy) -> Void)) {
//        if let error = error {
//            print("API2 error: \(error.code) - \(error.error_code) - \(error.gtDescription)")
//            decisionHandler(.forbidden)
//            return
//        }
//
//        if let data = data {
//            print("API2 repsonse: \(String(data: data, encoding: .utf8) ?? "")")
//            decisionHandler(.allow)
//            return
//        } else {
//            print("API2 repsonse: nil")
//            decisionHandler(.forbidden)
//        }
//        decisionHandler(.forbidden)
//    }
//
//    func gtCaptcha(_ manager: GT3CaptchaManager!, didReceiveCaptchaCode code: String!, result: [AnyHashable: Any]!, message: String!) {
//        if code == "0" { // 验证失败
//            
//        } else if code == "1" {  // 验证成功
//            self.delegate?.smsCodeView(self, checkSuccessResult: result)
//        }
//    }
//
//    // MARK: GT3CaptchaManagerViewDelegate
//    func gtCaptchaWillShowGTView(_ manager: GT3CaptchaManager) {
//        print("gtcaptcha will show gtview")
//    }
//}
//
//class DemoAsyncTask: NSObject {
//    fileprivate var api1: String?
//    fileprivate var api2: String?
//
//    private var validateTask: URLSessionDataTask?
//    private var registerTask: URLSessionDataTask?
//}
//
//extension DemoAsyncTask: GT3AsyncTaskProtocol {
//
//    func executeRegisterTask(completion: @escaping (GT3RegisterParameter?, GT3Error?) -> Void) {
//        /**
//         *  解析和配置验证参数
//         */
//        AccountNetworkManager.jiYanApi1Check { status, msg, model in
//            guard status else {
//                Toast.showToast(title: msg)
//                return
//            }
//            guard let model = model else {
//                return
//            }
//            let registerParameter = GT3RegisterParameter()
//            registerParameter.gt = model.gt
//            registerParameter.challenge = model.challenge
//            registerParameter.success = model.success
//            completion(registerParameter, nil)
//        }
//    }
//
//    func executeValidationTask(withValidate param: GT3ValidationParam, completion: @escaping (Bool, GT3Error?) -> Void) {
//    }
//
//    func cancel() {
//        self.registerTask?.cancel()
//        self.validateTask?.cancel()
//    }
//}
