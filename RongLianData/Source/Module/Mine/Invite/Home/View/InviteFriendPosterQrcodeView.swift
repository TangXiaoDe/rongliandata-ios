//
//  InviteFriendPosterQrcodeView.swift
//  SassProject
//
//  Created by crow on 2021/7/16.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit

class InviteFriendPosterQrcodeView: UIView {

    // MARK: - Internal Property

    fileprivate var model: InviteInfoModel? = nil {
        didSet {
            self.setupModel(model)
        }
    }

    // MARK: - Private Property

    fileprivate let mainContainer: UIView = UIView()
    fileprivate let qrCodeContainer: UIView = UIView()
    fileprivate let qrCodeIconView: UIImageView = UIImageView()

    fileprivate let rightView: UIView = UIView()
    fileprivate let inviteCodeLabel: UILabel = UILabel()
    fileprivate let imgVHead: UIImageView = UIImageView()
    fileprivate let nameLabel: UILabel = UILabel()

    fileprivate let lrMargin: CGFloat = 10
    fileprivate let qrCodeContainerWH: CGFloat = 137
    fileprivate let qrCodeWH: CGFloat = 125
    fileprivate let copyBtnSize: CGSize = CGSize.init(width: 64, height: 24)

    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
//        self.bounds = CGRect.init(origin: .zero, size: CGSize.init(width: kScreenWidth - 2 * 12, height: 177))
        self.initialUI()
        self.initialDataSource()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialUI()
        self.initialDataSource()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialUI()
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension InviteFriendPosterQrcodeView {

}

// MARK: - LifeCircle Function
extension InviteFriendPosterQrcodeView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension InviteFriendPosterQrcodeView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        self.set(cornerRadius: 15)
        // mainContainer
        self.addSubview(self.mainContainer)
        self.mainContainer.frame = CGRect.init(x: self.lrMargin, y: self.lrMargin, width: self.width - 2 * self.lrMargin, height: 157)
        self.initialMainView(self.mainContainer)

    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        self.mainContainer.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        self.mainContainer.set(cornerRadius: 8)
        // 1. qrCodeContainer
        mainView.addSubview(self.qrCodeContainer)
        self.qrCodeContainer.frame = CGRect.init(x: self.lrMargin, y: self.lrMargin, width: self.qrCodeContainerWH, height: self.qrCodeContainerWH)
        self.qrCodeContainer.set(cornerRadius: 0)
        // qrcodeIcon
        self.qrCodeContainer.addSubview(self.qrCodeIconView)
        self.qrCodeIconView.set(cornerRadius: 5)
        self.qrCodeIconView.frame = CGRect.init(x: (self.qrCodeContainerWH - self.qrCodeWH) / 2.0, y: (self.qrCodeContainerWH - self.qrCodeWH) / 2.0, width: self.qrCodeWH, height: self.qrCodeWH)
        // 2. rightView
        mainView.addSubview(self.rightView)
        self.rightView.frame = CGRect.init(x: self.qrCodeContainer.right, y: 0, width: mainView.width - self.qrCodeContainer.right, height: mainView.height)
        self.initialRightView(self.rightView)
    }
    fileprivate func initialRightView(_ rightView: UIView) {
        // 用户image
        rightView.addSubview(self.imgVHead)
        self.imgVHead.frame = CGRect.init(x: self.lrMargin, y: 25, width: 32, height: 32)
        self.imgVHead.set(cornerRadius: 16)
        // nameLabel
        rightView.addSubview(self.nameLabel)
        self.nameLabel.set(text: "用户", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.mainText)
        self.nameLabel.frame = CGRect.init(x: self.imgVHead.right + 8, y: self.imgVHead.top, width: rightView.width - self.imgVHead.right - 2 * 8, height: 18)
        // 文案
        let joinLabel: UILabel = UILabel()
        joinLabel.set(text: "邀您加入\(AppConfig.share.appName)", font: UIFont.pingFangSCFont(size: 13), textColor: AppColor.grayText)
        joinLabel.frame = CGRect.init(x: self.nameLabel.left, y: self.nameLabel.bottom, width: self.nameLabel.width, height: 15)
        rightView.addSubview(joinLabel)
        // inviteCode
        rightView.addSubview(self.inviteCodeLabel)
        self.inviteCodeLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 28, weight: .medium), textColor: AppColor.themeRed, alignment: .center)
        self.inviteCodeLabel.frame = CGRect.init(x: 0, y: rightView.height - 30 - 22, width: rightView.width, height: 30)
        // 邀请码 titleLabel
        let titleLabel: UILabel = UILabel()
        titleLabel.set(text: "我的邀请码", font: UIFont.pingFangSCFont(size: 14), textColor: AppColor.grayText, alignment: .center)
        titleLabel.frame = CGRect.init(x: 0, y: self.inviteCodeLabel.top - self.lrMargin - 16, width: rightView.width, height: 16)
        rightView.addSubview(titleLabel)
    }

}
// MARK: - Private UI Xib加载后处理
extension InviteFriendPosterQrcodeView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Request Function
extension InviteFriendPosterQrcodeView {
    fileprivate func initialDataSource() -> Void {
        if let inviteInfoModel = AppConfig.share.server?.inviteInfoModel, let userInfo = AccountManager.share.currentAccountInfo?.userInfo {
            self.model = inviteInfoModel
            self.imgVHead.kf.setImage(with: userInfo.avatarUrl, placeholder: kPlaceHolderAvatar)
            self.nameLabel.text = userInfo.name
        } else {
            self.refreshRequest()
        }
    }
    /// 请求系统配置
    fileprivate func refreshRequest() -> Void {
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

// MARK: - Data Function
extension InviteFriendPosterQrcodeView {

    func setupAsDemo() -> Void {
        self.inviteCodeLabel.text = "vx1234"
        let codeImage = "https://img.tupianzj.com/uploads/allimg/200424/30-200424140H80-L.gif".generateQRCode(size: 250, color: UIColor.black, bgColor: UIColor.white, logo: nil, radius: 0, borderLineWidth: 0, borderLineColor: UIColor.clear, boderWidth: 0, borderColor: UIColor.white)
        self.qrCodeIconView.image = codeImage
    }

    /// 数据加载
    fileprivate func setupModel(_ model: InviteInfoModel?) -> Void {
        guard let model = model, let user = AccountManager.share.currentAccountInfo?.userInfo else {
            return
        }
        let strLink = model.strUrl + "?c=" + user.inviteCode
        // 二维码图片
        self.qrCodeIconView.image = strLink.generateQRCode(size: 250, color: UIColor.black, bgColor: UIColor.white, logo: nil, radius: 5, borderLineWidth: 0, borderLineColor: UIColor.clear, boderWidth: 0, borderColor: UIColor.white)
        self.inviteCodeLabel.text = user.inviteCode
    }

}

// MARK: - Event Function
extension InviteFriendPosterQrcodeView {

}

// MARK: - Extension Function
extension InviteFriendPosterQrcodeView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension InviteFriendPosterQrcodeView {

}
