//
//  UserNameUpdateController.swift
//  iMeet
//
//  Created by 小唐 on 2019/1/19.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  用户名称修改界面

import UIKit
import ChainOneKit

class UserNameUpdateController: BaseViewController {
    // MARK: - Internal Property

    let user: CurrentUserModel

    /// 回调处理
    var updateSuccessAction: (() -> Void)?

    // MARK: - Private Property

    @IBOutlet weak var nameField: UITextField!

    fileprivate let maxLen: Int = 10

    // MARK: - Initialize Function

    init(user: CurrentUserModel) {
        self.user = user
        super.init(nibName: "UserNameUpdateController", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle Function
extension UserNameUpdateController {
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
extension UserNameUpdateController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.pageBg
        // navigationbar
        self.navigationItem.title = "修改昵称"
        let doneItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(rightBarItemClick))
        AppUtil.setupCommonNavTitleItem(doneItem, font: UIFont.pingFangSCFont(size: 15), normalColor: AppColor.subMainText, disableColor: AppColor.minorText)
        self.navigationItem.rightBarButtonItem = doneItem
        // nameField
        self.nameField.set(placeHolder: nil, font: UIFont.pingFangSCFont(size: 15), textColor: AppColor.subMainText)
        self.nameField.attributedPlaceholder = NSAttributedString.init(string: "请输入昵称", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xBBBBBB)])
        self.nameField.addTarget(self, action: #selector(nameFieldValueChanged(_:)), for: .editingChanged)
    }
}

// MARK: - Data(数据处理与加载)
extension UserNameUpdateController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        self.nameField.text = self.user.name
        self.couldDoneProcess()
    }

    /// 判断当前操作按钮(确定、登录、下一步...)是否可用
    fileprivate func couldDone() -> Bool {
        var flag: Bool = false
        guard let name = self.nameField.text else {
            return flag
        }
        flag = (!name.isEmpty)
        return flag
    }
    /// 操作按钮(确定、登录、下一步...)的可用性判断
    fileprivate func couldDoneProcess() -> Void {
        self.navigationItem.rightBarButtonItem?.isEnabled = self.couldDone()
    }
}

// MARK: - Event(事件响应)
extension UserNameUpdateController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    @objc fileprivate func rightBarItemClick() -> Void {
        self.view.endEditing(true)
        guard let name = self.nameField.text else {
            return
        }
        self.updateNameRequest(name)
    }

    /// 名称输入框内容变更
    @objc fileprivate func nameFieldValueChanged(_ textField: UITextField) -> Void {
        TextFieldHelper.limitTextField(textField, withMaxLen: self.maxLen)
        self.couldDoneProcess()
    }
}

// MARK: - Notification
extension UserNameUpdateController {

}

// MARK: - Extension Function
extension UserNameUpdateController {
    fileprivate func updateNameRequest(_ name: String) -> Void {
        self.view.isUserInteractionEnabled = false
        let indicator = AppLoadingView.init()
        indicator.show()
        UserNetworkManager.updateCurrentUser(name: name) { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            indicator.dismiss()
            self.view.isUserInteractionEnabled = true
            guard status, let model = model else {
                Toast.showToast(title: msg)
                return
            }
            Toast.showToast(title: "修改成功")
            AccountManager.share.updateCurrentAccount(userInfo: model)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self.updateSuccessAction?()
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
}

// MARK: - Delegate Function

// MARK: - <>
extension UserNameUpdateController {

}
