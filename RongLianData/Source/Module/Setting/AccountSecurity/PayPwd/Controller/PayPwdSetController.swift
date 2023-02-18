//
//  PayPwdSetController.swift
//  iMeet
//
//  Created by 小唐 on 2019/1/16.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  支付密码设置界面

import UIKit

/// 支付密码设置类型
enum PayPwdSetType {
    /// 初始化——第一次设置,使用验证码
    case initial(smsCode: String)
    /// 重置——使用验证码
    case reset(smsCode: String)
}

class PayPwdSetController: BaseViewController {
    // MARK: - Internal Property
    let type: PayPwdSetType

    // MARK: - Private Property

//    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var doneBtn: UIButton!

    fileprivate let doneBtnLayer: CAGradientLayer = AppUtil.commonGradientLayer()
    fileprivate let pwdInputView: PasswordInputView = PasswordInputView(width: kScreenWidth - 44)
    fileprivate let doneBtnH: CGFloat = 44
    fileprivate let lrMargin: CGFloat = 40


    // MARK: - Initialize Function

    init(type: PayPwdSetType) {
        self.type = type
        super.init(nibName: "PayPwdSetController", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle Function
extension PayPwdSetController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = self.pwdInputView.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
}

// MARK: - UI
extension PayPwdSetController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.white
        // title
        var title: String = "设置支付密码"
        var promptText: String = "请设置支付密码"
        switch self.type {
        case .initial:
            title = "设置支付密码"
            promptText = "请设置支付密码"
        case .reset:
            title = "重置支付密码"
            promptText = "请设置新的支付密码"
        }
        // navigationbar
        self.navigationItem.title = title
        // prompt
//        self.promptLabel.set(text: promptText, font: UIFont.pingFangSCFont(size: 24), textColor: AppColor.mainText, alignment: .center)
        // inputView
        self.passwordField.isHidden = true
        self.view.addSubview(self.pwdInputView)
        pwdInputView.secureTextEntry = true
        pwdInputView.delegate = self
        pwdInputView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.passwordField)
        }
        // doneBtn
        self.doneBtn.backgroundColor = UIColor.clear
        self.doneBtn.set(font: UIFont.pingFangSCFont(size: 18, weight: .medium), cornerRadius: 22)
        self.doneBtn.set(title: "确认", titleColor: UIColor.white, image: nil, bgImage: UIImage.imageWithColor(UIColor.init(hex: 0xD9DCE4)), for: .disabled)
        self.doneBtn.set(title: "确认", titleColor: UIColor.white, image: nil, bgImage: UIImage.imageWithColor(UIColor.clear), for: .normal)
        self.doneBtn.layer.insertSublayer(self.doneBtnLayer, below: nil)
        self.doneBtnLayer.colors = [AppColor.theme.cgColor, AppColor.theme.cgColor]
        self.doneBtnLayer.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth - self.lrMargin * 2.0, height: self.doneBtnH)
        self.doneBtnLayer.isHidden = true
    }
}

// MARK: - Data(数据处理与加载)
extension PayPwdSetController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        self.couldDoneProcess()
    }

    /// 判断当前操作按钮(确定、登录、下一步...)是否可用
    fileprivate func couldDone() -> Bool {
        let flag: Bool = self.pwdInputView.isFinish
        return flag
    }
    /// 操作按钮(确定、登录、下一步...)的可用性判断
    fileprivate func couldDoneProcess() -> Void {
        self.doneBtn.isEnabled = self.couldDone()
        self.doneBtnLayer.isHidden = !self.couldDone()
    }
}

// MARK: - Event(事件响应)
extension PayPwdSetController {

    @IBAction func doneBtnClick(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let password = self.pwdInputView.password else {
            return
        }
        self.payPwdRequest(type: self.type, password: password)
    }

}

// MARK: - Request
extension PayPwdSetController {
    /// 支付密码相关请求
    fileprivate func payPwdRequest(type: PayPwdSetType, password: String) -> Void {
        self.view.isUserInteractionEnabled = false
        let indicator = AppLoadingView.init()
        indicator.show()
        let completion: ((_ status: Bool, _ msg: String?) -> Void) = { [weak self](status, msg) in
            guard let `self` = self else {
                return
            }
            self.view.isUserInteractionEnabled = true
            indicator.dismiss()
            guard status else {
                Toast.showToast(title: msg)
                _ = self.pwdInputView.becomeFirstResponder()
                return
            }
            Toast.showToast(title: "设置成功")
            self.payPwdSetCompleted()
            if let userInfo = AccountManager.share.currentAccountInfo?.userInfo {
                userInfo.payPwdStatus = true
                AccountManager.share.updateCurrentAccount(userInfo: userInfo)
            }
        }
        switch type {
        case .initial(let smsCode):
            PasswordNetworkManager.updatePayPwd(code: smsCode, password: password, complete: completion)
        case .reset(let smsCode):
            PasswordNetworkManager.updatePayPwd(code: smsCode, password: password, complete: completion)
        }
    }

    /// 支付密码完成后的跳转逻辑
    fileprivate func payPwdSetCompleted() -> Void {
        if case PayPwdSetType.reset(smsCode: _) = self.type {
            NotificationCenter.default.post(name: Notification.Name.PayPwd.resetSuccess, object: nil, userInfo: nil)
        }
        // 1. 优先处理通过present方式弹出的
        if let _ = self.navigationController?.presentingViewController {
            self.navigationController?.dismiss(animated: false, completion: nil)
            return
        }
        // 2. 再次处理全程push出来的
        self.popProcess()
    }
    /// pop处理
    fileprivate func popProcess() -> Void {
        guard let childVCList = self.navigationController?.children else {
            return
        }

        // 2.1 判断经由PhoneVerityVC界面push过来的
        let firstIndex = childVCList.firstIndex { (childVC) -> Bool in
            if let _ = childVC as? PhoneVerityController {
                return true
            }
            return false
        }
        if let index = firstIndex {
            var popToVC: UIViewController = childVCList[0]
            if index - 1 >= 0 {
                popToVC = childVCList[index - 1]
            }
            self.navigationController?.popToViewController(popToVC, animated: true)
            return
        }

        // 2.2 判断指定界面push过来的
        for (_, childVC) in childVCList.enumerated() {
            // 集合：[AccountSecurityHomeController/MiningRechargeController/TransferInputController]
            if let childVC = childVC as? AccountSecurityHomeController {
                self.navigationController?.popToViewController(childVC, animated: true)
                break
            }
//            if let childVC = childVC as? MiningRechargeController {
//                self.navigationController?.popToViewController(childVC, animated: true)
//                break
//            }
//            if let childVC = childVC as? TransferInputController {
//                self.navigationController?.popToViewController(childVC, animated: true)
//                break
//            }
        }
    }

}

// MARK: - Notification
extension PayPwdSetController {

}

// MARK: - Extension Function
extension PayPwdSetController {

}

// MARK: - Delegate Function

// MARK: - <PasswordInputViewProtocol>
extension PayPwdSetController: PasswordInputViewProtocol {
    func pwdInputView(_ pwdInputView: PasswordInputView, didPasswordChanged password: String) {
        self.couldDoneProcess()
    }
}
