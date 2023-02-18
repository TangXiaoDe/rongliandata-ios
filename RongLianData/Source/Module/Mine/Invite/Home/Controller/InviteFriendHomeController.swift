//
//  InviteFriendHomeController.swift
//  SassProject
//
//  Created by zhaowei on 2020/11/16.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit
import ChainOneKit

/// 邀请主页
typealias InviteFriendHomeController = InviteFriendController
/// 邀请好友界面
class InviteFriendController: BaseViewController {
    // MARK: - Internal Property

    // MARK: - Private Property

    fileprivate let navBar: AppHomeNavStatusView = AppHomeNavStatusView.init()
    /// coverflow
    fileprivate let pagedView: HQFlowView = HQFlowView()

    /// 底部视图
    fileprivate let bottomView = InviteFriendBottomView.init()

    fileprivate let ruleBtn: UIButton = UIButton.init(type: .custom)
    fileprivate let sharedView: InviteFriendSharedView = InviteFriendSharedView()

    fileprivate var model: InviteInfoModel? = nil {
        didSet {
            self.setupModel(model)
        }
    }
    fileprivate var sourceList: [InvitePosterModel] = []
    fileprivate var qrCodeImage: UIImage?

    fileprivate let bottomViewH: CGFloat = InviteFriendBottomView.viewHeight
    fileprivate let codeWH: CGFloat = 100
    fileprivate let tbMargin: CGFloat = 10
    fileprivate let lrMargin: CGFloat = 35
    fileprivate let rewardRuleBtnH: CGFloat = 24
    fileprivate let rewardRuleBtnW: CGFloat = 76
    fileprivate let originItemSize: CGSize = CGSize.init(width: 375, height: 667)


    // MARK: - Initialize Function

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle Function
extension InviteFriendController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - UI
extension InviteFriendController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        // navigationbar
        self.view.addSubview(self.navBar)
        self.navBar.backgroundColor = .white
        self.navBar.title = "邀请好友"
        self.navBar.delegate = self
        self.navBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(kNavigationStatusBarHeight)
        }

        // 1. bottomView
        self.view.addSubview(self.bottomView)
        bottomView.delegate = self
        bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.bottomViewH)
            make.bottom.equalToSuperview()
        }
//        // shadowView
//        let shadowView: UIView = UIView.init()
//        let gradientLayer: CAGradientLayer = AppUtil.commonGradientLayer()
//        gradientLayer.colors = [UIColor.init(hex: 0xF2F4F6).withAlphaComponent(0).cgColor, UIColor.init(hex: 0x999999).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
//        gradientLayer.frame = CGRect.init(origin: .zero, size: CGSize(width: kScreenWidth, height: 230))
//        shadowView.layer.addSublayer(gradientLayer)
//        self.view.addSubview(shadowView)
//        shadowView.snp.makeConstraints { make in
//            make.bottom.equalTo(self.bottomView.snp.top).offset(16)
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(230)
//        }
        self.view.bringSubviewToFront(self.bottomView)
        // 2. pagedView
        self.view.addSubview(self.pagedView)
        self.pagedView.dataSource = self
        self.pagedView.delegate = self
        self.pagedView.minimumPageAlpha = 0.3
        self.pagedView.leftRightMargin = 30
        //self.pagedView.isCarousel = false
        self.pagedView.isOpenAutoScroll = false
        self.pagedView.autoTime = 3.0
        self.pagedView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.navBar.snp.bottom).offset(tbMargin)
            make.bottom.equalTo(self.bottomView.snp.top).offset(-self.tbMargin)
        }
        // 3. rewardRuleBtn
        self.view.addSubview(self.ruleBtn)
        self.ruleBtn.set(title: "规则说明", titleColor: UIColor.white, for: .normal)
        self.ruleBtn.set(font: UIFont.pingFangSCFont(size: 14))
        self.ruleBtn.setupCorners([UIRectCorner.topLeft, UIRectCorner.bottomLeft], selfSize: CGSize.init(width: self.rewardRuleBtnW, height: self.rewardRuleBtnH), cornerRadius: self.rewardRuleBtnH * 0.5)
        self.ruleBtn.addTarget(self, action: #selector(rewardRuleBtnClick(_:)), for: .touchUpInside)
        self.ruleBtn.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        // 要求奖励规则按钮在每页上，而不是直接悬浮在整个屏幕上。
        self.ruleBtn.isHidden = true
        self.ruleBtn.snp.makeConstraints { (make) in
            make.width.equalTo(self.rewardRuleBtnW)
            make.height.equalTo(self.rewardRuleBtnH)
            make.top.equalTo(self.pagedView).offset(20)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
        }
        // sharedView
        self.view.addSubview(self.sharedView)
        self.sharedView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.snp.bottom).offset(250)
            make.size.equalTo(self.originItemSize.scaleAspectForWidth(kScreenWidth))
        }
    }

}

// MARK: - Data(数据处理与加载)
extension InviteFriendController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        if let inviteInfoModel = AppConfig.share.server?.inviteInfoModel {
            self.model = inviteInfoModel
        } else {
            self.refreshRequest()
        }
        let loading = AppLoadingView.init()
        loading.show()
        InviteNetworkManager.getInvitePosters { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            loading.dismiss()
            guard status, let models = models else {
                Toast.showToast(title: msg)
                return
            }
            // coverFlow
            self.sourceList = models
            self.pagedView.reloadData()
        }
    }

    /// 数据加载
    fileprivate func setupModel(_ model: InviteInfoModel?) -> Void {
        guard let model = model, let user = AccountManager.share.currentAccountInfo?.userInfo else {
            return
        }
        let strLink = model.strUrl + "?c=" + user.inviteCode
        // 二维码图片
        self.qrCodeImage = strLink.generateQRCode(size: 250, color: UIColor.black, bgColor: UIColor.white, logo: nil, radius: 5, borderLineWidth: 0, borderLineColor: UIColor.clear, boderWidth: 0, borderColor: UIColor.white)
    }

}
// MARK: - Network
extension InviteFriendController {
    /// 请求系统配置
    @objc func refreshRequest() -> Void {
        SystemNetworkManager.appServerConfig { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            guard status, let inviteModel = model?.inviteInfoModel else {
                ToastUtil.showToast(title: msg)
                return
            }
            AppConfig.share.server = model
            self.model = inviteModel
        }
    }
}

// MARK: - Event(事件响应)
extension InviteFriendController {

    @objc fileprivate func rewardRuleBtnClick(_ button: UIButton) -> Void {

    }
}
extension InviteFriendController {

}
extension InviteFriendController {
    /// 复制邀请码操作
    fileprivate func copyInviteCode() -> Void {
        // 复制邀请码到粘贴板
        guard let user = AccountManager.share.currentAccountInfo?.userInfo else {
            return
        }
        let strCopy: String = user.inviteCode
        AppUtil.copyToPasteProcess(strCopy, indicatorMsg: "邀请码已复制到粘贴板")
    }
    /// 复制链接操作
    fileprivate func copyInviteLink() -> Void {
        // 复制邀请链接到粘贴板
        guard let model = self.model, let user = AccountManager.share.currentAccountInfo?.userInfo else {
            return
        }
        let strInvite = model.strUrl + "?c=" + user.inviteCode
        let strCopy: String = AppUtil.invitePageCopyLink(inviteUrl: strInvite)
        AppUtil.copyToPasteProcess(strCopy, indicatorMsg: "邀请链接已复制到粘贴板")
    }
    /// 分享海报操作
    fileprivate func loadSharePosterData(complete: @escaping(() -> Void)) -> Void {
        guard let user = AccountManager.share.currentAccountInfo?.userInfo, !self.sourceList.isEmpty else {
            return
        }
        // 配置sharedView
        self.sharedView.qrcodeImgView.image = self.qrCodeImage
        self.sharedView.codeLabel.text = user.inviteCode
        let currentIndex = self.pagedView.currentPageIndex
        let currentModel = self.sourceList[currentIndex]
        self.sharedView.bgImgView.kf.setImage(with: UrlManager.fileUrl(name: currentModel.url), placeholder: kPlaceHolderImage, options: nil, progressBlock: nil) { (image, error, type, url) in
            complete()
        }
    }

}

// MARK: - Notification
extension InviteFriendController {

}

// MARK: - Extension Function
extension InviteFriendController {
    /// 显示分享弹窗
    fileprivate func showSharePop(shareImage: UIImage, shareUrl: String, copyLink: String?) -> Void {
        let sharePopView = SharePopView.init(shareType: .image, shareImage: shareImage, shareUrl: shareUrl, copyLink: copyLink, shareTitle: nil, shareDesc: nil)
        sharePopView.show()
    }
    // 保存图片
    func saveImageToPhotoLibrary(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }

    /// 保存图片到本地回调
    @objc fileprivate func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let e = error as NSError? {
            print(e)
        } else {
            Toast.showToast(title: "图片已经保存到相册")
        }
    }
}

// MARK: - Delegate Function

// MARK: - <HQFlowViewDataSource>
extension InviteFriendController: HQFlowViewDataSource {
    func numberOfPages(in flowView: HQFlowView!) -> Int {
        return 3 // self.sourceList.count
    }
    func flowView(_ flowView: HQFlowView!, cellForPageAt index: Int) -> HQIndexBannerSubview! {
//        let model = self.sourceList[index]
        let bannerView = InviteFriendCardCell.cellInFlowView(flowView)
        bannerView.coverView.backgroundColor = AppColor.pageBg
//        bannerView.mainImageView.kf.setImage(with: UrlManager.fileUrl(name: model.url), placeholder: UIImage.init(named: "IMG_bg_inviteposter"))
        bannerView.qrcodeImgView.image = self.qrCodeImage
        bannerView.codeLabel.text = AccountManager.share.currentAccountInfo?.userInfo?.inviteCode
        bannerView.delegate = self
        return bannerView
    }

}

// MARK: - <HQFlowViewDelegate>
extension InviteFriendController: HQFlowViewDelegate {
    func sizeForPage(in flowView: HQFlowView!) -> CGSize {
        let height: CGFloat = kScreenHeight - kNavigationStatusBarHeight - self.bottomViewH - self.tbMargin * 3.0
        let size = CGSize.init(width: kScreenWidth - self.lrMargin * 2.0, height: height)
        return size
    }
    func didScroll(toPage pageNumber: Int, in flowView: HQFlowView!) {

    }
    func didSelectCell(_ subView: HQIndexBannerSubview!, withSubViewIndex subIndex: Int) {

    }
}

// MARK: - <InviteFriendBottomViewProtocol>
extension InviteFriendController: InviteFriendBottomViewProtocol {
    /// 复制链接按钮 点击回调
    func bottomView(_ bottomView: InviteFriendBottomView, didClickedCopyLink control: UIControl) {
        self.copyInviteLink()
    }
    /// 分享邀请码按钮 点击回调
    func bottomView(_ bottomView: InviteFriendBottomView, didClickedCopyCode control: UIControl) {
        self.copyInviteCode()
    }
    /// 微信分享
    func bottomView(_ popView: InviteFriendBottomView, didClickedWechat control: UIControl) {
        self.loadSharePosterData {
            let shareImage = UIImage.getImageFromView(self.sharedView)
            AppUtil.systemSharePage(shareImage: shareImage, shareUrl: nil)
//            let sharePopView = SharePopView.init(shareType: .image, shareImage: shareImage, shareUrl: nil, copyLink: nil, shareTitle: nil, shareDesc: nil)
//            sharePopView.shareToWechatFriend()
        }
    }
    /// 微信朋友圈回调
    func bottomView(_ popView: InviteFriendBottomView, didClickedCircle control: UIControl) {
        self.loadSharePosterData {
            let shareImage = UIImage.getImageFromView(self.sharedView)
            AppUtil.systemSharePage(shareImage: shareImage, shareUrl: nil)
//            let sharePopView = SharePopView.init(shareType: .image, shareImage: shareImage, shareUrl: nil, copyLink: nil, shareTitle: nil, shareDesc: nil)
//            sharePopView.shareToWechatCircle()
        }
    }
    /// 保存海报
    func bottomView(_ popView: InviteFriendBottomView, didClickedSave control: UIControl) {
        self.loadSharePosterData {
            if let image = UIImage.getImageFromView(self.sharedView) {
                // 保存图片到本地
                self.saveImageToPhotoLibrary(image)
            }
        }
    }
}

// MARK: - <InviteFriendCardCellProtocol>
extension InviteFriendController: InviteFriendCardCellProtocol {
    func cardCell(_ cell: InviteFriendCardCell, didClickedRule ruleBtn: UIButton) {

    }

}

extension InviteFriendController: AppHomeNavStatusViewProtocol {
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedLeftItem itemView: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedRightItem itemView: UIButton) {

    }
}
