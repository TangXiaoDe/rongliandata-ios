//
//  EquipmentHomeItemView.swift
//  AntClusterB
//
//  Created by 小唐 on 2020/12/3.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  

import UIKit

class EquipmentHomeItemView: UIView {
    
    // MARK: - Internal Property
    
    var model: EquipmentListModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    // MARK: - Private Property

    fileprivate let mainView: UIView = UIView.init()
    
    fileprivate let topView: UIView = UIView.init()
    fileprivate let iconView: UIImageView = UIImageView.init()          // 左侧红色竖线
    fileprivate let titleLabel: UILabel = UILabel.init()                // 第xxx期
    fileprivate let specView: TitleValueView = TitleValueView.init()    // 封装规格
    fileprivate let totalNumView: UILabel = UILabel.init()               // 规格数，xxT
    fileprivate let statusLabel: UILabel = UILabel.init()                // 状态
    fileprivate let dashLine: XDDashLineView = XDDashLineView.init(lineColor: AppColor.dividing, lengths: [3.0, 3.0])
    
    fileprivate let bottomView: UIView = UIView.init()
    fileprivate let miningNumView: TitleValueView = TitleValueView.init()   // 挖矿总数
    fileprivate let fengzhuangNumView: TitleValueView = TitleValueView.init()   // 封装数量
    fileprivate let progressNumView: TitleValueView = TitleValueView.init()   // 封存进度

    fileprivate let topViewHeight: CGFloat = 62
    fileprivate let bottomViewHeight: CGFloat = 62
    fileprivate let leftMargin: CGFloat = 14
    fileprivate let rightMargin: CGFloat = 10
    

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
extension EquipmentHomeItemView {

    class func loadXib() -> EquipmentHomeItemView? {
        return Bundle.main.loadNibNamed("EquipmentHomeItemView", owner: nil, options: nil)?.first as? EquipmentHomeItemView
    }

}

// MARK: - LifeCircle/Override Function
extension EquipmentHomeItemView {

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
extension EquipmentHomeItemView {
    
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
            make.height.equalTo(self.bottomViewHeight)
        }
    }
    ///
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        
        let iconSize: CGSize = CGSize.init(width: 3, height: 28)
        let iconTopMargin: CGFloat = 10
        let titleCenterYTopMargin: CGFloat = 23     // super.top
        let specCenterYTopMargin: CGFloat = 23      // title.centerY
        // 1. iconView
        topView.addSubview(self.iconView)
        self.iconView.set(cornerRadius: iconSize.width * 0.5)
        self.iconView.backgroundColor = UIColor.init(hex: 0xFF455E)
        self.iconView.snp.makeConstraints { (make) in
            make.size.equalTo(iconSize)
            make.leading.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(iconTopMargin)
        }
        // 2. titleLabel
        topView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: UIColor.init(hex: 0x333333))
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.leftMargin)
            make.centerY.equalTo(topView.snp.top).offset(titleCenterYTopMargin)
        }
        // 3. specView
        topView.addSubview(self.specView)
        self.specView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.titleLabel)
            make.centerY.equalTo(self.titleLabel.snp.centerY).offset(specCenterYTopMargin)
        }
        self.specView.titleLabel.set(text: "封装规格：", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x999999))
        self.specView.titleLabel.snp.remakeConstraints { (make) in
            make.leading.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        self.specView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x333333))
        self.specView.valueLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(self.specView.titleLabel.snp.trailing).offset(5)
            make.trailing.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        // 4. totalNumView
        topView.addSubview(self.totalNumView)
        self.totalNumView.set(text: nil, font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: UIColor.init(hex: 0x333333), alignment: .right)
        self.totalNumView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.rightMargin)
            make.centerY.equalTo(self.iconView)
        }
        // 5. statusLabel
        topView.addSubview(self.statusLabel)
        self.statusLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x999999), alignment: .right)
        self.statusLabel.snp.remakeConstraints { (make) in
            make.trailing.equalTo(self.totalNumView)
            make.centerY.equalTo(self.specView)
        }
        // 6. dashLine
        topView.addSubview(self.dashLine)
        self.dashLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(self.leftMargin)
            make.trailing.equalToSuperview().offset(-self.rightMargin)
            make.height.equalTo(0.5)
        }
    }
    ///
    fileprivate func initialBottomView(_ bottomView: UIView) -> Void {
        // itemViews: miningNumView/fengzhuangNumView/progressNumView
        bottomView.removeAllSubviews()
        let titleCenterYBottomMargin: CGFloat = 21 // super.bottom
        let valueCenterYTopMargin: CGFloat = 20    // super.top
        let itemViews: [TitleValueView] = [self.miningNumView, self.fengzhuangNumView, self.progressNumView]
        let itemTitles: [String] = ["挖矿总数", "封装数量(T)", "封存进度"]
        var leftView: UIView = bottomView
        for (index, itemView) in itemViews.enumerated() {
            bottomView.addSubview(itemView)
            itemView.snp.makeConstraints { (make) in
                make.width.equalToSuperview().multipliedBy(1.0 / 3.0)
                if 0 == index {
                    make.leading.equalToSuperview()
                } else {
                    make.leading.equalTo(leftView.snp.trailing)
                }
                if itemViews.count - 1 == index {
                    make.trailing.equalToSuperview()
                }
            }
            itemView.titleLabel.set(text: itemTitles[index], font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x999999), alignment: .center)
            itemView.titleLabel.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.leading.greaterThanOrEqualToSuperview()
                make.trailing.lessThanOrEqualToSuperview()
                make.centerY.equalTo(bottomView.snp.bottom).offset(-titleCenterYBottomMargin)
            }
            itemView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x333333), alignment: .center)
            itemView.valueLabel.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.leading.greaterThanOrEqualToSuperview()
                make.trailing.lessThanOrEqualToSuperview()
                make.centerY.equalTo(bottomView.snp.top).offset(valueCenterYTopMargin)
            }
            leftView = itemView
        }
    }
    
}
// MARK: - UI Xib加载后处理
extension EquipmentHomeItemView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension EquipmentHomeItemView {

    ///
    fileprivate func setupAsDemo() -> Void {
        self.titleLabel.text = "第20201019期"
        self.specView.valueLabel.text = "1个月"
        self.miningNumView.valueLabel.text = "324.12345678"
        self.fengzhuangNumView.valueLabel.text = "46.45"
        self.progressNumView.valueLabel.text = "14.20%"
        // 0x2381FB挖矿中 | 0x333333部署中 | 0x999999已关闭
        self.statusLabel.text = "挖矿中"
        self.statusLabel.textColor = UIColor.init(hex: 0x2381FB)
        
        var totalNumAtts = NSAttributedString.textAttTuples()
        totalNumAtts.append((str: "200", font: UIFont.pingFangSCFont(size: 22, weight: .medium), color: UIColor.init(hex: 0xFF455E)))
        totalNumAtts.append((str: " T", font: UIFont.pingFangSCFont(size: 14, weight: .medium), color: UIColor.init(hex: 0xFF455E)))
        self.totalNumView.attributedText = NSAttributedString.attribute(totalNumAtts)
    }
    
    /// 数据加载
    fileprivate func setupWithModel(_ model: EquipmentListModel?) -> Void {
        //self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 子控件数据加载
        self.titleLabel.text = "第\(model.fil_level)期"
        self.titleLabel.textColor = model.titleColor
        self.specView.valueLabel.text = model.spec_level
        self.specView.valueLabel.textColor = model.titleColor
        self.miningNumView.valueLabel.text = model.total_ming.decimalValidDigitsProcess(digits: 4)
        self.fengzhuangNumView.valueLabel.text = model.seal_num.decimalValidDigitsProcess(digits: 2)
        self.progressNumView.valueLabel.text = (model.fengcun_progress * 100).decimalValidDigitsProcess(digits: 2) + "%"
        self.statusLabel.text = model.status.title
        self.statusLabel.textColor = model.statusColor
        self.iconView.backgroundColor = model.iconColor

        var totalNumAtts = NSAttributedString.textAttTuples()
        totalNumAtts.append((str: "\(model.t_num)", font: UIFont.pingFangSCFont(size: 22, weight: .medium), color: model.totalNumColor))
        totalNumAtts.append((str: " T", font: UIFont.pingFangSCFont(size: 14, weight: .medium), color: model.totalNumColor))
        self.totalNumView.attributedText = NSAttributedString.attribute(totalNumAtts)
    }
    
}

// MARK: - Event Function
extension EquipmentHomeItemView {

    //
    @objc fileprivate func doneBtnClick(_ doneBtn: UIButton) -> Void {
        print("EquipmentHomeItemView doneBtnClick")
    }

}

// MARK: - Notification Function
extension EquipmentHomeItemView {
    
}

// MARK: - Extension Function
extension EquipmentHomeItemView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension EquipmentHomeItemView {
    
}

