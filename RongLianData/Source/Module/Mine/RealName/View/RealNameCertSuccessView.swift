//
//  RealNameCertSuccessView.swift
//  SassProject
//
//  Created by crow on 2021/7/21.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit

class RealNameCertSuccessView: UIView {

    // MARK: - Internal Property

    var model: RealNameCertModel? {
        didSet {
            self.setupWithModel(model)
        }
    }

    // MARK: - Private Property
    let mainView: UIView = UIView()

    let topView: UIView = UIView()
    let statusLabel: UILabel = UILabel()
    let statusImgV: UIImageView = UIImageView()
    let nameLabel: UILabel = UILabel()
    let numberLabel: UILabel = UILabel()

    let bottomView: UIView = UIView()

    fileprivate let lrMargin: CGFloat = 12
    fileprivate let topViewMargin: CGFloat = 50
    fileprivate let imgVSize: CGSize = CGSize.init(width: 107, height: 73)

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

// MARK: - Private UI 手动布局
extension RealNameCertSuccessView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = AppColor.white
        // 1. topView
        mainView.addSubview(self.topView)
        self.initialTopView(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
        }
        // 2. bottomView
        mainView.addSubview(self.bottomView)
        self.initailBottomView(self.bottomView)
        self.bottomView.snp.makeConstraints { make in
            make.top.equalTo(self.topView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    fileprivate func initialTopView(_ topView: UIView) {
        topView.addSubview(self.statusLabel)
        self.statusLabel.set(text: "* 恭喜您，认证成功！", font: UIFont.systemFont(ofSize: 12), textColor: UIColor.init(hex: 0x27BF4E))
        self.statusLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.lrMargin)
            make.leading.equalToSuperview().offset(lrMargin)
            make.trailing.equalToSuperview().offset(-lrMargin)
        }
        topView.addSubview(self.statusImgV)
        self.statusImgV.image = UIImage(named: "IMG_icon_certification_success")
        self.statusImgV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(self.imgVSize)
            make.top.equalTo(self.statusLabel.snp.bottom).offset(self.topViewMargin)
            make.bottom.equalToSuperview().offset(-self.topViewMargin)
        }
    }
    fileprivate func initailBottomView(_ bottomView: UIView) {
        let titleLabel: UILabel = UILabel()
        titleLabel.set(text: "认证信息", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.mainText)
        bottomView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.top.equalToSuperview()
        }
        bottomView.addSubview(self.nameLabel)
        self.nameLabel.set(text: "真实姓名", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.mainText)
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        bottomView.addSubview(self.numberLabel)
        self.numberLabel.set(text: "身份证号", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.mainText)
        self.numberLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(self.nameLabel)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Data Function
extension RealNameCertSuccessView {
    ///
    fileprivate func setupWithModel(_ model: RealNameCertModel?) -> Void {
        guard let model = model else {
            return
        }
        let mAttrName = NSMutableAttributedString.init(string: "真实姓名  ", attributes: [NSAttributedString.Key.font: UIFont.pingFangSCFont(size: 16)])
        
        mAttrName.append(NSAttributedString.init(string: XDStringHelper.nameMaskProcess(model.name), attributes: [NSAttributedString.Key.font: UIFont.pingFangSCFont(size: 18, weight: .medium)]))
        self.nameLabel.attributedText = mAttrName
        let mAttrNumber = NSMutableAttributedString.init(string: "身份证号  ", attributes: [NSAttributedString.Key.font: UIFont.pingFangSCFont(size: 16)])
        mAttrNumber.append(NSAttributedString.init(string: XDStringHelper.idCardNoMaskProcess(model.idNumber) ?? "", attributes: [NSAttributedString.Key.font: UIFont.pingFangSCFont(size: 18, weight: .medium)]))
        self.numberLabel.attributedText = mAttrNumber
    }
}

// MARK: - Event Function
extension RealNameCertSuccessView {

}

// MARK: - Extension Function
extension RealNameCertSuccessView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension RealNameCertSuccessView: UITextFieldDelegate {


}
