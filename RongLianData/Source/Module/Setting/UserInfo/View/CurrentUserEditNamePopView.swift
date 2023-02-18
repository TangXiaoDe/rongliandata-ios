//
//  AccountEditNickPopView.swift
//  ChuangYe
//
//  Created by zhaowei on 2020/8/19.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit
import ChainOneKit

protocol CurrentUserEditNamePopViewProtocol: class {
    /// 遮罩点击
    func popView(_ popView: CurrentUserEditNamePopView, didClickedCover cover: UIButton) -> Void
    /// 取消按钮点击
    func popView(_ popView: CurrentUserEditNamePopView, didClickedCancel cancelBtn: UIButton) -> Void
    /// 保存按钮点击
    func popView(_ popView: CurrentUserEditNamePopView, didClickedSave saveBtn: UIButton, name: String?) -> Void
}
extension CurrentUserEditNamePopView {
    /// 遮罩点击
    func popView(_ popView: CurrentUserEditNamePopView, didClickedCover cover: UIButton) -> Void {}
}

class CurrentUserEditNamePopView: UIView {

    // MARK: - Internal Property

    var model: String? {
        didSet {
            self.setupModel(model)
        }
    }

    weak var delegate: CurrentUserEditNamePopViewProtocol?

    // MARK: - Private Property

    let coverBtn: UIButton = UIButton.init(type: .custom)
    let mainView: UIView = UIView.init()
    let titleLabel: UILabel = UILabel.init()
    let inputTextField: UITextField = UITextField.init()
    let lineView: UIView = UIView.init()
    let tipsLabel: UILabel = UILabel.init()
    let doneBtn: UIButton = UIButton.init(type: .custom)
    let saveBtn: GradientLayerButton = GradientLayerButton.init()

    fileprivate let mainViewSize: CGSize = CGSize.init(width: 280, height: 208)
    fileprivate let lineTopMargin: CGFloat = 102
    fileprivate let lineLrMargin: CGFloat = 28
    fileprivate let btnLrMargin: CGFloat = 25
    fileprivate let btnSize: CGSize = CGSize.init(width: 100, height: 36)
    
    fileprivate let nameMaxLen: Int = 10

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
extension CurrentUserEditNamePopView {

}

// MARK: - LifeCircle Function
extension CurrentUserEditNamePopView {

}
// MARK: - Private UI 手动布局
extension CurrentUserEditNamePopView {

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
            make.size.equalTo(self.mainViewSize)
            make.center.equalToSuperview()
        }
    }
    /// mainView布局 - 子类可重写
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        //
        mainView.backgroundColor = UIColor.white
        mainView.set(cornerRadius: 10)
        //
        let titleCenYTopMargin: CGFloat = 32
        let doneBottomMargin: CGFloat = 24
        let inputCenterYTopMargin: CGFloat = 35
        // 1. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: "修改昵称", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor(hex: 0x333333), alignment: .center)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lineLrMargin)
            make.trailing.equalToSuperview().offset(-lineLrMargin)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(mainView.snp.top).offset(titleCenYTopMargin)
        }
        // 2. inputTextField
        mainView.addSubview(self.inputTextField)
        self.inputTextField.setPlaceHolder("请输入昵称", font: UIFont.pingFangSCFont(size: 15, weight: .medium), color: UIColor(hex: 0x999999))
        self.inputTextField.font = UIFont.pingFangSCFont(size: 15, weight: .medium)
        self.inputTextField.textColor = UIColor(hex: 0x4444FF) //UIColor(hex: 0x333333)
        self.inputTextField.textAlignment = .center
        self.inputTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        self.inputTextField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lineLrMargin)
            make.trailing.equalToSuperview().offset(-lineLrMargin)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.titleLabel.snp.bottom).offset(inputCenterYTopMargin)
            make.height.equalTo(30)
        }
        //
        mainView.addSubview(self.lineView)
        self.lineView.backgroundColor = UIColor(hex: 0xEEEEEE)
        self.lineView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.leading.equalToSuperview().offset(lineLrMargin)
            make.trailing.equalToSuperview().offset(-lineLrMargin)
            make.top.equalToSuperview().offset(lineTopMargin)
        }
        //
        mainView.addSubview(self.tipsLabel)
        self.tipsLabel.numberOfLines = 0
        self.tipsLabel.set(text: "*限10个字符以内，支持中英数字及下划线", font: UIFont.pingFangSCFont(size: 12), textColor: UIColor(hex: 0x666666), alignment: .center)
        self.tipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.lineView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(lineLrMargin)
            make.trailing.equalToSuperview().offset(-lineLrMargin)
        }
        // 3. doneBtn
        mainView.addSubview(self.doneBtn)
        self.doneBtn.set(title: "取消", titleColor: UIColor(hex: 0x999999), for: .normal)
        self.doneBtn.backgroundColor = UIColor(hex: 0xDDDDDD)
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.set(font: UIFont.pingFangSCFont(size: 15, weight: .medium))
        self.doneBtn.set(cornerRadius: self.btnSize.height * 0.5)
        self.doneBtn.snp.makeConstraints { (make) in
            make.size.equalTo(btnSize)
            make.leading.equalToSuperview().offset(btnLrMargin)
            make.bottom.equalToSuperview().offset(-doneBottomMargin)
        }
        mainView.addSubview(self.saveBtn)
        self.saveBtn.set(title: "保存", titleColor: .white, for: .normal)
        self.saveBtn.backgroundColor = UIColor(hex: 0x4444FF)
        self.saveBtn.addTarget(self, action: #selector(saveBtnClick(_:)), for: .touchUpInside)
        self.saveBtn.set(font: UIFont.pingFangSCFont(size: 15, weight: .medium))
        self.saveBtn.set(cornerRadius: self.btnSize.height * 0.5)
        self.saveBtn.gradientLayer.isHidden = true
        self.saveBtn.snp.makeConstraints { (make) in
            make.size.equalTo(btnSize)
            make.trailing.equalToSuperview().offset(-btnLrMargin)
            make.centerY.equalTo(self.doneBtn)
        }
    }

}
// MARK: - Private UI Xib加载后处理
extension CurrentUserEditNamePopView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension CurrentUserEditNamePopView {
    func setupModel(_ model: String?) {
        guard let model = model, !model.isEmpty else {
            return
        }
        self.inputTextField.text = model
        self.inputTextField.becomeFirstResponder()
    }
}

// MARK: - Event Function
extension CurrentUserEditNamePopView {
    /// 遮罩点击
    @objc func coverBtnClick(_ button: UIButton) -> Void {
        self.delegate?.popView(self, didClickedCover: button)
        self.removeFromSuperview()
    }
    /// 取消点击
    @objc fileprivate func doneBtnClick(_ button: UIButton) -> Void {
        self.delegate?.popView(self, didClickedCancel: button)
        self.removeFromSuperview()
    }
    /// 保存点击
    @objc fileprivate func saveBtnClick(_ button: UIButton) -> Void {
        self.delegate?.popView(self, didClickedSave: button, name: self.inputTextField.text)
        self.removeFromSuperview()
    }
    /// 输入框内容更新
    @objc fileprivate func textFieldChanged(_ textField: UITextField) -> Void {
        TextFieldHelper.limitTextField(textField, withMaxLen: self.nameMaxLen)
    }

}

// MARK: - Extension Function
extension CurrentUserEditNamePopView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension CurrentUserEditNamePopView {

}
