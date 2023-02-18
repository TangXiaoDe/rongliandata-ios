//
//  PassswordInputItemView.swift
//  iMeet
//
//  Created by 小唐 on 2019/1/16.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  方框密码输入item视图

import UIKit

class PasswordInputItemView: UIView {

    enum Style {
        case bottomLine
        case border
    }

    var style: PasswordInputItemView.Style = .bottomLine {
        didSet {
            self.bottomLine.isHidden = false
            self.topLine.isHidden = style == .bottomLine
            self.leftLine.isHidden = style == .bottomLine
            self.rightLine.isHidden = style == .bottomLine
        }
    }

    var secureTextEntry: Bool = true {
        didSet {
            self.titleLabel.isHidden = secureTextEntry
            self.imageView.isHidden = !secureTextEntry
        }
    }

    var secureTextColor: UIColor = AppColor.theme {
        didSet {
            if self.content == nil || self.content!.isEmpty {
                self.imageView.image = nil
            } else {
                self.imageView.image = UIImage.imageWithColor(secureTextColor)
            }
        }
    }
    var lineColor: UIColor = AppColor.theme {
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
        // 1. bgView
        self.addSubview(bgView)
        self.bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        // 2. titleLabel
        self.addSubview(titleLabel)
        titleLabel.set(text: nil, font: UIFont.systemFont(ofSize: 18), textColor: self.secureTextColor, alignment: .center)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
            make.center.equalTo(self)
        }
        // 3. imageView
        let iconWH: CGFloat = 10
        self.addSubview(imageView)
        imageView.set(cornerRadius: iconWH * 0.5)
        imageView.snp.makeConstraints { (make) in
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
