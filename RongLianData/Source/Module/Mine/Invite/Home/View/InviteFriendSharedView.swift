//
//  InviteFriendSharedView.swift
//  iMeet
//
//  Created by 小唐 on 2019/3/21.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  邀请好友分享出去的视图

import UIKit

class InviteFriendSharedView: UIView {

    // MARK: - Internal Property

    let bgImgView: UIImageView = UIImageView()
    var qrcodeCotainer: UIView = UIView()
    var qrcodeImgView: UIImageView = UIImageView()
    var bottomView: UIView = UIView()
    var logoImageView: UIImageView = UIImageView()
 
    fileprivate let codeContainerSize: CGSize = CGSize.init(width: 80, height: 80)
    fileprivate let codeWH: CGFloat = 70
    fileprivate let codeTopMargin: CGFloat = 5
    fileprivate let codeContainerBottomMargin: CGFloat = 21
    fileprivate let codeContainerRightMargin: CGFloat = 15
    fileprivate let bottomViewHeight: CGFloat = 110
    fileprivate let logoLeftMargin: CGFloat = 15
    
    // MARK: - Private Property



    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
        self.initialUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialUI()
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension InviteFriendSharedView {
    class func loadXib() -> InviteFriendSharedView? {
        return Bundle.main.loadNibNamed("InviteFriendSharedView", owner: nil, options: nil)?.first as? InviteFriendSharedView
    }
}

// MARK: - LifeCircle Function
extension InviteFriendSharedView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension InviteFriendSharedView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        //
        self.addSubview(self.bottomView)
        self.bottomView.snp.makeConstraints { make in
            make.height.equalTo(self.bottomViewHeight)
            make.leading.trailing.bottom.equalToSuperview()
        }
        self.bottomView.addSubview(self.logoImageView)
        self.logoImageView.set(cornerRadius: 0)
        self.logoImageView.image = UIImage.init(named: "IMG_setup_img_logo")
        self.logoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(19)
            make.centerY.equalToSuperview()
//            make.trailing.lessThanOrEqualToSuperview().offset(-115)
        }
        // 1. bgView
        self.addSubview(self.bgImgView)
        self.bgImgView.set(cornerRadius: 0)
        self.bgImgView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.bottomView.snp.top)
        }
        // 2. codeCotainer
        self.bottomView.addSubview(self.qrcodeCotainer)
        self.qrcodeCotainer.backgroundColor = UIColor.white
        self.qrcodeCotainer.set(cornerRadius: 8, borderWidth: 0.5, borderColor: UIColor(hex: 0xEAEAEA))
        self.qrcodeCotainer.snp.makeConstraints { (make) in
            make.size.equalTo(self.codeContainerSize)
            make.trailing.equalToSuperview().offset(-self.codeContainerRightMargin)
            make.centerY.equalToSuperview()
        }
        // 2.1 qrcodeImgView
        self.qrcodeCotainer.addSubview(self.qrcodeImgView)
        self.qrcodeImgView.set(cornerRadius: 0)
        self.qrcodeImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.codeWH)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(codeTopMargin)
        }
    }

}
// MARK: - Private UI Xib加载后处理
extension InviteFriendSharedView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension InviteFriendSharedView {

}

// MARK: - Event Function
extension InviteFriendSharedView {

}

// MARK: - Extension Function
extension InviteFriendSharedView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension InviteFriendSharedView {

}
