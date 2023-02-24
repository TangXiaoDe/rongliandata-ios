//
//  LoginHomeController.swift
//  ChuangYe
//
//  Created by 小唐 on 2020/8/14.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  登录主页：登录页 + 注册页

import UIKit

typealias LoginRegisterController = LoginHomeController
class LoginHomeController: BaseViewController {
    // MARK: - Internal Property

    var visitorLogin: Bool = false
    
    // MARK: - Private Property

    var type: LoginRegisterType = .login {
        didSet {
            self.loginVC.view.isHidden = type != .login
            self.registerVC.view.isHidden = type != .register
        }
    }

    fileprivate let loginVC = LoginViewController.init()
    fileprivate let registerVC = RegisterViewController.init()


    // MARK: - Initialize Function

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Internal Function

// MARK: - LifeCircle & Override Function
extension LoginHomeController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
        VersionManager.share.updateProcess()    // 版本更新判断
        // 添加通知处理
        NotificationCenter.default.addObserver(self, selector: #selector(versionNeedUpdateNotificationProcess(_:)), name: AppNotificationName.App.versionNeedUpate, object: nil)
    }

    /// 控制器的view将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    /// 控制器的view即将消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

// MARK: - UI
extension LoginHomeController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.pageBg
        // 1. login
        self.addChild(self.loginVC)
        self.view.addSubview(self.loginVC.view)
        self.loginVC.delegate = self
        self.loginVC.view.isHidden = true   // 默认隐藏
        self.loginVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 2. rigister
        self.addChild(self.registerVC)
        self.view.addSubview(self.registerVC.view)
        self.registerVC.delegate = self
        self.registerVC.view.isHidden = true
        self.registerVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

// MARK: - Data(数据处理与加载)
extension LoginHomeController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        self.type = .login
        //
        self.loginVC.hasBackBtn = self.visitorLogin
    }

}

// MARK: - Event(事件响应)
extension LoginHomeController {

}

// MARK: - Enter Page
extension LoginHomeController {

}

// MARK: - Notification
extension LoginHomeController {

    ///
    @objc fileprivate func versionNeedUpdateNotificationProcess(_ notification: Notification) -> Void {
        VersionManager.share.updateProcess()
    }
    
}

// MARK: - Extension Function
extension LoginHomeController {

}

// MARK: - Delegate Function

// MARK: - <LoginViewControllerProtocol>
extension LoginHomeController: LoginViewControllerProtocol {
    /// 注册点击回调
    func loginVC(_ loginVC: LoginViewController, didClickedRegister registerView: UIView) -> Void {
        self.type = .register
    }

}
// MARK: - <RegisterViewControllerProtocol>
extension LoginHomeController: RegisterViewControllerProtocol {
    /// 登录点击回调
    func registerVC(_ registerVC: RegisterViewController, didClickedLogin loginView: UIView) -> Void {
        self.type = .login
    }

}
