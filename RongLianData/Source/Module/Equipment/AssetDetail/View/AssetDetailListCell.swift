//
//  AssetDetailListCell.swift
//  RongLianData
//
//  Created by zhaowei on 2021/3/10.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit
import ChainOneKit

/// 资产列表Cell
class AssetDetailListCell: UITableViewCell {

    // MARK: - Internal Property

    static let cellHeight: CGFloat = 60

    /// 重用标识符
    static let identifier: String = "AssetDetailListCellReuseIdentifier"

    var model: AssetListModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    var isFirst: Bool = false {
        didSet {
            let corner: UIRectCorner = isFirst ? UIRectCorner.init([UIRectCorner.topLeft, UIRectCorner.topRight]) : UIRectCorner.init()
            self.mainView.setupCorners(corner, selfSize: CGSize.init(width: kScreenWidth - self.mainLrMargin * 2.0, height: self.mainViewHeight), cornerRadius: 12)
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

    
    fileprivate let mainViewHeight: CGFloat = 68
    fileprivate let mainLrMargin: CGFloat = 12
    fileprivate let lrMargin: CGFloat = 12
    
    fileprivate let titleTopMargin: CGFloat = 20
    fileprivate let dateTopMargin: CGFloat = 6
    fileprivate let dateBottomMargin: CGFloat = 12
    
    fileprivate let titleLeftMargin: CGFloat = 16   // superView
    fileprivate let valueW: CGFloat = 120

    // MARK: - Initialize Function

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    ///
    fileprivate func commonInit() -> Void {
        self.initialUI()
    }

}

// MARK: - Internal Function
extension AssetDetailListCell {
    /// 便利构造方法
    class func cellInTableView(_ tableView: UITableView) -> AssetDetailListCell {
        let identifier = AssetDetailListCell.identifier
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if nil == cell {
            cell = AssetDetailListCell.init(style: .default, reuseIdentifier: identifier)
        }
        // 状态重置
        if let cell = cell as? AssetDetailListCell {
            cell.resetSelf()
        }
        return cell as! AssetDetailListCell
    }
}

// MARK: - Override Function
extension AssetDetailListCell {
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
extension AssetDetailListCell {
    // 界面布局
    fileprivate func initialUI() -> Void {
        self.contentView.backgroundColor = AppColor.pageBg
        // mainView - 整体布局，便于扩展，特别是针对分割、背景色、四周间距
        self.contentView.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(self.mainLrMargin)
            make.trailing.equalToSuperview().offset(-self.mainLrMargin)
            make.height.equalTo(self.mainViewHeight)
        }
    }
    // 主视图布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = UIColor.white
        // 2. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: AppColor.mainText)
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.init(100), for: .horizontal)
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.centerY.equalTo(mainView.snp.top).offset(28)
        }
        // 3. dateLabel
        mainView.addSubview(self.dateLabel)
        self.dateLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12), textColor: UIColor(hex: 0x999999))
        self.dateLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
        }
        // 4. valueLabel
        // 0xF4CF4B ffffff
        mainView.addSubview(self.valueLabel)
        self.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.mainText, alignment: .right)
        self.valueLabel.setContentHuggingPriority(UILayoutPriority.init(1000), for: .horizontal)
        self.valueLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.leading.greaterThanOrEqualTo(self.titleLabel.snp.trailing).offset(5)
        }
        // 8. bottomLine
        self.bottomLine = mainView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: self.titleLeftMargin, margin2: 0)
    }
}

// MARK: - Data 数据加载
extension AssetDetailListCell {
    /// 重置
    fileprivate func resetSelf() -> Void {
        self.selectionStyle = .none
        self.showBottomLine = true
        self.isFirst = false
//        self.valueLabel.snp.updateConstraints { (make) in
//            make.width.equalTo(self.valueW)
//        }
//        self.mainView.layoutIfNeeded()
    }
    
    ///
    fileprivate func setupAsDemo() -> Void {
        self.titleLabel.text = "20210101期-可用FIL(含安全保"
        self.dateLabel.text = Date.init().string(format: "yyyy-MM-dd HH:mm", timeZone: TimeZone.current)
        self.valueLabel.text = "+0.1235"
        self.valueLabel.textColor = AppColor.themeRed
    }
    
    /// 数据加载
    fileprivate func setupWithModel(_ model: AssetListModel?) -> Void {
//        self.setupAsDemo()
//        return
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
extension AssetDetailListCell {

}
