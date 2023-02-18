//
//  CommonAlertView.swift
//  SassProject
//
//  Created by crow on 2021/9/14.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit
import ChainOneKit

protocol CommonAlertViewProtocol: AnyObject {
    /// 遮罩点击
    func alertView(_ alertView: CommonAlertView, didClickedCover btn: UIButton) -> Void
    /// 取消按钮点击回调
    func alertView(_ alertView: CommonAlertView, didClickedCancelBtn btn: UIButton)
    /// 确认按钮点击回调
    func alertView(_ alertView: CommonAlertView, didClickedSureBtn btn: UIButton)
}
extension CommonAlertViewProtocol {
    
    func alertView(_ alertView: CommonAlertView, didClickedCover btn: UIButton) -> Void {}
    func alertView(_ alertView: CommonAlertView, didClickedCancelBtn btn: UIButton) {}
    func alertView(_ alertView: CommonAlertView, didClickedSureBtn btn: UIButton) {}

}

enum CommonAlertViewShowType {
    case center
    case bottom
}

class CommonAlertView: UIView {

    var title: String
    var content: String?
    
    weak var delegate: CommonAlertViewProtocol?
    var doneBtnClickAction: ((_ alertView: CommonAlertView, _ doneBtn: UIButton) -> Void)?
    
    var showCancel: Bool = true {
        didSet {
            self.cancelBtn.isHidden = !showCancel
            self.sureBtn.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().offset(-self.bottomMargin)
                make.size.equalTo(self.btnSize)
                make.centerX.equalToSuperview().multipliedBy(self.showCancel ? 1.5 : 1)
            }
        }
    }
    var contentAttribute: NSAttributedString? = nil {
        didSet {
            self.contentLabel.attributedText = contentAttribute
        }
    }
    var mainViewBg: UIColor = .clear {
        didSet {
            self.mainView.backgroundColor = mainViewBg
        }
    }
    

    fileprivate let showType: CommonAlertViewShowType
    fileprivate let topViewTopMargin: CGFloat // 慎用
    fileprivate let isDoneLeft: Bool
    
    fileprivate let coverBtn: UIButton = UIButton.init(type: .custom)
    fileprivate let mainView: UIView = UIView()
    fileprivate let topView: UIView = UIView()
    fileprivate let centerView: UIView = UIView()
    fileprivate let bottomView: UIView = UIView()
    fileprivate let bottomSafeView: UIView = UIView()
    
    let titleLabel: UILabel = UILabel()
    let contentLabel: UILabel = UILabel()
    let cancelBtn: UIButton = UIButton()
    let sureBtn: GradientLayerButton = GradientLayerButton()

    fileprivate let lrMargin: CGFloat = 15
    fileprivate let bottomMargin: CGFloat = 5
    fileprivate let mainViewSize: CGSize = CGSize.init(width: 280, height: 180)
    fileprivate let btnSize: CGSize = CGSize.init(width: 140, height: 40)
    fileprivate let btnCenterSize: CGSize = CGSize.init(width: 100, height: 36)
    fileprivate let mainViewCenterYOffset: CGFloat = 80
    fileprivate let topViewHeight: CGFloat = 56
    fileprivate let centerViewMiniHeight: CGFloat = 78
    fileprivate let bottomViewHeight: CGFloat = 49
    fileprivate let contentTopMargin: CGFloat = 10  // 30
    fileprivate let contentBottomMargin: CGFloat = 10 // 30

    init(title: String, content: String?, showType: CommonAlertViewShowType = .center, topViewTopMargin: CGFloat = 0, isDoneLeft: Bool = false) {
        self.title = title
        self.content = content
        self.showType = showType
        self.topViewTopMargin = topViewTopMargin
        self.isDoneLeft = isDoneLeft
        super.init(frame: .init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        self.initialUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCircle/Override Function
extension CommonAlertView {
    
}

// MARK: - UI Function
extension CommonAlertView {
    fileprivate func initialUI() {
        self.backgroundColor = UIColor.clear
        // cover
        self.addSubview(self.coverBtn)
        self.coverBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.coverBtn.addTarget(self, action: #selector(coverBtnClick(_:)), for: .touchUpInside)
        self.coverBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // mainView
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { make in
            if self.showType == .bottom {
                make.leading.trailing.bottom.equalToSuperview()
            } else {
                make.center.equalToSuperview()
                make.leading.equalToSuperview().offset(47)
                make.trailing.equalToSuperview().offset(-47)
            }
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) {
        if self.showType == .center {
            mainView.set(cornerRadius: 10)
        }
        // 1.
        mainView.addSubview(self.topView)
        self.initialTopView(self.topView)
        self.topView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(self.topViewTopMargin)
            make.height.equalTo(self.topViewHeight)
        }
        // 2.
        mainView.addSubview(self.centerView)
        self.initialCenterView(self.centerView)
        self.centerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom)
            //make.height.greaterThanOrEqualTo(self.centerViewMiniHeight)
        }
        // 3.
        mainView.addSubview(self.bottomView)
        self.initialBottomView(self.bottomView)
        self.bottomView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.centerView.snp.bottom)
            make.height.equalTo(self.bottomViewHeight)
        }
        // 4.
        mainView.addSubview(self.bottomSafeView)
        self.bottomSafeView.backgroundColor = AppColor.white
        self.bottomSafeView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.bottomView.snp.bottom)
            make.height.equalTo(kBottomHeight)
        }
    }
    fileprivate func initialTopView(_ topView: UIView) {
        if self.showType == .bottom {
            topView.setupCorners([UIRectCorner.topLeft, UIRectCorner.topRight], selfSize: CGSize.init(width: kScreenWidth, height: 56), cornerRadius: 15)
            topView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: self.lrMargin, margin2: self.lrMargin)
        }
        topView.backgroundColor = AppColor.white
        // titleLabel
        topView.addSubview(self.titleLabel)
        self.titleLabel.set(text: self.title, font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor(hex: 0x222222), alignment: .center)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.centerY.equalToSuperview()
        }
    }
    fileprivate func initialCenterView(_ centerView: UIView) {
        centerView.backgroundColor = AppColor.white
        centerView.addSubview(self.contentLabel)
        self.contentLabel.set(text: self.content, font: UIFont.pingFangSCFont(size: 16), textColor: UIColor(hex: 0x333333), alignment: .center)
        self.contentLabel.numberOfLines = 0
        self.contentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.titleLabel)
            make.top.equalToSuperview().offset(contentTopMargin)
            make.bottom.equalToSuperview().offset(-contentBottomMargin)
        }
    }
    fileprivate func initialBottomView(_ bottomView: UIView) {
        bottomView.backgroundColor = AppColor.white
        let itemSize = self.showType == .bottom ? self.btnSize : self.btnCenterSize
        let cornerValue: CGFloat = itemSize.height * 0.5 //self.showType == .bottom ? 5 : 4
        // cancelBtn
        bottomView.addSubview(self.cancelBtn)
        self.cancelBtn.set(title: "取消", titleColor: UIColor.init(hex: 0xFFFFFF), image: nil, bgImage: nil, for: .normal)
        self.cancelBtn.set(font: UIFont.pingFangSCFont(size: 15, weight: .medium))
        self.cancelBtn.set(cornerRadius: cornerValue)
        self.cancelBtn.backgroundColor = UIColor.init(hex: 0xCCCCCC)
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnOnClicked(_:)), for: .touchUpInside)
        self.cancelBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(itemSize)
//            make.centerX.equalToSuperview().multipliedBy(0.5)
            if self.isDoneLeft {
                make.trailing.equalToSuperview().offset(-20)    // 显示在右侧
            } else {
                make.leading.equalToSuperview().offset(20)      // 显示在左侧
            }
        }
        // sureBtn
        bottomView.addSubview(self.sureBtn)
        self.sureBtn.set(title: "确认", titleColor: .white, image: nil, bgImage: nil, for: .normal)
        self.sureBtn.set(font: UIFont.pingFangSCFont(size: 15, weight: .medium))
        self.sureBtn.set(cornerRadius: cornerValue)
        self.sureBtn.backgroundColor = AppColor.theme
        self.sureBtn.gradientLayer.frame = CGRect.init(origin: .zero, size: itemSize)
        self.sureBtn.gradientLayer.colors = [AppColor.theme.cgColor, AppColor.theme.cgColor]
        self.sureBtn.addTarget(self, action: #selector(sureBtnOnClicked(_:)), for: .touchUpInside)
        self.sureBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(itemSize)
//            make.centerX.equalToSuperview().multipliedBy(1.5)
            if self.isDoneLeft {
                make.leading.equalToSuperview().offset(20)      // 显示在左侧
            } else {
                make.trailing.equalToSuperview().offset(-20)    // 显示在右侧
            }
        }
    }
}

// MARK: - Data Function

// MARK: - Event Function
extension CommonAlertView {
    
    // 点击取消
    @objc fileprivate func coverBtnClick(_ btn: UIButton) {
        self.removeFromSuperview()
        self.delegate?.alertView(self, didClickedCover: btn)
    }
    // 点击取消
    @objc fileprivate func cancelBtnOnClicked(_ btn: UIButton) {
        self.removeFromSuperview()
        self.delegate?.alertView(self, didClickedCancelBtn: btn)
    }
    // 点击确认
    @objc fileprivate func sureBtnOnClicked(_ btn: UIButton) {
        self.removeFromSuperview()
        self.delegate?.alertView(self, didClickedSureBtn: btn)
        self.doneBtnClickAction?(self, btn)
    }
    
}
