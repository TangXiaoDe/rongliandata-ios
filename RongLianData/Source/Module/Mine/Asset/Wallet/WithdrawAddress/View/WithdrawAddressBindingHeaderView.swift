//
//  WithdrawAddressBindingHeaderView.swift
//  HuoTuiVideo
//
//  Created by 小唐 on 2020/7/6.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  提币地址绑定头部视图

import UIKit

protocol WithdrawAddressBindingHeaderViewProtocol: class {
    /// 绑定按钮点击
    func headerView(_ view: WithdrawAddressBindingHeaderView, didClickBind address: String)
}

class WithdrawAddressBindingHeaderView: UIView
{
    // MARK: - Internal Property
    //static let viewHeight: CGFloat = 245
    var address: String? {
        return self.addressField.text
    }
    var delegate: WithdrawAddressBindingHeaderViewProtocol?
    // MARK: - Private Property
    fileprivate let mainView: UIView = UIView()
    // 提币地址相关
    fileprivate let addressInputPromptLabel: UILabel = UILabel.init()
    fileprivate let pasteBtn = UIButton.init(type: .custom)
    fileprivate let addressInputView: UIView = UIView.init()
    fileprivate let addressField: UITextField = UITextField.init()
    fileprivate let doneBtn: GradientLayerButton = GradientLayerButton.init(type: .custom)
    
    fileprivate let lrMargin: CGFloat = 10
    fileprivate let addressInputPromptCenterYTopMargin: CGFloat = 22     // mainView.top
    fileprivate let addressInputViewTopMargin: CGFloat = 22              // addressPrompt.centerY
    fileprivate let addressInputViewHeight: CGFloat = 56
    
    fileprivate let fieldHeight: CGFloat = 30
    fileprivate let fieldLrMargin: CGFloat = 12
    fileprivate let doneBtnHeight: CGFloat = 44
    fileprivate let doneBtnWidth: CGFloat = kScreenWidth - 20 * 2
    fileprivate let doneBtnTopMargin: CGFloat = 34
    fileprivate let doneBtnBottomMargin: CGFloat = kBottomHeight + 6
    
    fileprivate var limitSingleMinNum: Double = 1
    fileprivate var limitSingleMaxNum: Double = Double(Int.max)
    fileprivate var conversionDSTT: Double = 0
    
    
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
extension WithdrawAddressBindingHeaderView {
    class func loadXib() -> WithdrawAddressBindingHeaderView? {
        return Bundle.main.loadNibNamed("WithdrawAddressBindingHeaderView", owner: nil, options: nil)?.first as? WithdrawAddressBindingHeaderView
    }
}

// MARK: - LifeCircle Function
extension WithdrawAddressBindingHeaderView {
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
extension WithdrawAddressBindingHeaderView {
    
    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.backgroundColor = UIColor.white
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 5. addressInputPrompt
        mainView.addSubview(self.addressInputPromptLabel)
        self.addressInputPromptLabel.set(text: "请输入提现地址", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: UIColor.init(hex: 0x111112))
        self.addressInputPromptLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.centerY.equalTo(mainView.snp.top).offset(self.addressInputPromptCenterYTopMargin)
        }
        // pasteBtn
        mainView.addSubview(self.pasteBtn)
        self.pasteBtn.set(title: "粘贴", titleColor: UIColor.init(hex: 0x4444FF), for: .normal)
        self.pasteBtn.set(font: UIFont.pingFangSCFont(size: 14))
        self.pasteBtn.addTarget(self, action: #selector(pasteBtnClick(_:)), for: .touchUpInside)
        self.pasteBtn.snp.makeConstraints { (make) in
            make.width.equalTo(54)
            make.height.equalTo(44)
            make.right.equalToSuperview()
            make.centerY.equalTo(self.addressInputPromptLabel)
        }
        // 6. addressInputView
        mainView.addSubview(self.addressInputView)
        self.initialAddressInputView(self.addressInputView)
        self.addressInputView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.addressInputPromptLabel.snp.centerY).offset(self.addressInputViewTopMargin)
            make.height.equalTo(self.addressInputViewHeight)
        }
        // 2. doneBtn
        mainView.addSubview(self.doneBtn)
        self.doneBtn.set(title: "立即绑定", titleColor: UIColor.white, for: .normal)
        self.doneBtn.set(title: "立即绑定", titleColor: UIColor.white, for: .highlighted)
        self.doneBtn.set(font: UIFont.pingFangSCFont(size: 18, weight: .medium), cornerRadius: self.doneBtnHeight * 0.5)
        self.doneBtn.backgroundColor = UIColor.init(hex: 0xDDDDDD)
        self.doneBtn.gradientLayer.frame = CGRect.init(x: 0, y: 0, width: self.doneBtnWidth, height: self.doneBtnHeight)
        self.doneBtn.isEnabled = false
        self.doneBtn.gradientLayer.isHidden = !self.doneBtn.isEnabled
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview().offset(self.lrMargin)
//            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.doneBtnWidth)
//            make.top.equalTo(self.addressInputView.snp.bottom).offset(self.doneBtnTopMargin)
            make.bottom.equalToSuperview().offset(-self.doneBtnBottomMargin)
            make.height.equalTo(self.doneBtnHeight)
        }

    }
    fileprivate func initialAddressInputView(_ addressInputView: UIView) -> Void {
        addressInputView.backgroundColor = UIColor.init(hex: 0xF9F9F9)
        addressInputView.set(cornerRadius: 5)
        // addressField
        addressInputView.addSubview(self.addressField)
        self.addressField.set(placeHolder: nil, font: UIFont.pingFangSCFont(size: 18), textColor: UIColor.init(hex: 0x333333))
        self.addressField.attributedPlaceholder = NSAttributedString.init(string: "请输入提现地址", attributes: [NSAttributedString.Key.font: UIFont.pingFangSCFont(size: 18), NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xCCCCCC)])
        self.addressField.addTarget(self, action: #selector(addressFieldValueChanged(_:)), for: .editingChanged)
        self.addressField.snp.makeConstraints { (make) in
            make.height.equalTo(self.fieldHeight)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(self.fieldLrMargin)
            make.trailing.equalToSuperview().offset(-self.fieldLrMargin)
        }
    }
}
// MARK: - Private UI Xib加载后处理
extension WithdrawAddressBindingHeaderView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }

}

// MARK: - Data Function
extension WithdrawAddressBindingHeaderView {
    fileprivate func couldDone() -> Bool {
        var couldDone = false
        guard let address = self.addressField.text else {
            return couldDone
        }
        couldDone = !address.isEmpty
        return couldDone
    }
    fileprivate func couldDoneProcess() -> Void {
        self.doneBtn.isEnabled = self.couldDone()
        self.doneBtn.gradientLayer.isHidden = !self.couldDone()
    }
}

// MARK: - Event Function
extension WithdrawAddressBindingHeaderView {
    /// 地址输入框内容变更
    @objc fileprivate func addressFieldValueChanged(_ numField: UITextField) -> Void {
        self.couldDoneProcess()
    }
    /// 粘贴
    @objc fileprivate func pasteBtnClick(_ btn: UIButton) {
        let pasteStr = UIPasteboard.general.string
        if let pasteStr = pasteStr {
            self.addressField.text = pasteStr
            self.couldDoneProcess()
        }
    }
}

// MARK: - Event Function
extension WithdrawAddressBindingHeaderView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    /// 确定按钮点击
    @objc fileprivate func doneBtnClick(_ doneBtn: UIButton) -> Void {
        self.endEditing(true)
        guard let address = self.addressField.text else {
            return
        }
        // 1. 判断地址前缀是否以"0x"开头
//        if address.uppercased().hasPrefix("F") && address.count == 41 {
            self.delegate?.headerView(self, didClickBind: address)
//            return
//        } else {
//            Toast.showToast(title: "提现地址应以f开头且41位")
//        }
    }
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension WithdrawAddressBindingHeaderView {

}
