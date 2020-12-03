//
//  PasswordInputView.swift
//  iMeet
//
//  Created by 小唐 on 2019/1/16.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  方框密码输入框
//  注：输入的是6位纯数字

import UIKit

protocol PasswordInputViewProtocol: class {
    /// 密码改变的回调
    func pwdInputView(_ pwdInputView: PasswordInputView, didPasswordChanged password: String) -> Void
}

class PasswordInputView: UIView {

    // MARK: - Internal Property

    let count: Int = 6  // 最大位数
    let viewWidth: CGFloat
    // 固定itemWidth，而不固定spacing，而itemHeight跟整体高度一致，由外界确定
    let itemWidth: CGFloat
    //let spacing: CGFloat = 10

    let itemStyle: PasswordInputItemView.Style

    var secureTextEntry: Bool = true {
        didSet {
            for itemView in self.itemViewList {
                itemView.secureTextEntry = secureTextEntry
            }
        }
    }

    var itemLineColor: UIColor = AppColor.theme {
        didSet {
            for itemView in self.itemViewList {
                itemView.lineColor = itemLineColor
            }
        }
    }
    var itemSecureTextColor: UIColor = AppColor.theme {
        didSet {
            for itemView in self.itemViewList {
                itemView.secureTextColor = itemSecureTextColor
            }
        }
    }

    var password: String? {
        get {
            return self.textField.text
        }
        set {
            self.textField.text = newValue
            self.textFieldValueChanged(self.textField)
        }
    }
    func clear() -> Void {
        self.password = nil
    }

    var isFinish: Bool {
        var flag: Bool = false
        guard let password = self.password else {
            return flag
        }
        flag = password.count == self.count
        return flag
    }

    /// 代理
    weak var delegate: PasswordInputViewProtocol?

    // MARK: - Private Property

    let textField: UITextField = UITextField()
    fileprivate var itemViewList: [PasswordInputItemView] = []

    // MARK: - Initialize Function
    /// width: viewWidth
    init(width: CGFloat, itemWidth: CGFloat = 44, itemStyle: PasswordInputItemView.Style = PasswordInputItemView.Style.bottomLine) {
        self.viewWidth = width
        self.itemWidth = itemWidth
        self.itemStyle = itemStyle
        super.init(frame: CGRect.zero)
        self.initialUI()
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        //self.initialUI()
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCircle Function

    // MARK: - Override Function

    override func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }

}

// MARK: - Internal Function

// MARK: - Private  UI
extension PasswordInputView {

    // 界面布局
    fileprivate func initialUI() -> Void {
        // 1. 添加textField
        self.addSubview(textField)
        textField.isHidden = true
        textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        textField.delegate = self
        textField.keyboardType = .decimalPad
        textField.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        // 2. 添加inputItem
        //let itemW: CGFloat = (self.viewWidth - self.spacing * CGFloat(self.count - 1)) / CGFloat(self.count)
        let spacing: CGFloat = (self.viewWidth - self.itemWidth * CGFloat(self.count)) / CGFloat(self.count - 1)
        for index in 0..<count {
            let itemView = PasswordInputItemView()
            self.addSubview(itemView)
            self.itemViewList.append(itemView)
            itemView.secureTextEntry = false
            itemView.style = self.itemStyle
            itemView.snp.makeConstraints({ (make) in
                make.width.equalTo(self.itemWidth)
                make.top.bottom.equalTo(self)
                let offsetX: CGFloat = CGFloat(index) * (spacing + self.itemWidth)
                make.leading.equalTo(self).offset(offsetX)
            })
        }
        self.bringSubviewToFront(textField)
    }

}

// MARK: - Data Function

extension PasswordInputView {

}

// MARK: - Event Function

extension PasswordInputView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesBegan(touches, with: event)
        self.textField.becomeFirstResponder()
    }

    @objc fileprivate func textFieldValueChanged(_ textField: UITextField) -> Void {
        guard let text = textField.text else {
            return
        }
        let currentLen = text.count
        for index in 0..<self.count {
            let itemView = self.itemViewList[index]
            if index < currentLen {
                itemView.content = text.subString(with: NSRange(location: index, length: 1))
            } else {
                itemView.content = nil
            }
        }
        self.delegate?.pwdInputView(self, didPasswordChanged: text)
    }

}

// MARK: - Extension Function

// MARK: - <UITextFieldDelegate>
extension PasswordInputView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var shouldFlag: Bool = true
        // 纯数字判断
        if !string.isEmpty {
            if nil == Int(string) {
                shouldFlag = false
            }
        }
        // 长度判断
        if range.location >= self.count {
            shouldFlag = false
        }
        return shouldFlag
    }

}
