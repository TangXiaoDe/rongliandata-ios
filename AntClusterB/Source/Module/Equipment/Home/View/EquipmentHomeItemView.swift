//
//  EquipmentHomeItemView.swift
//  AntClusterB
//
//  Created by 小唐 on 2020/12/3.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  

protocol EquipmentHomeItemViewProtocol: class {
    /// 点击设备明细按钮
    func itemView(_ view: EquipmentHomeItemView, didClickEquipmentDetail btn: UIButton)
    /// 点击挖坑详情按钮
    func itemView(_ view: EquipmentHomeItemView, didClickOreDetail btn: UIButton)
}

import UIKit

class EquipmentHomeItemView: UIView {
    
    static let viewHeight: CGFloat = 178
    // MARK: - Internal Property
    
    var model: EquipmentListModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    weak var delegate: EquipmentHomeItemViewProtocol?
    
    // MARK: - Private Property

    fileprivate let mainView: UIView = UIView.init()
    
    fileprivate let topView: UIView = UIView.init()
    fileprivate let iconView: UIImageView = UIImageView.init()          // 左侧红色竖线
    fileprivate let titleLabel: UILabel = UILabel.init()                // 第xxx期
    fileprivate let specView: TitleValueView = TitleValueView.init()    // 封装规格
    fileprivate let totalNumView: UILabel = UILabel.init()               // 规格数，xxT
    fileprivate let statusLabel: UILabel = UILabel.init()                // 状态
    fileprivate let topDashLine: XDDashLineView = XDDashLineView.init(lineColor: UIColor.init(hex: 0xECECEC), lengths: [3.0, 3.0])
    
    fileprivate let centerView: UIView = UIView.init()
    // fil
    fileprivate let miningNumView: TitleValueView = TitleValueView.init()   // 挖矿总数
    fileprivate let fengzhuangNumView: TitleValueView = TitleValueView.init()   // 封装数量
    fileprivate let progressNumView: TitleValueView = TitleValueView.init()   // 封装比例
    // btc/eth
    fileprivate let incomeNumView: TitleValueView = TitleValueView.init()   // 累计收益
    fileprivate let yesterdayNumView: TitleValueView = TitleValueView.init()   // 昨日收益
    fileprivate let huibenNumView: TitleValueView = TitleValueView.init()   // 回本进度
    
    fileprivate let bottomDashLine: XDDashLineView = XDDashLineView.init(lineColor: UIColor.init(hex: 0xECECEC), lengths: [3.0, 3.0])
    fileprivate let bottomView: UIView = UIView.init()
    fileprivate let equimentDetailBtn: UIButton = UIButton.init(type: .custom)
    fileprivate let oreDetailBtn: UIButton = UIButton.init(type: .custom)

    fileprivate let topViewHeight: CGFloat = 71
    fileprivate let centerViewHeight: CGFloat = 62
    fileprivate let bottomViewHeight: CGFloat = 44
    fileprivate let leftMargin: CGFloat = 12
    fileprivate let rightMargin: CGFloat = 12
    fileprivate let detailBtnSize: CGSize = CGSize.init(width: 74, height: 28)
    fileprivate let detailBtnHorMargin: CGFloat = 12
    fileprivate let itemLrMargin: CGFloat = 12
    

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
        // 2. centerView
        mainView.addSubview(self.centerView)
        self.initialCenterView(self.centerView, [])
        self.centerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom)
            make.height.equalTo(self.centerViewHeight)
        }
        // 3. bottomView
        mainView.addSubview(self.bottomView)
        self.initiaBottomView(self.bottomView, [])
        self.bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.centerView.snp.bottom)
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
        let titleCenterYBottomMargin: CGFloat = 21 // super.bottom
        let valueCenterYTopMargin: CGFloat = 20    // super.top
        var leftView: UIView = centerView
        for (index, itemView) in itemViews.enumerated() {
            centerView.addSubview(itemView)
            itemView.snp.makeConstraints { (make) in
                make.width.equalToSuperview().multipliedBy(1.0 / 3.0)
                if 0 == index {
                    make.leading.equalToSuperview()
                } else {
                    make.leading.equalTo(leftView.snp.trailing)
                }
                if itemViews.count - 1 == index {
//                    make.trailing.equalToSuperview()
                }
            }
            itemView.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .regular), textColor: UIColor.init(hex: 0x999999), alignment: .center)
            itemView.titleLabel.snp.remakeConstraints { (make) in
                make.centerY.equalTo(centerView.snp.bottom).offset(-titleCenterYBottomMargin)
                if 0 == index {
                    make.leading.equalToSuperview().offset(self.itemLrMargin)
                    make.trailing.lessThanOrEqualToSuperview()
                } else if index == itemViews.count - 1 {
                    make.trailing.equalToSuperview().offset(-self.itemLrMargin)
                    make.leading.greaterThanOrEqualToSuperview()
                } else {
                    make.centerX.equalToSuperview()
                    make.leading.greaterThanOrEqualToSuperview()
                    make.trailing.lessThanOrEqualToSuperview()
                }
            }
            itemView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: UIColor.init(hex: 0x333333), alignment: .center)
            itemView.valueLabel.snp.remakeConstraints { (make) in
                make.centerY.equalTo(centerView.snp.top).offset(valueCenterYTopMargin)
                if 0 == index {
                    make.leading.equalToSuperview().offset(self.itemLrMargin)
                    make.trailing.lessThanOrEqualToSuperview()
                } else if index == itemViews.count - 1 {
                    make.trailing.equalToSuperview().offset(-self.itemLrMargin)
                    make.leading.greaterThanOrEqualToSuperview()
                } else {
                    make.centerX.equalToSuperview()
                    make.leading.greaterThanOrEqualToSuperview()
                    make.trailing.lessThanOrEqualToSuperview()
                }
            }
            if 0 == index {
                itemView.titleLabel.textAlignment = .left
                itemView.valueLabel.textAlignment = .left
            } else if index == itemViews.count - 1 {
                itemView.titleLabel.textAlignment = .right
                itemView.valueLabel.textAlignment = .right
            } else {
                itemView.titleLabel.textAlignment = .center
                itemView.valueLabel.textAlignment = .center
            }
            leftView = itemView
        }
        self.miningNumView.titleLabel.text = "挖矿总数"
        self.fengzhuangNumView.titleLabel.text = "封装数量"
        self.progressNumView.titleLabel.text = "封装比例"
        self.incomeNumView.titleLabel.text = "累计收益"
        self.yesterdayNumView.titleLabel.text = "昨日收益"
        self.huibenNumView.titleLabel.text = "回本进度"
    }
    fileprivate func initiaBottomView(_ bottomView: UIView, _ itemViews: [UIButton]) -> Void {
        bottomView.removeAllSubviews()
        // 0. dashLine
        bottomView.addSubview(self.bottomDashLine)
        self.bottomDashLine.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(self.leftMargin)
            make.trailing.equalToSuperview().offset(-self.rightMargin)
            make.height.equalTo(0.5)
        }
        var rightView: UIView = bottomView
        for (index, itemView) in itemViews.enumerated() {
            bottomView.addSubview(itemView)
            itemView.snp.makeConstraints { (make) in
                make.size.equalTo(self.detailBtnSize)
                if 0 == index {
                    make.trailing.equalToSuperview().offset(-rightMargin)
                } else {
                    make.trailing.equalTo(rightView.snp.leading).offset(-detailBtnHorMargin)
                }
                make.centerY.equalToSuperview()
            }
            rightView = itemView
        }
        // equimentDetailBtn
        self.equimentDetailBtn.set(title: "设备详情", titleColor: UIColor.init(hex: 0xF5BE41), for: .normal)
        self.equimentDetailBtn.set(font: UIFont.pingFangSCFont(size: 13, weight: .medium), cornerRadius: 4, borderWidth: 0.5, borderColor: UIColor.init(hex: 0xF5BE41))
        self.equimentDetailBtn.backgroundColor = UIColor.init(hex: 0xFFFBED)
        self.equimentDetailBtn.addTarget(self, action: #selector(equipmentDetailBtnClick(_:)), for: .touchUpInside)
        // oreDetailBtn
        self.oreDetailBtn.set(title: "挖矿明细", titleColor: UIColor.init(hex: 0x00B8FF), for: .normal)
        self.oreDetailBtn.set(font: UIFont.pingFangSCFont(size: 13, weight: .medium), cornerRadius: 4, borderWidth: 0.5, borderColor: UIColor.init(hex: 0x00B8FF))
        self.oreDetailBtn.backgroundColor = UIColor.init(hex: 0xEEF5FF)
        self.oreDetailBtn.addTarget(self, action: #selector(oreDetailBtnClick(_:)), for: .touchUpInside)
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
        self.initialCenterView(self.centerView, [self.miningNumView, self.fengzhuangNumView, self.progressNumView])
        self.initiaBottomView(self.bottomView, [self.equimentDetailBtn, self.oreDetailBtn])
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
//        self.setupAsDemo()
        guard let model = model else {
            return
        }
        if model.zone == .ipfs {
            self.initialCenterView(self.centerView, [self.miningNumView, self.fengzhuangNumView, self.progressNumView])
            self.initiaBottomView(self.bottomView, [self.equimentDetailBtn, self.oreDetailBtn])
        } else {
            self.initialCenterView(self.centerView, [self.miningNumView, self.fengzhuangNumView, self.progressNumView])
            self.initiaBottomView(self.bottomView, [self.oreDetailBtn])
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
    @objc fileprivate func equipmentDetailBtnClick(_ btn: UIButton) -> Void {
        self.delegate?.itemView(self, didClickEquipmentDetail: btn)
    }
    @objc fileprivate func oreDetailBtnClick(_ btn: UIButton) -> Void {
        self.delegate?.itemView(self, didClickOreDetail: btn)
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

