//
//  OreDetailHeaderView.swift
//  MallProject
//
//  Created by zhaowei on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit

class OreDetailHeaderView: UIView {
    
    static let noGroupViewHeight: CGFloat = CGSize.init(width: 351, height: 146.5).scaleAspectForWidth(kScreenWidth - 2 * 12).height
    static let hasGroupViewHeight: CGFloat = CGSize.init(width: 351, height: 166).scaleAspectForWidth(kScreenWidth - 2 * 12).height
    static let viewHeight: CGFloat = 143

    // MARK: - Internal Property
    
    var model: EquipmentListModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    // MARK: - Private Property

    fileprivate let mainView: UIView = UIView.init()
    fileprivate let bgImgView: UIImageView = UIImageView()
    
    fileprivate let topView: UIView = UIView.init()
    fileprivate let titleLabel: UILabel = UILabel.init()                // 第xxx期
    fileprivate let statusView: TitleContainer = TitleContainer.init()                // 状态
    fileprivate let zhiYaFlagView: TitleContainer = TitleContainer()           // 自付质押标记
    fileprivate let totalNumView: UILabel = UILabel.init()               // 规格数，xxT

    fileprivate let iconView: UIImageView = UIImageView.init()          // 左侧红色竖线
    fileprivate let zhiYaImgView: UIImageView = UIImageView()           // 自付质押图片标记
    fileprivate let topDashLine: XDDashLineView = XDDashLineView.init(lineColor: UIColor.init(hex: 0xECECEC), lengths: [3.0, 3.0])
    fileprivate let groupView: TitleValueView = TitleValueView.init()   // 节点号
    
    fileprivate let centerView: UIView = UIView.init()
    fileprivate let miningNumView: TitleValueView = TitleValueView.init()   // 产出总数
    fileprivate let specView: TitleValueView = TitleValueView.init()    // 封装规格
    
    // fil
    //fileprivate let miningNumView: TitleValueView = TitleValueView.init()   // 累计收益
    fileprivate let fengzhuangNumView: TitleValueView = TitleValueView.init()   // 封装数量
    fileprivate let progressNumView: TitleValueView = TitleValueView.init()   // 封装比例
    // btc/eth
    fileprivate let incomeNumView: TitleValueView = TitleValueView.init()   // 累计收益
    fileprivate let yesterdayNumView: TitleValueView = TitleValueView.init()   // 昨日收益
    fileprivate let huibenNumView: TitleValueView = TitleValueView.init()   // 回本进度

    fileprivate let noGroupTopViewHeight: CGFloat = 72
    fileprivate let hasGroupTopViewHeight: CGFloat = 92
    fileprivate let topViewHeight: CGFloat = 70
    fileprivate let titleCenterYTopMargin: CGFloat = 22
    fileprivate let statusTopMargin: CGFloat = 8
    fileprivate let statusViewHeight: CGFloat = 18
    fileprivate let statusInLrMargin: CGFloat = 6
    
    fileprivate let centerViewHeight: CGFloat = 58
    fileprivate let centerBottomMargin: CGFloat = 15
    fileprivate let centerItemHorMargin: CGFloat = 22
    
    fileprivate let leftMargin: CGFloat = 15
    fileprivate let rightMargin: CGFloat = 15
    
    fileprivate let itemLrMargin: CGFloat = 12
    fileprivate let zhiYaImgSize: CGSize = CGSize.init(width: 64, height: 18)
    fileprivate let zhiYaLeftMargin: CGFloat = 6

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
extension OreDetailHeaderView {

    class func loadXib() -> OreDetailHeaderView? {
        return Bundle.main.loadNibNamed("OreDetailHeaderView", owner: nil, options: nil)?.first as? OreDetailHeaderView
    }

}

// MARK: - LifeCircle/Override Function
extension OreDetailHeaderView {

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
extension OreDetailHeaderView {
    
    /// 界面布局
    fileprivate func initialUI() -> Void {
        //
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    /// mainView布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
//        mainView.addSubview(self.bgImgView)
//        self.bgImgView.image = UIImage.init(named: "IMG_mine_sb_top_box_group")
//        self.bgImgView.set(cornerRadius: 0)
//        self.bgImgView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        // 1. topView
        mainView.addSubview(self.topView)
        self.initialTopView(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.topViewHeight)
        }
        // 2. centerView
        mainView.addSubview(self.centerView)
        self.initialCenterView(self.centerView)
        self.centerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.centerViewHeight)
            make.top.equalTo(self.topView.snp.bottom)
            make.bottom.equalToSuperview().offset(-self.centerBottomMargin)
        }
    }
    ///
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        // titleLabel
        topView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 15, weight: .medium), textColor: UIColor.init(hex: 0x333333))
        self.titleLabel.numberOfLines = 1
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.leftMargin)
            make.trailing.equalToSuperview().offset(-self.rightMargin)
            make.centerY.equalTo(topView.snp.top).offset(self.titleCenterYTopMargin)
        }
        // statusView
        topView.addSubview(self.statusView)
        self.statusView.backgroundColor = UIColor.init(hex: 0x999999).withAlphaComponent(0.1)
        self.statusView.set(cornerRadius: 3)
        self.statusView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(self.statusTopMargin)
            make.height.equalTo(self.statusViewHeight)
        }
        self.statusView.label.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x999999), alignment: .center)
        self.statusView.label.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.statusInLrMargin)
            make.trailing.equalToSuperview().offset(-self.statusInLrMargin)
            make.centerY.equalToSuperview()
        }
        //zhiYaFlagView
        topView.addSubview(self.zhiYaFlagView)
        self.zhiYaFlagView.isHidden = true // 默认隐藏
        self.zhiYaFlagView.backgroundColor = UIColor.init(hex: 0x1CBD9E).withAlphaComponent(0.1)
        self.zhiYaFlagView.set(cornerRadius: 3)
        self.zhiYaFlagView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.statusView.snp.trailing).offset(6)
            make.centerY.equalTo(self.statusView)
            make.height.equalTo(self.statusViewHeight)
        }
        self.zhiYaFlagView.label.set(text: "自付质押", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x1CBD9E), alignment: .center)
        self.zhiYaFlagView.label.snp.remakeConstraints { (make) in
            make.trailing.equalToSuperview().offset(self.statusInLrMargin)
            make.trailing.equalToSuperview().offset(-self.statusInLrMargin)
            make.centerY.equalToSuperview()
        }
        //
        topView.addSubview(self.totalNumView)
        self.totalNumView.set(text: nil, font: UIFont.pingFangSCFont(size: 19, weight: .medium), textColor: AppColor.themeRed, alignment: .right)
        self.totalNumView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.rightMargin)
            make.centerY.equalTo(self.statusView).offset(-1)
        }

//        let iconSize: CGSize = CGSize.init(width: 3, height: 28)
//        let titleCenterYTopMargin: CGFloat = 23     // super.top
//        let specCenterYTopMargin: CGFloat = 23      // title.centerY
//        let groupCenterYTopMargin: CGFloat = 22     // spec.centerY
//        // 2. titleLabel
//        topView.addSubview(self.zhiYaImgView)
//        self.zhiYaImgView.set(cornerRadius: 0)
//        self.zhiYaImgView.isHidden = true
//        self.zhiYaImgView.image = UIImage.init(named: "IMG_equip_icon_zfzy")
//        self.zhiYaImgView.snp.makeConstraints { (make) in
//            make.size.equalTo(self.zhiYaImgSize)
//            make.centerY.equalTo(self.titleLabel)
//            make.left.equalTo(self.titleLabel.snp.right).offset(self.zhiYaLeftMargin)
//        }
//        // 1. iconView
//        topView.addSubview(self.iconView)
//        self.iconView.set(cornerRadius: iconSize.width * 0.5)
//        self.iconView.backgroundColor = UIColor.init(hex: 0xFF455E)
//        self.iconView.snp.makeConstraints { (make) in
//            make.size.equalTo(iconSize)
//            make.leading.equalToSuperview().offset(0)
//            make.centerY.equalTo(self.titleLabel)
//        }
//        // 3. specView
//        // groupView
//        topView.addSubview(self.groupView)
//        self.groupView.snp.makeConstraints { (make) in
//            make.leading.equalTo(self.titleLabel)
//            make.trailing.lessThanOrEqualToSuperview().offset(-self.rightMargin)
//            make.centerY.equalTo(self.specView.snp.centerY).offset(groupCenterYTopMargin)
//        }
//        self.groupView.titleLabel.set(text: "节点号：", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x999999))
//        self.groupView.titleLabel.snp.remakeConstraints { (make) in
//            make.leading.centerY.equalToSuperview()
//            make.top.greaterThanOrEqualToSuperview()
//            make.bottom.lessThanOrEqualToSuperview()
//        }
//        self.groupView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x999999))
//        self.groupView.valueLabel.snp.remakeConstraints { (make) in
//            make.leading.equalTo(self.groupView.titleLabel.snp.trailing).offset(0)
//            make.trailing.centerY.equalToSuperview()
//            make.top.greaterThanOrEqualToSuperview()
//            make.bottom.lessThanOrEqualToSuperview()
//        }
//        // 4. totalNumView
//        // 5. statusLabel
//        // 6. dashLine
//        topView.addSubview(self.topDashLine)
//        self.topDashLine.snp.makeConstraints { (make) in
//            make.bottom.equalToSuperview()
//            make.leading.equalToSuperview().offset(self.leftMargin)
//            make.trailing.equalToSuperview().offset(-self.rightMargin)
//            make.height.equalTo(0.5)
//        }
    }
    ///
    fileprivate func initialCenterView(_ centerView: UIView) -> Void {
        // miningNumView
        centerView.addSubview(self.miningNumView)
        self.miningNumView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.leftMargin)
            make.trailing.equalTo(centerView.snp.centerX).offset(-self.centerItemHorMargin * 0.5)
            make.top.bottom.equalToSuperview()
        }
        // specView
        centerView.addSubview(self.specView)
        self.specView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.rightMargin)
            make.leading.equalTo(centerView.snp.centerX).offset(self.centerItemHorMargin * 0.5)
            make.top.bottom.equalToSuperview()
        }
        //
        let itemViews: [TitleValueView] = [self.miningNumView, self.specView]
        let itemTitles: [String] = ["产出总数", "封装规格"]
        for (index, itemView) in itemViews.enumerated() {
            itemView.set(cornerRadius: 8)
            let bgLayer = AppUtil.commonGradientLayer()
            itemView.layer.insertSublayer(bgLayer, below: nil)
            bgLayer.colors = [UIColor.init(hex: 0xE6F1FD).cgColor, UIColor.init(hex: 0xF4F9FF).cgColor]
            let itemWidth: CGFloat = (kScreenWidth - 12.0 * 2.0 - self.leftMargin - self.rightMargin - self.centerItemHorMargin) * 0.5
            bgLayer.frame = CGRect.init(x: 0, y: 0, width: itemWidth, height: self.centerViewHeight)
            //
            itemView.titleLabel.set(text: itemTitles[index], font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: UIColor.init(hex: 0x999999), alignment: .center)
            itemView.titleLabel.snp.remakeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.centerY.equalTo(itemView.snp.bottom).offset(-17)
            }
            itemView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor.init(hex: 0x333333), alignment: .center)
            itemView.valueLabel.snp.remakeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.centerY.equalTo(itemView.snp.top).offset(20)
            }
        }
        //
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
                    make.trailing.equalToSuperview()
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
        self.miningNumView.titleLabel.text = "累计收益"
        self.fengzhuangNumView.titleLabel.text = "封装数量"
        self.progressNumView.titleLabel.text = "封装比例"
        self.incomeNumView.titleLabel.text = "累计收益"
        self.yesterdayNumView.titleLabel.text = "昨日收益"
        self.huibenNumView.titleLabel.text = "回本进度"
    }
}
// MARK: - UI Xib加载后处理
extension OreDetailHeaderView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension OreDetailHeaderView {

    ///
    fileprivate func setupAsDemo() -> Void {
        //self.initialCenterView(self.centerView, [self.miningNumView, self.fengzhuangNumView, self.progressNumView])
        self.titleLabel.text = "第20201019期"
        self.specView.valueLabel.text = "1个月"
        self.miningNumView.valueLabel.text = "324.12345678"
        //self.fengzhuangNumView.valueLabel.text = "46.45"
        //self.progressNumView.valueLabel.text = "14.20%"
        // 0x2381FB运行中 | 0x333333部署中 | 0x999999已关闭
        self.statusView.label.text = "运行中"
        self.statusView.label.textColor = UIColor.init(hex: 0x2381FB)
        self.statusView.backgroundColor = UIColor.init(hex: 0x2381FB).withAlphaComponent(0.1)
        
        var totalNumAtts = NSAttributedString.textAttTuples()
        totalNumAtts.append((str: "200", font: UIFont.pingFangSCFont(size: 22, weight: .medium), color: UIColor.init(hex: 0xE16940)))
        totalNumAtts.append((str: " T", font: UIFont.pingFangSCFont(size: 14, weight: .medium), color: UIColor.init(hex: 0xE16940)))
        self.totalNumView.attributedText = NSAttributedString.attribute(totalNumAtts)
    }
    
    /// 数据加载
    fileprivate func setupWithModel(_ model: EquipmentListModel?) -> Void {
//        self.setupAsDemo()
//        return
        guard let model = model else {
            return
        }
//        if model.zone == .ipfs {
            //self.initialCenterView(self.centerView, [self.miningNumView, self.fengzhuangNumView, self.progressNumView])
//        } else {
//            self.initialCenterView(self.centerView, [self.incomeNumView, self.yesterdayNumView, self.huibenNumView])
//        }
        // 子控件数据加载
        self.titleLabel.text = "第\(model.fil_level)期"
        //self.titleLabel.textColor = model.titleColor
        //self.zhiYaImgView.isHidden = !(model.zhiya_type == .zifu && (model.zone == .ipfs || model.zone == .bzz))
        self.zhiYaFlagView.isHidden = !(model.zhiya_type == .zifu && (model.zone == .ipfs || model.zone == .bzz))
        self.specView.valueLabel.text = model.spec_level
        //self.specView.valueLabel.textColor = model.titleColor
        self.miningNumView.valueLabel.text = model.total_ming.decimalValidDigitsProcess(digits: 8)
        //self.fengzhuangNumView.valueLabel.text = model.seal_num.decimalValidDigitsProcess(digits: 2)
        //self.progressNumView.valueLabel.text = (model.fengcun_progress * 100).decimalValidDigitsProcess(digits: 2) + "%"
        self.statusView.label.text = model.status.title
        self.statusView.label.textColor = model.statusColor
        self.statusView.backgroundColor = model.statusColor.withAlphaComponent(0.1)
        //self.iconView.backgroundColor = model.iconColor
        //self.groupView.valueLabel.text = model.group
        //self.setupGroupShow(!model.group.isEmpty)

        var totalNumAtts = NSAttributedString.textAttTuples()
        totalNumAtts.append((str: "\(model.t_num)", font: UIFont.pingFangSCFont(size: 22, weight: .medium), color: model.totalNumColor))
        totalNumAtts.append((str: model.totalUnit, font: UIFont.pingFangSCFont(size: 14, weight: .medium), color: model.totalNumColor))
        self.totalNumView.attributedText = NSAttributedString.attribute(totalNumAtts)
    }
    
    ///
    fileprivate func setupGroupShow(_ isShow: Bool) -> Void {
        self.groupView.isHidden = !isShow
        self.bgImgView.image = isShow ? UIImage.init(named: "IMG_mine_sb_top_box_group") : UIImage.init(named: "IMG_mine_sb_top_box")
        self.topView.snp.updateConstraints { (make) in
            let height: CGFloat = isShow ? self.hasGroupTopViewHeight : self.noGroupTopViewHeight
            make.height.equalTo(height)
        }
        self.layoutIfNeeded()
    }
    
}

// MARK: - Event Function
extension OreDetailHeaderView {

}

// MARK: - Notification Function
extension OreDetailHeaderView {
    
}

// MARK: - Extension Function
extension OreDetailHeaderView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension OreDetailHeaderView {
    
}
