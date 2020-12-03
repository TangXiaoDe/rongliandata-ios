//
//  SettingHomeController.swift
//  iMeet
//
//  Created by 小唐 on 2019/5/29.
//  Copyright © 2019 iMeet. All rights reserved.
//
//  设置主页

import UIKit
import Kingfisher

/// 设置主页控制器
class SettingHomeController: BaseTableViewController {

    // MARK: - Internal Property
    // MARK: - Private Property

    fileprivate var sourceList: [SettingSectionModel] = []
    fileprivate let realNameModel = SettingItemModel.init(type: .rightDetailAccessory, title: "")
    fileprivate let cacheModel = SettingItemModel.init(type: .rightDetailAccessory, title: "")
    // MARK: - Initialize Function

}

// MARK: - Internal Function

// MARK: - LifeCircle Function
extension SettingHomeController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userCertStatusRequest()
    }
}

// MARK: - UI
extension SettingHomeController {
    override func initialUI() -> Void {
        super.initialUI()
        // 1. navigationbar
        self.navigationItem.title = "设置"
        self.view.backgroundColor = AppColor.pageBg
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
extension SettingHomeController {
    // MARK: - Private  数据处理与加载
    override func initialDataSource() -> Void {
        var realNameDetail: String = "未认证"
        if let userInfo = AccountManager.share.currentAccountInfo?.userInfo {
            realNameDetail = userInfo.certStatus.title
        }
        self.realNameModel.title = "实名认证"
        self.realNameModel.detail = realNameDetail
        self.cacheModel.title = "清除缓存"
        let userInfoItem = SettingItemModel.init(type: .rightAccessory, title: "个人资料")
        let loginPwdItem = SettingItemModel.init(type: .rightAccessory, title: "登录密码")
        let payPwdItem = SettingItemModel.init(type: .rightAccessory, title: "支付密码")
        let feedbackItem = SettingItemModel.init(type: .rightAccessory, title: "意见反馈")
        let logoutItem = SettingItemModel.init(type: .centerTitle, title: "退出登录")
        
        let normalSection1Items: [SettingItemModel] = [userInfoItem, loginPwdItem, payPwdItem, self.realNameModel, feedbackItem, self.cacheModel]
        let shieldSection1Items: [SettingItemModel] = [userInfoItem, loginPwdItem, self.realNameModel, feedbackItem, self.cacheModel]
        let section1Items: [SettingItemModel] = AppConfig.share.shield.currentNeedShield ? shieldSection1Items : normalSection1Items
        let section1 = SettingSectionModel.init(title: nil, items: section1Items)
        let section2 = SettingSectionModel.init(title: nil, items: [logoutItem])
        CacheManager.instance.getCacheSize { (cacheSize) in
            let strCache = String(format: "%d.0 M", cacheSize / (1024 * 1024) )
            self.cacheModel.detail = strCache
            self.tableView.reloadData()
        }
        self.sourceList = [section1, section2]
        self.tableView.reloadData()
    }

    /// 认证状态请求
    fileprivate func userCertStatusRequest() -> Void {
//        CertificationNetworkManager.getRealNameCertDetail { [weak self](status, msg, model) in
//            guard let `self` = self else {
//                return
//            }
//            // model.status有默认值，可能导致判断失效
//            guard status, let model = model, let _ = model.statusValue else {
//                return
//            }
//            if let userInfo = AccountManager.share.currentAccountInfo?.userInfo {
//                userInfo.certStatusValue = model.userCertStatus.rawValue
//                AccountManager.share.updateCurrentAccount(userInfo: userInfo)
//            }
//            self.realNameModel.detail = model.userCertStatus.title
//            self.tableView.reloadData()
//        }
    }

}

// MARK: - Event(事件响应)
extension SettingHomeController {

}

// MARK: -
extension SettingHomeController {

}
// MARK: - Extension
extension SettingHomeController {

    /// 退出登录弹窗
    fileprivate func showLogoutAlert() -> Void {
        let alertVC = UIAlertController.init(title: nil, message: "退出登录?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            self.logout()
        }))
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    /// 退出登录处理
    fileprivate func logout() -> Void {
        CacheManager.instance.clearWebCookieAndCache()
        AccountManager.share.logoutProcess()
        JPushHelper.instance.deleteAlias()
        RootManager.share.switchRoot(.login)
    }

}

// MARK: - EnterPage
extension SettingHomeController {
    /// 进入个人资料界面
    fileprivate func enterUserInfoPage() -> Void {
        self.enterPageVC(CurrentUserInfoController())
    }
    /// 实名认证
    fileprivate func enterRealNamePage() -> Void {
//        self.enterPageVC(RealNameCertController())
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
    /// 进入意见反馈
    fileprivate func enterFeedbackPage() -> Void {
//        self.enterPageVC(FeedbackController())
    }
    /// 缓存清理
    fileprivate func showClearCacheAlert() -> Void {
        let alertVC = UIAlertController.init(title: nil, message: "是否清理缓存?", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction.init(title: "确定", style: .destructive, handler: { (action) in
            self.clearCache()
        }))
        alertVC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    fileprivate func clearCache() -> Void {
        // Kingfisher 缓存
        KingfisherManager.shared.cache.clearDiskCache()
        // 自定义缓存文件 清除

        // 重新计算缓存大小
        CacheManager.instance.getCacheSize { (cacheSize) in
            let strCache = String(format: "%d.0M", cacheSize / (1024 * 1024) )
            self.cacheModel.detail = strCache
            self.tableView.reloadData()
        }
    }

}
extension SettingHomeController {
    /// cell选择
    fileprivate func cellSelectWithTitle(_ title: String) -> Void {
        switch title {
        case "个人资料":
            self.enterUserInfoPage()
        case "登录密码":
            self.enterLoginPwdPage()
        case "支付密码":
            self.enterPayPwdPage()
        case "实名认证":
            self.enterRealNamePage()
        case "意见反馈":
            self.enterFeedbackPage()
        case "清除缓存":
            self.showClearCacheAlert()
        case "退出登录":
            break
        default:
            break
        }
    }

}


// MARK: - Notification
extension SettingHomeController {
    
}

// MARK: - Delegate Function

// MARK: - <UITableViewDataSource>
extension SettingHomeController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sourceList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceList[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionModel = self.sourceList[indexPath.section]
        let model = self.sourceList[indexPath.section].items[indexPath.row]
        if 1 == indexPath.section {
            let cell = SettingHomeBtnCell.cellInTableView(tableView)
            cell.model = model
            cell.selectionStyle = .none
            cell.showBottomLine = false
            cell.delegate = self
            return cell
        } else {
            let cell = SettingItemCell.cellInTableView(tableView, at: indexPath)
            cell.model = model
            cell.showBottomLine = true
//            if model.title == "实名认证" {
//                cell.detailLabel.textColor = AccountManager.share.currentAccountInfo?.userInfo?.certStatus.color
//            }
           return cell
       }
    }
}

// MARK: - <UITableViewDelegate>
extension SettingHomeController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableViewAutomaticDimension
        return SettingItemCell.cellHeight
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.sourceList[indexPath.section].items[indexPath.row]
        self.cellSelectWithTitle(model.title)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerHeight: CGFloat = 80.0 // 退出登录顶部间距
        if 0 == section {
            headerHeight = 0.01
        }
        return headerHeight
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SettingSectionHeader.headerInTableView(tableView)
        header.title = self.sourceList[section].title
        return header
    }

}

// MARK: - <SettingHomeBtnCellProtocol>
extension SettingHomeController: SettingHomeBtnCellProtocol {
    func btnCell(_ cell: SettingHomeBtnCell, didClickedBtn btn: UIButton) {
        self.showLogoutAlert()
    }
}
