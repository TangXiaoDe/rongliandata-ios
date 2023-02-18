//
//  EquipDetailTermInfoView.swift
//  RongLianData
//
//  Created by 小唐 on 2021/5/28.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  设备期数配置视图

import UIKit

class EquipDetailTermInfoView: UIView
{
    
    // MARK: - Internal Property
    
    var model: EquipmentDetailExtendModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    fileprivate let dashLine: XDDashLineView = XDDashLineView.init(lineColor: UIColor.init(hex: 0xECECEC), lengths: [3.0, 3.0])
    fileprivate let titleLabel: UILabel = UILabel.init()        // 期数配置说明
    fileprivate let baozhengjinView: TitleValueView = TitleValueView.init()     // 安全保证金
    fileprivate let canUseNumView: TitleValueView = TitleValueView.init()       // 可用数量
    fileprivate let diyaNumView: TitleValueView = TitleValueView.init()         // 抵押数量
    fileprivate let lockNumView: TitleValueView = TitleValueView.init()         // 锁仓数量
    fileprivate let frozenNumView: TitleValueView = TitleValueView.init()       // 冻结数量
    
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let titleCenterYTopMargin: CGFloat = 20
    fileprivate let itemVerMargin: CGFloat = 6
    fileprivate let itemTopMargin: CGFloat = 10
    fileprivate let itemBottomMargin: CGFloat = 12
    
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
extension EquipDetailTermInfoView {

    class func loadXib() -> EquipDetailTermInfoView? {
        return Bundle.main.loadNibNamed("EquipDetailTermInfoView", owner: nil, options: nil)?.first as? EquipDetailTermInfoView
    }

}

// MARK: - LifeCircle/Override Function
extension EquipDetailTermInfoView {

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
extension EquipDetailTermInfoView {
    
    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    /// mainView布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = UIColor.white
        mainView.set(cornerRadius: 10)
        // 1. dashLine
        mainView.addSubview(self.dashLine)
        self.dashLine.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.height.equalTo(0.5)
        }
        // 2. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: "*期数配置说明", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: AppColor.subMainText)
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.centerY.equalTo(mainView.snp.top).offset(self.titleCenterYTopMargin)
        }
        // 3. items
        mainView.addSubview(self.baozhengjinView)
        self.setupItemView(self.baozhengjinView, title: "安全保证金：")
        self.baozhengjinView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(self.lrMargin)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(self.itemTopMargin)
        }
        //
        let titles: [String] = ["可用数量：", "锁仓数量：", "抵押数量：", "冻结数量："]
        let itemViews: [TitleValueView] = [self.canUseNumView, self.lockNumView, self.diyaNumView, self.frozenNumView]
        var topView: UIView = self.baozhengjinView
        for (index, itemView) in itemViews.enumerated() {
            //let row: Int = index / 2
            let col: Int = index % 2
            let isLeft: Bool = col == 0
            mainView.addSubview(itemView)
            self.setupItemView(itemView, title: titles[index], isLeft: isLeft)
            itemView.snp.makeConstraints { (make) in
                if isLeft {
                    make.leading.equalToSuperview().offset(self.lrMargin)
                    make.trailing.lessThanOrEqualTo(mainView.snp.centerX)
                } else {
                    make.trailing.equalToSuperview().offset(-self.lrMargin)
                    make.leading.greaterThanOrEqualTo(mainView.snp.centerX)
                }
                make.top.equalTo(topView.snp.bottom).offset(self.itemVerMargin)
                if index == itemViews.count - 1 {
                    make.bottom.equalToSuperview().offset(-self.itemBottomMargin)
                }
            }
            if !isLeft {
                topView = itemView
            }
        }
    }
    ///
    func setupItemView(_ itemView: TitleValueView, title: String, isLeft: Bool = true) -> Void {
        // 1. title
        itemView.titleLabel.set(text: title, font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.grayText)
        itemView.titleLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            if isLeft {
                make.leading.equalToSuperview()
            } else {
                make.leading.greaterThanOrEqualToSuperview()
            }
        }
        // 2. value
        itemView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: AppColor.subMainText)
        itemView.valueLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(itemView.titleLabel.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            if isLeft {
                make.trailing.lessThanOrEqualToSuperview()
            } else {
                make.trailing.lessThanOrEqualToSuperview()
            }
        }
    }
    
}
// MARK: - UI Xib加载后处理
extension EquipDetailTermInfoView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension EquipDetailTermInfoView {

    ///
    fileprivate func setupAsDemo() -> Void {
        self.titleLabel.text = "我是标题"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: EquipmentDetailExtendModel?) -> Void {
        //self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 子控件数据加载
        self.baozhengjinView.valueLabel.text = model.security.decimalValidDigitsProcess(digits: 2) + "%"
        self.canUseNumView.valueLabel.text = model.withdrawable.decimalValidDigitsProcess(digits: 2) + "%"
        self.diyaNumView.valueLabel.text = model.pawn.decimalValidDigitsProcess(digits: 2) + "%"
        self.lockNumView.valueLabel.text = model.lock.decimalValidDigitsProcess(digits: 2) + "%"
        self.frozenNumView.valueLabel.text = model.frozen.decimalValidDigitsProcess(digits: 2) + "%"
    }
    
}

// MARK: - Event Function
extension EquipDetailTermInfoView {


}

// MARK: - Notification Function
extension EquipDetailTermInfoView {
    
}

// MARK: - Extension Function
extension EquipDetailTermInfoView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension EquipDetailTermInfoView {
    
}

