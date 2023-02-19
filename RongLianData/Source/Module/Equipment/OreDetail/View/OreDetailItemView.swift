//
//  OreDetailItemView.swift
//  MallProject
//
//  Created by zhaowei on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit

class OreDetailItemView: UIView {
    
    // MARK: - Internal Property
    
    var model: AssetListModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    var type: EquipZhiyaType = .dianfu {
        didSet {
            self.setupWithType(type)
        }
    }
    
    var showTopMargin: Bool = false {
        didSet {
            self.setupShowTopMargin(showTopMargin)
        }
    }
    var showBottomMargin: Bool = false {
        didSet {
            self.setupShowBottomMargin(showBottomMargin)
        }
    }
    
    // MARK: - Private Property

    fileprivate let mainTopCorner: UIView = UIView.init()
    fileprivate let mainBottomCorner: UIView = UIView.init()
    fileprivate let mainView: UIView = UIView.init()
    
    fileprivate let topView: UIView = UIView.init()
    fileprivate let lineView: UIView = UIView.init()
    fileprivate let dateLabel: UILabel = UILabel.init()
    fileprivate let copyBtn: UIButton = UIButton.init(type: .custom)
    fileprivate let topDashLine: XDDashLineView = XDDashLineView.init(lineColor: UIColor.init(hex: 0xECECEC), lengths: [3.0, 3.0])
    
    fileprivate let produceNumView: TitleValueView = TitleValueView.init()   // 产出数
    
    fileprivate let centerView: UIView = UIView.init()
    // fil
    fileprivate let miningNumView: TitleValueView = TitleValueView.init()   // 累计收益
    fileprivate let fengzhuangNumView: TitleValueView = TitleValueView.init()   // 封装数量
    fileprivate let zhiyaNumView: TitleValueView = TitleValueView.init()   // 借贷质押数量
    fileprivate let gasNumView: TitleValueView = TitleValueView.init()   // 借贷GAS
    fileprivate let interestNumView: TitleValueView = TitleValueView.init()   // 应还利息
    fileprivate let arrearsNumView: TitleValueView = TitleValueView.init()   // 欠款利息

    
    fileprivate let mainTopMargin: CGFloat = 12
    fileprivate let mainBottomMargin: CGFloat = 12
    fileprivate let mainViewHeight: CGFloat = 64
    
    fileprivate let leftMargin: CGFloat = 12
    fileprivate let rightMargin: CGFloat = 12
    
    fileprivate let dateViewCenterYTopMargin: CGFloat = 18
    fileprivate let produceNumCenterYTopMargin: CGFloat = 25
    
    
    
    fileprivate let topViewHeight: CGFloat = 32
    fileprivate let copyViewSize: CGSize = CGSize.init(width: 36, height: 18)
    fileprivate let centerViewHeight: CGFloat = 66

    

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
extension OreDetailItemView {

    class func loadXib() -> OreDetailItemView? {
        return Bundle.main.loadNibNamed("OreDetailItemView", owner: nil, options: nil)?.first as? OreDetailItemView
    }

}

// MARK: - LifeCircle/Override Function
extension OreDetailItemView {

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
extension OreDetailItemView {
    
    /// 界面布局
    fileprivate func initialUI() -> Void {
        //self.backgroundColor = UIColor.white
        //
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-0)
            make.height.equalTo(self.mainViewHeight)
        }
        //
        self.addSubview(self.mainTopCorner)
        self.mainTopCorner.backgroundColor = AppColor.white
        self.mainTopCorner.setupCorners(UIRectCorner.init([UIRectCorner.topLeft, UIRectCorner.topRight]), selfSize: CGSize.init(width: kScreenWidth - 12.0 * 2.0, height: self.mainTopMargin), cornerRadius: 12)
        self.mainTopCorner.isHidden = true
        self.mainTopCorner.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.mainTopMargin)
        }
        //
        self.addSubview(self.mainBottomCorner)
        self.mainBottomCorner.backgroundColor = AppColor.white
        //self.mainBottomCorner.setupCorners(UIRectCorner.init([UIRectCorner.topLeft, UIRectCorner.topRight]), selfSize: CGSize.init(width: kScreenWidth - 12.0 * 2.0, height: self.mainTopMargin), cornerRadius: 12)
        self.mainBottomCorner.isHidden = true
        self.mainBottomCorner.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(self.mainBottomMargin)
        }
    }
    /// mainView布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = UIColor.white
        // 1. lineView
        mainView.addSubview(self.lineView)
        self.lineView.backgroundColor = AppColor.theme
        self.lineView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.leftMargin)
            make.centerY.equalTo(mainView.snp.top).offset(self.dateViewCenterYTopMargin)
            make.size.equalTo(CGSize.init(width: 1.5, height: 10))
        }
        // 2. dateLabel
        mainView.addSubview(self.dateLabel)
        self.dateLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: UIColor.init(hex: 0x333333))
        self.dateLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.lineView.snp.trailing).offset(5)
            make.centerY.equalTo(self.lineView)
        }
        // 3. produceNum
        mainView.addSubview(self.produceNumView)
        self.produceNumView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(self.lineView).offset(self.produceNumCenterYTopMargin)
        }
        self.produceNumView.titleLabel.set(text: "产出数", font: UIFont.pingFangSCFont(size: 13, weight: .regular), textColor: UIColor.init(hex: 0x333333).withAlphaComponent(0.66), alignment: .left)
        self.produceNumView.titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.leftMargin)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(0)
            make.bottom.lessThanOrEqualToSuperview().offset(-0)
        }
        self.produceNumView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: UIColor.init(hex: 0xE26D44), alignment: .right)
        self.produceNumView.valueLabel.snp.remakeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.rightMargin)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(0)
            make.bottom.lessThanOrEqualToSuperview().offset(-0)
        }
        //
        mainView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: self.leftMargin, margin2: self.rightMargin)
//        // 1. topView
//        mainView.addSubview(self.topView)
//        self.initialTopView(self.topView)
//        self.topView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(self.topViewHeight)
//        }
//        // 2. centerView
//        mainView.addSubview(self.centerView)
//        self.initialCenterView(self.centerView, [])
//        self.centerView.snp.makeConstraints { (make) in
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(self.topView.snp.bottom)
//            make.bottom.equalToSuperview()
//        }
    }
    ///
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        let titleLeftMargin: CGFloat = 12     // super.left
        // 1. titleLabel
        topView.addSubview(self.dateLabel)
        self.dateLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x999999))
        self.dateLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(titleLeftMargin)
            make.centerY.equalToSuperview()
        }
        // 2. copyBtn
        topView.addSubview(self.copyBtn)
        self.copyBtn.backgroundColor = UIColor.init(hex: 0xeeeeee)
        self.copyBtn.set(font: UIFont.pingFangSCFont(size: 12), cornerRadius: self.copyViewSize.height * 0.5)
        self.copyBtn.set(title: "复制", titleColor: UIColor.init(hex: 0x666666), for: .normal)
        self.copyBtn.set(title: "复制", titleColor: UIColor.init(hex: 0x666666), for: .highlighted)
        self.copyBtn.addTarget(self, action: #selector(copyBtnClick(_:)), for: .touchUpInside)
        self.copyBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.rightMargin)
            make.centerY.equalToSuperview()
            make.size.equalTo(self.copyViewSize)
        }
        // 6. dashLine
        topView.addSubview(self.topDashLine)
        self.topDashLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(self.leftMargin)
            make.trailing.equalToSuperview().offset(-self.rightMargin)
            make.height.equalTo(0.5)
        }
    }
    ///
    fileprivate func initialCenterView(_ centerView: UIView, _ itemViews: [TitleValueView]) -> Void {
        // itemViews: miningNumView/fengzhuangNumView/progressNumView
        centerView.removeAllSubviews()
        let itemCenterYTBMargin: CGFloat = 20 // cenY to super bottom/top
        let itemVerMargin: CGFloat = 24 // cenY.to cenY
        var lastView: UIView = centerView
        for (index, itemView) in itemViews.enumerated() {
            centerView.addSubview(itemView)
            itemView.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                if 0 == index {
                    make.centerY.equalTo(lastView.snp.top).offset(itemCenterYTBMargin)
                } else {
                    make.centerY.equalTo(lastView.snp.centerY).offset(itemVerMargin)
                }
                if itemViews.count - 1 == index {
                    make.centerY.equalTo(centerView.snp.bottom).offset(-itemCenterYTBMargin)
                }
            }
            itemView.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x999999), alignment: .center)
            itemView.titleLabel.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview().offset(leftMargin)
                make.centerY.equalToSuperview()
                make.top.greaterThanOrEqualToSuperview().offset(0)
                make.bottom.lessThanOrEqualToSuperview().offset(-0)
            }
            itemView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 15, weight: .medium), textColor: UIColor.init(hex: 0x333333), alignment: .center)
            itemView.valueLabel.snp.remakeConstraints { (make) in
                make.trailing.equalToSuperview().offset(-rightMargin)
                make.centerY.equalToSuperview()
                make.top.greaterThanOrEqualToSuperview().offset(0)
                make.bottom.lessThanOrEqualToSuperview().offset(-0)
            }
            lastView = itemView
        }
        self.miningNumView.titleLabel.text = "收益数"
        self.miningNumView.valueLabel.textColor = UIColor.init(hex: 0xE06236)
        self.fengzhuangNumView.titleLabel.text = "封装数"
        self.zhiyaNumView.titleLabel.text = "借贷质押数量"
        self.gasNumView.titleLabel.text = "借贷GAS"
        self.interestNumView.titleLabel.text = "应还利息"
        self.arrearsNumView.titleLabel.text = "欠款利息"
    }

}
// MARK: - UI Xib加载后处理
extension OreDetailItemView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension OreDetailItemView {
    
    /// 顶部间距是否显示
    fileprivate func setupShowTopMargin(_ show: Bool) -> Void {
        let topMargin: CGFloat = show ? self.mainTopMargin : 0
        self.mainView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(topMargin)
        }
        self.layoutIfNeeded()
        //self.mainTopCorner.isHidden = !show
    }
    /// 底部间距是否显示
    fileprivate func setupShowBottomMargin(_ show: Bool) -> Void {
        let bottomMargin: CGFloat = show ? self.mainBottomMargin : 0
        self.mainView.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottomMargin)
        }
        self.layoutIfNeeded()
        //self.mainBottomCorner.isHidden = !show
    }
    
}
extension OreDetailItemView {

    ///
    fileprivate func setupAsDemo() -> Void {
        self.initialCenterView(self.centerView, [self.miningNumView, self.fengzhuangNumView, self.zhiyaNumView, self.gasNumView])
//        self.initialCenterView(self.centerView, [self.miningNumView, self.fengzhuangNumView])
        self.dateLabel.text = "2020年11月09日"
        self.produceNumView.valueLabel.text = "1.1234"
        self.miningNumView.valueLabel.text = "324.12345678"
        self.fengzhuangNumView.valueLabel.text = "46.45"
        self.zhiyaNumView.valueLabel.text = 9.9945.decimalValidDigitsProcess(digits: 8)
        self.gasNumView.valueLabel.text = 536.8464.decimalValidDigitsProcess(digits: 8)
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: AssetListModel?) -> Void {
        self.setupAsDemo()
        return
        guard let model = model else {
            return
        }
//        var itemViews: [TitleValueView] = [self.miningNumView, self.fengzhuangNumView]
//        if let zone = model.zone, zone == .ipfs || zone == .bzz {
//            itemViews.append(contentsOf: [self.zhiyaNumView, self.gasNumView])
//        }
//        if let _ = model.extend?.interest {
//            itemViews.append(self.interestNumView)
//        }
//        if let _ = model.extend?.arrears {
//            itemViews.append(self.arrearsNumView)
//        }
//        self.initialCenterView(self.centerView, itemViews)
        // 子控件数据加载
        // 控件加载数据
        self.dateLabel.text = model.createDate.string(format: "yyyy年MM月dd日", timeZone: .current)
        self.produceNumView.valueLabel.text = model.amount.decimalValidDigitsProcess(digits: 8)
        self.miningNumView.valueLabel.text = model.amount.decimalValidDigitsProcess(digits: 8)
        self.fengzhuangNumView.valueLabel.text = model.extend?.fz_num.decimalValidDigitsProcess(digits: 8)
        self.zhiyaNumView.valueLabel.text = model.extend?.pledge_amount.decimalValidDigitsProcess(digits: 8)
        self.gasNumView.valueLabel.text = model.extend?.gas_amount.decimalValidDigitsProcess(digits: 8)
        self.interestNumView.valueLabel.text = model.extend?.interest?.decimalValidDigitsProcess(digits: 8)
        self.arrearsNumView.valueLabel.text = model.extend?.arrears?.decimalValidDigitsProcess(digits: 8)
    }
    
    ///
    fileprivate func setupWithType(_ type: EquipZhiyaType) -> Void {
        switch type {
        case .dianfu:
            self.zhiyaNumView.titleLabel.text = "借贷质押数量"
            self.gasNumView.titleLabel.text = "借贷GAS"
        case .zifu:
            self.zhiyaNumView.titleLabel.text = "使用质押数量"
            self.gasNumView.titleLabel.text = "使用GAS"
        }
    }
    
}

// MARK: - Event Function
extension OreDetailItemView {

    /// 复制按钮响应
    @objc fileprivate func copyBtnClick(_ button: UIButton) -> Void {
        guard let model = model else {
            return
        }
        var content: String = "收益数: \(model.amount.decimalValidDigitsProcess(digits: 8))\n"
        if let extend = model.extend {
            content += "封装数: \(extend.fz_num.decimalValidDigitsProcess(digits: 8))\n"
            if let zone = model.zone, zone == .ipfs || zone == .bzz {
                content += "借贷质押数量: \(extend.pledge_amount.decimalValidDigitsProcess(digits: 8))\n"
                content += "借贷GAS: \(extend.gas_amount.decimalValidDigitsProcess(digits: 8))\n"
            }
            if let interest = extend.interest {
                content += "应还利息: \(interest.decimalValidDigitsProcess(digits: 8))\n"
            }
            if let arrears = extend.arrears {
                content += "欠款利息: \(arrears.decimalValidDigitsProcess(digits: 8))"
            }
        }
        AppUtil.copyToPasteProcess(content, indicatorMsg: "复制成功") // "复制成功"
    }
    
}

// MARK: - Notification Function
extension OreDetailItemView {
    
}

// MARK: - Extension Function
extension OreDetailItemView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension OreDetailItemView {
    
}
