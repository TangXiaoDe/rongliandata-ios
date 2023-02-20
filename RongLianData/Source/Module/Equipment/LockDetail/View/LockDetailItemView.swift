//
//  LockDetailItemView.swift
//  MallProject
//
//  Created by zhaowei on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit

class LockDetailItemView: UIView {
    
    static let viewHeight: CGFloat = 96
    // MARK: - Internal Property
    
    var model: LockDetailLogModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    var isFirst: Bool = false {
        didSet {
            self.setupIsFirst(isFirst)
        }
    }
    var showBottomLine: Bool = true {
        didSet {
            self.bottomLine.isHidden = !showBottomLine
        }
    }
    // MARK: - Private Property

    fileprivate let mainView: UIView = UIView.init()
    
    fileprivate let topView: UIView = UIView.init()
    //fileprivate let titleView: UIView = UIView.init()
    fileprivate let lineView: UIView = UIView.init()
    fileprivate let dateLabel: UILabel = UILabel.init()
    fileprivate let amountLabel: UILabel = UILabel.init()
    
    fileprivate let centerView: UIView = UIView.init()
    fileprivate let releasedItemView: TitleValueView = TitleValueView.init()   // 已释放
    fileprivate let progressItemView: TitleValueView = TitleValueView.init()   // 进度
    
    
    // fil
    fileprivate let miningNumView: TitleValueView = TitleValueView.init()   // 累计收益
    fileprivate let fengzhuangNumView: TitleValueView = TitleValueView.init()   // 封装数量
    fileprivate let progressNumView: TitleValueView = TitleValueView.init()   // 封装比例
    
    fileprivate weak var bottomLine: UIView!
    fileprivate let centerViewHeight: CGFloat = 68
    
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let titleLeftMargin: CGFloat = 18
    
    fileprivate let leftMargin: CGFloat = 12
    fileprivate let rightMargin: CGFloat = 12
    

    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        //fatalError("init(coder:) has not been implemented")
    }
    
    /// 通用初始化：UI、配置、数据等
    func commonInit() -> Void {
        self.initialUI()
    }
    
}

// MARK: - Internal Function
extension LockDetailItemView {

    class func loadXib() -> LockDetailItemView? {
        return Bundle.main.loadNibNamed("LockDetailItemView", owner: nil, options: nil)?.first as? LockDetailItemView
    }

}

// MARK: - LifeCircle/Override Function
extension LockDetailItemView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
    
    /// 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
// MARK: - UI Function
extension LockDetailItemView {
    
    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.backgroundColor = UIColor.white
        //
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    /// mainView布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // topView
        mainView.addSubview(self.topView)
        self.initialTopView(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(15)
        }
        // 2. centerView
        mainView.addSubview(self.centerView)
        self.initialCenterView(self.centerView)
        self.centerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        //
        self.bottomLine = mainView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: self.lrMargin, margin2: self.lrMargin)
    }
    ///
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        // lineView
        topView.addSubview(self.lineView)
        self.lineView.backgroundColor = AppColor.theme
        self.lineView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 1.5, height: 10))
        }
        // 2. dateLabel
        topView.addSubview(self.dateLabel)
        self.dateLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: UIColor.init(hex: 0x333333))
        self.dateLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.titleLeftMargin)
            make.centerY.equalTo(self.lineView)
        }
        // 3. amountLabel
        topView.addSubview(self.amountLabel)
        self.amountLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.themeRed, alignment: .right)
        self.amountLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.centerY.equalToSuperview()
        }
    }
    ///
    fileprivate func initialCenterView(_ centerView: UIView) -> Void {
        //
        let itemViews: [TitleValueView] = [self.releasedItemView, self.progressItemView]
        let itemTitles: [String] = ["已释放", "进度"]
        var topView: UIView = centerView
        for (index, itemView) in itemViews.enumerated() {
            centerView.addSubview(itemView)
            itemView.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(12)
                if 0 == index {
                    make.top.equalToSuperview().offset(8)
                } else {
                    make.top.equalTo(topView.snp.bottom).offset(10)
                }
                if index == itemViews.count - 1 {
                    make.bottom.equalToSuperview().offset(-8)
                }
            }
            //
            itemView.titleLabel.set(text: itemTitles[index], font: UIFont.pingFangSCFont(size: 13, weight: .regular), textColor: UIColor.init(hex: 0x333333).withAlphaComponent(0.66), alignment: .left)
            itemView.titleLabel.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview().offset(self.titleLeftMargin)
                make.centerY.equalToSuperview()
            }
            itemView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: UIColor.init(hex: 0x333333), alignment: .right)
            itemView.valueLabel.snp.remakeConstraints { (make) in
                make.trailing.equalToSuperview().offset(-self.lrMargin)
                make.centerY.equalToSuperview()
            }
            //
            topView = itemView
        }
    }
    
    ///
    fileprivate func initialCenterView(_ centerView: UIView, _ itemViews: [TitleValueView]) -> Void {
        // itemViews: miningNumView/fengzhuangNumView/progressNumView
        centerView.removeAllSubviews()
        let titleCenterYBottomMargin: CGFloat = 21 // super.bottom
        let valueCenterYTopMargin: CGFloat = 20    // super.top
        var leftView: UIView = centerView
        let leftWidth: CGFloat = kScreenWidth * 0.5 - 12 - 20   // 12(itemLeftMargin)
        let centerWidth: CGFloat = (kScreenWidth * 0.5 + 20.0) * 0.5 - 20
        let rightWidth: CGFloat = (kScreenWidth * 0.5 + 20.0) * 0.5 + 20
        for (index, itemView) in itemViews.enumerated() {
            centerView.addSubview(itemView)
            itemView.snp.makeConstraints { (make) in
                if 0 == index {
                    make.leading.equalToSuperview().offset(12)
                } else {
                    make.leading.equalTo(leftView.snp.trailing)
                }
                if 0 == index {
                    make.width.equalTo(leftWidth)
                } else if index == itemViews.count - 1 {
                    make.width.equalTo(rightWidth)
                } else {
                    make.width.equalTo(centerWidth)
                }
            }
            itemView.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x999999), alignment: .center)
            itemView.titleLabel.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview()
                make.trailing.lessThanOrEqualToSuperview()
                make.centerY.equalTo(centerView.snp.bottom).offset(-titleCenterYBottomMargin)
            }
            itemView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.mainText, alignment: .center)
            itemView.valueLabel.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview()
                make.trailing.lessThanOrEqualToSuperview()
                make.centerY.equalTo(centerView.snp.top).offset(valueCenterYTopMargin)
            }
            leftView = itemView
        }
        self.miningNumView.titleLabel.text = "2021-01-10 12:00"
        self.fengzhuangNumView.titleLabel.text = "进度"
        self.progressNumView.titleLabel.text = "已释放"
        // 0. bottomLine
        self.bottomLine = centerView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: self.leftMargin, margin2: self.rightMargin)
    }
}
// MARK: - UI Xib加载后处理
extension LockDetailItemView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension LockDetailItemView {

    ///
    fileprivate func setupIsFirst(_ isFirst: Bool) -> Void {
        if isFirst {
            self.setupCorners([UIRectCorner.topRight, UIRectCorner.topLeft], selfSize: CGSize.init(width: kScreenWidth, height: self.centerViewHeight), cornerRadius: 16)
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    ///
    fileprivate func setupShowTopMargin(_ isShow: Bool) -> Void {
        
    }
    ///
    fileprivate func setupShowBottomMargin(_ isShow: Bool) -> Void {
        
    }
    
    ///
    fileprivate func setupAsDemo() -> Void {
        //self.initialCenterView(self.centerView, [self.miningNumView, self.fengzhuangNumView, self.progressNumView])
        //self.miningNumView.valueLabel.text = "324.12345678"
        //self.fengzhuangNumView.valueLabel.text = "46.45"
        //self.progressNumView.valueLabel.text = "14.20%"
        //
        self.dateLabel.text = Date.init().string(format: "yyyy-MM-dd HH:mm", timeZone: .current)
        self.amountLabel.text = "1.1234"
        self.releasedItemView.valueLabel.text = "0.6548"
        self.progressItemView.valueLabel.text = "1/180"
    }
    
    /// 数据加载
    fileprivate func setupWithModel(_ model: LockDetailLogModel?) -> Void {
//        self.setupAsDemo()
//        return
        guard let model = model else {
            return
        }
        //self.initialCenterView(self.centerView, [self.miningNumView, self.fengzhuangNumView, self.progressNumView])
        //self.miningNumView.titleLabel.text = model.created_at.string(format: "yyyy-MM-dd HH:mm", timeZone: .current)
        //self.miningNumView.valueLabel.text = model.amount.decimalValidDigitsProcess(digits: 8)
        //self.fengzhuangNumView.valueLabel.text = model.strProgress
        //self.progressNumView.valueLabel.text = model.released.decimalValidDigitsProcess(digits: 8)
        self.dateLabel.text = model.created_at.string(format: "yyyy-MM-dd HH:mm", timeZone: .current)
        self.amountLabel.text = model.amount.decimalValidDigitsProcess(digits: 8)
        self.releasedItemView.valueLabel.text = model.released.decimalValidDigitsProcess(digits: 8)
        self.progressItemView.valueLabel.text = model.strProgress
    }
    
}

// MARK: - Event Function
extension LockDetailItemView {

}

// MARK: - Notification Function
extension LockDetailItemView {
    
}

// MARK: - Extension Function
extension LockDetailItemView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension LockDetailItemView {
    
}
