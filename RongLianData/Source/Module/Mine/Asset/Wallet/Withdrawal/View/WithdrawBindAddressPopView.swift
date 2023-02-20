//
//  WithdrawBindAddressPopView.swift
//  HuoTuiVideo
//
//  Created by 小唐 on 2020/7/6.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  提币绑定地址弹窗

import UIKit

protocol WithdrawBindAddressPopViewProtocol: class {
    /// 遮罩点击 - 可选
    func popView(_ popView: WithdrawBindAddressPopView, didClickedCover cover: UIButton) -> Void
    /// 取消点击 - 可选
    func popView(_ popView: WithdrawBindAddressPopView, didClickedCancel cancelBtn: UIButton) -> Void
    /// 确定点击/去绑定点击
    func popView(_ popView: WithdrawBindAddressPopView, didClickedBind bindBtn: UIButton) -> Void
}
extension WithdrawBindAddressPopViewProtocol {
    func popView(_ popView: WithdrawBindAddressPopView, didClickedCover cover: UIButton) -> Void {}
    func popView(_ popView: WithdrawBindAddressPopView, didClickedCancel cancelBtn: UIButton) -> Void {}
}

typealias WithdrawCurrencyBindAddressPopView = WithdrawBindAddressPopView
class WithdrawBindAddressPopView: UIView
{

    // MARK: - Internal Property

    weak var delegate: WithdrawBindAddressPopViewProtocol?

    // MARK: - Private Property

    let coverBtn: UIButton = UIButton.init(type: .custom)
    let mainView: UIView = UIView()
    //let iconView: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    let cancelBtn: UIButton = UIButton.init(type: .custom)
    let doneBtn: GradientLayerButton = GradientLayerButton.init(type: .custom)

    fileprivate let mainLrMargin: CGFloat = 45
    fileprivate let titleCenterYTopMargin: CGFloat = 28
    fileprivate let btnTopMargin: CGFloat = 33 // title.centerY
    fileprivate let btnSize: CGSize = CGSize.init(width: (kScreenWidth - 20 * 3) / 2.0, height: 44)
    fileprivate let btnLrMargin: CGFloat = 20
    fileprivate let btnBottomMargin: CGFloat = 20


    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        //fatalError("init(coder:) has not been implemented")
    }

    /// 通用初始化：UI、配置、数据等
    func commonInit() -> Void {
        self.initialUI()
    }

}

// MARK: - Internal Function
extension WithdrawBindAddressPopView {

}

// MARK: - LifeCircle Function
extension WithdrawBindAddressPopView {

}
// MARK: - Private UI 手动布局
extension WithdrawBindAddressPopView {

    /// 界面布局 - 子类可重写
    fileprivate func initialUI() -> Void {
        // 1. coverBtn
        self.addSubview(self.coverBtn)
        self.coverBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.coverBtn.addTarget(self, action: #selector(coverBtnClick(_:)), for: .touchUpInside)
        self.coverBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 2. mainView
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(10)
        }
    }
    /// mainView布局 - 子类可重写
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = UIColor.white
        mainView.set(cornerRadius: 10)
        //
        let bgImgV = UIImageView(image: UIImage(named: "IMG_qb_icon_dizhi_tishi"))
        mainView.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(42)
            make.height.equalTo(61)
            make.centerX.equalToSuperview()
        }
        // 1. titlLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: "请先绑定提现地址", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor.init(hex: 0x333333), alignment: .center)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(bgImgV.snp.bottom).offset(self.titleCenterYTopMargin)
        }
        // 1. titlLabel
        let tipLabel = UILabel()
        mainView.addSubview(tipLabel)
        tipLabel.set(text: "绑定后，才可继续操作", font: UIFont.pingFangSCFont(size: 16, weight: .regular), textColor: UIColor.init(hex: 0x999999), alignment: .center)
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.titleLabel.snp.bottom).offset(self.titleCenterYTopMargin)
        }
        // 2. cancelBtn
        mainView.addSubview(self.cancelBtn)
        self.cancelBtn.set(title: "再看看", titleColor: UIColor.init(hex: 0xFFFFFF), for: .normal)
        self.cancelBtn.set(title: "再看看", titleColor: UIColor.init(hex: 0xFFFFFF), for: .highlighted)
        self.cancelBtn.set(font: UIFont.pingFangSCFont(size: 18, weight: .medium), cornerRadius: self.btnSize.height * 0.5)
        self.cancelBtn.backgroundColor = UIColor.init(hex: 0xCCCCCC)
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnClick(_:)), for: .touchUpInside)
        self.cancelBtn.snp.makeConstraints { (make) in
            make.size.equalTo(self.btnSize)
            make.leading.equalToSuperview().offset(self.btnLrMargin)
            make.top.equalToSuperview().offset(222)
            make.bottom.equalToSuperview().offset(-(kBottomHeight + 6))
        }
        // 3. doneBtn
        mainView.addSubview(self.doneBtn)
        self.doneBtn.set(title: "去绑定", titleColor: UIColor.white, for: .normal)
        self.doneBtn.set(title: "去绑定", titleColor: UIColor.white, for: .highlighted)
        self.doneBtn.set(font: UIFont.pingFangSCFont(size: 18, weight: .medium), cornerRadius: self.btnSize.height * 0.5)
        self.doneBtn.gradientLayer.colors = [AppColor.theme.cgColor, AppColor.theme.cgColor]
        self.doneBtn.gradientLayer.frame = CGRect.init(origin: CGPoint.zero, size: self.btnSize)
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.snp.makeConstraints { (make) in
            make.size.equalTo(self.btnSize)
            make.trailing.equalToSuperview().offset(-self.btnLrMargin)
            make.centerY.equalTo(self.cancelBtn)
        }
    }

}
// MARK: - Private UI Xib加载后处理
extension WithdrawBindAddressPopView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension WithdrawBindAddressPopView {

}

// MARK: - Event Function
extension WithdrawBindAddressPopView {
    /// 遮罩点击
    @objc func coverBtnClick(_ button: UIButton) -> Void {
        self.delegate?.popView(self, didClickedCover: button)
        self.removeFromSuperview()
    }
    /// 取消按钮点击
    @objc fileprivate func cancelBtnClick(_ button: UIButton) -> Void {
        self.delegate?.popView(self, didClickedCancel: button)
        self.removeFromSuperview()
    }
    /// 确定按钮点击
    @objc fileprivate func doneBtnClick(_ button: UIButton) -> Void {
        self.delegate?.popView(self, didClickedBind: button)
        self.removeFromSuperview()
    }

}

// MARK: - Extension Function
extension WithdrawBindAddressPopView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension WithdrawBindAddressPopView {

}
