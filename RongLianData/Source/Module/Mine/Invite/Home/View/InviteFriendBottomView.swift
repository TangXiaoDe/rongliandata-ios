//
//  InviteFriendBottomView.swift
//  iMeet
//
//  Created by 小唐 on 2019/4/1.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  邀请好友页底部视图：复制邀请码、复制链接、分享海报

import UIKit

protocol InviteFriendBottomViewProtocol: class {
    /// 复制链接按钮 点击回调
    func bottomView(_ bottomView: InviteFriendBottomView, didClickedCopyLink control: UIControl) -> Void
    /// 分享邀请码按钮 点击回调
    func bottomView(_ bottomView: InviteFriendBottomView, didClickedCopyCode control: UIControl) -> Void
    /// 保存微信回调
    func bottomView(_ popView: InviteFriendBottomView, didClickedWechat control: UIControl) -> Void
    /// 保存微信朋友圈回调
    func bottomView(_ popView: InviteFriendBottomView, didClickedCircle control: UIControl) -> Void
    /// 保存本地回调
    func bottomView(_ popView: InviteFriendBottomView, didClickedSave control: UIControl) -> Void
}

class InviteFriendBottomView: UIView {

    // MARK: - Internal Property
    static let viewHeight: CGFloat = 115 + kBottomHeight
    /// 商城商品
    var model: ProductDetailModel? {
        didSet {
            self.setupWithModel(model)
        }
    }

    weak var delegate: InviteFriendBottomViewProtocol?

    // MARK: - Private Property

    fileprivate let mainView: UIView = UIView()
    fileprivate let itemContainer: UIView = UIView()
    fileprivate let itemContainerTitleLabel: UILabel = UILabel()

    fileprivate let kItemTagBase: Int = 250

    fileprivate let mainOutLrMargin: CGFloat = 0
//    fileprivate let mainInLrMargin: CGFloat = kIsiPhoneXSeries ? 35 : 20
    fileprivate let mainInLrMargin: CGFloat = 35
    fileprivate let titleTop: CGFloat = 15
    fileprivate let itemContainerH: CGFloat = 115 + kBottomHeight

    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
        self.initialUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialUI()
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension InviteFriendBottomView {
    /// 显示在window上
    func show(on view: UIView? = nil) -> Void {
        var superView: UIView? = UIApplication.shared.keyWindow
        if let view = view {
            superView = view
        }
        if let superView = superView {
            superView.addSubview(self)
            self.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
}

// MARK: - LifeCircle Function

// MARK: - Private  UI
extension InviteFriendBottomView {
    // 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = .white
        mainView.setupCorners(UIRectCorner.init(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), selfSize: CGSize(width: kScreenWidth, height: Self.viewHeight), cornerRadius: 20)
        // 2. itemContainer
        mainView.addSubview(self.itemContainer)
        self.initialItemContainer(self.itemContainer)
        self.itemContainer.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.itemContainerH)
            make.bottom.equalToSuperview()
        }
        mainView.addSubview(self.itemContainerTitleLabel)
        self.itemContainerTitleLabel.set(text: "分享到", font: UIFont.pingFangSCFont(size: 16, weight: .regular), textColor: AppColor.mainText, alignment: .center)
        self.itemContainerTitleLabel.set(cornerRadius: 15)
        self.itemContainerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.itemContainer).offset(self.titleTop)
            make.leading.trailing.equalToSuperview()
        }
    }
    fileprivate func initialItemContainer(_ itemContainer: UIView) -> Void {
        // item布局 IMG_common_icon_share_wechat IMG_common_icon_share_save IMG_common_icon_share_link
        let items: [(iconName: String, title: String)] = [
            (iconName: "IMG_common_icon_share_wechat", title: "微信"),
            (iconName: "IMG_common_icon_share_pyq", title: "朋友圈"),
            (iconName: "IMG_common_icon_share_link", title: "复制链接"),
            (iconName: "IMG_common_icon_share_save", title: "保存图片")
        ]
        let lrMargin: CGFloat = 0
        let itemMaxW: CGFloat = CGFloat(Int((kScreenWidth - lrMargin * 2.0) / CGFloat(items.count)))
        for (index, item) in items.enumerated() {
            let itemControl: UIControl = UIControl()
            itemContainer.addSubview(itemControl)
            itemControl.tag = self.kItemTagBase + index
            itemControl.addTarget(self, action: #selector(itemControlClick(_:)), for: .touchUpInside)
            self.setupItemControl(itemControl, with: item)
            itemControl.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(50)
                let centerXoffset: CGFloat = lrMargin + CGFloat(Int((CGFloat(index) + 0.5) * itemMaxW))
                make.centerX.equalTo(itemContainer.snp.leading).offset(centerXoffset)
            }
        }
    }
    /// itemControl布局
    fileprivate func setupItemControl(_ itemControl: UIControl, with item: (iconName: String, title: String)) -> Void {
        let topMargin: CGFloat = 0
        let bottomMargin: CGFloat = 0
        let iconWH: CGFloat = 37
        let nameIconMargin: CGFloat = 5
        // iconView
        let iconView: UIImageView = UIImageView()
        itemControl.addSubview(iconView)
        iconView.set(cornerRadius: iconWH * 0.5)
        iconView.isUserInteractionEnabled = false
        iconView.image = UIImage(named: item.iconName)
        iconView.snp.makeConstraints { (make) in
            make.width.height.equalTo(iconWH)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(0)
            make.trailing.lessThanOrEqualToSuperview().offset(-0)
            make.top.equalToSuperview().offset(topMargin)
        }
        // titleLabel
        let titleLabel: UILabel = UILabel()
        itemControl.addSubview(titleLabel)
        titleLabel.set(text: item.title, font: UIFont.systemFont(ofSize: 13), textColor: UIColor(hex: 0x333333), alignment: .center)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(0)
            make.trailing.lessThanOrEqualToSuperview().offset(-0)
            make.top.equalTo(iconView.snp.bottom).offset(nameIconMargin)
            make.bottom.equalToSuperview().offset(-bottomMargin)
        }
    }

}

// MARK: - Data Function
extension InviteFriendBottomView {
    func setupAsDemo() -> Void {
        
    }

    /// 商品数据加载
    fileprivate func setupWithModel(_ model: ProductDetailModel?) -> Void {
        self.setupAsDemo()
        guard let model = model, let user = AccountManager.share.currentAccountInfo?.userInfo, let inviteModel = AppConfig.share.server?.inviteInfoModel else {
            return
        }

    }
}

// MARK: - Event Function
extension InviteFriendBottomView {
    ///
    @objc fileprivate func itemControlClick(_ control: UIControl) -> Void {
        let index: Int = control.tag - self.kItemTagBase
        switch index {
        case 0:
            self.delegate?.bottomView(self, didClickedWechat: control)
        case 1:
            self.delegate?.bottomView(self, didClickedCircle: control)
        case 2:
            self.delegate?.bottomView(self, didClickedCopyLink: control)
        case 3:
            self.delegate?.bottomView(self, didClickedCopyCode: control)
        case 4:
            self.delegate?.bottomView(self, didClickedSave: control)
        default:
            break
        }
    }
}

// MARK: - Extension Function

extension InviteFriendBottomView {
    // 截取图片
    fileprivate func screenPhoto() {
//        UIGraphicsBeginImageContextWithOptions(self.posterView.bounds.size, false, UIScreen.main.scale)
//        self.posterView.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        self.saveImageToPhotoLibrary(image)
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
