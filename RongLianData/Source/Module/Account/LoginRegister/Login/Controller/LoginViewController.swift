//
//  LoginViewController.swift
//  ChuangYe
//
//  Created by 小唐 on 2020/8/14.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit

protocol LoginViewControllerProtocol: class {
    /// 注册点击回调
    func loginVC(_ loginVC: LoginViewController, didClickedRegister registerView: UIView) -> Void
}

class LoginViewController: BaseViewController {
    // MARK: - Internal Property

    weak var delegate: LoginViewControllerProtocol?
    var hasBackBtn: Bool = false {
        didSet {
//            let showBackWH: CGFloat = 44
//            let backIconLrMargin: CGFloat = (showBackWH - self.backIconSize.width) * 0.5 // (44 - 19) * 0.5 = 12
//            self.backBtn.isHidden = !hasBackBtn
//            self.welcomeLabel.snp.remakeConstraints { make in
//                make.centerY.equalTo(self.backBtn)
//                if hasBackBtn {
//                    make.leading.equalTo(self.backBtn.snp.trailing).offset(self.welcomeLeftMargin - backIconLrMargin)
//                } else {
//                    make.leading.equalToSuperview().offset(self.lrMargin)
//                }
//            }
//            self.view.layoutIfNeeded()
        }
    }
    /// 是否显示密码登录
    var showPwdLogin: Bool = true {
        didSet {
//            self.forgetPwdBtn.isHidden = !showPwdLogin
//            self.typeView.showPwdLogin = showPwdLogin
//            if !showPwdLogin {
//                self.selectedType = .smscode
//            }
        }
    }

    // MARK: - Private Property

    fileprivate let bgView: UIImageView = UIImageView.init()
    
    fileprivate let mainView: UIView = UIView.init()
    fileprivate let mainBgView: UIImageView = UIImageView.init()
    
    fileprivate let backBtn: UIButton = UIButton.init()
    fileprivate let topBgView: UIImageView = UIImageView.init()
    fileprivate let topBgCover: UIView = UIView.init()
    
    fileprivate let topView: UIView = UIView.init()
    fileprivate let welcomeLabel = UILabel()
    fileprivate let nameLabel: UILabel = UILabel.init()
    fileprivate let welcomeView: UIImageView = UIImageView.init()   //
    
    fileprivate let bottomView: UIView = UIView.init()
    fileprivate let logoView: UIImageView = UIImageView.init()
    fileprivate let typeView: LoginTypeView = LoginTypeView.init()
    fileprivate let inputContainer: UIView = UIView.init()
    fileprivate let smsLoginView: SmsCodeLoginView = SmsCodeLoginView.init()
    fileprivate let pwdLoginView: PasswordLoginView = PasswordLoginView.init()
    fileprivate let btnType: UIButton = UIButton.init()

    fileprivate let doneBtn: GradientLayerButton = GradientLayerButton.init(type: .custom)
    fileprivate let forgetPwdBtn: UIButton = UIButton.init(type: .custom)
    fileprivate let visitorLoginBtn: UIButton = UIButton.init(type: .custom)    // 游客登录
    fileprivate let registerBtn: UIButton = UIButton.init(type: .custom)
    //fileprivate let noAccountRegisterView: TitleButtonView = TitleButtonView.init() // 没有账号，立即注册

    
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
    fileprivate lazy var inputContainerHeight: CGFloat = {
        return self.singleInfoHeight * 2.0 + LoginNormalInputView.verMargin
    }()
    fileprivate let tipsTopMargin: CGFloat = 15     // doneBtn.bottom
    fileprivate let doneBtnHeight: CGFloat = 44
    fileprivate let doneBtnTopMargin: CGFloat = 48  // inputContainer.bottom
    
    
    
    fileprivate let backIconSize: CGSize = CGSize.init(width: 19, height: 13.5)
    fileprivate let welcomeLeftMargin: CGFloat = 16
    fileprivate let welcomeViewSize: CGSize = CGSize.init(width: 132.5, height: 49)
    fileprivate let welcomeTopMargin: CGFloat = kStatusBarHeight + 25
    fileprivate let topBgHeight: CGFloat = CGSize.init(width: 375, height: 300).scaleAspectForWidth(kScreenWidth).height
    //fileprivate let topBgHeight: CGFloat = (196 - 88 + kNavigationStatusBarHeight) + 86
    fileprivate let topViewHeight: CGFloat = kNavigationStatusBarHeight + 76
    fileprivate let bottomViewHeight: CGFloat = 500
    fileprivate let typeViewTopMargin: CGFloat = 50
    fileprivate let typeViewHeight: CGFloat = LoginTypeView.viewHeight
    //fileprivate let logoBottomMargin: CGFloat = 22
    

    
    fileprivate let types: [LoginType] = [.password, .smscode]
    fileprivate var selectedType: LoginType = .password {
        didSet {
            self.setupSelectedType(selectedType)
        }
    }

    /// 请求转圈
    fileprivate let loadingView: AppLoadingView = AppLoadingView.init(title: "请求中")

    // MARK: - Initialize Function

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle & Override Function
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    /// 控制器的view将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        // 添加键盘通知
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotificationProcess(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotificationProcess(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    /// 控制器的view即将消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 移除键盘通知
        //NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        //NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - UI
extension LoginViewController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.pageBg
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
        
//        // 0. topBgView
//        self.view.addSubview(self.topBgView)
//        self.topBgView.set(cornerRadius: 0)
//        self.topBgView.image = UIImage.init(named: "IMG_login_img_top_bg")
//        //self.topBgView.backgroundColor = AppColor.theme.withAlphaComponent(0.5)
//        self.topBgView.snp.makeConstraints { (make) in
//            make.top.leading.trailing.equalToSuperview()
//            make.height.equalTo(self.topBgHeight)
//        }
////        self.topBgView.addSubview(self.topBgCover)
////        self.topBgCover.backgroundColor = AppColor.theme.withAlphaComponent(0.5)
////        self.topBgCover.snp.makeConstraints { make in
////            make.edges.equalToSuperview()
////        }
//        // 1. topView
//        self.view.addSubview(self.topView)
//        self.initialTopView(self.topView)
//        self.topView.snp.makeConstraints { (make) in
//            make.leading.trailing.top.equalToSuperview()
//            make.height.equalTo(self.topViewHeight)
//        }
//        // 2. bottomView
//        self.view.addSubview(self.bottomView)
//        self.initialBottomView(self.bottomView)
//        self.bottomView.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview().offset(self.mainLrMargin)
//            make.trailing.equalToSuperview().offset(-self.mainLrMargin)
//            make.top.equalTo(self.topView.snp.bottom)
//            make.height.equalTo(self.bottomViewHeight)
//            //make.bottom.equalToSuperview()
//        }
//        // 3. logoView
//        self.view.addSubview(self.logoView)
//        self.logoView.set(cornerRadius: 0)
//        self.logoView.image = UIImage.init(named: "IMG_login_icon_logo")
//        self.logoView.snp.makeConstraints { (make) in
//            make.size.equalTo(self.logoSize)
//            make.centerX.equalTo(self.bottomView)
//            make.centerY.equalTo(self.bottomView.snp.top)
//        }
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
        // registerBtn
        mainView.addSubview(self.registerBtn)
        self.registerBtn.set(title: "注册", titleColor: AppColor.theme, for: .normal)
        self.registerBtn.set(title: "注册", titleColor: AppColor.theme, for: .highlighted)
        self.registerBtn.set(font: UIFont.pingFangSCFont(size: 16, weight: .medium))
        self.registerBtn.backgroundColor = UIColor.white
        self.registerBtn.set(cornerRadius: self.registerBtnSize.height * 0.5, borderWidth: 0.5, borderColor: AppColor.theme)
        self.registerBtn.addTarget(self, action: #selector(registerBtnClick(_:)), for: .touchUpInside)
        self.registerBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.size.equalTo(self.registerBtnSize)
            make.centerY.equalTo(self.logoView)
        }
        // inputContainer
        mainView.addSubview(self.inputContainer)
        self.initialInputContainer(self.inputContainer)
        self.inputContainer.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.logoView.snp.bottom).offset(self.inputContainerTopMargin)
            make.height.equalTo(self.inputContainerHeight)
        }
        // loginBtn
        mainView.addSubview(self.doneBtn)
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.set(title: "donebtn.login".localized, titleColor: AppColor.white, bgImage: nil, for: .normal)
        self.doneBtn.set(title: "donebtn.login".localized, titleColor: AppColor.white, bgImage: nil, for: .highlighted)
        self.doneBtn.set(title: "donebtn.login".localized, titleColor: AppColor.white, bgImage: nil, for: .disabled)
        self.doneBtn.set(font: UIFont.pingFangSCFont(size: 18, weight: .medium), cornerRadius: self.doneBtnHeight * 0.5, borderWidth: 0, borderColor: UIColor.clear)
        self.doneBtn.backgroundColor = AppColor.disable
        self.doneBtn.gradientLayer.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth - self.mainLrMargin * 2.0 - self.lrMargin * 2.0, height: self.doneBtnHeight)
        self.doneBtn.gradientLayer.isHidden = !self.doneBtn.isEnabled
        self.doneBtn.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.height.equalTo(self.doneBtnHeight)
            make.top.equalTo(self.inputContainer.snp.bottom).offset(self.doneBtnTopMargin)
        }
        // forgetPwd
        mainView.addSubview(self.forgetPwdBtn)
        self.forgetPwdBtn.contentHorizontalAlignment = .center
        self.forgetPwdBtn.set(title: "login.forgetpwd".localized, titleColor: AppColor.themeRed, for: .normal)
        self.forgetPwdBtn.set(title: "login.forgetpwd".localized, titleColor: AppColor.themeRed, for: .highlighted)
        self.forgetPwdBtn.set(font: UIFont.pingFangSCFont(size: 14))
        self.forgetPwdBtn.addTarget(self, action: #selector(forgetPwdBtnClick(_:)), for: .touchUpInside)
        self.forgetPwdBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.doneBtn.snp.bottom).offset(self.tipsTopMargin)
        }
        // loginTypeBtn
        mainView.addSubview(self.btnType)
        self.btnType.contentHorizontalAlignment = .center
        self.btnType.set(title: "验证码登录", titleColor: AppColor.theme, image: nil, bgImage: nil, for: .normal)
        self.btnType.set(title: "验证码登录", titleColor: AppColor.theme, image: nil, bgImage: nil, for: .highlighted)
        self.btnType.set(font: UIFont.pingFangSCFont(size: 16), cornerRadius: 0, borderWidth: 0, borderColor: AppColor.theme)
        //self.btnType.isHidden = true    // 取消验证码登录
        self.btnType.addTarget(self, action: #selector(loginTypeBtnClick(_:)), for: .touchUpInside)
        self.btnType.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-self.loginTypeBtnBottomMargin)
        }
    }
    
    //
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        let showBackWH: CGFloat = 44
        let backIconLrMargin: CGFloat = (showBackWH - self.backIconSize.width) * 0.5 // (44 - 19) * 0.5 = 12
        // backBtn
        topView.addSubview(self.backBtn)
        self.backBtn.isHidden = true    //
        self.backBtn.setImage(UIImage.init(named: "IMG_common_icon_back_light"), for: .normal)
        self.backBtn.setImage(UIImage.init(named: "IMG_common_icon_back_light"), for: .highlighted)
        self.backBtn.addTarget(self, action: #selector(navLeftItemClick), for: .touchUpInside)
        self.backBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(showBackWH)
            make.leading.equalToSuperview().offset(self.lrMargin - backIconLrMargin)
            make.top.equalToSuperview().offset(kStatusBarHeight)
        }
        // welcome - 隐藏
        topView.addSubview(self.welcomeLabel)
        self.welcomeLabel.set(text: "欢迎登录", font: UIFont.pingFangSCFont(size: 24, weight: .medium), textColor: AppColor.white)
        self.welcomeLabel.isHidden = true
        self.welcomeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.backBtn)
            make.leading.equalTo(self.backBtn.snp.trailing).offset(self.welcomeLeftMargin - backIconLrMargin)
        }
        // nameLabel - 隐藏
        topView.addSubview(self.nameLabel)
        self.nameLabel.set(text: AppConfig.share.appName, font: UIFont.pingFangSCFont(size: 21, weight: .semibold), textColor: AppColor.white)
        self.nameLabel.isHidden = true
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.welcomeLabel.snp.trailing).offset(12)
            make.centerY.equalTo(self.welcomeLabel)
            make.trailing.equalToSuperview()
        }
        // welcomeView
        topView.addSubview(self.welcomeView)
        self.welcomeView.set(cornerRadius: 0)
        self.welcomeView.image = UIImage.init(named: "IMG_login_img_text_dl")
        self.welcomeView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.welcomeLeftMargin)
            make.size.equalTo(self.welcomeViewSize)
            make.top.equalToSuperview().offset(self.welcomeTopMargin)
        }
        // registerBtn
        topView.addSubview(self.registerBtn)
        self.registerBtn.set(title: "去注册", titleColor: AppColor.theme, for: .normal)
        self.registerBtn.set(title: "去注册", titleColor: AppColor.theme, for: .highlighted)
        self.registerBtn.set(font: UIFont.pingFangSCFont(size: 16, weight: .medium))
        self.registerBtn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.registerBtn.set(cornerRadius: 5, borderWidth: 0.5, borderColor: AppColor.theme)
        self.registerBtn.addTarget(self, action: #selector(registerBtnClick(_:)), for: .touchUpInside)
        self.registerBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.mainLrMargin)
            make.size.equalTo(self.registerBtnSize)
            make.centerY.equalTo(self.backBtn)
        }
    }
    ///
    fileprivate func initialBottomView(_ bottomView: UIView) -> Void {
        // bottomView
        //bottomView.backgroundColor = AppColor.white
        //bottomView.setupCorners(UIRectCorner.init([UIRectCorner.topLeft, UIRectCorner.topRight]), selfSize: CGSize.init(width: kScreenWidth - self.mainLrMargin * 2.0, height: kScreenHeight - self.topViewHeight), cornerRadius: 20)
        bottomView.set(cornerRadius: 20)
        // 0. bgView
        let bottomBgView: UIImageView = UIImageView.init()
        bottomView.addSubview(bottomBgView)
        bottomBgView.set(cornerRadius: 0)
        bottomBgView.image = UIImage.init(named: "IMG_login_img_bg")
        bottomBgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
//        // bgTopCornerView
//        let bgTopCornerView: UIView = UIView.init()
//        bottomView.addSubview(bgTopCornerView)
//        bgTopCornerView.backgroundColor = AppColor.white
//        bgTopCornerView.setupCorners(UIRectCorner.init([UIRectCorner.topLeft, UIRectCorner.topRight]), selfSize: CGSize.init(width: kScreenWidth, height: 20), cornerRadius: 16)
//        bgTopCornerView.snp.makeConstraints { make in
//            make.leading.trailing.top.equalToSuperview()
//            make.height.equalTo(20)
//        }
//        // bgBottomView
//        let bgBottomView: UIView = UIView.init()
//        bottomView.addSubview(bgBottomView)
//        bgBottomView.backgroundColor = AppColor.white
//        bgBottomView.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.top.equalTo(bgTopCornerView.snp.bottom)
//        }
        // typView
        bottomView.addSubview(self.typeView)
        self.typeView.delegate = self
        self.typeView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(self.typeViewTopMargin)
            make.height.equalTo(self.typeViewHeight)
        }
        // 1. loginContainer
        bottomView.addSubview(self.inputContainer)
        self.initialInputContainer(self.inputContainer)
        self.inputContainer.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.typeView.snp.bottom).offset(self.inputContainerTopMargin)
            make.height.equalTo(self.inputContainerHeight)
        }
//        // 2. registerBtn
//        var registerTitleAtts = NSAttributedString.textAttTuples()
//        registerTitleAtts.append((str: "还没有账号？", font: UIFont.pingFangSCFont(size: 12), color: AppColor.mainText))
//        registerTitleAtts.append((str: "立即注册", font: UIFont.pingFangSCFont(size: 12), color: AppColor.theme))
//        let resiterTitleAttribute = NSAttributedString.attribute(registerTitleAtts)
//        bottomView.addSubview(self.registerBtn)
//        self.registerBtn.contentHorizontalAlignment = .left
//        self.registerBtn.setAttributedTitle(resiterTitleAttribute, for: .normal)
//        self.registerBtn.setAttributedTitle(resiterTitleAttribute, for: .highlighted)
//        self.registerBtn.addTarget(self, action: #selector(registerBtnClick(_:)), for: .touchUpInside)
//        self.registerBtn.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview().offset(self.lrMargin)
//            make.top.equalTo(self.inputContainer.snp.bottom).offset(self.tipsTopMargin)
//        }
        // 3. forgetPwdBtn
        bottomView.addSubview(self.forgetPwdBtn)
        self.forgetPwdBtn.contentHorizontalAlignment = .right
        self.forgetPwdBtn.set(title: "login.forgetpwd".localized, titleColor: AppColor.grayText, for: .normal)
        self.forgetPwdBtn.set(title: "login.forgetpwd".localized, titleColor: AppColor.grayText, for: .highlighted)
        self.forgetPwdBtn.set(font: UIFont.pingFangSCFont(size: 14))
        self.forgetPwdBtn.addTarget(self, action: #selector(forgetPwdBtnClick(_:)), for: .touchUpInside)
        self.forgetPwdBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.inputContainer.snp.bottom).offset(self.tipsTopMargin)
        }
        // 4. doneBtn
        bottomView.addSubview(self.doneBtn)
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.set(title: "donebtn.login".localized, titleColor: AppColor.white, bgImage: nil, for: .normal)
        self.doneBtn.set(title: "donebtn.login".localized, titleColor: AppColor.white, bgImage: nil, for: .highlighted)
        self.doneBtn.set(title: "donebtn.login".localized, titleColor: AppColor.white, bgImage: nil, for: .disabled)
        self.doneBtn.set(font: UIFont.pingFangSCFont(size: 18, weight: .medium), cornerRadius: self.doneBtnHeight * 0.5, borderWidth: 0, borderColor: UIColor.clear)
        self.doneBtn.backgroundColor = AppColor.disable
        self.doneBtn.gradientLayer.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth - self.mainLrMargin * 2.0 - self.lrMargin * 2.0, height: self.doneBtnHeight)
        self.doneBtn.gradientLayer.isHidden = !self.doneBtn.isEnabled
        self.doneBtn.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.height.equalTo(self.doneBtnHeight)
            make.top.equalTo(self.inputContainer.snp.bottom).offset(self.doneBtnTopMargin)
        }
        // 5. visitorLoginBtn
        bottomView.addSubview(self.visitorLoginBtn)
        self.visitorLoginBtn.set(title: "游客登录", titleColor: AppColor.theme, for: .normal)
        self.visitorLoginBtn.set(title: "游客登录", titleColor: AppColor.theme, for: .highlighted)
        self.visitorLoginBtn.set(font: UIFont.pingFangSCFont(size: 12))
        self.visitorLoginBtn.addTarget(self, action: #selector(visitorLoginBtnClick(_:)), for: .touchUpInside)
        self.visitorLoginBtn.isHidden = true    // 默认隐藏
        self.visitorLoginBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.doneBtn.snp.bottom).offset(15)
            //make.bottom.lessThanOrEqualToSuperview()
        }
//        // 2.2.2 loginTypeBtn
//        bottomView.addSubview(self.btnType)
//        self.btnType.contentHorizontalAlignment = .right
//        self.btnType.set(title: "验证码登录", titleColor: AppColor.theme, image: nil, bgImage: nil, for: .normal)
//        self.btnType.set(title: "验证码登录", titleColor: AppColor.theme, image: nil, bgImage: nil, for: .highlighted)
//        self.btnType.set(font: UIFont.pingFangSCFont(size: 12), cornerRadius: 5, borderWidth: 0.5, borderColor: AppColor.theme)
//        self.btnType.isHidden = true    // 取消验证码登录
//        self.btnType.addTarget(self, action: #selector(loginTypeBtnClick(_:)), for: .touchUpInside)
//        self.btnType.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.size.equalTo(self.loginTypeBtnSize)
//            make.top.equalTo(self.inputContainer.snp.bottom).offset(self.loginTypeBtnTopMargin)
//        }
    }
    ///
    fileprivate func initialInputContainer(_ container: UIView) -> Void {
        // 1. smsCodeLogin
        container.addSubview(self.smsLoginView)
        self.smsLoginView.isHidden = true
        //self.smsLoginView.delegate = self
        self.smsLoginView.inputChangedAction = { (_ inputView: SmsCodeLoginView) in
            self.couldDoneProcess()
        }
        self.smsLoginView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 2. passwordLogin
        container.addSubview(self.pwdLoginView)
        //self.pwdLoginView.delegate = self
        self.pwdLoginView.inputChangedAction = { (_ inputView: PasswordLoginView) in
            self.couldDoneProcess()
        }
        self.pwdLoginView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

// MARK: - Data(数据处理与加载)
extension LoginViewController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
//        //
//        self.logoView.kf.setImage(with: AppConfig.share.server?.designStyleModel?.square_logo_url, placeholder: nil)
        //
        self.typeView.types = self.types
        // 默认选中
        self.selectedType = .password
        //
        self.couldDoneProcess()
//        //
//        if let config = AppConfig.share.server {
//            self.showPwdLogin = config.pwdlogin_status
//        }
    }

    fileprivate func setupSelectedType(_ type: LoginType) -> Void {
        self.smsLoginView.isHidden = type != .smscode
        self.pwdLoginView.isHidden = type != .password
        self.forgetPwdBtn.isHidden = type != .password
        self.couldDoneProcess()
    }

    fileprivate func couldDoneProcess() -> Void {
        switch self.selectedType {
        case .password:
            self.doneBtn.isEnabled = self.pwdLoginView.couldDone()
        case .smscode:
            self.doneBtn.isEnabled = self.smsLoginView.couldDone()
        }
        self.doneBtn.gradientLayer.isHidden = !self.doneBtn.isEnabled
    }

    fileprivate func passwordLoginProcess() -> Void {
        // 检查账号是否合规
        guard let account = self.pwdLoginView.account, self.checkAccountFormat(account) else {
            return
        }
        // 检查密码是否填写
        guard let password = self.pwdLoginView.password, !password.isEmpty else {
            return
        }
        self.passwordLoginRequest(account: account, password: password)
    }
    fileprivate func smsCodeLoginProcess() -> Void {
        // 检查账号是否合规
        guard let account = self.smsLoginView.account, self.checkAccountFormat(account) else {
            return
        }
        // 检查密码是否填写
        guard let smsCode = self.smsLoginView.smsCode, !smsCode.isEmpty else {
            return
        }
        self.smsCodeLoginRequest(account: account, smsCode: smsCode)
    }

}

// MARK: - Event(事件响应)
extension LoginViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    /// 确定按钮点击响应
    @objc fileprivate func doneBtnClick(_ button: UIButton) -> Void {
        self.view.endEditing(true)
        switch self.selectedType {
        case .smscode:
            self.smsCodeLoginProcess()
        case .password:
            self.passwordLoginProcess()
        }
    }
    /// 没有账号，立即注册按钮点击
    @objc fileprivate func registerBtnClick(_ button: UIButton) -> Void {
        self.delegate?.loginVC(self, didClickedRegister: button)
    }
    /// 忘记密码按钮点击
    @objc fileprivate func forgetPwdBtnClick(_ button: UIButton) -> Void {
        let forgetPwdVC = LoginPwdResetController.init(scene: .login)
        self.enterPageVC(forgetPwdVC)
    }
    /// 登录方式按钮点击
    @objc fileprivate func loginTypeBtnClick(_ button: UIButton) -> Void {
        switch button.title(for: .normal) {
        case "验证码登录":
            self.selectedType = .smscode
        case "密码登录":
            self.selectedType = .password
        default:
            self.selectedType = .password
        }
        button.setTitle(self.selectedType == .password ? "验证码登录" : "密码登录", for: .normal)
    }
    @objc fileprivate func navLeftItemClick() {
        //self.navigationController?.popViewController(animated: true)
        self.view.endEditing(true)
        self.enterMainPage()
    }
    @objc fileprivate func visitorLoginBtnClick(_ button: UIButton) -> Void {
        self.view.endEditing(true)
        self.enterMainPage()
    }
}

// MARK: - Request
extension LoginViewController {

    /// 密码登录请求
    fileprivate func passwordLoginRequest(account: String, password: String) -> Void {
        self.view.isUserInteractionEnabled = false
        loadingView.title = "登录中"
        loadingView.show()
        AccountNetworkManager.pwdLogin(account: account, password: password, ticket: "", randStr: "") { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            guard status, let model = model else {
                self.view.isUserInteractionEnabled = true
                self.loadingView.dismiss()
                Toast.showToast(title: msg)
                return
            }
            NetworkManager.share.configAuthorization(model.token)
            // token获取成功，请求当前用户信息
            self.requestCurrentUserInfo(with: model, for: account)
        }
    }
    /// 短信验证码登录请求
    fileprivate func smsCodeLoginRequest(account: String, smsCode: String) -> Void {
        self.view.isUserInteractionEnabled = false
        loadingView.title = "登录中"
        loadingView.show()
        AccountNetworkManager.smsCodeLogin(account: account, smsCode: smsCode) { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            guard status, let model = model else {
                self.view.isUserInteractionEnabled = true
                self.loadingView.dismiss()
                Toast.showToast(title: msg)
                return
            }
            NetworkManager.share.configAuthorization(model.token)
            // token获取成功，请求当前用户信息
            self.requestCurrentUserInfo(with: model, for: account)
        }
    }

    /// 请求当前用户信息
    private func requestCurrentUserInfo(with token: AccountTokenModel, for account: String, isRegister: Bool = false) -> Void {
        UserNetworkManager.getCurrentUser { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            self.view.isUserInteractionEnabled = true
            self.loadingView.dismiss()
            guard status, let model = model else {
                // 注册时 只要用户请求成功，即使用户信息获取失败，也要进入主界面
                if isRegister {
                    AppConfig.share.internal.settedJPushAlias = false
                    self.enterMainPage()
                } else {
                    Toast.showToast(title: msg)
                }
                return
            }
            let accountInfo = AccountModel.init(account: account, token: token, isLast: true, userInfo: model)
            AccountManager.share.addLoginAccountInfo(accountInfo)
            JPushHelper.instance.setAlias("\(model.id)")
            self.enterMainPage()
        }
    }

}

// MARK: - Enter Page
extension LoginViewController {
    /// 进入主界面
    fileprivate func enterMainPage() -> Void {
        // 判断是否是present出来的界面，若是则直接dismiss，否则游客登录处理
        if let _ = self.navigationController?.presentingViewController {
            self.navigationController?.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: AppNotificationName.User.dismissLogin, object: nil, userInfo: nil)
        } else {
            RootManager.share.type = .main
        }
    }

}

// MARK: - Notification
extension LoginViewController {
    /// 键盘将要显示
    @objc fileprivate func keyboardWillShowNotificationProcess(_ notification: Notification) -> Void {
        var confirmMaxY: CGFloat = 0
        switch self.selectedType {
        case .password:
            if self.pwdLoginView.phoneView.textField.isFirstResponder {
                confirmMaxY = self.pwdLoginView.phoneView.convert(CGPoint.init(x: 0, y: self.singleInfoHeight), to: nil).y
                return
            } else if self.pwdLoginView.passwordView.textField.isFirstResponder {
                confirmMaxY = self.pwdLoginView.passwordView.convert(CGPoint.init(x: 0, y: self.singleInfoHeight), to: nil).y
            } else {
                return
            }
        case .smscode:
            if self.smsLoginView.phoneView.textField.isFirstResponder {
                confirmMaxY = self.smsLoginView.phoneView.convert(CGPoint.init(x: 0, y: self.singleInfoHeight), to: nil).y
                return
            } else if self.smsLoginView.smsCodeView.textField.isFirstResponder {
                confirmMaxY = self.smsLoginView.smsCodeView.convert(CGPoint.init(x: 0, y: self.singleInfoHeight), to: nil).y
            } else {
                return
            }
        }
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
extension LoginViewController {
    fileprivate func checkAccountFormat(_ account: String) -> Bool {
        var format: Bool = true
        if account.isEmpty {
            Toast.showToast(title: "账号不可为空")
            format = false
        } else if !account.isPhoneNum() {
            Toast.showToast(title: "手机号格式错误")
            format = false
        }
        return format
    }
}

// MARK: - Delegate Function

// MARK: - <LoginTypeViewProtocol>
extension LoginViewController: LoginTypeViewProtocol {

    ///
    func typeView(_ typeView: LoginTypeView, didClickedAt index: Int, type: LoginType, title: String?) -> Void {
        self.typeView.setupSelectedIndex(index)
        self.selectedType = type
    }
    
}
