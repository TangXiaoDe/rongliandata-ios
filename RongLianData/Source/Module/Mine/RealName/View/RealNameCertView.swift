//
//  RealNameCertView.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  实名认证视图

import UIKit
import ChainOneKit

protocol RealNameCertViewProtocol: class {
    /// 身份证正面照
    func certView(_ certView: RealNameCertView, didClickedIdCardFont frontBtn: UIButton) -> Void
    /// 身份证背面照
    func certView(_ certView: RealNameCertView, didClickedIdCardBack backBtn: UIButton) -> Void
    /// 手持照
    func certView(_ certView: RealNameCertView, didClickedHandHold holdBtn: UIButton) -> Void
}

class RealNameCertView: UIView {

    // MARK: - Internal Property

    /// 回调
    weak var delegate: RealNameCertViewProtocol?

    var model: RealNameCertModel? {
        didSet {
            self.setupWithModel(model)
        }
    }

    // MARK: - Private Property

    let mainView: UIView = UIView()

    let topView: UIView = UIView()
    let statusLabel: UILabel = UILabel()

    let idCardInputView: UIView = UIView()
    let inputPromptLabel: UILabel = UILabel()
    let nameField: UITextField = UITextField()
    let idNumField: UITextField = UITextField()

    let idCardPhotoView: UIView = UIView()
    let photoPromptLabel: UILabel = UILabel()
    let idCardFrontBtn: UIButton = UIButton(type: .custom)  // 身份证正面照
    let idCardBackBtn: UIButton = UIButton(type: .custom)   // 身份证背面照
    let handHoldBtn: UIButton = UIButton(type: .custom)     // 手持照
    let photoTipsLabel: UILabel = UILabel()

    fileprivate let lrMargin: CGFloat = 12
    fileprivate let topViewH: CGFloat = 40
    fileprivate let inputFieldH: CGFloat = 56
    fileprivate let idCardImgBtnH: CGFloat = CGSize(width: 351, height: 189).scaleAspectForWidth(kScreenWidth - 24).height

    fileprivate let inputPromptTopMargin: CGFloat = 22
    fileprivate let nameFieldTopMargin: CGFloat = 15
    fileprivate let idFieldTopMargin: CGFloat = 12
    fileprivate let photoPromptTopMargin: CGFloat = 22
    fileprivate let idFrontImgTopMargin: CGFloat = 15
    fileprivate let idBackImgTopMargin: CGFloat = 22
    fileprivate let handHoldImgTopMargin: CGFloat = 22
    fileprivate let tipsTopMargin: CGFloat = 22
    fileprivate let tipsBottomMargin: CGFloat = 22

    fileprivate let idNumMaxLen: Int = 18

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
extension RealNameCertView {
    class func loadXib() -> RealNameCertView? {
        return Bundle.main.loadNibNamed("RealNameCertView", owner: nil, options: nil)?.first as? RealNameCertView
    }
}

// MARK: - LifeCircle Function
extension RealNameCertView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension RealNameCertView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = AppColor.pageBg
        // 1. topView
        mainView.addSubview(self.topView)
        self.topView.backgroundColor = AppColor.minor
        self.topView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.topViewH)
        }
        self.topView.addSubview(self.statusLabel)
        self.statusLabel.set(text: "* 实名认证后的身份信息不可更改", font: UIFont.systemFont(ofSize: 13), textColor: AppColor.themeRed)
        self.statusLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.centerY.equalToSuperview()
        }
        // 2. idCardInputView
        mainView.addSubview(self.idCardInputView)
        self.initialIdCardInputView(self.idCardInputView)
        self.idCardInputView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom)
        }
        // 3. idCardPhotoView
        mainView.addSubview(self.idCardPhotoView)
        self.initialIdCardPhotoView(self.idCardPhotoView)
        self.idCardPhotoView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.idCardInputView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    fileprivate func initialIdCardInputView(_ inputView: UIView) -> Void {
        // 1. inputPrompt
        inputView.addSubview(self.inputPromptLabel)
        self.inputPromptLabel.set(text: "请填写需要认证的身份信息", font: UIFont.pingFangSCFont(size: 14), textColor: AppColor.mainText)
        self.inputPromptLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.top.equalToSuperview().offset(inputPromptTopMargin)
        }
        // 2. nameInput
        let nameInputView: UIView = UIView()
        inputView.addSubview(nameInputView)
        nameInputView.set(cornerRadius: 5)
        nameInputView.backgroundColor = .white
        nameInputView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.inputPromptLabel)
            make.height.equalTo(self.inputFieldH)
            make.top.equalTo(self.inputPromptLabel.snp.bottom).offset(nameFieldTopMargin)
        }
        let nameLeftLabel: UILabel = UILabel.init()
        nameInputView.addSubview(nameLeftLabel)
        nameLeftLabel.set(text: "真实姓名", font: UIFont.pingFangSCFont(size: 16), textColor: AppColor.mainText, alignment: .center)
        nameLeftLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview().offset(-1)
            make.width.equalTo(85)
        }
        nameInputView.addSubview(self.nameField)
        self.nameField.set(placeHolder: nil, font: UIFont.pingFangSCFont(size: 16), textColor: AppColor.mainText)
        self.nameField.attributedPlaceholder = NSAttributedString.init(string: "请如实填写", attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder])
        self.nameField.snp.makeConstraints { (make) in
            make.top.bottom.centerY.equalToSuperview()
            make.leading.equalTo(nameLeftLabel.snp.trailing)
            make.trailing.equalToSuperview()
        }
        // 3. idnoInput
        let idnoInputView: UIView = UIView()
        inputView.addSubview(idnoInputView)
        idnoInputView.set(cornerRadius: 5)
        idnoInputView.backgroundColor = .white
        idnoInputView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(nameInputView)
            make.height.equalTo(self.inputFieldH)
            make.top.equalTo(nameInputView.snp.bottom).offset(idFieldTopMargin)
            make.bottom.equalToSuperview()
        }
        let idnoLeftLabel: UILabel = UILabel.init()
        idnoInputView.addSubview(idnoLeftLabel)
        idnoLeftLabel.set(text: "身份证号", font: UIFont.pingFangSCFont(size: 16), textColor: AppColor.mainText, alignment: .center)
        idnoLeftLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview().offset(-1)
            make.width.equalTo(85)
        }
        idnoInputView.addSubview(self.idNumField)
        self.idNumField.set(placeHolder: nil, font: UIFont.pingFangSCFont(size: 16), textColor: AppColor.mainText)
        self.idNumField.attributedPlaceholder = NSAttributedString.init(string: "请如实填写", attributes: [NSAttributedString.Key.foregroundColor: AppColor.inputPlaceHolder ])
        self.idNumField.keyboardType = .asciiCapable
        self.idNumField.delegate = self
        self.idNumField.snp.makeConstraints { (make) in
            make.top.bottom.centerY.equalToSuperview()
            make.leading.equalTo(nameLeftLabel.snp.trailing)
            make.trailing.equalToSuperview()
        }
    }
    fileprivate func initialIdCardPhotoView(_ photoView: UIView) -> Void {
        let photoDescTopMargin: CGFloat = 12
        // 1. photoPrompt
        photoView.addSubview(self.photoPromptLabel)
        self.photoPromptLabel.set(text: "请点击上传以下图片便于认证审核", font: UIFont.pingFangSCFont(size: 14), textColor: AppColor.mainText)
        self.photoPromptLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.top.equalToSuperview().offset(photoPromptTopMargin)
        }
        // 2. frontPhoto
        photoView.addSubview(self.idCardFrontBtn)
        self.idCardFrontBtn.set(cornerRadius: 5)
        self.idCardFrontBtn.addTarget(self, action: #selector(idCardFrontBtnClick(_:)), for: .touchUpInside)
        self.idCardFrontBtn.setBackgroundImage(UIImage.init(named: "IMG_icon_certification_front"), for: .normal)
        self.idCardFrontBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.photoPromptLabel)
            make.height.equalTo(self.idCardImgBtnH)
            make.top.equalTo(self.photoPromptLabel.snp.bottom).offset(idFrontImgTopMargin)
        }
        let idCardFrontPromptLabel: UILabel = UILabel()
        idCardFrontPromptLabel.set(text: "身份证正面", font: UIFont.pingFangSCFont(size: 15), textColor: AppColor.mainText, alignment: .center)
        photoView.addSubview(idCardFrontPromptLabel)
        idCardFrontPromptLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.photoPromptLabel)
            make.top.equalTo(self.idCardFrontBtn.snp.bottom).offset(photoDescTopMargin)
        }
        // 3. backPhoto
        photoView.addSubview(self.idCardBackBtn)
        self.idCardBackBtn.set(cornerRadius: 5)
        self.idCardBackBtn.addTarget(self, action: #selector(idCardBackBtnClick(_:)), for: .touchUpInside)
        self.idCardBackBtn.setBackgroundImage(UIImage.init(named: "IMG_icon_certification_verso"), for: .normal)
        self.idCardBackBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.photoPromptLabel)
            make.height.equalTo(self.idCardImgBtnH)
            make.top.equalTo(idCardFrontPromptLabel.snp.bottom).offset(self.idBackImgTopMargin)
        }
        let idCardBackPromptLabel: UILabel = UILabel()
        idCardBackPromptLabel.set(text: "身份证反面", font: UIFont.pingFangSCFont(size: 15), textColor: AppColor.mainText, alignment: .center)
        photoView.addSubview(idCardBackPromptLabel)
        idCardBackPromptLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.photoPromptLabel)
            make.top.equalTo(self.idCardBackBtn.snp.bottom).offset(photoDescTopMargin)
        }
        // 4. handHold
        photoView.addSubview(self.handHoldBtn)
        self.handHoldBtn.set(cornerRadius: 5)
        self.handHoldBtn.addTarget(self, action: #selector(handHoldBtnClick(_:)), for: .touchUpInside)
        self.handHoldBtn.setBackgroundImage(UIImage.init(named: "IMG_icon_certification_other"), for: .normal)
        self.handHoldBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.photoPromptLabel)
            make.height.equalTo(self.idCardImgBtnH)
            make.top.equalTo(idCardBackPromptLabel.snp.bottom).offset(self.handHoldImgTopMargin)
        }
        let handHoldBtnPromptLabel: UILabel = UILabel()
        photoView.addSubview(handHoldBtnPromptLabel)
        handHoldBtnPromptLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 15), textColor: AppColor.mainText, alignment: .center)
        let headAtt: NSAttributedString = NSAttributedString.init(string: "手持身份证+签名", attributes: [NSAttributedString.Key.font: UIFont.pingFangSCFont(size: 15)])
        let tailAtt: NSAttributedString = NSAttributedString.init(string: "（融链+姓名+日期）", attributes: [NSAttributedString.Key.font: UIFont.pingFangSCFont(size: 12)])
        let holdAtt: NSMutableAttributedString = NSMutableAttributedString.init()
        holdAtt.append(headAtt)
        holdAtt.append(tailAtt)
        handHoldBtnPromptLabel.attributedText = holdAtt
        handHoldBtnPromptLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.photoPromptLabel)
            make.top.equalTo(self.handHoldBtn.snp.bottom).offset(photoDescTopMargin)
        }
        // 5. tips
        photoView.addSubview(self.photoTipsLabel)
        self.photoTipsLabel.numberOfLines = 0
        let tips: String = "注意：\n1.支持小于8M的jpg、jpge、png格式图片；\n2.照片要求清晰，不允许任何修改和遮挡，必须能看清人像、证件 号和姓名；\n3.照片需免冠，建议未化妆，手持证件人的五官清晰可见，完整漏出手臂；\n4.需要一张本人同时手持证件正面和个人手写文案的照片，手写内 容包括：融链+姓名+日期；"
        self.photoTipsLabel.set(text: tips, font: UIFont.pingFangSCFont(size: 14), textColor: AppColor.minorText)
        self.photoTipsLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.top.equalTo(handHoldBtnPromptLabel.snp.bottom).offset(tipsTopMargin)
            make.bottom.equalToSuperview().offset(-tipsBottomMargin)
        }
    }

}
// MARK: - Private UI Xib加载后处理
extension RealNameCertView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension RealNameCertView {
    ///
    fileprivate func setupWithModel(_ model: RealNameCertModel?) -> Void {
        guard let model = model else {
            return
        }
        switch model.status {
        case .wait:
            self.statusLabel.text = "* 资料审核中，请耐心等待！"
            self.statusLabel.textColor = AppColor.themeRed
            //
            self.nameField.text = model.name
            self.idNumField.text = model.idNumber
            self.idCardFrontBtn.kf.setBackgroundImage(with: model.frontUrl, for: .normal, placeholder: UIImage.init(named: "IMG_icon_certification_front"), options: nil, progressBlock: nil, completionHandler: nil)
            self.idCardBackBtn.kf.setBackgroundImage(with: model.backUrl, for: .normal, placeholder: UIImage.init(named: "IMG_icon_certification_verso"), options: nil, progressBlock: nil, completionHandler: nil)
            self.handHoldBtn.kf.setBackgroundImage(with: model.handUrl, for: .normal, placeholder: UIImage.init(named: "IMG_icon_certification_other"), options: nil, progressBlock: nil, completionHandler: nil)
        case .success:
            self.statusLabel.text = "* 恭喜你，认证成功！" // model.desc ?? "* 恭喜你，认证成功！"
            self.statusLabel.textColor = UIColor.init(hex: 0x27BF4E)
            //
            self.nameField.text = XDStringHelper.nameMaskProcess(model.name)
            self.idNumField.text = XDStringHelper.idCardNoMaskProcess(model.idNumber)
            // 认证成功后的特殊处理
            self.inputPromptLabel.text = "认证信息"
            self.idCardPhotoView.removeAllSubView()
        case .failure:
            self.statusLabel.text = "* 认证审核失败，请重新提交！" // model.reason ?? "* 认证审核失败，请重新提交！"
            self.statusLabel.textColor = AppColor.themeRed
        }

    }
}

// MARK: - Event Function
extension RealNameCertView {
    /// 图片点击
    @objc fileprivate func idCardFrontBtnClick(_ button: UIButton) -> Void {
        self.delegate?.certView(self, didClickedIdCardFont: button)
    }
    @objc fileprivate func idCardBackBtnClick(_ button: UIButton) -> Void {
        self.delegate?.certView(self, didClickedIdCardBack: button)
    }
    @objc fileprivate func handHoldBtnClick(_ button: UIButton) -> Void {
        self.delegate?.certView(self, didClickedHandHold: button)
    }
    // 身份证号输入框内容变更
    @objc fileprivate func idNumFieldValueChanged(_ textField: UITextField) -> Void {
        TextFieldHelper.limitTextField(textField, withMaxLen: self.idNumMaxLen)
    }

}

// MARK: - Extension Function
extension RealNameCertView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension RealNameCertView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != self.idNumField {
            return true
        }
        if string.isEmpty {
            return true
        }
        let chars: String = "01234567890xX"
        let cs: CharacterSet = CharacterSet.init(charactersIn: chars)
        let filters = string.components(separatedBy: cs)
        var filtered: String = ""
        filters.forEach { (strFilter) in
            filtered.append(strFilter)
        }
        let isBasicText: Bool = filtered != string
        return isBasicText
    }

}
