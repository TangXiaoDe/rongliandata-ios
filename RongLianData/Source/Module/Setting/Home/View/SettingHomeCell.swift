//
//  SettingHomeCell.swift
//  iMeet
//
//  Created by 小唐 on 2019/6/5.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  设置主页Cell
//  使用Cell样式，便于扩展和兼容
//  可考虑移除，请参考SettingItemCell
/**
 设置通用Cell样式
 centerTitle
 leftTitleRightAccessory
 leftTitleRightDetail
 leftTitleRightDetailAccessory
 leftTitleRightSwitch
 **/

import UIKit

/// 设置主页Cell
class SettingHomeCell: UITableViewCell {

    // MARK: - Internal Property
    static let cellHeight: CGFloat = 56
    /// 重用标识符
    static let identifier: String = "SettingHomeCellReuseIdentifier"

    var model: SettingHomeModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    var showBottomLine: Bool = true {
        didSet {
            self.bottomLine.isHidden = !showBottomLine
        }
    }

    let mainView = UIView()
    let leftIconView: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    let detailLabel: UILabel = UILabel()
    let rightIconView: UIImageView = UIImageView()
    let bottomLine: UIView = UIView()

    // MARK: - fileprivate Property

    fileprivate let titleLeftMargin: CGFloat = 12
    fileprivate let detailRightMargin: CGFloat = 12
    fileprivate let leftIconLeftMargin: CGFloat = 12
    fileprivate let rightIconRightMargin: CGFloat = 12
    fileprivate let bottomLineLrMargin: CGFloat = 0

    // MARK: - Initialize Function

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialUI()
    }

}

// MARK: - Internal Function
extension SettingHomeCell {
    /// 便利构造方法
    class func cellInTableView(_ tableView: UITableView) -> SettingHomeCell {
        let identifier = SettingHomeCell.identifier
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if nil == cell {
            cell = SettingHomeCell.init(style: .default, reuseIdentifier: identifier)
        }
        // 状态重置
        if let cell = cell as? SettingHomeCell {
            cell.resetSelf()
        }
        return cell as! SettingHomeCell
    }
}

// MARK: - Override Function
extension SettingHomeCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - UI 界面布局
extension SettingHomeCell {
    // 界面布局
    fileprivate func initialUI() -> Void {
        // mainView - 整体布局，便于扩展，特别是针对分割、背景色、四周间距
        self.contentView.addSubview(mainView)
        self.initialMainView(self.mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // bottomLine
        mainView.addSubview(self.bottomLine)
        self.bottomLine.backgroundColor = UIColor(hex: 0x202A46)
        self.bottomLine.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(bottomLineLrMargin)
            make.trailing.equalToSuperview().offset(-bottomLineLrMargin)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    // 主视图布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = UIColor.init(hex: 0x2D385C)
        // 1. leftIcon
        mainView.addSubview(self.leftIconView)
        self.leftIconView.set(cornerRadius: 0)
        self.leftIconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(self.leftIconLeftMargin)
        }
        // 2. rightIcon
        mainView.addSubview(self.rightIconView)
        //self.rightIconView.set(cornerRadius: 0)
        self.rightIconView.contentMode = .right
        self.rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.rightIconRightMargin)
        }
        // 3. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.systemFont(ofSize: 16), textColor: UIColor.white)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(titleLeftMargin)
            make.trailing.equalToSuperview().offset(-titleLeftMargin)
        }
        // 4. detailLabel
        mainView.addSubview(self.detailLabel)
        self.detailLabel.set(text: nil, font: UIFont.systemFont(ofSize: 12), textColor: UIColor.init(hex: 0x8C97AC), alignment: .right)
        self.detailLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(detailRightMargin)
            make.trailing.equalToSuperview().offset(-detailRightMargin)
        }
    }
}

// MARK: - Data 数据加载
extension SettingHomeCell {
    /// 重置
    fileprivate func resetSelf() -> Void {
        self.selectionStyle = .none

        self.titleLabel.text = nil
        self.detailLabel.text = nil
        self.leftIconView.image = nil
        self.rightIconView.image = nil
        self.titleLabel.textAlignment = .left
        self.detailLabel.textAlignment = .right
        self.bottomLine.isHidden = false
        self.detailLabel.textColor = UIColor.init(hex: 0x8C97AC)

        self.detailLabel.snp.updateConstraints { (make) in
            make.trailing.equalToSuperview().offset(-detailRightMargin)
        }
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: SettingHomeModel?) -> Void {
        guard let model = model else {
            return
        }
        self.leftIconView.image = model.icon
        self.rightIconView.image = model.accessory
        self.titleLabel.text = model.title
        self.detailLabel.text = model.detail
        if "setting.realname".localized == model.title {
            self.detailLabel.textColor = UIColor.init(hex: 0xF4CF4B)
        }

        // 如果detail 与 accessory 同时存在时特殊处理
        if let image = model.accessory, let detail = model.detail, !detail.isEmpty {
            self.detailLabel.snp.updateConstraints { (make) in
                make.trailing.equalToSuperview().offset(-rightIconRightMargin - image.size.width - 5)
            }
        } else {
            self.detailLabel.snp.updateConstraints { (make) in
                make.trailing.equalToSuperview().offset(-detailRightMargin)
            }
        }
    }

}

// MARK: - Event  事件响应
extension SettingHomeCell {

}
