//
//  LoginPasswordInputView.swift
//  ChuangYe
//
//  Created by 小唐 on 2020/8/17.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  登录相关中密码输入界面包装，仅做UI封装，不对输入控件的响应做任何处理；
//  注1：右侧按钮响应添加，处理密码输入框的安全性问题；

import UIKit

typealias CommonPasswordInputView = LoginPasswordInputView
class LoginPasswordInputView: UIView {

    // MARK: - Internal Property

    static let viewHeight: CGFloat = 50

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
    // TODO: - textfieldBg 需要更名为fieldContainer
    let textfieldBg = UIView.init()
    let textField: UITextField = UITextField.init()
    let pwdSecureBtn: UIButton = UIButton.init(type: .custom)

    
    fileprivate let lrMargin: CGFloat = 0
    
    fileprivate let iconLeftMargin: CGFloat = 16        // super.left
    fileprivate let titleLeftMargin: CGFloat = 16       // super.left
    fileprivate let iconCenterYTopMargin: CGFloat = 24 + 9.0  // super.top
    
    let fieldHeight: CGFloat = 50
    fileprivate let fieldBottomMargin: CGFloat = 0
    fileprivate lazy var fieldCenterYBottomMargin: CGFloat = {
        let margin: CGFloat = self.fieldBottomMargin + self.fieldHeight * 0.5
        return margin
    }()
    fileprivate let fieldLeftMargin: CGFloat = 16

    fileprivate let pwdSecureSize: CGSize = CGSize.init(width: 28 + 10, height: 44)


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
extension LoginPasswordInputView {
    class func loadXib() -> LoginPasswordInputView? {
        return Bundle.main.loadNibNamed("LoginPasswordInputView", owner: nil, options: nil)?.first as? LoginPasswordInputView
    }
}

// MARK: - LifeCircle Function
extension LoginPasswordInputView {
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
extension LoginPasswordInputView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
//        // 1. iconView
//        mainView.addSubview(self.iconView)
//        self.iconView.set(cornerRadius: 0)
//        self.iconView.isHidden = true
//        //self.iconView.image = UIImage.init(named: "IMG_login_icon_password")
//        //self.iconView.image = UIImage.getIconFontImage(code: IconFont.login_password, fontSize: 16, color: AppColor.theme)
//        self.iconView.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview().offset(self.iconLeftMargin)
//            make.centerY.equalTo(mainView.snp.top).offset(self.iconCenterYTopMargin)
//            //make.size.equalTo(CGSize.init(width: 16, height: 16))
//        }
//        // 2. titleLabel
//        mainView.addSubview(self.titleLabel)
//        self.titleLabel.set(text: "密码", font: UIFont.pingFangSCFont(size: 16), textColor: AppColor.minorText)
//        self.titleLabel.snp.makeConstraints { (make) in
//            make.centerY.equalTo(self.iconView)
//            make.leading.equalToSuperview().offset(self.titleLeftMargin)
//        }
        // textfieldBg
        mainView.addSubview(self.textfieldBg)
        self.textfieldBg.backgroundColor = AppColor.inputBg.withAlphaComponent(0.5)
        self.textfieldBg.set(cornerRadius: self.fieldHeight * 0.5, borderWidth: 0, borderColor: AppColor.dividing)
        self.textfieldBg.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.bottom.equalToSuperview()
        }
        // 3. textField
        self.textfieldBg.addSubview(self.textField)
        self.textField.set(placeHolder: nil, font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.mainText)
        self.textField.setPlaceHolder("请输入密码", font: UIFont.pingFangSCFont(size: 18, weight: .medium), color: AppColor.inputPlaceHolder)
        self.textField.isSecureTextEntry = true
        self.textField.clearButtonMode = .whileEditing
        self.textField.keyboardType = .asciiCapable
        self.textField.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalToSuperview()
        }
        self.textField.leftViewMode = .always
        self.textField.leftView = UIView.init(frame: CGRect.init(origin: .zero, size: .init(width: 20, height: 0)))
        let clearButton: UIButton = self.textField.value(forKey: "_clearButton") as! UIButton
        clearButton.setImage(UIImage(named: "IMG_login_icon_close"), for: .normal)
        clearButton.setImage(UIImage(named: "IMG_login_icon_close"), for: .highlighted)
        // 4. pwdSecureBtn
        self.textfieldBg.addSubview(self.pwdSecureBtn)
        self.pwdSecureBtn.setImage(UIImage.init(named: "IMG_login_icon_eyeson"), for: .normal)      //
        self.pwdSecureBtn.setImage(UIImage.init(named: "IMG_login_icon_eyesoff"), for: .selected)  //
        //self.pwdSecureBtn.contentHorizontalAlignment = .right
        self.pwdSecureBtn.isSelected = true
        //self.pwdSecureBtn.isHidden = true
        self.pwdSecureBtn.addTarget(self, action: #selector(pwdSecureBtnClick(_:)), for: .touchUpInside)
        self.pwdSecureBtn.snp.makeConstraints { (make) in
            make.size.equalTo(self.pwdSecureSize)
            make.centerY.equalTo(self.textField)
            make.trailing.equalToSuperview()
            make.leading.equalTo(self.textField.snp.trailing)
        }
    }

}
// MARK: - Private UI Xib加载后处理
extension LoginPasswordInputView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }

}

// MARK: - Data Function
extension LoginPasswordInputView {
    /// 数据加载
    fileprivate func setupWithModel(_ model: String?) -> Void {
        guard let _ = model else {
            return
        }
        // 子控件数据加载
    }

}

// MARK: - Event Function
extension LoginPasswordInputView {
    /// 密码安全性按钮点击
    @objc fileprivate func pwdSecureBtnClick(_ button: UIButton) -> Void {
        button.isSelected = !button.isSelected
        self.textField.isSecureTextEntry = button.isSelected
    }

}

// MARK: - Extension Function
extension LoginPasswordInputView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension LoginPasswordInputView {

}
