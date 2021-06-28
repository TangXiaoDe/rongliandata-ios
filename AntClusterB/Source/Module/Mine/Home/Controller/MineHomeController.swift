//
//  MineHomeController.swift
//  JXProject
//
//  Created by 小唐 on 2020/4/28.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  我的主页

import UIKit
import Kingfisher
/// 我的主页
class MineHomeController: BaseViewController {

    // MARK: - Internal Property
    // MARK: - Private Property

    fileprivate let statusView: UIView = UIView()
    fileprivate let scrollView: UIScrollView = UIScrollView()
    fileprivate let incomeInfoView = MineHomeIncomeInfoView.init(viewWidth: kScreenWidth - 12.0 * 2.0)
    fileprivate let optionView = MineHomeOptionView()
    fileprivate let headerView: MineHomeHeaderView = MineHomeHeaderView()
    
    fileprivate let animaViewTopMargin: CGFloat = kStatusBarHeight + MineHomeHeaderView.iconTopMargin
    
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let verMargin: CGFloat = 12
    fileprivate let bottomMargin: CGFloat = 25
    
    fileprivate var userInfo: CurrentUserModel?
    //  1.收益钱包
    fileprivate var assetInfo: AssetInfoModel?

    // MARK: - Initialize Function

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}

// MARK: - Internal Function
extension MineHomeController {

}

// MARK: - LifeCircle Function
extension MineHomeController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
        NotificationCenter.default.addObserver(self, selector: #selector(unreadMessageNoticiationProcess(_:)), name: AppNotificationName.Message.unread, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.post(name: AppNotificationName.Message.refresh, object: nil)
        self.refreshReust()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - UI
extension MineHomeController {
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.white
        // 1. navigationbar
        self.navigationItem.title = "我的"
        // 3.statusView
        self.view.addSubview(self.statusView)
        self.statusView.backgroundColor = AppColor.theme
        self.statusView.alpha = 0
        self.statusView.isHidden = true
        self.statusView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(kStatusBarHeight)
        }
        // 2. scrollView
        self.view.addSubview(self.scrollView)
        self.initialScrollView(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(self.view.snp_bottomMargin)
        }
        // 顶部位置 的版本适配
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else if #available(iOS 9.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        // statusView
        self.view.bringSubviewToFront(self.statusView)
    }

    /// 滚动视图布局
    fileprivate func initialScrollView(_ scrollView: UIScrollView) -> Void {
        scrollView.showsVerticalScrollIndicator = false
//        scrollView.delegate = self
        self.scrollView.mj_header = XDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        // headerView
        scrollView.addSubview(self.headerView)
        self.headerView.delegate = self
        self.headerView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(MineHomeHeaderView.viewHeight)
        }
        // incomeInfoView
        scrollView.addSubview(self.incomeInfoView)
        self.incomeInfoView.delegate = self
        self.incomeInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(0)
            make.leading.equalToSuperview().offset(lrMargin)
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.height.equalTo(MineHomeIncomeInfoView.viewHeight)
        }
        // optionView
        scrollView.addSubview(self.optionView)
        self.optionView.delegate = self
        self.optionView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-0)
            //make.top.equalTo(self.incomeView.snp.bottom).offset(verMargin)
            make.top.equalTo(self.incomeInfoView.snp.bottom).offset(verMargin)
            make.bottom.equalToSuperview().offset(-bottomMargin)
        }
        // shield
//        self.incomeInfoView.isHidden = AppConfig.share.shield.currentNeedShield
//        if AppConfig.share.shield.currentNeedShield {
//            self.incomeInfoView.snp.remakeConstraints { (make) in
//                make.leading.equalToSuperview().offset(lrMargin)
//                make.trailing.equalToSuperview().offset(-lrMargin)
//                make.top.equalTo(self.headerView.snp.bottom).offset(-56)
//            }
//        }
    }
}

// MARK: - Data(数据处理与加载)
extension MineHomeController {
    // MARK: - Private  数据处理与加载
    fileprivate func initialDataSource() -> Void {
        self.calculatCache()
        self.scrollView.mj_header?.beginRefreshing()
    }
    
    fileprivate func refreshReust() -> Void {
        MineNetworkManager.refreshHomeData { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            self.scrollView.mj_header?.endRefreshing()
            guard status, let model = model else {
                Toast.showToast(title: msg)
                return
            }
            self.userInfo = model.user
            self.headerView.userModel = model.user
            self.incomeInfoView.models = model.filModel
        }
    }

}

// MARK: - Event(事件响应)
extension MineHomeController {
    /// 广告点击响应
    @objc fileprivate func bannerBtnClick(_ button: UIButton) -> Void {
//        self.enterInviteFriendPage()
    }
    
    @objc fileprivate func headerRefresh() -> Void {
        self.refreshReust()
    }
    
}

// MARK: - Notification
extension MineHomeController {
    /// 未读消息通知处理
    @objc fileprivate func unreadMessageNoticiationProcess(_ notification: Notification) -> Void {
        guard let model = notification.object as? MessageUnreadModel else {
            return
        }
        self.headerView.unReadNum = model.count
    }
}

// MARK: - Delegate Function

// MARK: - <UIScrollViewDelegate>
//extension MineHomeController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset
//        let orderY: CGFloat = MineHomeHeaderView.viewHeight - MineHomeIncomeInfoView.viewHeight - kStatusBarHeight
//        if offset.y <= orderY {
//            self.statusView.alpha = (orderY - abs(offset.y - orderY)) / orderY
//        } else if offset.y > orderY {
//            self.statusView.alpha = 1
//        } else if offset.y < 0 {
//            self.statusView.alpha = 1
//        }
//    }
//}

// MARK: extension
extension MineHomeController {
    /// 退出登录处理
    fileprivate func logout() -> Void {
        CacheManager.instance.clearWebCookieAndCache()
        AccountManager.share.logoutProcess()
        JPushHelper.instance.deleteAlias()
        RootManager.share.type = .login
    }
    /// 退出登录弹窗
    fileprivate func showLogoutAlert() -> Void {
        let alertVC = UIAlertController.init(title: nil, message: "退出登录?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            self.logout()
        }))
        DispatchQueue.main.async {
            // 若遇到此处问题，请记录机型、系统、问题描述，可尝试使用RootManager.share下的 .rootVC .showRootVC；
            self.present(alertVC, animated: false, completion: nil)
        }
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
            self.optionView.cacheSize = cacheSize
        }
    }
    fileprivate func calculatCache() -> Void {
        // 计算缓存大小
        CacheManager.instance.getCacheSize { (cacheSize) in
            self.optionView.cacheSize = cacheSize
        }
    }
}

// MARK: - <MineHomeOptionViewProtocol>
extension MineHomeController: MineHomeOptionViewProtocol {
    /// 账户安全
    func optionView(_ optionView: MineHomeOptionView, didSelectedAccount itemView: MineHomeOptionItemControl) -> Void {
        self.enterAccountSecurityPage()
    }
    /// 个人资料
    func optionView(_ optionView: MineHomeOptionView, didSelectedUserInfo itemView: MineHomeOptionItemControl) -> Void {
        self.enterUserInfoPage()
    }
    /// 清除缓存
    func optionView(_ optionView: MineHomeOptionView, didSelectedClearCache itemView: MineHomeOptionItemControl) -> Void {
        self.showClearCacheAlert()
    }
    /// 退出登录
    func optionView(_ optionView: MineHomeOptionView, didSelectedLogout itemView: MineHomeOptionItemControl) -> Void {
        self.showLogoutAlert()
    }
}


// MARK: - <MineHomeHeaderViewProtocol>
extension MineHomeController: MineHomeHeaderViewProtocol {
    func didClickedUserInfo(in headerView: MineHomeHeaderView, didClickVipImageView imageView: UIImageView) {
        if !AppConfig.share.shield.currentNeedShield {

        }
    }
    /// 通知点击回调
    func headerView(_ headerView: MineHomeHeaderView, didClickedNotice noticeBtn: UIButton) -> Void {
        self.enterMessagePage()
    }
    /// 用户点击回调
    func didClickedUserInfo(in headerView: MineHomeHeaderView) -> Void {
        self.enterUserInfoPage()
    }
}
// MARK: - <MineHomeIncomeInfoViewProtocol>
extension MineHomeController: MineHomeIncomeInfoViewProtocol {
    /// fil点击
    func incomeInfoView(_ view: MineHomeIncomeInfoView, didTapPageAt index: Int) {
        if index == 0 {
            self.enterFilHomePage()
        } else if index == 1 {
            self.enterAssetPage()
        } else if index == 2 {
            self.enterAssetPage()
        }
    }
}
// MARK: - EnterPage
extension MineHomeController {
    /// 未读消息
    fileprivate func enterMessagePage() -> Void {
        let messageVC = MessageHomeController()
        self.navigationController?.pushViewController(messageVC, animated: true)
    }

    /// 我的Fil钱包
    fileprivate func enterFilHomePage() -> Void {
        let filVC = WalletHomeController()
        self.navigationController?.pushViewController(filVC, animated: true)
    }
    /// 我的资产
    fileprivate func enterAssetPage() -> Void {
        let assetVC = AssetHomeController(currency: "xch")
        self.navigationController?.pushViewController(assetVC, animated: true)
    }
    /// 设置
    fileprivate func enterSettingPage() -> Void {
        let setVC = SettingHomeController()
        self.navigationController?.pushViewController(setVC, animated: true)
    }
    /// 进入个人资料界面
    fileprivate func enterUserInfoPage() -> Void {
        self.enterPageVC(CurrentUserInfoController())
    }
    /// 账户安全
    fileprivate func enterAccountSecurityPage(){
        self.enterPageVC(AccountSecurityHomeController())
    }
}
