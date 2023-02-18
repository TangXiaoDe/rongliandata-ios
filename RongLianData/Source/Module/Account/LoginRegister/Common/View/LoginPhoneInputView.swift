//
//  LoginPhoneInputView.swift
//  ChuangYe
//
//  Created by 小唐 on 2020/8/17.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  登录相关中手机号输入界面包装，仅做UI封装，不对控件的响应做任何处理；

import UIKit

typealias CommonPhoneInputView = LoginPhoneInputView
class LoginPhoneInputView: UIView {

    // MARK: - Internal Property

    static let viewHeight: CGFloat = 54 + 56

    var model: String? {
        didSet {
            self.setupWithModel(model)
        }
    }

    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    var icon: UIImage? {
        didSet {
            self.iconView.image = icon
        }
    }
    var placeholder: String = "" {
        didSet {
            self.textField.setPlaceHolder(placeholder, font: UIFont.pingFangSCFont(size: 18, weight: .medium), color: AppColor.inputPlaceHolder)
        }
    }

    // MARK: - Private Property

    let mainView: UIView = UIView()
    let iconView: UIImageView = UIImageView.init()
    let titleLabel: UILabel = UILabel.init()
    let textField: UITextField = UITextField.init()
    let areaCodeView: TitleIconControl = TitleIconControl.init()

    fileprivate let lrMargin: CGFloat = 16
    
    fileprivate let iconLeftMargin: CGFloat = 16        // super.left
    fileprivate let titleLeftMargin: CGFloat = 16       // super.left
    fileprivate let iconCenterYTopMargin: CGFloat = 24 + 9.0  // super.top
    
    fileprivate let fieldHeight: CGFloat = 56
    fileprivate let fieldBottomMargin: CGFloat = 0
    fileprivate lazy var fieldCenterYBottomMargin: CGFloat = {
        let margin: CGFloat = self.fieldBottomMargin + self.fieldHeight * 0.5
        return margin
    }()
    fileprivate let fieldLeftMargin: CGFloat = 16


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
extension LoginPhoneInputView {
    class func loadXib() -> LoginPhoneInputView? {
        return Bundle.main.loadNibNamed("LoginPhoneInputView", owner: nil, options: nil)?.first as? LoginPhoneInputView
    }
}

// MARK: - LifeCircle Function
extension LoginPhoneInputView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }

    /// 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()

    }

}
// MARK: - Private UI 手动布局
extension LoginPhoneInputView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. iconView
        mainView.addSubview(self.iconView)
        self.iconView.set(cornerRadius: 0)
        self.iconView.isHidden = true
        //self.iconView.image = UIImage.init(named: "IMG_login_icon_account")
        //self.iconView.image = UIImage.getIconFontImage(code: IconFont.login_account, fontSize: 16, color: AppColor.theme)
        self.iconView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.iconLeftMargin)
            make.centerY.equalTo(mainView.snp.top).offset(self.iconCenterYTopMargin)
            //make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        // 2. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: "账号", font: UIFont.pingFangSCFont(size: 16), textColor: AppColor.minorText)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.iconView)
            make.leading.equalToSuperview().offset(self.titleLeftMargin)
        }
        // 3. areaCodeView
        mainView.addSubview(self.areaCodeView)
        self.areaCodeView.isUserInteractionEnabled = false
        self.areaCodeView.isHidden = true   // AppConfig.share.registerType != .phone
        self.areaCodeView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.centerY.equalTo(mainView.snp.bottom).offset(-self.fieldCenterYBottomMargin)
        }
        self.areaCodeView.titleLabel.set(text: "+86", font: UIFont.pingFangSCFont(size: 15), textColor: AppColor.mainText)
        self.areaCodeView.titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview().offset(2)
            make.centerY.top.bottom.equalToSuperview()
        }
        self.areaCodeView.iconView.set(cornerRadius: 0)
        self.areaCodeView.iconView.image = UIImage.init(named: "IMG_login_triangle")
        self.areaCodeView.iconView.snp.remakeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 8, height: 4))
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.areaCodeView.titleLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-2)
        }
        // 4. textField
        mainView.addSubview(self.textField)
        self.textField.set(placeHolder: nil, font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.mainText)
        let strAccountPlaceHolder: String = "请输入手机号"
        self.textField.setPlaceHolder(strAccountPlaceHolder, font: UIFont.pingFangSCFont(size: 18, weight: .medium), color: AppColor.inputPlaceHolder)
        self.textField.backgroundColor = AppColor.inputBg.withAlphaComponent(0.5)
        self.textField.clearButtonMode = .whileEditing
        self.textField.autocorrectionType = .no
        self.textField.keyboardType = .phonePad //.numbersAndPunctuation
        self.textField.set(cornerRadius: 8, borderWidth: 0.5, borderColor: AppColor.dividing)
        self.textField.snp.makeConstraints { (make) in
            let leftMargin: CGFloat = self.lrMargin // AppConfig.share.registerType == .phone ? self.fieldLeftMargin : self.lrMargin
            make.leading.equalToSuperview().offset(leftMargin)   // self.fieldLeftMargin self.lrMargin
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.height.equalTo(self.fieldHeight)
            make.bottom.equalToSuperview().offset(-self.fieldBottomMargin)
        }
        self.textField.leftViewMode = .always
        self.textField.leftView = UIView.init(frame: CGRect.init(origin: .zero, size: .init(width: 24, height: 0)))
        let clearButton: UIButton = self.textField.value(forKey: "_clearButton") as! UIButton
        clearButton.setImage(UIImage(named: "IMG_login_icon_close"), for: .normal)
        clearButton.setImage(UIImage(named: "IMG_login_icon_close"), for: .highlighted)
    }

}
// MARK: - Private UI Xib加载后处理
extension LoginPhoneInputView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }

}

// MARK: - Data Function
extension LoginPhoneInputView {
    /// 数据加载
    fileprivate func setupWithModel(_ model: String?) -> Void {
        guard let _ = model else {
            return
        }
        // 子控件数据加载
    }

}

// MARK: - Event Function
extension LoginPhoneInputView {

}

// MARK: - Extension Function
extension LoginPhoneInputView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension LoginPhoneInputView {

}
