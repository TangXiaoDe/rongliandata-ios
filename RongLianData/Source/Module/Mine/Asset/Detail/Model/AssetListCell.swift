//
//  AssetListCell.swift
//  iMeet
//
//  Created by 小唐 on 2019/1/18.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  资产列表Cell

import UIKit
import ChainOneKit

/// 资产列表Cell
class AssetListCell: UITableViewCell {

    // MARK: - Internal Property

    static let cellHeight: CGFloat = 68

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
    var isFirst: Bool = false {
        didSet {
            let cornerRadius: CGFloat = isFirst ? 12: 0
            self.mainView.setupCorners(UIRectCorner.init([UIRectCorner.topLeft, UIRectCorner.topRight]), selfSize: CGSize.init(width: kScreenWidth - self.mainLrMargin * 2.0, height: self.mainViewHeight), cornerRadius: cornerRadius)
        }
    }

    // MARK: - fileprivate Property
    
    fileprivate let mainView = UIView()
    
    fileprivate let titleLabel: UILabel = UILabel()
    fileprivate let dateLabel: UILabel = UILabel()
    fileprivate let valueLabel: UILabel = UILabel()
    fileprivate let statusLabel: UILabel = UILabel()
    fileprivate weak var bottomLine: UIView!

    
    fileprivate let mainViewHeight: CGFloat = 68
    fileprivate let mainLrMargin: CGFloat = 12
    fileprivate let lrMargin: CGFloat = 16
    
    fileprivate let titleTopMargin: CGFloat = 16   // superView
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
        self.contentView.backgroundColor = AppColor.pageBg
        // mainView - 整体布局，便于扩展，特别是针对分割、背景色、四周间距
        self.contentView.addSubview(mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            //make.edges.equalToSuperview()
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
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.init(rawValue: 100), for: .horizontal)
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.top.equalToSuperview().offset(self.titleTopMargin)
        }
        // 3. dateLabel
        mainView.addSubview(self.dateLabel)
        self.dateLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor(hex: 0x999999))
        self.dateLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
        }
        // 4. valueLabel    // #333333 #E34F1E
        mainView.addSubview(self.valueLabel)
        self.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.mainText, alignment: .right)
        self.valueLabel.setContentHuggingPriority(UILayoutPriority.init(rawValue: 1000), for: .horizontal)
        self.valueLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLabel)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.leading.greaterThanOrEqualTo(self.titleLabel.snp.trailing).offset(5)
        }
        // 4. statusLabel    // #333333 #E34F1E
        mainView.addSubview(self.statusLabel)
        self.statusLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: AppColor.mainText, alignment: .right)
        self.statusLabel.isHidden = true
        self.statusLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.dateLabel)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
        }
        // 8. bottomLine
        self.bottomLine = mainView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: self.lrMargin, margin2: self.lrMargin)
    }
}

// MARK: - Data 数据加载
extension AssetListCell {
    /// 重置
    fileprivate func resetSelf() -> Void {
        self.selectionStyle = .none
        self.showBottomLine = true
        self.isFirst = false
        self.statusLabel.isHidden = true
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
