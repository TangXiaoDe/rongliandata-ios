//
//  PassswordInputItemView.swift
//  iMeet
//
//  Created by 小唐 on 2019/1/16.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  方框密码输入item视图

import UIKit

// TODO: - 兼容其他输入

class PasswordInputItemView: UIView {

    enum Style {
        // TODO: - 添加none类型
        case bottomLine
        case border
        case round
    }

    var style: PasswordInputItemView.Style = .bottomLine {
        didSet {
            // TODO: - 添加none类型
            switch style {
            case .bottomLine:
                self.bottomLine.isHidden = false//false
                self.topLine.isHidden = true//style == .bottomLine
                self.leftLine.isHidden = true//style == .bottomLine
                self.rightLine.isHidden = true//style == .bottomLine
            case .border:
                self.bottomLine.isHidden = false//false
                self.topLine.isHidden = false//style == .bottomLine
                self.leftLine.isHidden = false//style == .bottomLine
                self.rightLine.isHidden = false//style == .bottomLine
            case .round:
                self.bottomLine.isHidden = true//false
                self.topLine.isHidden = true//style == .bottomLine
                self.leftLine.isHidden = true//style == .bottomLine
                self.rightLine.isHidden = true//style == .bottomLine
            }
        }
    }

    var secureTextEntry: Bool = true {
        didSet {
            self.titleLabel.isHidden = secureTextEntry
            self.imageView.isHidden = !secureTextEntry
        }
    }

    var secureTextColor: UIColor = AppColor.mainText {
        didSet {
            if self.content == nil || self.content!.isEmpty {
                self.imageView.image = nil
            } else {
                self.imageView.image = UIImage.imageWithColor(secureTextColor)
            }
        }
    }
    var lineColor: UIColor = UIColor.init(hex: 0xCCCCCC) {
        didSet {
            self.topLine.backgroundColor = lineColor
            self.bottomLine.backgroundColor = lineColor
            self.leftLine.backgroundColor = lineColor
            self.rightLine.backgroundColor = lineColor
        }
    }

    var content: String? {
        didSet {
            self.titleLabel.text = content
            if content == nil || content!.isEmpty {
                self.imageView.image = nil
            } else {
                self.imageView.image = UIImage.imageWithColor(self.secureTextColor)
            }
            if let content = content, !content.isEmpty {
                self.lineColor = AppColor.theme
            } else {
                self.lineColor = UIColor.init(hex: 0xCCCCCC)
            }
        }
    }

    fileprivate let bgView: UIImageView = UIImageView()
    fileprivate let titleLabel: UILabel = UILabel()
    fileprivate let imageView: UIImageView = UIImageView()
    fileprivate weak var leftLine: UIView!
    fileprivate weak var rightLine: UIView!
    fileprivate weak var topLine: UIView!
    fileprivate weak var bottomLine: UIView!


    init() {
        super.init(frame: CGRect.zero)
        self.initialUI()
        self.style = .bottomLine
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func initialUI() -> Void {
        self.backgroundColor = .white
        // 1. bgView
        self.addSubview(self.bgView)
        self.bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        // 2. titleLabel
        self.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14, weight: .regular), textColor: self.secureTextColor, alignment: .center)
        self.titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
            make.center.equalTo(self)
        }
        // 3. imageView
        let iconWH: CGFloat = 10
        self.addSubview(self.imageView)
        self.imageView.set(cornerRadius: iconWH * 0.5)
        self.imageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.height.equalTo(iconWH)
        }

        // 4. line
        self.topLine = self.addLineWithSide(.inTop, color: self.lineColor, thickness: 0.5, margin1: 0, margin2: 0)
        self.bottomLine = self.addLineWithSide(.inBottom, color: self.lineColor, thickness: 0.5, margin1: 0, margin2: 0)
        self.leftLine = self.addLineWithSide(.inLeft, color: self.lineColor, thickness: 0.5, margin1: 0, margin2: 0)
        self.rightLine = self.addLineWithSide(.inRight, color: self.lineColor, thickness: 0.5, margin1: 0, margin2: 0)
    }

}
