//
//  UserInfoControl.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/6.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  用户信息控件
//  子类可重写

import UIKit

typealias UserInfoSettingControl = UserInfoControl
typealias UserSettingControl = UserInfoControl
class UserInfoControl: UIControl {

    // MARK: - Internal Property

    static let minViewHeight: CGFloat = 64

    var content: String? = nil {
        didSet {
            self.setupWithContent(content)
        }
    }
    var placeholder: String? {
        didSet {
            self.placeHolderLabel.text = placeholder
        }
    }
    var showBottomLine: Bool = false {
        didSet {
            self.bottomLine.isHidden = !showBottomLine
        }
    }

    let titleLabel: UILabel = UILabel()
    let accessoryView: UIImageView = UIImageView()

    let placeHolderLabel: UILabel = UILabel()
    /// 内容视图，子类重写时重写该视图布局
    let contentView: UIView = UIView()
    let contentLabel: UILabel = UILabel()
    fileprivate(set) weak var bottomLine: UIView!


    // MARK: - Private Property

    let titleLeftMargin: CGFloat = 16
    let contentLeftMargin: CGFloat = 66
    let accessoryRightMargin: CGFloat = 16
    let accessoryWidth: CGFloat = 15
    let lineLeftMargin: CGFloat = 12
    let titleCenterYTopMargin: CGFloat = UserInfoControl.minViewHeight * 0.5
    let contentTbMargin: CGFloat = 20

    let contentWidth: CGFloat


    // MARK: - Initialize Function

    init() {
        self.contentWidth = kScreenWidth - self.contentLeftMargin - self.accessoryWidth - self.accessoryRightMargin
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        self.contentWidth = kScreenWidth - self.contentLeftMargin - self.accessoryWidth - self.accessoryRightMargin
        super.init(coder: aDecoder)
        self.commonInit()
    }

    /// 通用初始化：UI、配置、数据等
    func commonInit() -> Void {
        self.initialUI()
    }
}

// MARK: - Internal Function
extension UserInfoControl {
    func setupPlaceHolder(_ placeholder: String?, title: String?) -> Void {
        self.placeHolderLabel.text = placeholder
        self.titleLabel.text = title
    }

}

// MARK: - Override Function

// MARK: - Private  UI
extension UserInfoControl {
    /// 界面布局
    @objc func initialUI() -> Void {
        // 1. titleLabel
        self.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 16), textColor: UIColor.init(hex: 0x8A98AE))
        self.titleLabel.numberOfLines = 2
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(self.titleLeftMargin)
        }
        // 2. accessoryView
        self.addSubview(self.accessoryView)
        self.accessoryView.image = UIImage.init(named: "IMG_common_detail")
        self.accessoryView.contentMode = .right
        self.accessoryView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(self.accessoryWidth)
            make.trailing.equalToSuperview().offset(-self.accessoryRightMargin)
        }
        // 3. contentView
        self.addSubview(self.contentView)
        self.contentView.isUserInteractionEnabled = false
        self.contentView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.contentLeftMargin)
            make.trailing.equalToSuperview().offset(-self.accessoryRightMargin - self.accessoryWidth)
            make.top.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(UserInfoControl.minViewHeight)
        }
        // 3.1 placeHolderLabel
        self.contentView.addSubview(self.placeHolderLabel)
        self.placeHolderLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 18), textColor: UIColor.init(hex: 0x4F5C70))
        self.placeHolderLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        // 3.2 contentLabel
        self.contentView.addSubview(self.contentLabel)
        self.contentLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 18), textColor: UIColor.white)
        self.contentLabel.numberOfLines = 0
        self.contentLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(self.contentTbMargin)
            make.bottom.lessThanOrEqualToSuperview().offset(-self.contentTbMargin)
        }
        // 4. bottomLine
        self.bottomLine = self.addLineWithSide(.inBottom, color: UIColor.init(hex: 0x2D385C), thickness: 0.5, margin1: self.lineLeftMargin, margin2: 0)

    }
}

// MARK: - Private  数据(处理 与 加载)
extension UserInfoControl {
    /// 数据加载
    fileprivate func setupWithContent(_ content: String?) -> Void {
        guard let content = content, !content.isEmpty else {
            self.placeHolderLabel.isHidden = false
            self.contentLabel.isHidden = true
            return
        }
        self.placeHolderLabel.isHidden = true
        self.contentLabel.isHidden = false
        self.contentLabel.text = content
    }
}

// MARK: - Private  事件
