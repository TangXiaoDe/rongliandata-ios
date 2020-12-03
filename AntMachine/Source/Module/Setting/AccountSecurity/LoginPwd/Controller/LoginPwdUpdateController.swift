//
//  LoginPwdUpdateController.swift
//  iMeet
//
//  Created by 小唐 on 2019/1/17.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  登录密码修改界面——使用原密码
//  注：登录密码修改之后会重置token为nil，因此需要跳转到登录页

import UIKit

class LoginPwdUpdateController: BaseViewController {
    // MARK: - Internal Property

    // MARK: - Private Property


    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var oldPwdField: UITextField!
    @IBOutlet weak var newPwdField: UITextField!
    @IBOutlet weak var confirmPwdField: UITextField!
    @IBOutlet weak var doneBtn: GradientLayerButton!

    @IBOutlet weak var forgetBtn: UIButton!
    @IBOutlet weak var oldPwdView: UIView!
    @IBOutlet weak var newPwdView: UIView!
    @IBOutlet weak var confirmPwdView: UIView!

    fileprivate let lrMargin: CGFloat = 12
    fileprivate let doneBtnH: CGFloat = 44

    // MARK: - Initialize Function

    init() {
        super.init(nibName: "LoginPwdUpdateController", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle Function
extension LoginPwdUpdateController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - UI
extension LoginPwdUpdateController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.minor
        // navigationbar
        self.navigationItem.title = "登录密码"
        // xib
        self.forgetBtn.setTitleColor(AppColor.theme, for: .normal)
        self.oldPwdView.backgroundColor = UIColor.clear
        self.newPwdView.backgroundColor = UIColor.clear
        self.confirmPwdView.backgroundColor = UIColor.clear
        self.oldPwdView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 1, margin1: 0, margin2: 0)
        self.newPwdView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 1, margin1: 0, margin2: 0)
        self.confirmPwdView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 1, margin1: 0, margin2: 0)
        // oldPwdField
        let oldPwdSecureBtn: UIButton = UIButton.init(type: .custom)
        oldPwdSecureBtn.bounds = CGRect.init(x: 0, y: 0, width: 22, height: 22)
        oldPwdSecureBtn.setImage(UIImage(named: "IMG_login_pwdshow"), for: .normal)
        oldPwdSecureBtn.setImage(UIImage(named: "IMG_login_pwdhidden"), for: .selected)
        oldPwdSecureBtn.addTarget(self, action: #selector(oldPwdSecureBtnClick(_:)), for: .touchUpInside)
        oldPwdSecureBtn.isSelected = true
        self.oldPwdField.rightView = oldPwdSecureBtn
        self.oldPwdField.rightViewMode = .always
        self.oldPwdField.isSecureTextEntry = true
        self.oldPwdField.set(placeHolder: nil, font: UIFont.pingFangSCFont(size: 18), textColor: AppColor.mainText)
        self.oldPwdField.attributedPlaceholder = NSAttributedString.init(string: "请输入旧密码", attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        self.oldPwdField.addTarget(self, action: #selector(oldPwdFieldValueChanged(_:)), for: .editingChanged)
        // newPwdField
        let newPwdSecureBtn: UIButton = UIButton.init(type: .custom)
        newPwdSecureBtn.bounds = CGRect.init(x: 0, y: 0, width: 22, height: 22)
        newPwdSecureBtn.setImage(UIImage(named: "IMG_login_pwdshow"), for: .normal)
        newPwdSecureBtn.setImage(UIImage(named: "IMG_login_pwdhidden"), for: .selected)
        newPwdSecureBtn.addTarget(self, action: #selector(newPwdSecureBtnClick(_:)), for: .touchUpInside)
        newPwdSecureBtn.isSelected = true
        self.newPwdField.rightView = newPwdSecureBtn
        self.newPwdField.rightViewMode = .always
        self.newPwdField.isSecureTextEntry = true
        self.newPwdField.set(placeHolder: nil, font: UIFont.pingFangSCFont(size: 18), textColor: AppColor.mainText)
        self.newPwdField.attributedPlaceholder = NSAttributedString.init(string: "请输入新密码", attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        self.newPwdField.addTarget(self, action: #selector(newPwdFieldValueChanged(_:)), for: .editingChanged)
        // confirmField
        let confirmPwdSecureBtn: UIButton = UIButton.init(type: .custom)
        confirmPwdSecureBtn.bounds = CGRect.init(x: 0, y: 0, width: 22, height: 22)
        confirmPwdSecureBtn.setImage(UIImage(named: "IMG_login_pwdshow"), for: .normal)
        confirmPwdSecureBtn.setImage(UIImage(named: "IMG_login_pwdhidden"), for: .selected)
        confirmPwdSecureBtn.addTarget(self, action: #selector(confirmPwdSecureBtnClick(_:)), for: .touchUpInside)
        confirmPwdSecureBtn.isSelected = true
        self.confirmPwdField.rightView = confirmPwdSecureBtn
        self.confirmPwdField.rightViewMode = .always
        self.confirmPwdField.isSecureTextEntry = true
        self.confirmPwdField.set(placeHolder: nil, font: UIFont.pingFangSCFont(size: 18), textColor: AppColor.mainText)
        self.confirmPwdField.attributedPlaceholder = NSAttributedString.init(string: "请再次输入新密码", attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        self.confirmPwdField.addTarget(self, action: #selector(confirmPwdFieldValueChanged(_:)), for: .editingChanged)

        // doneBtn
        self.doneBtn.backgroundColor = UIColor.clear
        self.doneBtn.set(font: UIFont.pingFangSCFont(size: 18), cornerRadius: 5)
        self.doneBtn.set(title: "确认修改", titleColor: AppColor.mainText, image: nil, bgImage: UIImage.imageWithColor(AppColor.theme), for: .normal)
        self.doneBtn.set(title: "确认修改", titleColor: AppColor.mainText, image: nil, bgImage: UIImage.imageWithColor(AppColor.theme), for: .highlighted)
        self.doneBtn.set(title: "确认修改", titleColor: UIColor.white, image: nil, bgImage: UIImage.imageWithColor(UIColor.init(hex: 0xD9DCE4)), for: .disabled)
    }
}

// MARK: - Data(数据处理与加载)
extension LoginPwdUpdateController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        self.couldDoneProcess()
    }

    /// 判断当前操作按钮(确定、登录、下一步...)是否可用
    fileprivate func couldDone() -> Bool {
        var flag: Bool = false
        guard let oldPwd = self.oldPwdField.text, let newPwd = self.newPwdField.text, let confirmPwd = self.confirmPwdField.text else {
            return flag
        }
        flag = (!oldPwd.isEmpty && !newPwd.isEmpty && !confirmPwd.isEmpty)
        return flag
    }
    /// 操作按钮(确定、登录、下一步...)的可用性判断
    fileprivate func couldDoneProcess() -> Void {
        self.doneBtn.isEnabled = self.couldDone()
        self.doneBtn.gradientLayer.isHidden = !self.couldDone()
    }
}

// MARK: - Event(事件响应)
extension LoginPwdUpdateController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    @objc fileprivate func oldPwdSecureBtnClick(_ button: UIButton) -> Void {
        button.isSelected = !button.isSelected
        self.oldPwdField.isSecureTextEntry = button.isSelected
    }
    @objc fileprivate func newPwdSecureBtnClick(_ button: UIButton) -> Void {
        button.isSelected = !button.isSelected
        self.newPwdField.isSecureTextEntry = button.isSelected
    }
    @objc fileprivate func confirmPwdSecureBtnClick(_ button: UIButton) -> Void {
        button.isSelected = !button.isSelected
        self.confirmPwdField.isSecureTextEntry = button.isSelected
    }

    @objc fileprivate func oldPwdFieldValueChanged(_ textField: UITextField) -> Void {
        self.couldDoneProcess()
    }
    @objc fileprivate func newPwdFieldValueChanged(_ textField: UITextField) -> Void {
        self.couldDoneProcess()
    }
    @objc fileprivate func confirmPwdFieldValueChanged(_ textField: UITextField) -> Void {
        self.couldDoneProcess()
    }

    @IBAction func doneBtnClick(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let oldPwd = self.oldPwdField.text, let newPwd = self.newPwdField.text, let confirmPwd = self.confirmPwdField.text else {
            return
        }
        if newPwd != confirmPwd {
            Toast.showToast(title: "两次密码不一致")
            return
        }
        self.loginPwdUpdatRequest(oldPwd: oldPwd, newPwd: newPwd, confirmPwd: confirmPwd)
    }

    @IBAction func forgetBtnClick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.enterForgetPwdPage()
    }

}

// MARK: - EnterPage
extension LoginPwdUpdateController {
    fileprivate func enterForgetPwdPage() -> Void {
        let resetVC = LoginPwdForgetController.init(scene: LoginPwdForgetScene.setting)
        self.enterPageVC(resetVC)
    }

}

// MARK: - Notification
extension LoginPwdUpdateController {

}

// MARK: - Extension Function
extension LoginPwdUpdateController {
    /// 登录密码更新请求
    fileprivate func loginPwdUpdatRequest(oldPwd: String, newPwd: String, confirmPwd: String) -> Void {
        self.view.isUserInteractionEnabled = false
        let indicator = AppLoadingView.init()
        indicator.show()
        PasswordNetworkManager.updateLoginPwd(oldPwd: oldPwd, newPwd: newPwd, confirmPwd: confirmPwd) { [weak self](status, msg) in
            guard let `self` = self else {
                return
            }
            self.view.isUserInteractionEnabled = true
            indicator.dismiss()
            guard status else {
                Toast.showToast(title: msg)
                return
            }
            // 密码修改成功 重置token 跳转到登录页
            AppUtil.logoutProcess(isAuthValid: false)
            // 注：这里不能将2个提示放到status的判断前面，否则修改成功没有提示展示，可能跟根控切换有关.
            Toast.showToast(title: msg)
        }
    }
    
}

// MARK: - Delegate Function

// MARK: - <>
extension LoginPwdUpdateController {

}
