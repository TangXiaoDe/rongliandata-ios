//
//  FirstPageHomeController.swift
//  HZProject
//
//  Created by 小唐 on 2020/11/13.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  首页

import UIKit
import ChainOneKit


typealias FirstPageHomeController = FirstPageController
class FirstPageController: BaseViewController
{
    // MARK: - Internal Property
    
    // MARK: - Private Property
    
    fileprivate let topBgView: UIImageView = UIImageView.init()
    fileprivate let navBar: MallHomeStatusNavBar = MallHomeStatusNavBar.init()
    
    fileprivate let scrollView: UIScrollView = UIScrollView.init()

    fileprivate let headerView: FPHomeHeaderView = FPHomeHeaderView.init()          // 头部视图：banner、消息、ipfs数据
    fileprivate let orePoolView: FPHomeOrePoolView = FPHomeOrePoolView.init()         // 区块数据
    fileprivate let footerView: UIView = UIView.init()

    fileprivate let barHeight: CGFloat = MallHomeStatusNavBar.barHeight
    fileprivate let topBgHeight: CGFloat = CGSize.init(width: 375, height: 178).scaleAspectForWidth(kScreenWidth).height
    

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
extension FirstPageController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
        NotificationCenter.default.addObserver(self, selector: #selector(unreadMessageNoticiationProcess(_:)), name: AppNotificationName.Message.unread, object: nil)
    }
    
    /// 控制器的view将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

// MARK: - UI
extension FirstPageController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.white
        // navBar
        self.view.addSubview(self.navBar)
        self.navBar.showBottomLine = false
        self.navBar.delegate = self
        self.navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.barHeight)
        }
        // topBgView
        self.view.addSubview(self.topBgView)
        self.topBgView.image = UIImage.init(named: "IMG_home_img_topbg")
        self.topBgView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.topBgHeight)
        }
        // scrollView
        self.view.addSubview(self.scrollView)
        self.initialScrollView(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            //make.edges.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.navBar.snp.bottom)
        }
        // 顶部位置 的版本适配
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else if #available(iOS 9.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        //
        self.view.bringSubviewToFront(self.navBar)
    }
    ///
    fileprivate func initialScrollView(_ scrollView: UIScrollView) -> Void {
        //scrollView.backgroundColor = AppColor.pageBg
        scrollView.showsVerticalScrollIndicator = false
        scrollView.mj_header = XDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        // 1. headerView
        scrollView.addSubview(self.headerView)
        self.headerView.delegate = self
        self.headerView.snp.makeConstraints { (make) in
            make.leading.trailing.top.width.equalToSuperview()
        }
        // 2. orePoolView
        scrollView.addSubview(self.orePoolView)
        self.orePoolView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom).offset(10)
        }
        // 4. footerView
        scrollView.addSubview(self.footerView)
        self.initialFooterView(self.footerView)
        self.footerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.orePoolView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    ///
    fileprivate func initialFooterView(_ footerView: UIView) -> Void {
        //
        let footerIconSize: CGSize = CGSize.init(width: 315, height: 15)
        let iconView: UIImageView = UIImageView.init()
        footerView.addSubview(iconView)
        iconView.image = UIImage.init(named: "IMG_common_icon_dibu")
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(footerIconSize)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
//        let lineTitleHorMargin: CGFloat = 10
//        let lineLrMargin: CGFloat = 32
//        // 1. titleLabel
//        let titleLabel: UILabel = UILabel.init()
//        footerView.addSubview(titleLabel)
//        titleLabel.set(text: "已经到底啦", font: UIFont.pingFangSCFont(size: 12), textColor: UIColor.init(hex: 0xC7CED8), alignment: .center)
//        titleLabel.snp.makeConstraints { (make) in
//            make.centerY.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(10)
//            make.bottom.equalToSuperview().offset(-10)
//        }
//        // 2. leftLine
//        let leftLine: UIView = UIView.init()
//        footerView.addSubview(leftLine)
//        leftLine.backgroundColor = UIColor.init(hex: 0xC7CED8)
//        leftLine.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.height.equalTo(0.5)
//            make.leading.equalToSuperview().offset(lineLrMargin)
//            make.trailing.equalTo(titleLabel.snp.leading).offset(-lineTitleHorMargin)
//        }
//        // 3. rightLine
//        let rightLine: UIView = UIView.init()
//        footerView.addSubview(rightLine)
//        rightLine.backgroundColor = UIColor.init(hex: 0xC7CED8)
//        rightLine.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.height.equalTo(0.5)
//            make.leading.leading.equalTo(titleLabel.snp.trailing).offset(lineTitleHorMargin)
//            make.trailing.equalToSuperview().offset(-lineLrMargin)
//        }
    }

}

// MARK: - Data(数据处理与加载)
extension FirstPageController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        //self.setupAsDemo()
        self.scrollView.mj_header?.beginRefreshing()
    }
    ///
    fileprivate func setupAsDemo() -> Void {
        self.headerView.model = nil
        self.orePoolView.model = nil
    }

}
// MARK: - Request
extension FirstPageController {
    /// 刷新请求
    fileprivate func refreshRequest() -> Void {
        FirstPageNetworkManager.getHomeTotalData { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            self.scrollView.mj_header?.endRefreshing()
            guard status, let model = model else {
                Toast.showToast(title: msg)
                return
            }
            self.headerView.model = model
            self.orePoolView.model = model

            self.orePoolView.type = .ipfs
        }
    }

}

// MARK: - Event(事件响应)
extension FirstPageController {
    ///
    @objc fileprivate func headerRefresh() -> Void {
        self.refreshRequest()
    }
}

// MARK: - Enter Page
extension FirstPageController {
    /// 进入系统通知列表页
    fileprivate func enterNoticeListPage() -> Void {
        let messagVC = MessageListController.init(type: .system)
        self.enterPageVC(messagVC)
    }

}

// MARK: - Notification
extension FirstPageController {
    /// 未读消息通知处理
    @objc fileprivate func unreadMessageNoticiationProcess(_ notification: Notification) -> Void {
        guard let model = notification.object as? MessageUnreadModel else {
            return
        }
        self.navBar.msgcount = model.count
    }
}

// MARK: - Extension Function
extension FirstPageController {

}

// MARK: - Delegate Function

// MARK: - <MallHomeStatusNavBarProtocol>
extension FirstPageController: MallHomeStatusNavBarProtocol {
    /// 导航栏右侧按钮点击回调
    func homeBar(_ navBar: MallHomeStatusNavBar, didClickedRightItem itemView: UIView) -> Void {
        if AccountManager.share.isLogin {
            let messageVC = MessageListController.init(type: .system)
            self.enterPageVC(messageVC)
        } else {
            AppUtil.presentLoginPage()
        }
    }

}


// MARK: - <FPHomeHeaderViewProtocol>
extension FirstPageController: FPHomeHeaderViewProtocol {
    /// 通知内容点击回调
    func headerView(_ headerView: FPHomeHeaderView, didClickedNoticeContent contentView: UIView, with model: MessageListModel) -> Void {

    }
    /// 通知右侧全部按钮点击回调
    func headerView(_ headerView: FPHomeHeaderView, didClickedNoticeAll allView: UIView) -> Void {
        if AccountManager.share.isLogin {
            self.enterNoticeListPage()
        } else {
            AppUtil.presentLoginPage()
        }
    }

}
