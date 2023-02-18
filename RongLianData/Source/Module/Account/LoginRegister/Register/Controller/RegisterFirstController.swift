//
//  RegisterFirstController.swift
//  ChuangYe
//
//  Created by 小唐 on 2020/8/14.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  注册步骤一界面

import UIKit
import ChainOneKit

protocol RegisterViewControllerProtocol: class {
    /// 登录点击回调
    func registerVC(_ registerVC: RegisterViewController, didClickedLogin loginView: UIView) -> Void
}

typealias RegisterViewController = RegisterFirstController
class RegisterFirstController: BaseViewController {
    // MARK: - Internal Property

    var hasBackBtn: Bool = false
    weak var delegate: RegisterViewControllerProtocol?

    // MARK: - Private Property

    fileprivate let bgView: UIImageView = UIImageView.init()
    
    fileprivate let mainView: UIView = UIView.init()
    fileprivate let mainBgView: UIImageView = UIImageView.init()
    
    fileprivate let scrollView: UIScrollView = UIScrollView.init()      // 适配5s

    fileprivate let topBgView: UIImageView = UIImageView.init()
    fileprivate let topBgCover: UIView = UIView.init()
    fileprivate let backBtn: UIButton = UIButton.init()
    fileprivate let loginBtn: UIButton = UIButton.init(type: .custom)
    
    fileprivate let topView: UIView = UIView.init()
    fileprivate let welcomeLabel = UILabel()
    fileprivate let nameLabel: UILabel = UILabel.init()
    fileprivate let welcomeView: UIImageView = UIImageView.init()   //
    //fileprivate let titleView: TitleIconView = TitleIconView.init()
    
    fileprivate let bottomView: UIView = UIView.init()
    fileprivate let logoView: UIImageView = UIImageView.init()
    fileprivate let inputContainer: UIView = UIView.init()
    fileprivate let phoneView: LoginPhoneInputView = LoginPhoneInputView.init()
    fileprivate let smsCodeView: LoginSmsCodeInputView = LoginSmsCodeInputView.init()
    fileprivate let inviteCodeView: LoginNormalInputView = LoginNormalInputView.init()
    //fileprivate let hasAccountLoginView: TitleButtonView = TitleButtonView.init() // 已有账号，立即登录

    fileprivate let doneBtn: GradientLayerButton = GradientLayerButton.init(type: .custom)
    fileprivate let selectBtn: UIButton = UIButton.init(type: .custom)          // 选择按钮、协议是否同意
    fileprivate let agreementView: TitleButtonView = TitleButtonView.init()
    fileprivate let privacyView: TitleButtonView = TitleButtonView.init()

    
    fileprivate let mainTopMargin: CGFloat = kNavigationStatusBarHeight + 5
    fileprivate let mainBgSize: CGSize = CGSize.init(width: 349, height: 582)
    
    fileprivate let mainLrMargin: CGFloat = 13
    fileprivate let lrMargin: CGFloat = 34
    
    
    fileprivate let logoTopMargin: CGFloat = 147
    fileprivate let logoSize: CGSize = CGSize.init(width: 83.5, height: 24.5)
    fileprivate let loginBtnSize: CGSize = CGSize.init(width: 68, height: 28)
    
    fileprivate let inputContainerTopMargin: CGFloat = 28   // logo.bottom
    fileprivate let singleInfoHeight: CGFloat = LoginNormalInputView.viewHeight
    fileprivate let infoVerMargin: CGFloat = LoginNormalInputView.verMargin
    fileprivate lazy var inputContainerHeight: CGFloat = {
        return self.singleInfoHeight * 2.0 + LoginNormalInputView.verMargin
    }()
    fileprivate let tipsTopMargin: CGFloat = 15     // doneBtn.bottom
    fileprivate let doneBtnHeight: CGFloat = 44
    fileprivate let doneBtnTopMargin: CGFloat = 82  // inputContainer.bottom
    fileprivate let selectIconWH: CGFloat = 18
    
    
    fileprivate let backIconSize: CGSize = CGSize.init(width: 19, height: 13.5)
    fileprivate let welcomeLeftMargin: CGFloat = 16
    fileprivate let registerTypeBtnSize: CGSize = CGSize.init(width: 90, height: 28)
    fileprivate let registerTypeBtnTopMargin: CGFloat = 98
    fileprivate let welcomeViewSize: CGSize = CGSize.init(width: 132.5, height: 49)
    fileprivate let welcomeTopMargin: CGFloat = kStatusBarHeight + 25
    
    fileprivate let topBgHeight: CGFloat = CGSize.init(width: 375, height: 300).scaleAspectForWidth(kScreenWidth).height
    //fileprivate let topBgHeight: CGFloat = (196 - 88 + kNavigationStatusBarHeight) + 86
    fileprivate let topViewHeight: CGFloat = kNavigationStatusBarHeight + 76
    fileprivate let titleViewTitleHeight: CGFloat = 44
    fileprivate let titleViewIconSize: CGSize = CGSize.init(width: 76, height: 12)
    
    fileprivate let bottomViewHeight: CGFloat = 500


    
    fileprivate let accountMaxLen: Int = 11
    fileprivate let smsCodeMaxLen: Int = 6
    fileprivate let inviteCodeMaxLen: Int = 6
    
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
extension RegisterFirstController {
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
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

// MARK: - UI
extension RegisterFirstController {
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

//        // 0. bgImage
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
//        // scrollView
//        self.view.addSubview(self.scrollView)
//        self.initialScrollView(self.scrollView)
//        self.scrollView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//        // 顶部位置 的版本适配
//        if #available(iOS 11.0, *) {
//            self.scrollView.contentInsetAdjustmentBehavior = .never
//        } else if #available(iOS 9.0, *) {
//            self.automaticallyAdjustsScrollViewInsets = false
//        }
//        // tapGR
//        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGRProcess(_:)))
//        self.scrollView.addGestureRecognizer(tapGR)
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
        // loginBtn
        mainView.addSubview(self.loginBtn)
        self.loginBtn.set(title: "登录", titleColor: AppColor.theme, for: .normal)
        self.loginBtn.set(title: "登录", titleColor: AppColor.theme, for: .highlighted)
        self.loginBtn.set(font: UIFont.pingFangSCFont(size: 16, weight: .medium))
        self.loginBtn.backgroundColor = UIColor.white
        self.loginBtn.set(cornerRadius: self.loginBtnSize.height * 0.5, borderWidth: 0.5, borderColor: AppColor.theme)
        self.loginBtn.addTarget(self, action: #selector(loginBtnClick(_:)), for: .touchUpInside)
        self.loginBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.size.equalTo(self.loginBtnSize)
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
        // selecteBtn
        mainView.addSubview(self.selectBtn)
        //self.selectBtn.set(font: UIFont.init(name: "iconfont", size: 18))
        //self.selectBtn.set(title: IconFont.option_uncheck, titleColor: AppColor.minorText, for: .normal)
        //self.selectBtn.set(title: IconFont.option_checked, titleColor: AppColor.theme, for: .selected)
        self.selectBtn.setImage(UIImage.init(named: "IMG_login_option_uncheck"), for: .normal)
        self.selectBtn.setImage(UIImage.init(named: "IMG_login_option_checked"), for: .selected)
        self.selectBtn.addTarget(self, action: #selector(selectBtnClick(_:)), for: .touchUpInside)
        self.selectBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.selectIconWH)
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.top.equalTo(self.inputContainer.snp.bottom).offset(self.tipsTopMargin)
        }
        // agreementView
        mainView.addSubview(self.agreementView)
        self.agreementView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.selectBtn)
            make.leading.equalTo(self.selectBtn.snp.trailing).offset(5)
        }
        self.agreementView.titleLabel.set(text: "我已阅读并同意", font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.mainText)
        self.agreementView.titleLabel.snp.remakeConstraints { (make) in
            make.leading.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        self.agreementView.button.set(title: "《用户协议》", titleColor: AppColor.theme, for: .normal)
        self.agreementView.button.set(title: "《用户协议》", titleColor: AppColor.theme, for: .highlighted)
        self.agreementView.button.set(font: UIFont.pingFangSCFont(size: 12))
        self.agreementView.button.addTarget(self, action: #selector(agreementBtnClick(_:)), for: .touchUpInside)
        self.agreementView.button.snp.remakeConstraints { (make) in
            make.leading.equalTo(self.agreementView.titleLabel.snp.trailing).offset(2)
            make.centerY.trailing.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        let mAttr = NSMutableAttributedString.init(string: "")
        mAttr.append(NSAttributedString.init(string: "《用户协议》", attributes: [NSAttributedString.Key.foregroundColor: AppColor.theme, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor: AppColor.theme]))
        self.agreementView.button.setAttributedTitle(mAttr, for: .normal)
        // doneBtn 下一步/注册
        mainView.addSubview(self.doneBtn)
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.set(title: "注册", titleColor: AppColor.white, bgImage: nil, for: .normal)
        self.doneBtn.set(title: "注册", titleColor: AppColor.white, bgImage: nil, for: .highlighted)
        self.doneBtn.set(title: "注册", titleColor: AppColor.white, bgImage: nil, for: .disabled)
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
        }

    }
    
    /// scrollView布局
    fileprivate func initialScrollView(_ scrollView: UIScrollView) -> Void {
        // scrollView
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        // 1. topView
        scrollView.addSubview(self.topView)
        self.initialTopView(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.leading.trailing.width.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(self.topViewHeight)
        }
        // 2. bottomView
        scrollView.addSubview(self.bottomView)
        self.initialBottomView(self.bottomView)
        self.bottomView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.mainLrMargin)
            make.trailing.equalToSuperview().offset(-self.mainLrMargin)
            make.top.equalTo(self.topView.snp.bottom)
            //make.bottom.equalToSuperview()
            //make.height.greaterThanOrEqualTo(kScreenHeight - self.topViewHeight)
            make.height.equalTo(self.bottomViewHeight)
            make.bottom.lessThanOrEqualToSuperview()
        }
        // 3. logoView
        scrollView.addSubview(self.logoView)
        self.logoView.set(cornerRadius: 0)
        self.logoView.image = UIImage.init(named: "IMG_login_icon_logo")
        self.logoView.snp.makeConstraints { (make) in
            make.size.equalTo(self.logoSize)
            make.centerX.equalTo(self.bottomView)
            make.centerY.equalTo(self.bottomView.snp.top)
        }
    }
    ///
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        let showBackWH: CGFloat = 44
        let backIconLrMargin: CGFloat = (showBackWH - self.backIconSize.width) * 0.5 // (44 - 19) * 0.5 = 12
        // 1. backBtn
        topView.addSubview(self.backBtn)
        self.backBtn.setImage(UIImage.init(named: "IMG_common_icon_back_light"), for: .normal)
        self.backBtn.setImage(UIImage.init(named: "IMG_common_icon_back_light"), for: .highlighted)
        self.backBtn.addTarget(self, action: #selector(navLeftItemClick), for: .touchUpInside)
        self.backBtn.isHidden = true
        self.backBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(showBackWH)
            make.leading.equalToSuperview().offset(self.lrMargin - backIconLrMargin)
            make.top.equalToSuperview().offset(kStatusBarHeight)
        }
        // 2. welcome - 隐藏
        topView.addSubview(self.welcomeLabel)
        self.welcomeLabel.set(text: "欢迎注册", font: UIFont.pingFangSCFont(size: 24, weight: .medium), textColor: AppColor.white)
        self.welcomeLabel.isHidden = true
        self.welcomeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.backBtn)
            make.leading.equalTo(self.backBtn.snp.trailing).offset(self.welcomeLeftMargin - backIconLrMargin)
        }
        // nameLabel - 隐藏
        topView.addSubview(self.nameLabel)
        self.nameLabel.set(text: AppConfig.share.appName, font: UIFont.pingFangSCFont(size: 21, weight: .semibold), textColor: AppColor.white)
        self.nameLabel.isHidden = true
        self.nameLabel.snp.remakeConstraints { make in
            make.leading.equalTo(self.welcomeLabel.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        // welcomeView
        topView.addSubview(self.welcomeView)
        self.welcomeView.set(cornerRadius: 0)
        self.welcomeView.image = UIImage.init(named: "IMG_login_img_text_zc")
        self.welcomeView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.welcomeLeftMargin)
            make.size.equalTo(self.welcomeViewSize)
            make.top.equalToSuperview().offset(self.welcomeTopMargin)
        }
        // 3. loginBtn
        topView.addSubview(self.loginBtn)
        self.loginBtn.set(title: "去登录", titleColor: AppColor.theme, for: .normal)
        self.loginBtn.set(title: "去登录", titleColor: AppColor.theme, for: .highlighted)
        self.loginBtn.set(font: UIFont.pingFangSCFont(size: 16, weight: .medium))
        self.loginBtn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.loginBtn.set(cornerRadius: 5, borderWidth: 0.5, borderColor: AppColor.theme)
        self.loginBtn.addTarget(self, action: #selector(loginBtnClick(_:)), for: .touchUpInside)
        //self.loginBtn.isHidden = self.hasBackBtn
        self.loginBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.mainLrMargin)
            make.size.equalTo(self.loginBtnSize)
            make.centerY.equalTo(self.backBtn)
        }        
//        // titleView
//        topView.addSubview(self.titleView)
//        self.titleView.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//        self.titleView.titleLabel.set(text: "注册", font: UIFont.pingFangSCFont(size: 20), textColor: AppColor.white, alignment: .center)
//        self.titleView.titleLabel.snp.remakeConstraints { make in
//            make.centerX.equalToSuperview().multipliedBy(0.5)
//            make.top.equalToSuperview()
//            make.height.equalTo(self.titleViewTitleHeight)
//        }
//        self.titleView.iconView.image = UIImage.init(named: "IMG_login_img_arrowhead")
//        self.titleView.iconView.set(cornerRadius: 0)
//        self.titleView.iconView.snp.remakeConstraints { make in
//            make.top.equalTo(self.titleView.titleLabel.snp.bottom)
//            make.centerX.equalTo(self.titleView.titleLabel)
//            make.size.equalTo(self.titleViewIconSize)
//            make.bottom.equalToSuperview()
//        }
        //
        self.backBtn.isHidden = !self.hasBackBtn
        self.welcomeLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(self.backBtn)
            if self.hasBackBtn {
                make.leading.equalTo(self.backBtn.snp.trailing).offset(self.welcomeLeftMargin - backIconLrMargin)
            } else {
                make.leading.equalToSuperview().offset(self.lrMargin)
            }
        }
    }
    ///
    fileprivate func initialBottomView(_ bottomView: UIView) -> Void {
        // bottomView
        bottomView.set(cornerRadius: 20)
        //bottomView.backgroundColor = AppColor.white
        //bottomView.setupCorners(UIRectCorner.init([UIRectCorner.topLeft, UIRectCorner.topRight]), selfSize: CGSize.init(width: kScreenWidth - self.mainLrMargin * 2.0, height: kScreenHeight - self.topViewHeight), cornerRadius: 20)
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
        // 1. inputContainer
        bottomView.addSubview(self.inputContainer)
        self.initialInputContainer(self.inputContainer)
        self.inputContainer.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(self.inputContainerTopMargin)
        }
//        // 2. loginBtn
//        var loginTitleAtts = NSAttributedString.textAttTuples()
//        loginTitleAtts.append((str: "已有账号？", font: UIFont.pingFangSCFont(size: 12), color: AppColor.mainText))
//        loginTitleAtts.append((str: "立即登录", font: UIFont.pingFangSCFont(size: 12), color: AppColor.theme))
//        let loginTitleAttribute = NSAttributedString.attribute(loginTitleAtts)
//        bottomView.addSubview(self.loginBtn)
//        self.loginBtn.contentHorizontalAlignment = .left
//        self.loginBtn.setAttributedTitle(loginTitleAttribute, for: .normal)
//        self.loginBtn.setAttributedTitle(loginTitleAttribute, for: .highlighted)
//        self.loginBtn.addTarget(self, action: #selector(loginBtnClick(_:)), for: .touchUpInside)
//        self.loginBtn.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview().offset(self.lrMargin)
//            make.top.equalTo(self.inputContainer.snp.bottom).offset(self.tipsTopMargin)
//        }
        // 3. doneBtn
        bottomView.addSubview(self.doneBtn)
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.set(title: "下一步", titleColor: AppColor.white, bgImage: nil, for: .normal)
        self.doneBtn.set(title: "下一步", titleColor: AppColor.white, bgImage: nil, for: .highlighted)
        self.doneBtn.set(title: "下一步", titleColor: AppColor.white, bgImage: nil, for: .disabled)
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
        }
        // 4. agreementSelect
        // selecteBtn
        bottomView.addSubview(self.selectBtn)
        //self.selectBtn.set(font: UIFont.init(name: "iconfont", size: 18))
        //self.selectBtn.set(title: IconFont.option_uncheck, titleColor: AppColor.minorText, for: .normal)
        //self.selectBtn.set(title: IconFont.option_checked, titleColor: AppColor.theme, for: .selected)
        self.selectBtn.setImage(UIImage.init(named: "IMG_common_icon_option_uncheck"), for: .normal)
        self.selectBtn.setImage(UIImage.init(named: "IMG_common_icon_option_checked"), for: .selected)
        self.selectBtn.addTarget(self, action: #selector(selectBtnClick(_:)), for: .touchUpInside)
        self.selectBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.selectIconWH)
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.top.equalTo(self.doneBtn.snp.bottom).offset(self.tipsTopMargin)
            make.bottom.lessThanOrEqualToSuperview()
        }
        // agreementView
        bottomView.addSubview(self.agreementView)
        self.agreementView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.selectBtn)
            make.leading.equalTo(self.selectBtn.snp.trailing).offset(5)
        }
        self.agreementView.titleLabel.set(text: "我已阅读并同意", font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.grayText)
        self.agreementView.titleLabel.snp.remakeConstraints { (make) in
            make.leading.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        self.agreementView.button.set(title: "《用户协议》", titleColor: AppColor.theme, for: .normal)
        self.agreementView.button.set(title: "《用户协议》", titleColor: AppColor.theme, for: .highlighted)
        self.agreementView.button.set(font: UIFont.pingFangSCFont(size: 12))
        self.agreementView.button.addTarget(self, action: #selector(agreementBtnClick(_:)), for: .touchUpInside)
        self.agreementView.button.snp.remakeConstraints { (make) in
            make.leading.equalTo(self.agreementView.titleLabel.snp.trailing).offset(2)
            make.centerY.trailing.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        let mAttr = NSMutableAttributedString.init(string: "")
        mAttr.append(NSAttributedString.init(string: "《用户协议》", attributes: [NSAttributedString.Key.foregroundColor: AppColor.theme, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor: AppColor.theme]))
        self.agreementView.button.setAttributedTitle(mAttr, for: .normal)
        // privacyView
        bottomView.addSubview(self.privacyView)
        self.privacyView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.selectBtn)
            make.leading.equalTo(self.agreementView.snp.trailing)
            make.trailing.lessThanOrEqualToSuperview()
        }
        self.privacyView.titleLabel.set(text: "和", font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.grayText)
        self.privacyView.titleLabel.snp.remakeConstraints { (make) in
            make.leading.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        self.privacyView.button.set(title: "《隐私政策》", titleColor: AppColor.theme, for: .normal)
        self.privacyView.button.set(title: "《隐私政策》", titleColor: AppColor.theme, for: .highlighted)
        self.privacyView.button.set(font: UIFont.pingFangSCFont(size: 12))
        self.privacyView.button.addTarget(self, action: #selector(privacyBtnClick(_:)), for: .touchUpInside)
        self.privacyView.button.snp.remakeConstraints { (make) in
            make.leading.equalTo(self.privacyView.titleLabel.snp.trailing).offset(2)
            make.centerY.trailing.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        let mAttrPrivacy = NSMutableAttributedString.init(string: "")
        mAttrPrivacy.append(NSAttributedString.init(string: "《隐私政策》", attributes: [NSAttributedString.Key.foregroundColor: AppColor.theme, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor: AppColor.theme]))
        self.privacyView.button.setAttributedTitle(mAttrPrivacy, for: .normal)
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
            make.bottom.equalToSuperview()
        }
//        // 3. inviteCode
//        container.addSubview(self.inviteCodeView)
//        self.inviteCodeView.title = "邀请码"
//        //self.inviteCodeView.icon = UIImage.init(named: "IMG_login_icon_invitecode")
//        //self.inviteCodeView.icon = UIImage.getIconFontImage(code: IconFont.login_invitation, fontSize: 16, color: AppColor.theme)
//        self.inviteCodeView.placeholder = "请输入邀请码（选填）"
//        self.inviteCodeView.textField.addTarget(self, action: #selector(textFieldValueChainge(_:)), for: .editingChanged)
//        self.inviteCodeView.snp.makeConstraints { (make) in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.top.equalTo(self.smsCodeView.snp.bottom)
//            make.height.equalTo(self.singleInfoHeight)
//        }
    }

}

// MARK: - Data(数据处理与加载)
extension RegisterFirstController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        //
        //self.logoView.kf.setImage(with: AppConfig.share.server?.designStyleModel?.square_logo_url, placeholder: nil)
        //
        self.couldDoneProcess()
    }

    fileprivate func couldDone() -> Bool {
        var flag: Bool = false
        guard let account = self.phoneView.textField.text, let verifyCode = self.smsCodeView.textField.text  else {
            return flag
        }
        flag = (!account.isEmpty && !verifyCode.isEmpty && self.selectBtn.isSelected)
        return flag
    }
    fileprivate func couldDoneProcess() -> Void {
        self.doneBtn.isEnabled = self.couldDone()
        self.doneBtn.gradientLayer.isHidden = !self.doneBtn.isEnabled
    }

}

// MARK: - Event(事件响应)
extension RegisterFirstController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc fileprivate func tapGRProcess(_ tapGR: UITapGestureRecognizer) -> Void {
        self.view.endEditing(true)
    }

    /// 确定按钮点击响应
    @objc fileprivate func doneBtnClick(_ button: UIButton) -> Void {
        self.view.endEditing(true)
        // 检查账号格式
        guard let account = self.phoneView.textField.text, self.checkAccountFormat(account) else {
            return
        }
        guard let smsCode = self.smsCodeView.textField.text else {
            return
        }
        self.contentInputValidRequest(account: account, smsCode: smsCode, inviteCode: self.inviteCodeView.textField.text)
    }
    /// 已有账号，立即登录按钮点击
    @objc fileprivate func loginBtnClick(_ button: UIButton) -> Void {
        self.delegate?.registerVC(self, didClickedLogin: button)
    }

    /// 发送验证码按钮点击
    @objc fileprivate func sendSmsCodeBtnClick(_ button: UIButton) -> Void {
        self.view.endEditing(true)
        guard let account = self.phoneView.textField.text, !account.isEmpty else {
            Toast.showToast(title: "请先输入手机号")
            return
        }
//        // 使用xxx验证
//        self.smsCodeView.gt3CaptchaManager.startGTCaptchaWith(animated: true)
//        // 使用顶象验证
//        self.showDingXiangVerifyPopView(account: account)
        // 使用腾讯验证
        self.showTencentVerifyPopView(account: account)
    }

    @objc fileprivate func textFieldValueChainge(_ textField: UITextField) -> Void {
        switch textField {
        case self.phoneView.textField:
            TextFieldHelper.limitTextField(textField, withMaxLen: self.accountMaxLen)
            self.couldDoneProcess()
        case self.smsCodeView.textField:
            TextFieldHelper.limitTextField(textField, withMaxLen: self.smsCodeMaxLen)
            self.couldDoneProcess()
        case self.inviteCodeView.textField:
            TextFieldHelper.limitTextField(textField, withMaxLen: self.inviteCodeMaxLen)
            self.couldDoneProcess()
        default:
            break
        }
    }
    @objc fileprivate func navLeftItemClick() {
        self.navigationController?.popViewController(animated: true)
    }
    /// 选中按钮点击
    @objc fileprivate func selectBtnClick(_ button: UIButton) -> Void {
        button.isSelected = !button.isSelected
        self.couldDoneProcess()
    }
    /// 协议按钮点击
    @objc fileprivate func agreementBtnClick(_ button: UIButton) -> Void {
        self.enterAgreementPage()
    }
    /// 隐私按钮点击
    @objc fileprivate func privacyBtnClick(_ button: UIButton) -> Void {
        self.enterPrivacyPage()
    }
}

// MARK: - Request
extension RegisterFirstController {
    /// 发送短信验证码请求
    fileprivate func sendSmsCodeRequest(account: String, geetest_validate: String? = nil, geetest_challenge: String? = nil, geetest_seccode: String? = nil, token: String? = nil, ticket: String? = nil, randstr: String? = nil) -> Void {
        self.view.isUserInteractionEnabled = false
        AccountNetworkManager.sendSMSCode(account: account, scene: .register, ticket: "", randStr: "") { [weak self](status, msg) in
            guard let `self` = self else {
                return
            }
//            self.smsCodeView.closeGTView()
            //self.smsCodeView.codeBtn.setTitle("重新发送验证码", for: .normal)
            self.view.isUserInteractionEnabled = true
            guard status else {
                Toast.showToast(title: msg)
                return
            }
            Toast.showToast(title: "验证码已发送")
            self.smsCodeView.startTimer()
        }
    }
    /// 验证码、手机号、邀请码 验证请求 - 服务器提供仅校验验证码
    fileprivate func contentInputValidRequest(account: String, smsCode: String, inviteCode: String?) -> Void {
        self.view.isUserInteractionEnabled = false
        AppUtil.showHud()
        AccountNetworkManager.validSMSCode(account: account, scene: .register, code: smsCode) { [weak self](status, msg) in
            guard let `self` = self else {
                return
            }
            AppUtil.hideHud()
            self.view.isUserInteractionEnabled = true
            guard status else {
                Toast.showToast(title: msg)
                return
            }
            self.enterRegisterSecondPage(account: account, smsCode: smsCode, inviteCode: inviteCode)
        }
    }

}

// MARK: - Enter Page
extension RegisterFirstController {
    /// 进入注册二级界面
    fileprivate func enterRegisterSecondPage(account: String, smsCode: String, inviteCode: String?) -> Void {
        let secondVC = RegisterSecondController.init(account: account, smsCode: smsCode, inviteCode: inviteCode)
        secondVC.hasBackBtn = self.hasBackBtn
        self.enterPageVC(secondVC)
    }
    /// 进入协议界面
    fileprivate func enterAgreementPage() -> Void {
        guard let registerProtocol = AppConfig.share.server?.register_protocol else {
            return
        }
        let webVC = XDWKWebViewController.init(type: XDWebViwSourceType.strUrl(strUrl: registerProtocol))
        self.enterPageVC(webVC)
    }
    /// 进入隐私界面
    fileprivate func enterPrivacyPage() -> Void {
        self.enterAgreementPage()
    }
    
    /// 显示顶象验证弹窗
    fileprivate func showDingXiangVerifyPopView(account: String) -> Void {
        // 直接发送验证码请求
        self.sendSmsCodeRequest(account: account)
    }
    /// 显示腾讯验证弹窗
    fileprivate func showTencentVerifyPopView(account: String) -> Void {
        // 直接发送验证码请求
        self.sendSmsCodeRequest(account: account)
    }
    
}

// MARK: - Notification
extension RegisterFirstController {
    /// 键盘将要显示
    @objc fileprivate func keyboardWillShowNotificationProcess(_ notification: Notification) -> Void {
        var confirmMaxY: CGFloat = 0
        if self.phoneView.textField.isFirstResponder {
            return
        } else if self.smsCodeView.textField.isFirstResponder {
            confirmMaxY = self.smsCodeView.convert(CGPoint.init(x: 0, y: self.singleInfoHeight), to: nil).y
        } else if self.inviteCodeView.textField.isFirstResponder {
            confirmMaxY = self.inviteCodeView.convert(CGPoint.init(x: 0, y: self.singleInfoHeight), to: nil).y
        } else {
            return
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
extension RegisterFirstController {
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
