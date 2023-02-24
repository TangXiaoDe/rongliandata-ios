//
//  PasswordLoginView.swift
//  ChuangYe
//
//  Created by 小唐 on 2020/8/14.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  登录密码登录视图

import UIKit
import ChainOneKit

class PasswordLoginView: UIView {

    // MARK: - Internal Property

    var model: String? {
        didSet {
            self.setupWithModel(model)
        }
    }

    var inputChangedAction: ((_ inputView: PasswordLoginView) -> Void)?

    var account: String? {
        return self.phoneView.textField.text
    }
    var password: String? {
        return self.passwordView.textField.text
    }

    // MARK: - Private Property

    let mainView: UIView = UIView()
    let phoneView: LoginPhoneInputView = LoginPhoneInputView.init()
    let passwordView: LoginPasswordInputView = LoginPasswordInputView.init()

    fileprivate let infoHeight: CGFloat = LoginNormalInputView.viewHeight
    fileprivate let verMargin: CGFloat = LoginNormalInputView.verMargin
    
    fileprivate let accountMaxLen: Int = 11
    fileprivate let passwordMaxLen: Int = 20


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
extension PasswordLoginView {
    class func loadXib() -> PasswordLoginView? {
        return Bundle.main.loadNibNamed("PasswordLoginView", owner: nil, options: nil)?.first as? PasswordLoginView
    }

    func couldDone() -> Bool {
        var flag: Bool = false
        guard let account = self.phoneView.textField.text, let password = self.passwordView.textField.text else {
            return flag
        }
        flag = !account.isEmpty && !password.isEmpty
        return flag
    }

}

// MARK: - LifeCircle Function
extension PasswordLoginView {
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
extension PasswordLoginView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. phone
        mainView.addSubview(self.phoneView)
        self.phoneView.textField.addTarget(self, action: #selector(textFieldValueChainge(_:)), for: .editingChanged)
        self.phoneView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.infoHeight)
        }
        // 2. password
        mainView.addSubview(self.passwordView)
        self.passwordView.textField.addTarget(self, action: #selector(textFieldValueChainge(_:)), for: .editingChanged)
        self.passwordView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.phoneView.snp.bottom).offset(self.verMargin)
            make.height.equalTo(self.infoHeight)
        }
    }

}
// MARK: - Private UI Xib加载后处理
extension PasswordLoginView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension PasswordLoginView {
    /// 数据加载
    fileprivate func setupWithModel(_ model: String?) -> Void {
        guard let _ = model else {
            return
        }
        // 子控件数据加载
    }

}

// MARK: - Event Function
extension PasswordLoginView {

    /// 输入框输入值变更
    @objc fileprivate func textFieldValueChainge(_ textField: UITextField) -> Void {
        switch textField {
        case self.phoneView.textField:
            TextFieldHelper.limitTextField(textField, withMaxLen: self.accountMaxLen)
            self.inputChangedAction?(self)
        case self.passwordView.textField:
            TextFieldHelper.limitTextField(textField, withMaxLen: self.passwordMaxLen)
            self.inputChangedAction?(self)
        default:
            break
        }
    }

    /// 账号清除按钮点击
    @objc fileprivate func accountClearBtnClick(_ button: UIButton) -> Void {
        //self.accountField.text = nil
        //self.inputChangedAction?(self)
    }

}

// MARK: - Extension Function
extension PasswordLoginView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension PasswordLoginView {

}
