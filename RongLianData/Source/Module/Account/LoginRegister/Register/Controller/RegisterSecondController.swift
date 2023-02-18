//
//  RegisterSecondController.swift
//  ChuangYe
//
//  Created by 小唐 on 2020/8/14.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  注册步骤二界面

import UIKit
import ChainOneKit

class RegisterSecondController: BaseViewController {
    // MARK: - Internal Property
    var hasBackBtn: Bool = false
    weak var delegate: RegisterViewControllerProtocol?
    let account: String
    let smsCode: String
    let inviteCode: String?


    // MARK: - Private Property
    
    //fileprivate let navBar: UIView = UIView.init()
    
    fileprivate let bgView: UIImageView = UIImageView.init()
    
    fileprivate let mainView: UIView = UIView.init()
    fileprivate let mainBgView: UIImageView = UIImageView.init()
    
    fileprivate let scrollView: UIScrollView = UIScrollView.init()      // 适配5s
    //fileprivate let mainView: UIView = UIView.init()
    
    fileprivate let topBgView: UIImageView = UIImageView.init()
    fileprivate let topBgCover: UIView = UIView.init()
    fileprivate let backBtn: UIButton = UIButton.init(type: .custom)
    
    fileprivate let topView: UIView = UIView.init()
    fileprivate let welcomeLabel = UILabel()
    fileprivate let nameLabel: UILabel = UILabel.init()
    //fileprivate let welcomeView: UIImageView = UIImageView.init()   //
    //fileprivate let titleView: TitleIconView = TitleIconView.init()
 
    fileprivate let bottomView: UIView = UIView.init()
    fileprivate let logoView: UIImageView = UIImageView.init()
    fileprivate let inputContainer: UIView = UIView.init()
    fileprivate let setPwdView: LoginPasswordInputView = LoginPasswordInputView.init()
    fileprivate let ensurePwdView: LoginPasswordInputView = LoginPasswordInputView.init()
    fileprivate let tipsLabel: UILabel = UILabel.init()

    fileprivate let doneBtn: GradientLayerButton = GradientLayerButton.init(type: .custom)

    
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
    fileprivate let tipsLrMargin: CGFloat = 55
    fileprivate let tipsTopMargin: CGFloat = 15     // doneBtn.bottom
    fileprivate let doneBtnHeight: CGFloat = 44
    fileprivate let doneBtnTopMargin: CGFloat = 82  // inputContainer.bottom
    fileprivate lazy var ensurePwdFieldHeight: CGFloat = {
        return self.ensurePwdView.fieldHeight
    }()
    
    
    fileprivate let backIconSize: CGSize = CGSize.init(width: 19, height: 13.5)
    fileprivate let welcomeLeftMargin: CGFloat = 16
    fileprivate let registerTypeBtnSize: CGSize = CGSize.init(width: 90, height: 28)
    fileprivate let registerTypeBtnTopMargin: CGFloat = 98
    
    fileprivate let topBgHeight: CGFloat = CGSize.init(width: 375, height: 300).scaleAspectForWidth(kScreenWidth).height
    //fileprivate let topBgHeight: CGFloat = (196 - 88 + kNavigationStatusBarHeight) + 86
    fileprivate let topViewHeight: CGFloat = kNavigationStatusBarHeight + 76
    fileprivate let titleViewTitleHeight: CGFloat = 44
    fileprivate let titleViewIconSize: CGSize = CGSize.init(width: 76, height: 12)
    
    fileprivate let bottomViewHeight: CGFloat = 500


    
    
    fileprivate let passwordMinLen: Int = 6
    fileprivate let passwordMaxLen: Int = 20

    /// 请求转圈
    fileprivate let loadingView: AppLoadingView = AppLoadingView.init(title: "请求中")

    
    /// 注册是否需要同步
    fileprivate var isRegisterSync: Bool = false
    

    // MARK: - Initialize Function

    init(account: String, smsCode: String, inviteCode: String?) {
        self.account = account
        self.smsCode = smsCode
        self.inviteCode = inviteCode
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle & Override Function
extension RegisterSecondController {
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
extension RegisterSecondController {
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
        // 1. backBtn
        self.view.addSubview(self.backBtn)
        self.backBtn.setImage(UIImage.init(named: "IMG_icon_nav_back_white"), for: .normal)
        self.backBtn.setImage(UIImage.init(named: "IMG_icon_nav_back_white"), for: .highlighted)
        self.backBtn.addTarget(self, action: #selector(navLeftItemClick), for: .touchUpInside)
        self.backBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(kStatusBarHeight)
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
//        // loginBtn
//        mainView.addSubview(self.loginBtn)
//        self.loginBtn.set(title: "登录", titleColor: AppColor.theme, for: .normal)
//        self.loginBtn.set(title: "登录", titleColor: AppColor.theme, for: .highlighted)
//        self.loginBtn.set(font: UIFont.pingFangSCFont(size: 16, weight: .medium))
//        self.loginBtn.backgroundColor = UIColor.white
//        self.loginBtn.set(cornerRadius: self.loginBtnSize.height * 0.5, borderWidth: 0.5, borderColor: AppColor.theme)
//        self.loginBtn.addTarget(self, action: #selector(loginBtnClick(_:)), for: .touchUpInside)
//        self.loginBtn.isHidden = true
//        self.loginBtn.snp.makeConstraints { (make) in
//            make.trailing.equalToSuperview().offset(-self.lrMargin)
//            make.size.equalTo(self.loginBtnSize)
//            make.centerY.equalTo(self.logoView)
//        }
        // inputContainer
        mainView.addSubview(self.inputContainer)
        self.initialInputContainer(self.inputContainer)
        self.inputContainer.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.logoView.snp.bottom).offset(self.inputContainerTopMargin)
            make.height.equalTo(self.inputContainerHeight)
        }
        // 2. tips
        mainView.addSubview(self.tipsLabel)
        self.tipsLabel.set(text: "*限6-20个字符以内，建议使用数字字母组合，区分大小写", font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.grayText)
        self.tipsLabel.numberOfLines = 2
        self.tipsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(self.tipsLrMargin)
            make.trailing.equalToSuperview().offset(-self.tipsLrMargin)
            make.top.equalTo(self.inputContainer.snp.bottom).offset(self.tipsTopMargin)
        }
        // 3. doneBtn
        mainView.addSubview(self.doneBtn)
        let doneBtnTitle: String = "进入融链数据" // "进入" + "\(AppConfig.share.appName)"      // "立即注册"
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.set(title: doneBtnTitle, titleColor: AppColor.white, bgImage: nil, for: .normal)
        self.doneBtn.set(title: doneBtnTitle, titleColor: AppColor.white, bgImage: nil, for: .highlighted)
        self.doneBtn.set(title: doneBtnTitle, titleColor: AppColor.white, bgImage: nil, for: .disabled)
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

    
    /// scrollView布局
    fileprivate func initialScrollView(_ scrollView: UIScrollView) -> Void {
        // scrollView
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        // 0. topView
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
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        let showBackWH: CGFloat = 44
        let backIconLrMargin: CGFloat = (showBackWH - self.backIconSize.width) * 0.5 // (44 - 19) * 0.5 = 12
        // 1. backBtn
        topView.addSubview(self.backBtn)
        self.backBtn.setImage(UIImage.init(named: "IMG_common_icon_back_white"), for: .normal)
        self.backBtn.setImage(UIImage.init(named: "IMG_common_icon_back_white"), for: .highlighted)
        self.backBtn.addTarget(self, action: #selector(navLeftItemClick), for: .touchUpInside)
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
            make.top.equalTo(self.topView.snp.bottom).offset(self.inputContainerTopMargin)
        }
        // 2. tips
        bottomView.addSubview(self.tipsLabel)
        self.tipsLabel.set(text: "*限6-20个字符以内，建议使用数字字母组合，区分大小写", font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.grayText)
        self.tipsLabel.numberOfLines = 2
        self.tipsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.inputContainer.snp.bottom).offset(self.tipsTopMargin)
        }
        // 3. doneBtn
        bottomView.addSubview(self.doneBtn)
        //let appName = "\(AppConfig.share.appName)"   //"进入" + appName
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.set(title: "立即注册", titleColor: AppColor.white, bgImage: nil, for: .normal)
        self.doneBtn.set(title: "立即注册", titleColor: AppColor.white, bgImage: nil, for: .highlighted)
        self.doneBtn.set(title: "立即注册", titleColor: AppColor.white, bgImage: nil, for: .disabled)
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
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    ///
    fileprivate func initialInputContainer(_ container: UIView) -> Void {
        // 2. setPwd
        container.addSubview(self.setPwdView)
        self.setPwdView.title = "设置密码"
        self.setPwdView.placeholder = "请设置登录密码"
        self.setPwdView.textField.addTarget(self, action: #selector(textFieldValueChainge(_:)), for: .editingChanged)
        self.setPwdView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
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
extension RegisterSecondController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        //
        //self.logoView.kf.setImage(with: AppConfig.share.server?.designStyleModel?.square_logo_url, placeholder: nil)
        //
        self.couldDoneProcess()
    }

    fileprivate func couldDone() -> Bool {
        var flag: Bool = false
        guard let password = self.setPwdView.textField.text, let ensurePwd = self.ensurePwdView.textField.text else {
            return flag
        }
        flag = (!password.isEmpty && !ensurePwd.isEmpty && password == ensurePwd)
        return flag
    }
    fileprivate func couldDoneProcess() -> Void {
        self.doneBtn.isEnabled = self.couldDone()
        self.doneBtn.gradientLayer.isHidden = !self.doneBtn.isEnabled
    }

}

// MARK: - Event(事件响应)
extension RegisterSecondController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc fileprivate func tapGRProcess(_ tapGR: UITapGestureRecognizer) -> Void {
        self.view.endEditing(true)
    }
    /// 确定按钮点击响应
    @objc fileprivate func doneBtnClick(_ button: UIButton) -> Void {
        self.view.endEditing(true)
        guard let password = self.setPwdView.textField.text, let confirmPwd = self.ensurePwdView.textField.text else {
            return
        }
        if password != confirmPwd {
//            Toast.showToast(title: "两次密码不一致")
            self.tipsLabel.text = "*请输入一致的新密码"
            self.tipsLabel.textColor = AppColor.themeRed
            self.ensurePwdView.textfieldBg.set(cornerRadius: self.ensurePwdFieldHeight * 0.5, borderWidth: 0.5, borderColor: AppColor.themeRed)
            return
        } else {
            self.tipsLabel.text = "*限6-20个字符以内，建议使用数字字母组合，区分大小写"
            self.tipsLabel.textColor = AppColor.grayText
            self.ensurePwdView.textfieldBg.set(cornerRadius: self.ensurePwdFieldHeight * 0.5, borderWidth: 0, borderColor: AppColor.dividing)
        }
        self.registerRequest(account: self.account, smsCode: self.smsCode, inviteCode: self.inviteCode, password: password, confirmPwd: confirmPwd)
    }
    /// 返回按钮点击
    @objc fileprivate func navLeftItemClick() -> Void {
        self.navigationController?.popViewController(animated: true)
    }

    @objc fileprivate func textFieldValueChainge(_ textField: UITextField) -> Void {
        switch textField {
        case self.setPwdView.textField:
            TextFieldHelper.limitTextField(textField, withMaxLen: self.passwordMaxLen)
        case self.ensurePwdView.textField:
            TextFieldHelper.limitTextField(textField, withMaxLen: self.passwordMaxLen)
        default:
            break
        }
        if let password = self.setPwdView.textField.text, let ensurePwd = self.ensurePwdView.textField.text, !password.isEmpty, !ensurePwd.isEmpty, password != ensurePwd {
            self.tipsLabel.set(text: "*请输入一致的新密码", font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.themeRed)
            self.ensurePwdView.textfieldBg.set(cornerRadius: self.ensurePwdFieldHeight * 0.5, borderWidth: 0.5, borderColor: AppColor.themeRed)
        } else {
            self.tipsLabel.set(text: "*限6-20个字符以内，建议使用数字字母组合，区分大小写", font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.grayText)
            self.ensurePwdView.textfieldBg.set(cornerRadius: self.ensurePwdFieldHeight * 0.5, borderWidth: 0, borderColor: AppColor.dividing)
        }
        self.couldDoneProcess()
    }

}

// MARK: - Request
extension RegisterSecondController {

    /// 注册请求
    fileprivate func registerRequest(account: String, smsCode: String, inviteCode: String?, password: String, confirmPwd: String) -> Void {
        self.view.isUserInteractionEnabled = false
        self.loadingView.title = "注册中"
        self.loadingView.show()
        AccountNetworkManager.register(account: account, password: password, confirmPwd: confirmPwd, smsCode: smsCode, inviteCode: inviteCode) { [weak self](status, msg, data) in
            guard let `self` = self else {
                return
            }
            guard status, let data = data else {
                self.view.isUserInteractionEnabled = true
                self.loadingView.dismiss()
                Toast.showToast(title: msg)
                return
            }
            NetworkManager.share.configAuthorization(data.token.token)
            // token获取成功，请求当前用户信息
            self.requestCurrentUserInfo(with: data.token, for: account, isRegister: true)
            self.isRegisterSync = data.syncStatus
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
extension RegisterSecondController {
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
extension RegisterSecondController {
    /// 键盘将要显示
    @objc fileprivate func keyboardWillShowNotificationProcess(_ notification: Notification) -> Void {
        var confirmMaxY: CGFloat = 0
        if self.setPwdView.textField.isFirstResponder {
            confirmMaxY = self.setPwdView.convert(CGPoint.init(x: 0, y: self.singleInfoHeight), to: nil).y
            return
        } else if self.ensurePwdView.textField.isFirstResponder {
            confirmMaxY = self.ensurePwdView.convert(CGPoint.init(x: 0, y: self.singleInfoHeight), to: nil).y
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
extension RegisterSecondController {

}

// MARK: - Delegate Function

// MARK: - <>
extension RegisterSecondController {

}
