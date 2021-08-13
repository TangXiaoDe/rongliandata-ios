//
//  inputPasswordView.swift
//  TokenBook
//
//  Created by 卿绍成 on 2018/8/2.
//  Copyright © 2018年 ZhiYiCX. All rights reserved.
//

import UIKit

protocol InputPayPasswordViewProtocol: class {
    /// 取消
    func inputPayView(_ view: InputPasswordWithKeyBoardView, cancel button: UIButton) -> Void
    /// 完成
    func inputPayView(_ view: InputPasswordWithKeyBoardView, finish text: String) -> Void
    /// 忘记密码
    func inputPayView(_ view: InputPasswordWithKeyBoardView, forget button: UIButton) -> Void
}

class InputPasswordWithKeyBoardView: UIView {
    // bgView
    fileprivate let bgView: UIView = UIView()
    // mainView
    fileprivate let mainView: UIView = UIView()
    // backBtn
    fileprivate let backBtn: UIButton = UIButton()
    // tips
    fileprivate let tipsLabel: UILabel = UILabel(text: "输入支付密码", font: UIFont.systemFont(ofSize: 15), textColor: UIColor(hex: 0x2d2d2d))
    // inputTextField
    let inputTextField: UITextField = UITextField()
    // forgetBtn
    fileprivate let forgetBtn: UIButton = UIButton()

    weak var delegate: InputPayPasswordViewProtocol?
    fileprivate let bgViewHeight: CGFloat = UIDevice.current.isiPhone5series() ? 100 : 150
    fileprivate let backBtnltMargin: CGFloat = 10
    fileprivate let backBtnWH: CGFloat = 30
    fileprivate let inputTexttMargin: CGFloat = 40
    fileprivate let inputTextW: CGFloat = kScreenWidth - 30
    fileprivate let inputTextH: CGFloat = 45
    fileprivate let forgetBtntMargin: CGFloat = 10
    fileprivate let forgetBtnW: CGFloat = 65
    fileprivate let forgetBtnH: CGFloat = 30
    init() {
        super.init(frame: CGRect.zero)
        self.initUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initUI()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    fileprivate func initUI() {
        // bgView
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.5
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(bgViewHeight)
        }
        // mainView
        mainView.backgroundColor = UIColor.white
        self.addSubview(mainView)
        self.initMainViewUI()
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    fileprivate func initMainViewUI() {
        // backBtn
        backBtn.addTarget(self, action: #selector(backBtnClick(_:)), for: .touchUpInside)
        backBtn.setImage(UIImage.init(named: "IMG_icon_input_clear"), for: .normal)
        mainView.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(backBtnltMargin)
            make.right.equalTo(-backBtnltMargin)
            make.width.height.equalTo(backBtnWH)
        }
        // tips
        mainView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(backBtn)
            make.centerX.equalToSuperview()
        }
        // inputTextField
        inputTextField.keyboardType = .numberPad
        inputTextField.borderStyle = .none
        inputTextField.tintColor = UIColor.clear
        inputTextField.textColor = UIColor.clear
        inputTextField.canPerformAction(#selector(paste(_:)), withSender: self)
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // 设置切边以及圆角
        inputTextField.addLineWithSide(.inTop, color: UIColor(hex: 0xc5c6c7), thickness: 1, margin1: 0, margin2: 0)
        inputTextField.addLineWithSide(.inBottom, color: UIColor(hex: 0xc5c6c7), thickness: 1, margin1: 0, margin2: 0)
        inputTextField.addLineWithSide(.inLeft, color: UIColor(hex: 0xc5c6c7), thickness: 1, margin1: 0, margin2: 0)
        inputTextField.addLineWithSide(.inRight, color: UIColor(hex: 0xc5c6c7), thickness: 1, margin1: 0, margin2: 0)
        inputTextField.set(cornerRadius: 3)
        //第一响应者
        inputTextField.becomeFirstResponder()
        mainView.addSubview(inputTextField)
        inputTextField.snp.makeConstraints { (make) in
            make.width.equalTo(inputTextW)
            make.height.equalTo(inputTextH)
            make.centerX.equalToSuperview()
            make.top.equalTo(tipsLabel.snp.bottom).offset(inputTexttMargin)
        }
        // forgetBtn
        forgetBtn.addTarget(self, action: #selector(forgetBtnClick(_:)), for: .touchUpInside)
        forgetBtn.setTitle("忘记密码？", for: .normal)
        //forgetBtn.setTitleColor(AppColor.theme, for: .normal)
        forgetBtn.setTitleColor(UIColor.init(hex: 0x58AED7), for: .normal)
        forgetBtn.set(font: UIFont.systemFont(ofSize: 12))
        mainView.addSubview(forgetBtn)
        forgetBtn.snp.makeConstraints { (make) in
            make.right.equalTo(inputTextField)
            make.top.equalTo(inputTextField.snp.bottom).offset(forgetBtntMargin)
            make.width.equalTo(forgetBtnW)
            make.height.equalTo(forgetBtnH)
        }
        // inputTextField分割线
        let width = inputTextW / 6.0
        for i in 1...5 {
            let view = UIView()
            view.backgroundColor = UIColor(hex: 0xc5c6c7)
            mainView.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(inputTextField)
                make.width.equalTo(1)
                make.left.equalTo(inputTextField.snp.left).offset(CGFloat(i) * width)
            }
        }
    }
    @objc fileprivate func backBtnClick(_ sender: UIButton) -> Void {
        self.delegate?.inputPayView(self, cancel: sender)
    }
    @objc fileprivate func forgetBtnClick(_ sender: UIButton) -> Void {
        self.delegate?.inputPayView(self, forget: sender)
    }
    @objc fileprivate func textFieldDidChange(_ textField: UITextField) -> Void {
        guard var text = textField.text else {
            return
        }
        // 移除所有圆点
        for i in 0...5 {
            let view = textField.viewWithTag((i + 1) * 1_000)
            view?.removeFromSuperview()
        }
        if text.count > 6 {
            text = String(text.prefix(6))
            textField.text = text
            return
        }
        let width = inputTextW / 6.0
        let dotWH: CGFloat = 9
        let lMargin: CGFloat = (width - dotWH) / 2.0
        // 绘制圆点
        if text.count > 0 {
            for i in 0...text.count - 1 {
                let view = UIView()
                view.tag = (i + 1) * 1_000
                view.backgroundColor = UIColor(hex: 0x2d2d2d)
                view.layer.cornerRadius = dotWH / 2.0
                view.layer.masksToBounds = true
                textField.addSubview(view)
                view.snp.makeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.width.height.equalTo(dotWH)
                    make.left.equalTo(lMargin + CGFloat(i) * width)
                }
            }
        }
        // 输入完6位后返回
        if text.count == 6 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.delegate?.inputPayView(self, finish: text)
            }
//            textField.text = ""
//            self.textFieldDidChange(textField)
        }
    }
}
