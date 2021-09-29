//
//  MiningDetailListCell.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/1/12.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  收益收益列表Cell

import UIKit

class MiningDetailListCell: UITableViewCell
{
    
    // MARK: - Internal Property

    static let cellHeight: CGFloat = 75
    /// 重用标识符
    static let identifier: String = "MiningDetailListCellReuseIdentifier"
    
    var indexPath: IndexPath?
    var model: AssetListModel? {
        didSet {
            self.setupWithModel(model)
        }
    }

    
//    var showBottomLine: Bool = false {
//        didSet {
////            self.bottomLine.isHidden = !showBottomLine
//        }
//    }
//    var showTopMargin: Bool = true {
//        didSet {
//            self.setupShowTopMargin(showTopMargin)
//        }
//    }
//    var showBottomMargin: Bool = false {
//        didSet {
//            self.setupShowBottomMargin(showBottomMargin)
//        }
//    }


    // MARK: - fileprivate Property
    
    fileprivate let topSeparateView: UIView = UIView.init()
    fileprivate let topLeftLine: UIView = UIView.init()
    fileprivate let topRightLine: UIView = UIView.init()
    
    fileprivate let mainView: UIView = UIView()
    
    fileprivate let topView: UIView = UIView.init()
    fileprivate let dateLabel: UILabel = UILabel.init()     //  日期
    fileprivate let dashLine: XDDashLineView = XDDashLineView.init(lineColor: AppColor.dividing, lengths: [3.0, 3.0])
    
    fileprivate let bottomView: UIView = UIView.init()
    fileprivate let miningNumView: TitleValueView = TitleValueView.init()   // 收益数
    fileprivate let fenzuaNumView: TitleValueView = TitleValueView.init()   // 封装数
    
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let topSeparateMargin: CGFloat = 12      // 顶部间距，多用于分组首个cell时的间距展示；
    fileprivate let bottomSeparateMargin: CGFloat = 0   // 底部间距
    fileprivate let mainOutLrMargin: CGFloat = 12
    fileprivate let mainInLrMargin: CGFloat = 12

    fileprivate let topViewHeight: CGFloat = 32
    fileprivate let itemViewTopMargin: CGFloat = 14
    fileprivate let itemViewHeight: CGFloat = 14
    fileprivate let itemViewVerMargin: CGFloat = 10
    fileprivate let itemViewBottomMargin: CGFloat = 12
    
    // MARK: - Initialize Function
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    /// 通用初始化：UI、配置、数据等
    fileprivate func commonInit() -> Void {
        self.initialUI()
    }
    
}

// MARK: - Internal Function
extension MiningDetailListCell {

    /// 便利构造方法
    class func cellInTableView(_ tableView: UITableView, at indexPath: IndexPath? = nil) -> MiningDetailListCell {
        let identifier = MiningDetailListCell.identifier
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if nil == cell {
            cell = MiningDetailListCell.init(style: .default, reuseIdentifier: identifier)
        }
        // 状态重置
        if let cell = cell as? MiningDetailListCell {
            cell.resetSelf()
            cell.indexPath = indexPath
        }
        return cell as! MiningDetailListCell
    }

}

// MARK: - LifeCircle/Override Function
extension MiningDetailListCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

// MARK: - UI Function
extension MiningDetailListCell {

    // 界面布局
    fileprivate func initialUI() -> Void {
        //self.contentView.backgroundColor = AppColor.pageBg
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        // topSeparate
        self.contentView.addSubview(self.topSeparateView)
        self.initialTopSeparateView(self.topSeparateView)
        self.topSeparateView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.topSeparateMargin)
        }
        // mainView - 整体布局，便于扩展，特别是针对分割、背景色、四周间距
        self.contentView.addSubview(mainView)
        self.initialMainView(self.mainView)
        mainView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.mainOutLrMargin)
            make.trailing.equalToSuperview().offset(-self.mainOutLrMargin)
            make.top.equalTo(self.topSeparateView.snp.bottom)
            make.bottom.equalToSuperview().offset(-self.bottomSeparateMargin)
        }
    }
    ///
    fileprivate func initialTopSeparateView(_ separateView: UIView) -> Void {
        let lrMargin: CGFloat = self.mainOutLrMargin + self.mainInLrMargin
        // 1. leftLine
        separateView.addSubview(self.topLeftLine)
        self.topLeftLine.backgroundColor = UIColor.white
        self.topLeftLine.snp.makeConstraints { (make) in
            make.width.equalTo(1.5)
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(lrMargin)
        }
        // 2. rightLine
        separateView.addSubview(self.topRightLine)
        self.topRightLine.backgroundColor = UIColor.white
        self.topRightLine.snp.makeConstraints { (make) in
            make.width.equalTo(1.5)
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-lrMargin)
        }
    }
    // 主视图布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = UIColor.white
        mainView.set(cornerRadius: 10)
        // 1. topView
        mainView.addSubview(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.topViewHeight)
        }
        // 1.1
        self.topView.addSubview(self.dateLabel)
        self.dateLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x999999))
        self.dateLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.mainInLrMargin)
            make.trailing.lessThanOrEqualToSuperview().offset(-self.mainInLrMargin)
            make.centerY.equalToSuperview()
        }
        // 1.2
        self.topView.addSubview(self.dashLine)
        self.dashLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(self.mainInLrMargin)
            make.trailing.equalToSuperview().offset(-self.mainInLrMargin)
            make.height.equalTo(0.5)
        }
        // 2. bottomView
        mainView.addSubview(self.bottomView)
        self.bottomView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom)
        }
        // 2.1 miningNumView
        self.bottomView.addSubview(self.miningNumView)
        self.miningNumView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.mainInLrMargin)
            make.trailing.equalToSuperview().offset(-self.mainInLrMargin)
            make.height.equalTo(self.itemViewHeight)
            make.top.equalToSuperview().offset(self.itemViewTopMargin)
        }
        self.miningNumView.titleLabel.set(text: "收益数", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x666666))
        self.miningNumView.titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.miningNumView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: UIColor.init(hex: 0xFF455E), alignment: .right)
        self.miningNumView.valueLabel.snp.remakeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        // 2.2 fenzuaNumView
        self.bottomView.addSubview(self.fenzuaNumView)
        self.fenzuaNumView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.mainInLrMargin)
            make.trailing.equalToSuperview().offset(-self.mainInLrMargin)
            make.height.equalTo(self.itemViewHeight)
            make.top.equalTo(self.miningNumView.snp.bottom).offset(self.itemViewVerMargin)
            make.bottom.equalToSuperview().offset(-self.itemViewBottomMargin)
        }
        self.fenzuaNumView.titleLabel.set(text: "封装数", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x666666))
        self.fenzuaNumView.titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.fenzuaNumView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: UIColor.init(hex: 0x333333), alignment: .right)
        self.fenzuaNumView.valueLabel.snp.remakeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

}

// MARK: - Data Function
extension MiningDetailListCell {

//    /// 顶部间距是否显示
//    fileprivate func setupShowTopMargin(_ show: Bool) -> Void {
//        let topMargin: CGFloat = show ? self.topSeparateMargin : 0
//        mainView.snp.updateConstraints { (make) in
//            make.top.equalToSuperview().offset(topMargin)
//        }
//        self.layoutIfNeeded()
//    }
//    /// 底部间距是否显示
//    fileprivate func setupShowBottomMargin(_ show: Bool) -> Void {
//        let bottomMargin: CGFloat = show ? self.bottomSeparateMargin : 0
//        mainView.snp.updateConstraints { (make) in
//            make.bottom.equalToSuperview().offset(-bottomMargin)
//        }
//        self.layoutIfNeeded()
//    }

    /// 重置
    fileprivate func resetSelf() -> Void {
        self.selectionStyle = .none
        self.isSelected = false
//        self.showTopMargin = false
//        self.showBottomMargin = true
//        self.showBottomLine = true
    }
    ///
    fileprivate func setupAsDemo() -> Void {

    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: AssetListModel?) -> Void {
        //self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 控件加载数据
        self.dateLabel.text = model.createDate.string(format: "yyyy年MM月dd日", timeZone: .current)
        self.miningNumView.valueLabel.text = model.amount.decimalValidDigitsProcess(digits: 8)
        self.fenzuaNumView.valueLabel.text = model.extend?.fz_num.decimalValidDigitsProcess(digits: 8)
    }

}

// MARK: - Event Function
extension MiningDetailListCell {
    
}

// MARK: - Notification Function
extension MiningDetailListCell {
    
}

// MARK: - Extension Function
extension MiningDetailListCell {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension MiningDetailListCell {
    
}

