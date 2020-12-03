//
//  AccountSecurityController.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/9.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  账号安全主页

import UIKit

typealias AccountSecurityHomeController = AccountSecurityController
/// 账号安全主页
class AccountSecurityController: BaseTableViewController {

    // MARK: - Internal Property

    // MARK: - Private Property

    fileprivate var sourceList: [SettingSectionModel] = []
    fileprivate var imeetAccountModel: SettingItemModel = SettingItemModel.init(type: .rightDetail, title: "链聊账号")
    fileprivate var bindPhoneModel: SettingItemModel = SettingItemModel.init(type: .rightDetailAccessory, title: "绑定手机号")
    fileprivate let loginPwdModel: SettingItemModel = SettingItemModel.init(type: .rightAccessory, title: "登录密码")
    fileprivate let payPwdModel: SettingItemModel = SettingItemModel.init(type: .rightAccessory, title: "支付密码")
    //  TODO: - 绑定与授权待接口后台更新
    fileprivate let authSection: SettingSectionModel = SettingSectionModel.init(title: "绑定与授权", items: [])


    // MARK: - Initialize Function

}

// MARK: - Internal Function

// MARK: - LifeCircle Function
extension AccountSecurityController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UI
extension AccountSecurityController {
    override func initialUI() -> Void {
        super.initialUI()
        // 1. navigationbar
        self.navigationItem.title = "账号与安全"
        // 2. tableView
        // 顶部位置 的版本适配
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else if #available(iOS 9.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
}

// MARK: - Data(数据处理与加载)
extension AccountSecurityController {
    // MARK: - Private  数据处理与加载
    override func initialDataSource() -> Void {
        self.imeetAccountModel.detail = AccountManager.share.currentAccountInfo?.userInfo?.number
        self.bindPhoneModel.detail = AccountManager.share.currentAccountInfo?.userInfo?.phone
        // 构造数据
        let section1 = SettingSectionModel.init(title: nil, items: [self.imeetAccountModel, self.bindPhoneModel])
        let section2 = SettingSectionModel.init(title: nil, items: [self.loginPwdModel])
        if !AppConfig.share.shield.currentNeedShield {
            section2.items.append(self.payPwdModel)
        }
        self.sourceList = [section1, section2]
        self.tableView.reloadData()
    }

}

// MARK: - Event(事件响应)
extension AccountSecurityController {
    /// cell点击响应处理
    fileprivate func cellSelectWithTitle(_ title: String) -> Void {
        switch title {
        case "绑定手机号":
            self.enterBindPhonePage()
        case "登录密码":
            self.enterLoginPwdPage()
        case "支付密码":
            self.enterPayPwdPage()
        default:
            break
        }
    }

}

// MARK; - Request(网络请求)
extension AccountSecurityController {


}

// MARK: - Enter Page
extension AccountSecurityController {
    /// 手机号绑定界面
    fileprivate func enterBindPhonePage() -> Void {
        let bindVC = PhoneBindController()
        self.enterPageVC(bindVC)
    }
    /// 登录密码设置界面
    fileprivate func enterLoginPwdPage() -> Void {
        let loginPwdUpdateVC = LoginPwdUpdateController()
        self.enterPageVC(loginPwdUpdateVC)
    }
    /// 支付密码设置界面
    fileprivate func enterPayPwdPage() -> Void {
        guard let user = AccountManager.share.currentAccountInfo?.userInfo else {
            return
        }
        // 未初始化支付密码，则初始化支付密码——验证码验证
        if !user.payPwdStatus {
            let verifyVC = PhoneVerityController.init(type: .payPwdInitial)
            self.enterPageVC(verifyVC)
        } else {
            let verifyVC = PhoneVerityController.init(type: .payPwdReset)
            self.enterPageVC(verifyVC)
        }
    }

}

// MARK: - Notification
extension AccountSecurityController {

}

// MARK: - Extension
extension AccountSecurityController {

}

// MARK: - Delegate Function

// MARK: - <UITableViewDataSource>
extension AccountSecurityController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sourceList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceList[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.sourceList[indexPath.section].items[indexPath.row]
        let cell = SettingItemCell.cellInTableView(tableView, at: indexPath)
        cell.model = model
        cell.showBottomLine = (self.sourceList[indexPath.section].items.count - 1 != indexPath.row)
        switch model.title {
        case "链聊账号":
            cell.detailLabel.font = UIFont.pingFangSCFont(size: 18)
            cell.detailLabel.textColor = AppColor.mainText
            cell.detailLabel.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().offset(-26)
            }
        case "绑定手机号":
            cell.detailLabel.font = UIFont.pingFangSCFont(size: 18)
            cell.detailLabel.textColor = AppColor.mainText
        default:
            break
        }
        return cell
    }

}

// MARK: - <UITableViewDelegate>
extension AccountSecurityController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableView.automaticDimension
        return SettingItemCell.cellHeight
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.sourceList[indexPath.section].items[indexPath.row]
        self.cellSelectWithTitle(model.title)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SettingSectionHeader.separateHeight
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SettingSectionHeader.headerInTableView(tableView)
        return header
    }

}
