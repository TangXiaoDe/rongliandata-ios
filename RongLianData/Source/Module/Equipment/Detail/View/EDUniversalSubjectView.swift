//
//  EDUniversalSubjectView.swift
//  MallProject
//
//  Created by 小唐 on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  设备详情页通用的子项目视图

import UIKit

///
class EDUniversalSubjectView: UIView {
    
    // MARK: - Internal Property
    
    var model: (title: String, zone: ProductZone)? {
        didSet {
            self.setupWithModel(model)
        }
    }
//    var model: String? {
//        didSet {
//            self.setupWithModel(model)
//        }
//    }
    var status: EquipPackageStatus = .deploying {
        didSet {
            var statusAtts = NSAttributedString.textAttTuples()
            statusAtts.append((str: "封装状态：", font: UIFont.pingFangSCFont(size: 12), color: UIColor.init(hex: 0x666666)))
            statusAtts.append((str: status.title, font: UIFont.pingFangSCFont(size: 16, weight: .medium), color: status.titleColor))
            self.statusView.attributedText = NSAttributedString.attribute(statusAtts)
        }
    }
    
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    
    let titleView: TitleIconView = TitleIconView.init()     // 标题
    let statusView: UILabel = UILabel.init()  // 状态
    
    fileprivate let container: UIView = UIView.init()
    let zhiyaItemView: TitleValueView = TitleValueView.init()       // 质押数量
    let xiaohaoItemView: TitleValueView = TitleValueView.init()     // Gas消耗数量
    
    fileprivate let titleLeftMargin: CGFloat = 12
    fileprivate let titleViewHeight: CGFloat = 44
    fileprivate let titleIconWH: CGFloat = 14

    fileprivate let itemLrMargin: CGFloat = 24
    fileprivate let itemHeight: CGFloat = 66
    fileprivate let itemHorMargin: CGFloat = 12
    fileprivate let itemVerMargin: CGFloat = 12
    fileprivate let itemTopMargin: CGFloat = 5
    fileprivate let itemBottomMargin: CGFloat = 10
    fileprivate let itemColNum: Int = 2
    fileprivate lazy var itemWidth: CGFloat = {
        let width: CGFloat = (kScreenWidth - self.itemLrMargin * 2.0 - self.itemHorMargin * CGFloat(self.itemColNum - 1)) / CGFloat(self.itemColNum)
        return width
    }()

    
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
extension EDUniversalSubjectView {

    class func loadXib() -> EDUniversalSubjectView? {
        return Bundle.main.loadNibNamed("EDUniversalSubjectView", owner: nil, options: nil)?.first as? EDUniversalSubjectView
    }

}

// MARK: - LifeCircle/Override Function
extension EDUniversalSubjectView {

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
extension EDUniversalSubjectView {
    
    /// 界面布局
    fileprivate func initialUI() -> Void {
        //self.backgroundColor = UIColor.white
        //
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    /// mainView布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. titleView
        mainView.addSubview(self.titleView)
        self.titleView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.titleLeftMargin)
            make.top.equalToSuperview()
            make.height.equalTo(self.titleViewHeight)
        }
        self.titleView.iconView.set(cornerRadius: 0)
        self.titleView.iconView.snp.remakeConstraints { (make) in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(self.titleIconWH)
        }
        self.titleView.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: AppColor.mainText, alignment: .left)
        self.titleView.titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(self.titleView.iconView.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        // 2. statusView
        mainView.addSubview(self.statusView)
        self.statusView.set(text: nil, font: UIFont.pingFangSCFont(size: 12), textColor: UIColor.init(hex: 0x666666), alignment: .right)
        self.statusView.isHidden = true     // 默认隐藏
        self.statusView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.itemLrMargin)
            make.centerY.equalTo(self.titleView)
        }
        // 3. container
        mainView.addSubview(self.container)
        self.initialContainer(self.container)
        self.container.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.titleView.snp.bottom)
        }
    }
    ///
    fileprivate func initialContainer(_ container: UIView) -> Void {
        let itemInLrMargin: CGFloat = 10
        let itemTitleCenterYTopMargin: CGFloat = 20     // super.top
        let itemValueCenterYBottomMargin: CGFloat = 22  // super.bottom
        
        container.removeAllSubviews()
        //
        let itemViews: [TitleValueView] = [self.zhiyaItemView, self.xiaohaoItemView]
        for (index, itemView) in itemViews.enumerated() {
            let row: Int = index / self.itemColNum
            let col: Int = index % self.itemColNum
            container.addSubview(itemView)
            itemView.backgroundColor = UIColor.init(hex: 0xFDC818).withAlphaComponent(0.08)
            itemView.set(cornerRadius: 5)
            itemView.snp.makeConstraints { (make) in
                make.width.equalTo(self.itemWidth)
                make.height.equalTo(self.itemHeight)
                let leftMargin: CGFloat = self.itemLrMargin + (self.itemWidth + self.itemHorMargin) * CGFloat(col)
                let topMargin: CGFloat = self.itemTopMargin + (self.itemHeight + self.itemVerMargin) * CGFloat(row)
                make.top.equalToSuperview().offset(topMargin)
                make.leading.equalToSuperview().offset(leftMargin)
                if index == itemViews.count - 1 {
                    let rightMargin: CGFloat = kScreenWidth - leftMargin - self.itemWidth
                    make.trailing.equalToSuperview().offset(-rightMargin)
                    make.bottom.equalToSuperview().offset(-self.itemBottomMargin)
                }
            }
            //
            itemView.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12), textColor: UIColor.init(hex: 0x666666))
            itemView.titleLabel.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview().offset(itemInLrMargin)
                make.trailing.lessThanOrEqualToSuperview()
                make.centerY.equalTo(itemView.snp.top).offset(itemTitleCenterYTopMargin)
            }
            itemView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 20, weight: .medium), textColor: AppColor.mainText)
            itemView.valueLabel.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview().offset(itemInLrMargin)
                make.trailing.lessThanOrEqualToSuperview()
                make.centerY.equalTo(itemView.snp.bottom).offset(-itemValueCenterYBottomMargin)
            }
        }
    }
    
}
// MARK: - UI Xib加载后处理
extension EDUniversalSubjectView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension EDUniversalSubjectView {

    ///
    fileprivate func setupAsDemo() -> Void {
        self.titleView.iconView.backgroundColor = UIColor.red
        self.titleView.titleLabel.text = "我是标题"
        
        self.statusView.isHidden = false
        var statusAtts = NSAttributedString.textAttTuples()
        statusAtts.append((str: "封装状态：", font: UIFont.pingFangSCFont(size: 12), color: UIColor.init(hex: 0x666666)))
        statusAtts.append((str: "部署中", font: UIFont.pingFangSCFont(size: 16, weight: .medium), color: UIColor.init(hex: 0xE06236)))
        self.statusView.attributedText = NSAttributedString.attribute(statusAtts)
        
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: (title: String, zone: ProductZone)?) -> Void {
//        self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 子控件数据加载
        self.titleView.titleLabel.text = model.title

        self.zhiyaItemView.backgroundColor = UIColor.init(hex: 0xFDC818).withAlphaComponent(0.08)
        self.xiaohaoItemView.backgroundColor = UIColor.init(hex: 0xFDC818).withAlphaComponent(0.08)
        self.statusView.isHidden = true
        
        var zhiyaTitle: String = ""
        var xiaohaoTitle: String = ""
        switch model.title {
        case "封装详情":
            self.titleView.iconView.image = UIImage.init(named: "IMG_equip_icon_fengzhuang")
            self.statusView.isHidden = false
            zhiyaTitle = "使用质押数量(\(model.zone.rawValue.uppercased()))"
            xiaohaoTitle = "Gas消耗数量(\(model.zone.rawValue.uppercased()))"
        case "借贷资本明细":
            self.titleView.iconView.image = UIImage.init(named: "IMG_equip_icon_jiedai")
            zhiyaTitle = "借贷质押数量(\(model.zone.rawValue.uppercased()))"
            xiaohaoTitle = "借贷Gas消耗数量(\(model.zone.rawValue.uppercased()))"
        case "已归还":
            self.titleView.iconView.image = UIImage.init(named: "IMG_equip_icon_yiguihuan")
            self.zhiyaItemView.backgroundColor = UIColor.init(hex: 0x2280FB).withAlphaComponent(0.08)
            self.xiaohaoItemView.backgroundColor = UIColor.init(hex: 0x2280FB).withAlphaComponent(0.08)
            zhiyaTitle = "质押数量(\(model.zone.rawValue.uppercased()))"
            xiaohaoTitle = "Gas消耗数量(\(model.zone.rawValue.uppercased()))"
        case "待归还":
            self.titleView.iconView.image = UIImage.init(named: "IMG_equip_icon_daiguihuan")
            zhiyaTitle = "质押数量(\(model.zone.rawValue.uppercased()))"
            xiaohaoTitle = "Gas消耗数量(\(model.zone.rawValue.uppercased()))"
        default:
            break
        }
        self.zhiyaItemView.titleLabel.text = zhiyaTitle
        self.xiaohaoItemView.titleLabel.text = xiaohaoTitle
    }
//    fileprivate func setupWithModel(_ model: String?) -> Void {
//        self.setupAsDemo()
//        guard let model = model else {
//            return
//        }
//        // 子控件数据加载
//    }

}

// MARK: - Event Function
extension EDUniversalSubjectView {

}

// MARK: - Notification Function
extension EDUniversalSubjectView {
    
}

// MARK: - Extension Function
extension EDUniversalSubjectView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension EDUniversalSubjectView {
    
}

