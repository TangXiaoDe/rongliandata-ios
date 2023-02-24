//
//  InviteFriendCardCell.swift
//  iMeet
//
//  Created by 小唐 on 2019/3/21.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  邀请好友页的卡片Cell

import UIKit

protocol InviteFriendCardCellProtocol: class {
    func cardCell(_ cell: InviteFriendCardCell, didClickedRule ruleBtn: UIButton) -> Void
}

class InviteFriendCardCell: HQIndexBannerSubview {

    var qrcodeCotainer: UIView = UIView()
    var qrcodeImgView: UIImageView = UIImageView()
    var codeLabel: UILabel = UILabel()
    var ruleBtn: UIButton = UIButton.init(type: .custom)

    /// 回调
    weak var delegate: InviteFriendCardCellProtocol?
    var ruleClickAction: ((_ cell: InviteFriendCardCell, _ ruleBtn: UIButton) -> Void)?

    fileprivate let codeContainerSize: CGSize = CGSize.init(width: 65.5, height: 65.5)
    fileprivate let codeWH: CGFloat = 61.5
    fileprivate let codeTopMargin: CGFloat = 2
    fileprivate let codeContainerBottomMargin: CGFloat = 21
    fileprivate let codeContainerRightMargin: CGFloat = 15
    fileprivate let ruleBtnH: CGFloat = 24
    fileprivate let ruleBtnW: CGFloat = 76
    fileprivate let ruleBtnTopMargin: CGFloat = 20
    fileprivate let bottomH: CGFloat = 109

    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func cellInFlowView(_ flowView: HQFlowView) -> InviteFriendCardCell {
        var cell = flowView.dequeueReusableCell()
        if nil == cell {
            cell = InviteFriendCardCell()
        }
        // 状态重置
        if let cell = cell as? InviteFriendCardCell {
            cell.resetSelf()
        }
        return cell as! InviteFriendCardCell
    }

    fileprivate func resetSelf() -> Void {

    }

    fileprivate func commonInit() -> Void {
        self.set(cornerRadius: 8)
        self.backgroundColor = UIColor.white
        // 0. mainImageView
        self.mainImageView.contentMode = .scaleAspectFill
        self.mainImageView.snp.removeConstraints()
        self.mainImageView.clipsToBounds = true
        self.mainImageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-self.bottomH)
        }
        // 1. qrcodeCotainer
        self.addSubview(self.qrcodeCotainer)
        self.qrcodeCotainer.backgroundColor = UIColor.white
        self.qrcodeCotainer.set(cornerRadius: 8, borderWidth: 0.5, borderColor: UIColor(hex: 0xEAEAEA))
        self.qrcodeCotainer.snp.makeConstraints { (make) in
            make.size.equalTo(self.codeContainerSize)
            make.trailing.equalToSuperview().offset(-self.codeContainerRightMargin)
            make.bottom.equalToSuperview().offset(-codeContainerBottomMargin)
        }
        // 2. qrcodeImgView
        self.qrcodeCotainer.addSubview(self.qrcodeImgView)
        self.qrcodeImgView.set(cornerRadius: 0)
        self.qrcodeImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.codeWH)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(codeTopMargin)
        }
        //
        let logoImgV: UIImageView = UIImageView.init(image: UIImage(named: "IMG_setup_img_logo"))
        logoImgV.contentMode = .scaleAspectFit
        self.addSubview(logoImgV)
        logoImgV.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(19)
            make.bottom.equalToSuperview().offset(-17.5)
        }
    }

    /// 奖励规则点击
    @objc fileprivate func ruleBtnClick(_ button: UIButton) -> Void {
        self.delegate?.cardCell(self, didClickedRule: button)
        self.ruleClickAction?(self, button)
    }

}
