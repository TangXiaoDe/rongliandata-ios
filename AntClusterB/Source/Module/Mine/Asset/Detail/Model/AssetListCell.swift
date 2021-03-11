//
//  AssetListCell.swift
//  iMeet
//
//  Created by 小唐 on 2019/1/18.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  资产列表Cell

import UIKit

/// 资产列表Cell
class AssetListCell: UITableViewCell {

    // MARK: - Internal Property

    static let cellHeight: CGFloat = 60

    /// 重用标识符
    static let identifier: String = "AssetListCellReuseIdentifier"

    var model: AssetListModel? {
        didSet {
            self.setupWithModel(model)
        }
    }

    var showBottomLine: Bool = true {
        didSet {
            self.bottomLine.isHidden = !showBottomLine
        }
    }

    // MARK: - fileprivate Property
    fileprivate let mainView = UIView()
    fileprivate let titleLabel: UILabel = UILabel()
    fileprivate let dateLabel: UILabel = UILabel()
    fileprivate let valueLabel: UILabel = UILabel()
    fileprivate weak var bottomLine: UIView!

    fileprivate let lrMargin: CGFloat = 16
    fileprivate let titleLeftMargin: CGFloat = 16   // superView
    fileprivate let valueW: CGFloat = 120

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
extension AssetListCell {
    /// 便利构造方法
    class func cellInTableView(_ tableView: UITableView) -> AssetListCell {
        let identifier = AssetListCell.identifier
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if nil == cell {
            cell = AssetListCell.init(style: .default, reuseIdentifier: identifier)
        }
        // 状态重置
        if let cell = cell as? AssetListCell {
            cell.resetSelf()
        }
        return cell as! AssetListCell
    }
}

// MARK: - Override Function
extension AssetListCell {
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
extension AssetListCell {
    // 界面布局
    fileprivate func initialUI() -> Void {
        // mainView - 整体布局，便于扩展，特别是针对分割、背景色、四周间距
        self.contentView.addSubview(mainView)
        self.initialMainView(self.mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    // 主视图布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = UIColor.white
        // 0.x - titleLabel约束依赖valueLabel，而valueLabel约束也依赖titleLabel；
        mainView.addSubview(self.valueLabel)
        // 2. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: AppColor.mainText)
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.titleLeftMargin)
            make.trailing.lessThanOrEqualTo(self.valueLabel.snp.leading).offset(-3)
            make.bottom.equalTo(mainView.snp.centerY).offset(-2)
        }
        // 3. dateLabel
        mainView.addSubview(self.dateLabel)
        self.dateLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12), textColor: UIColor(hex: 0x999999))
        self.dateLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.titleLabel)
            make.top.equalTo(mainView.snp.centerY).offset(2)
        }
        // 4. valueLabel
        // 0xF4CF4B ffffff
        self.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.mainText, alignment: .right)
        self.valueLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.lrMargin)
        }
        // 8. bottomLine
        self.bottomLine = mainView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: self.titleLeftMargin, margin2: 0)
    }
}

// MARK: - Data 数据加载
extension AssetListCell {
    /// 重置
    fileprivate func resetSelf() -> Void {
        self.selectionStyle = .none
//        self.valueLabel.snp.updateConstraints { (make) in
//            make.width.equalTo(self.valueW)
//        }
//        self.mainView.layoutIfNeeded()
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: AssetListModel?) -> Void {
        guard let model = model else {
            return
        }
        self.titleLabel.text = model.title
        self.dateLabel.text = model.createDate.string(format: "yyyy-MM-dd HH:mm", timeZone: TimeZone.current)
        self.valueLabel.text = model.valueTitle
        self.valueLabel.textColor = model.valueColor
    }

}

// MARK: - Event  事件响应
extension AssetListCell {

}
