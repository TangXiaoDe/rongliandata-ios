//
//  LoginNormalInputView.swift
//  ChuangYe
//
//  Created by 小唐 on 2020/8/17.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  登录相关中通用输入界面包装，仅做UI封装，不对控件的响应做任何处理；
//  注2：目前仅注册时的验证码用到；

import UIKit

typealias CommonNormalInputView = LoginNormalInputView
class LoginNormalInputView: UIView {

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

    fileprivate let lrMargin: CGFloat = 16
    
    fileprivate let iconLeftMargin: CGFloat = 16        // super.left
    fileprivate let titleLeftMargin: CGFloat = 16       // super.left
    fileprivate let iconCenterYTopMargin: CGFloat = 24 + 9.0  // super.top
    
    fileprivate let fieldHeight: CGFloat = 56
    fileprivate let fieldBottomMargin: CGFloat = 0


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
extension LoginNormalInputView {
    class func loadXib() -> LoginNormalInputView? {
        return Bundle.main.loadNibNamed("LoginNormalInputView", owner: nil, options: nil)?.first as? LoginNormalInputView
    }
}

// MARK: - LifeCircle Function
extension LoginNormalInputView {
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
extension LoginNormalInputView {

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
        self.iconView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.iconLeftMargin)
            make.centerY.equalTo(mainView.snp.top).offset(self.iconCenterYTopMargin)
        }
        // 2. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 16), textColor: AppColor.minorText)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.iconView)
            make.leading.equalToSuperview().offset(self.titleLeftMargin)
        }
        // 3. textField
        mainView.addSubview(self.textField)
        self.textField.set(placeHolder: nil, font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.mainText)
        self.textField.clearButtonMode = .whileEditing
        self.textField.backgroundColor = AppColor.inputBg.withAlphaComponent(0.5)
        self.textField.set(cornerRadius: 8, borderWidth: 0.5, borderColor: AppColor.dividing)
        self.textField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
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
extension LoginNormalInputView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }

}

// MARK: - Data Function
extension LoginNormalInputView {
    /// 数据加载
    fileprivate func setupWithModel(_ model: String?) -> Void {
        guard let _ = model else {
            return
        }
        // 子控件数据加载
    }

}

// MARK: - Event Function
extension LoginNormalInputView {

}

// MARK: - Extension Function
extension LoginNormalInputView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension LoginNormalInputView {

}
