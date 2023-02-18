//
//  ReturnListCell.swift
//  SassProject
//
//  Created by 小唐 on 2021/7/27.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  归还流水明细Cell

import UIKit

class ReturnListCell: UITableViewCell
{
    
    // MARK: - Internal Property
    
    /// 重用标识符
    static let identifier: String = "ReturnListCellReuseIdentifier"
    
    var indexPath: IndexPath?
    var model: ReturnListModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    var showBottomLine: Bool = false {
        didSet {
            self.bottomLine.isHidden = !showBottomLine
        }
    }
    var showTopMargin: Bool = false {
        didSet {
            self.setupShowTopMargin(showTopMargin)
        }
    }
    var showBottomMargin: Bool = true {
        didSet {
            self.setupShowBottomMargin(showBottomMargin)
        }
    }


    // MARK: - fileprivate Property
    
    fileprivate let mainView: UIView = UIView()
    fileprivate let bottomLine: UIView = UIView()
    
    fileprivate let topView: UIView = UIView.init()
    fileprivate let dateLabel: UILabel = UILabel.init()
    
    fileprivate let bottomView: UIView = UIView.init()
    fileprivate let returnAmountView: TitleValueView = TitleValueView.init()    // 归还金额(FIL)
    fileprivate let realReturnInterestView: TitleValueView = TitleValueView.init()    // 实还利息(FIL)
    fileprivate let newInterestView: TitleValueView = TitleValueView.init()    // 新增欠款利息(FIL)
    fileprivate let returnMortgageView: TitleValueView = TitleValueView.init()    // 归还抵押(FIL)
    fileprivate let returnGasView: TitleValueView = TitleValueView.init()    // 归还GAS(FIL)
    fileprivate let returnTotalInterestView: TitleValueView = TitleValueView.init()    // 归还累计欠款利息(FIL)
    
    fileprivate let topSeparateMargin: CGFloat = 12      // 顶部间距，多用于分组首个cell时的间距展示；
    fileprivate let bottomSeparateMargin: CGFloat = 12   // 底部间距
    fileprivate let mainOutLrMargin: CGFloat = 12
    fileprivate let mainInLrMargin: CGFloat = 12

    fileprivate let topViewHeight: CGFloat = 40
    fileprivate let itemVerMargin: CGFloat = 15
    
    
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
extension ReturnListCell {

    /// 便利构造方法
    class func cellInTableView(_ tableView: UITableView, at indexPath: IndexPath? = nil) -> ReturnListCell {
        let identifier = ReturnListCell.identifier
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if nil == cell {
            cell = ReturnListCell.init(style: .default, reuseIdentifier: identifier)
        }
        // 状态重置
        if let cell = cell as? ReturnListCell {
            cell.resetSelf()
            cell.indexPath = indexPath
        }
        return cell as! ReturnListCell
    }

}

// MARK: - LifeCircle/Override Function
extension ReturnListCell {

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
extension ReturnListCell {

    // 界面布局
    fileprivate func initialUI() -> Void {
        self.contentView.backgroundColor = AppColor.pageBg
        // mainView - 整体布局，便于扩展，特别是针对分割、背景色、四周间距
        self.contentView.addSubview(mainView)
        self.initialMainView(self.mainView)
        mainView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.mainOutLrMargin)
            make.trailing.equalToSuperview().offset(-self.mainOutLrMargin)
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-self.bottomSeparateMargin)
        }
        // bottomLine
        mainView.addSubview(self.bottomLine)
        self.bottomLine.backgroundColor = AppColor.dividing
        self.bottomLine.isHidden = true     // 默认隐藏
        self.bottomLine.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.mainInLrMargin)
            make.trailing.equalToSuperview().offset(-self.mainInLrMargin)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    // 主视图布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        //mainView.backgroundColor = UIColor.white
        mainView.set(cornerRadius: 10)
        // 1. topView
        mainView.addSubview(self.topView)
        self.initialTopView(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.topViewHeight)
        }
        // 2. bottomView
        mainView.addSubview(self.bottomView)
        self.initialBottomView(self.bottomView)
        self.bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom)
        }
    }
    ///
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        topView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        //
        topView.addSubview(self.dateLabel)
        self.dateLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: AppColor.mainText)
        self.dateLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.mainInLrMargin)
            make.centerY.equalToSuperview()
        }
    }
    ///
    fileprivate func initialBottomView(_ bottomView: UIView) -> Void {
        bottomView.backgroundColor = UIColor.white
        bottomView.removeAllSubviews()
        //
        let itemViews: [TitleValueView] = [self.returnAmountView, self.realReturnInterestView, self.newInterestView, self.returnMortgageView, self.returnGasView, self.returnTotalInterestView]
        let itemTitles: [String] = ["归还金额(FIL)", "实还利息(FIL)", "新增欠款利息(FIL)", "归还抵押(FIL)", "归还GAS(FIL)", "归还累计欠款利息(FIL)"]
        var lastView: UIView = bottomView
        for (index, itemView) in itemViews.enumerated() {
            bottomView.addSubview(itemView)
            itemView.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                if 0 == index {
                    make.top.equalToSuperview().offset(self.itemVerMargin)
                } else {
                    make.top.equalTo(lastView.snp.bottom).offset(self.itemVerMargin)
                }
                if itemViews.count - 1 == index {
                    make.bottom.equalToSuperview().offset(-self.itemVerMargin)
                }
            }
            itemView.titleLabel.set(text: itemTitles[index], font: UIFont.pingFangSCFont(size: 14), textColor: AppColor.mainText, alignment: .left)
            itemView.titleLabel.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview().offset(self.mainInLrMargin)
                make.centerY.equalToSuperview()
                make.top.greaterThanOrEqualToSuperview().offset(0)
                make.bottom.lessThanOrEqualToSuperview().offset(-0)
            }
            itemView.valueLabel.set(text: "0", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.mainText, alignment: .right)
            itemView.valueLabel.snp.remakeConstraints { (make) in
                make.trailing.equalToSuperview().offset(-self.mainInLrMargin)
                make.centerY.equalToSuperview()
                make.top.greaterThanOrEqualToSuperview().offset(0)
                make.bottom.lessThanOrEqualToSuperview().offset(-0)
            }
            lastView = itemView
        }
    }

}

// MARK: - Data Function
extension ReturnListCell {

    /// 顶部间距是否显示
    fileprivate func setupShowTopMargin(_ show: Bool) -> Void {
        let topMargin: CGFloat = show ? self.topSeparateMargin : 0
        mainView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(topMargin)
        }
        self.layoutIfNeeded()
    }
    /// 底部间距是否显示
    fileprivate func setupShowBottomMargin(_ show: Bool) -> Void {
        let bottomMargin: CGFloat = show ? self.bottomSeparateMargin : 0
        mainView.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottomMargin)
        }
        self.layoutIfNeeded()
    }

    /// 重置
    fileprivate func resetSelf() -> Void {
        self.selectionStyle = .none
        self.isSelected = false
        self.showTopMargin = false
        self.showBottomMargin = true
        self.showBottomLine = false
    }
    ///
    fileprivate func setupAsDemo() -> Void {
        self.dateLabel.text = "2021-02-04 12:00"
        self.returnAmountView.valueLabel.text = "0.1528"
        self.realReturnInterestView.valueLabel.text = "0.1224"
        self.newInterestView.valueLabel.text = "1.24"
        self.returnMortgageView.valueLabel.text = "0"
        self.returnGasView.valueLabel.text = "0"
        self.returnTotalInterestView.valueLabel.text = "13.5781"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: ReturnListModel?) -> Void {
//        self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 控件加载数据
        self.dateLabel.text = model.created_at.string(format: "yyyy-MM-dd HH:mm", timeZone: .current)
        self.returnAmountView.valueLabel.text = model.amount.decimalValidDigitsProcess(digits: 8)
        self.realReturnInterestView.valueLabel.text = model.real_return_interest.decimalValidDigitsProcess(digits: 8)
        self.newInterestView.valueLabel.text = model.arrears_interest.decimalValidDigitsProcess(digits: 8)
        self.returnMortgageView.valueLabel.text = model.pledge.decimalValidDigitsProcess(digits: 8)
        self.returnGasView.valueLabel.text = model.gas.decimalValidDigitsProcess(digits: 8)
        self.returnTotalInterestView.valueLabel.text = model.return_arrears_interest.decimalValidDigitsProcess(digits: 8)
    }

}

// MARK: - Event Function
extension ReturnListCell {
    
}

// MARK: - Notification Function
extension ReturnListCell {
    
}

// MARK: - Extension Function
extension ReturnListCell {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension ReturnListCell {
    
}

