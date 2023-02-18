//
//  SettingCenterTitleCell.swift
//  iMeet
//
//  Created by 小唐 on 2019/6/5.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  设置模块中间标题样式的Cell
//  可考虑移除，请参考SettingItemCell

import UIKit

/// 设置模块中间标题样式的Cell，如退出、清空聊天记录
class SettingCenterTitleCell: UITableViewCell {

    // MARK: - Internal Property
    static let cellHeight: CGFloat = 56
    /// 重用标识符
    static let identifier: String = "SettingCenterTitleCellReuseIdentifier"

    var model: SettingHomeModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    var showBottomLine: Bool = false {
        didSet {
            self.bottomLine.isHidden = !showBottomLine
        }
    }

    let mainView = UIView()
    let titleLabel: UILabel = UILabel()
    let bottomLine: UIView = UIView()

    // MARK: - fileprivate Property

    fileprivate let titleLrMargin: CGFloat = 12
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
extension SettingCenterTitleCell {
    /// 便利构造方法
    class func cellInTableView(_ tableView: UITableView) -> SettingCenterTitleCell {
        let identifier = SettingCenterTitleCell.identifier
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if nil == cell {
            cell = SettingCenterTitleCell.init(style: .default, reuseIdentifier: identifier)
        }
        // 状态重置
        if let cell = cell as? SettingCenterTitleCell {
            cell.resetSelf()
        }
        return cell as! SettingCenterTitleCell
    }
}

// MARK: - Override Function
extension SettingCenterTitleCell {
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
extension SettingCenterTitleCell {
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
        // 1. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.systemFont(ofSize: 16), textColor: UIColor.init(hex: 0xEA445C), alignment: .center)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(titleLrMargin)
            make.trailing.equalToSuperview().offset(-titleLrMargin)
        }
    }
}

// MARK: - Data 数据加载
extension SettingCenterTitleCell {
    /// 重置
    fileprivate func resetSelf() -> Void {
        self.selectionStyle = .none

        self.titleLabel.text = nil
        self.bottomLine.isHidden = true
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: SettingHomeModel?) -> Void {
        guard let model = model else {
            return
        }
        self.titleLabel.text = model.title
    }
}

// MARK: - Event  事件响应
extension SettingCenterTitleCell {

}
