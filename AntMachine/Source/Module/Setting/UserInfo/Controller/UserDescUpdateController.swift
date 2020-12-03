//
//  UserDescUpdateController.swift
//  iMeet
//
//  Created by 小唐 on 2019/1/19.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  用户个性签名修改界面

import UIKit
import ChainOneKit

class UserDescUpdateController: BaseViewController {
    // MARK: - Internal Property

    let user: CurrentUserModel

    var updateSuccessAction: (() -> Void)?

    // MARK: - Private Property

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    fileprivate let limit: Int = 15

    // MARK: - Initialize Function

    init(user: CurrentUserModel) {
        self.user = user
        super.init(nibName: "UserDescUpdateController", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle Function
extension UserDescUpdateController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChangeNotificationProcess(_:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
}

// MARK: - UI
extension UserDescUpdateController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        // navigationbar
        self.navigationItem.title = "个性签名"
        let doneItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(rightBarItemClick))
        AppUtil.setupCommonNavTitleItem(doneItem)
        self.navigationItem.rightBarButtonItem = doneItem
        //
        self.textView.text = nil
        self.textView.delegate = self
        self.textView.textContainerInset = UIEdgeInsets.zero
    }
}

// MARK: - Data(数据处理与加载)
extension UserDescUpdateController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        self.textView.text = self.user.bio
        self.countLabel.text = "\(self.user.bio.count)" + "/\(self.limit)"
        self.couldDoneProcess()
    }

    /// 判断当前操作按钮(确定、登录、下一步...)是否可用
    fileprivate func couldDone() -> Bool {
        var flag: Bool = false
        guard let text = self.textView.text else {
            return flag
        }
        flag = (!text.isEmpty)
        return flag
    }
    /// 操作按钮(确定、登录、下一步...)的可用性判断
    fileprivate func couldDoneProcess() -> Void {
        self.placeholder.isHidden = self.couldDone()
        self.navigationItem.rightBarButtonItem?.isEnabled = self.couldDone()
    }
}

// MARK: - Event(事件响应)
extension UserDescUpdateController {
    @objc fileprivate func rightBarItemClick() -> Void {
        self.view.endEditing(true)
        guard let text = self.textView.text else {
            return
        }
        self.updateDescRequest(text)
    }
}

// MARK: - Notification
extension UserDescUpdateController {
    @objc fileprivate func textViewDidChangeNotificationProcess(_ notification: Notification) -> Void {
        // textView判断
        guard let textView = notification.object as? UITextView else {
            return
        }
        if textView != self.textView {
            return
        }
        // 输入内容处理
        let maxLen = self.limit
        if textView.text == nil || textView.text.isEmpty {

        } else {
            TextViewHelper.limitTextView(textView, withMaxLen: maxLen)
        }
        self.countLabel.text = "\(textView.text!.count)" + "/\(maxLen)"
        self.couldDoneProcess()
    }
}

// MARK: - Extension Function
extension UserDescUpdateController {
    fileprivate func updateDescRequest(_ desc: String) -> Void {
        let indicator = AppLoadingView.init(title: "请求中")
        indicator.show(on: self.view, timeInterval: nil)
        self.view.isUserInteractionEnabled = false
//        UserNetworkManager.updateCurrentUser(bio: desc) { [weak self](status, msg, model) in
//            guard let `self` = self else {
//                return
//            }
//            self.view.isUserInteractionEnabled = true
//            indicator.dismiss()
//            guard status, let model = model else {
//                Toast.showToast(title: msg)
//                return
//            }
//            Toast.showToast(title: "修改成功")
//            AccountManager.share.updateCurrentAccount(userInfo: model)
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
//                self.updateSuccessAction?()
//                self.navigationController?.popViewController(animated: true)
//            })
//        }
    }
}

// MARK: - Delegate Function

// MARK: - <UITextViewDelegate>
extension UserDescUpdateController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }

}
