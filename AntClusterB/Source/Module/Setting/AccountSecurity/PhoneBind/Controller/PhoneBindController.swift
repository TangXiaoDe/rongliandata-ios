//
//  PhoneBindController.swift
//  iMeet
//
//  Created by 小唐 on 2019/5/29.
//  Copyright © 2019 iMeet. All rights reserved.
//
//  手机号绑定界面

import UIKit

/// 当前绑定手机号
typealias PhoneBindCurrentController = PhoneBindController
/// 手机号绑定界面
class PhoneBindController: BaseViewController {
    // MARK: - Internal Property

    // MARK: - Private Property

    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var updateBtn: UIButton!

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
extension PhoneBindController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

}

// MARK: - UI
extension PhoneBindController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.white
        // navbar
        self.navigationItem.title = "绑定手机号"
        // xib
        self.promptLabel.set(text: "当前绑定的手机号", font: UIFont.pingFangSCFont(size: 16), textColor: AppColor.minorText, alignment: .center)
        self.phoneLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 24), textColor: AppColor.mainText, alignment: .center)
        self.updateBtn.set(font: UIFont.pingFangSCFont(size: 18), cornerRadius: 5, borderWidth: 1, borderColor: AppColor.theme)
        self.updateBtn.set(title: "更改手机号", titleColor: AppColor.theme, image: nil, bgImage: UIImage.imageWithColor(UIColor.white), for: .normal)
        self.updateBtn.set(title: "更改手机号", titleColor: AppColor.theme, image: nil, bgImage: UIImage.imageWithColor(UIColor.white), for: .highlighted)
    }
}

// MARK: - Data(数据处理与加载)
extension PhoneBindController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        self.phoneLabel.text = AccountManager.share.currentAccountInfo?.userInfo?.phone
    }
}

// MARK: - Event(事件响应)
extension PhoneBindController {
    ///
    @IBAction func updateBtnClick(_ sender: UIButton) {
        let verifyVC = PhoneVerityController.init(type: .phoneBind)
        self.enterPageVC(verifyVC)
    }

}

// MARK: - Enter Page
extension PhoneBindController {

}

// MARK: - Notification
extension PhoneBindController {

}

// MARK: - Extension Function
extension PhoneBindController {

}

// MARK: - Delegate Function

// MARK: - <>
extension PhoneBindController {

}
