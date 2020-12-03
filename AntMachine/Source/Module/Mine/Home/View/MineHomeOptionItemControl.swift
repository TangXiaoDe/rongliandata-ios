//
//  MineHomeOptionItemControl.swift
//  CCMall
//
//  Created by 小唐 on 2019/2/18.
//  Copyright © 2019 COMC. All rights reserved.
//
//  我的主页底部单个选项控件

import UIKit

class MineHomeOptionItemControl: UIControl {

    // MARK: - Internal Property

    static let itemHeight: CGFloat = 56

    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    var showAccessory: Bool = true {
        didSet {
            self.accessoryView.isHidden = !showAccessory
            self.detailLabel.isHidden = showAccessory
        }
    }
    var showImage: Bool = true {
        didSet {
            if showImage {
                self.iconImgView.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.leading.equalToSuperview().offset(lrMargin)
                }
                self.titleLabel.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.left.equalTo(self.iconImgView.snp.right).offset(labelLeftMargin)
                }
            } else {
                self.iconImgView.snp.removeConstraints()
                self.titleLabel.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.leading.equalToSuperview().offset(lrMargin)
                }
            }
        }
    }
    var detail: String? {
        didSet {
            self.detailLabel.text = detail
            self.detailLabel.isHidden = false
            self.accessoryView.isHidden = true
        }
    }
    var unread: Int? {
        didSet {
            self.setupUnreadCount(unread)
        }
    }
    let iconImgView: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    let accessoryView: UIImageView = UIImageView()
    let detailLabel: UILabel = UILabel()
    let bottomLine: UIView = UIView()
    let unreadView: UIView = UIView()
    let unreadLabel: UILabel = UILabel()

    // MARK: - Private Property

    fileprivate let lrMargin: CGFloat = 15
    fileprivate let labelLeftMargin: CGFloat = 12
    fileprivate let unreadViewH: CGFloat = 15
    fileprivate let unreadLabelLrMargin: CGFloat = 5
    fileprivate let unreadViewRightMargin: CGFloat = 12

    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
        self.initialUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialUI()
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension MineHomeOptionItemControl {

}

// MARK: - LifeCircle Function
extension MineHomeOptionItemControl {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension MineHomeOptionItemControl {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        // 0. titleLabel
        self.addSubview(self.iconImgView)
        self.iconImgView.set(cornerRadius: 0)
        self.iconImgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(lrMargin)
        }
        // 1. titleLabel
        self.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.systemFont(ofSize: 15), textColor: UIColor(hex: 0x333333))
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.iconImgView.snp.right).offset(labelLeftMargin)
        }
        // 2. accessoryView
        self.addSubview(self.accessoryView)
        self.accessoryView.image = UIImage.init(named: "IMG_common_detail")
        self.accessoryView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-lrMargin)
        }
        // 3. detailLabel
        self.addSubview(self.detailLabel)
        self.detailLabel.set(text: nil, font: UIFont.systemFont(ofSize: 12), textColor: UIColor(hex: 0x999999), alignment: .right)
        self.detailLabel.isHidden = true
        self.detailLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-lrMargin)
        }
        // 4. bottomLine
        self.addSubview(self.bottomLine)
        self.bottomLine.backgroundColor = UIColor(hex: 0xececec)
        self.bottomLine.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        // 5. unreadView
        self.addSubview(self.unreadView)
        self.unreadView.backgroundColor = UIColor.init(hex: 0xF0250F)
        self.unreadView.set(cornerRadius: self.unreadViewH * 0.5)
        self.unreadView.isHidden = true // 默认隐藏
        self.unreadView.snp.makeConstraints { (make) in
            make.height.equalTo(self.unreadViewH)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-lrMargin - self.unreadViewRightMargin)
        }
        // 6. unreadLabel
        self.unreadView.addSubview(self.unreadLabel)
        self.unreadLabel.set(text: nil, font: UIFont.systemFont(ofSize: 10), textColor: UIColor.white, alignment: .center)
        self.unreadLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(self.unreadLabelLrMargin)
            make.trailing.lessThanOrEqualToSuperview().offset(-self.unreadLabelLrMargin)
        }
    }

}
// MARK: - Private UI Xib加载后处理
extension MineHomeOptionItemControl {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension MineHomeOptionItemControl {
    /// 未读数设置
    fileprivate func setupUnreadCount(_ count: Int?) -> Void {
        guard let count = count, count > 0 else {
            self.unreadView.isHidden = true
            return
        }
        self.unreadView.isHidden = false
        self.unreadLabel.text = self.unreadCountProcess(count)
    }
    
    fileprivate func unreadCountProcess(_ count: Int) -> String {
        var string = "\(count)"
        if count > 999 {
            string = "999+"
        }
        return string
    }
    
}

// MARK: - Event Function
extension MineHomeOptionItemControl {

}

// MARK: - Extension Function
extension MineHomeOptionItemControl {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension MineHomeOptionItemControl {

}
