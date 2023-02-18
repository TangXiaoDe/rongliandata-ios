//
//  FPHomeOrePoolView.swift
//  HZProject
//
//  Created by 小唐 on 2020/11/13.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  首页区块数据视图

import UIKit

protocol FPHomeOrePoolViewProtocol: class {
    /// 矿池类型点击回调
    func orePoolView(_ orePoolView: FPHomeOrePoolView, didClickedType typeView: FPHomeOrePoolTypeView) -> Void
}

typealias FPHomeOrePoolDataView = FPHomeOrePoolView
class FPHomeOrePoolView: UIView
{
    
    // MARK: - Internal Property
    
    var model: FirstPageHomeModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    var type: FPOrePoolType? = nil {
        didSet {
            self.setupWithType(type)
        }
    }
    
    /// 是否显示类型选择
    var showTypeSelect: Bool = true {
        didSet {
            self.typeView.isHidden = !showTypeSelect
        }
    }

    weak var delegate: FPHomeOrePoolViewProtocol?

    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView()
    
    fileprivate let titleView: IconContainer = IconContainer.init()
    fileprivate let typeView: FPHomeOrePoolTypeView = FPHomeOrePoolTypeView.init()
    
    fileprivate let container: UIView = UIView.init()
    fileprivate let miningIncomeOneDayItemView: FPHomeOrePoolItemView = FPHomeOrePoolItemView.init()    // 24h平均提供存储服务收益(FIL/TiB)
    fileprivate let addPowerCostItemView: FPHomeOrePoolItemView = FPHomeOrePoolItemView.init()    // 新增算力成本(FIL/TiB)
    fileprivate let nowNledgeCollateralItemView: FPHomeOrePoolItemView = FPHomeOrePoolItemView.init()    // 当前扇区质押量(FiL/32GiB)
    fileprivate let totalPledgeCollateralItemView: FPHomeOrePoolItemView = FPHomeOrePoolItemView.init()    // FIL质押量(FIL)

    
    fileprivate let titleViewHeight: CGFloat = 44
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let itemHeight: CGFloat = FPHomeOrePoolItemView.viewHeight
    fileprivate let itemVerMargin: CGFloat = 8
    fileprivate let itemHorMargin: CGFloat = 8
    fileprivate let itemTopMargin: CGFloat = 0
    fileprivate let itemBottomMargin: CGFloat = 0
    
    
    fileprivate let itemColCount: Int = 2
    fileprivate lazy var itemWidth: CGFloat = {
        let width: CGFloat = (kScreenWidth - self.lrMargin * 2.0 - self.itemHorMargin * CGFloat(self.itemColCount - 1)) / CGFloat(self.itemColCount)
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
extension FPHomeOrePoolView {
    class func loadXib() -> FPHomeOrePoolView? {
        return Bundle.main.loadNibNamed("FPHomeOrePoolView", owner: nil, options: nil)?.first as? FPHomeOrePoolView
    }

}

// MARK: - LifeCircle Function
extension FPHomeOrePoolView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
    
    /// 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
// MARK: - Private UI 手动布局
extension FPHomeOrePoolView {
    
    /// 界面布局
    fileprivate func initialUI() -> Void {
        //
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    ///
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. titleView
        mainView.addSubview(self.titleView)
        self.titleView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(self.titleViewHeight)
        }
        self.titleView.iconView.image = UIImage.init(named: "IMG_home_icon_title")
        self.titleView.iconView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
//        self.titleView.label.set(text: "区块数据", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor.init(hex: 0x333333))
//        self.titleView.label.snp.remakeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.leading.equalToSuperview().offset(self.lrMargin)
//            make.trailing.equalToSuperview().offset(-self.lrMargin)
//        }
//        // 2. typeView
//        mainView.addSubview(self.typeView)
//        self.typeView.addTarget(self, action: #selector(typeViewClick(_:)), for: .touchUpInside)
//        self.typeView.snp.makeConstraints { (make) in
//            make.centerY.equalTo(self.titleView)
//            make.trailing.equalToSuperview().offset(-self.lrMargin)
//        }
        // 3. container
        mainView.addSubview(self.container)
        self.container.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.titleView.snp.bottom)
        }
    }
    
    ///
//    fileprivate func initialContainer(_ container: UIView) -> Void {
//        self.container.removeAllSubviews()
//        let itemViews: [FPHomeOrePoolItemView] = [self.miningIncomeOneDayItemView, self.addPowerCostItemView, self.nowNledgeCollateralItemView, self.totalPledgeCollateralItemView]
//        let titels: [String] = ["24h平均提供存储服务收益(FIL/TiB)", "新增算力成本(FIL/TIB)", "当前扇区质押量(FIL/32GiB)", "FIL质押量(FIL)"]
//        let iconNames: [String] = ["IMG_img_home_bg_reward", "IMG_img_home_bg_chengben", "IMG_img_home_bg_shanxing", "IMG_img_home_bg_zhiya"]
//        let nameIconNames: [String] = ["IMG_home_icon_reward", "IMG_home_icon_chengben", "IMG_home_icon_shanxing", "IMG_home_icon_zhiya"]
//        for (index, itemView) in itemViews.enumerated() {
//            let row: Int = index / self.itemColCount
//            let col: Int = index % self.itemColCount
//            self.container.addSubview(itemView)
//            itemView.set(cornerRadius: 5)
//            itemView.iconView.image = UIImage.init(named: iconNames[index])
//            itemView.nameView.iconView.image = UIImage.init(named: nameIconNames[index])
//            itemView.nameView.titleLabel.text = titels[index]
//            itemView.nameView.titleLabel.font = UIFont.pingFangSCFont(size: 10)
//            itemView.snp.makeConstraints { (make) in
//                make.height.equalTo(self.itemHeight)
//                make.width.equalTo(self.itemWidth)
//                let leftMargin: CGFloat = self.lrMargin + (self.itemWidth + self.itemHorMargin) * CGFloat(col)
//                let topMargin: CGFloat = self.itemTopMargin + (self.itemHeight + self.itemVerMargin) * CGFloat(row)
//                let rightMargin: CGFloat = kScreenWidth - leftMargin - self.itemWidth
//                make.top.equalToSuperview().offset(topMargin)
//                make.leading.equalToSuperview().offset(leftMargin)
//                if index == itemViews.count - 1 {
//                    make.trailing.equalToSuperview().offset(-rightMargin)
//                    make.bottom.equalToSuperview().offset(-self.itemBottomMargin)
//                }
//            }
//        }
//    }
    
    fileprivate func setupContainer(with items: [FPOrePoolItemModel]) -> Void {
        self.container.removeAllSubviews()
        for (index, model) in items.enumerated() {
            let row: Int = index / self.itemColCount
            let col: Int = index % self.itemColCount
            let itemView = FPHomeOrePoolItemView.init()
            self.container.addSubview(itemView)
            itemView.set(cornerRadius: 5)
            itemView.model = model
            itemView.snp.makeConstraints { (make) in
                make.height.equalTo(self.itemHeight)
                make.width.equalTo(self.itemWidth)
                let leftMargin: CGFloat = self.lrMargin + (self.itemWidth + self.itemHorMargin) * CGFloat(col)
                let topMargin: CGFloat = self.itemTopMargin + (self.itemHeight + self.itemVerMargin) * CGFloat(row)
                let rightMargin: CGFloat = kScreenWidth - leftMargin - self.itemWidth
                make.top.equalToSuperview().offset(topMargin)
                make.leading.equalToSuperview().offset(leftMargin)
                if index == items.count - 1 {
                    make.trailing.equalToSuperview().offset(-rightMargin)
                    make.bottom.equalToSuperview().offset(-self.itemBottomMargin)
                }
            }
        }
    }
}
// MARK: - Private UI Xib加载后处理
extension FPHomeOrePoolView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }

}

// MARK: - Data Function
extension FPHomeOrePoolView {
    ///
    fileprivate func setupAsDemo() -> Void {
        self.miningIncomeOneDayItemView.valueLabel.text = "32.19"
        self.addPowerCostItemView.valueLabel.text = "30"
        self.nowNledgeCollateralItemView.valueLabel.text = "684"
        self.totalPledgeCollateralItemView.valueLabel.text = "5415661211"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: FirstPageHomeModel?) -> Void {
        //self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 子控件数据加载
        self.miningIncomeOneDayItemView.valueLabel.text = model.ipfs?.mining_income_str_one_day
        self.addPowerCostItemView.valueLabel.text = model.ipfs?.add_power_cost
        self.nowNledgeCollateralItemView.valueLabel.text = model.ipfs?.now_pledge_collateral
        self.totalPledgeCollateralItemView.valueLabel.text = model.ipfs?.pledge_collateral
    }
    ///
    fileprivate func setupWithType(_ type: FPOrePoolType?) -> Void {
        guard let type = type, let model = model else {
            return
        }
        self.typeView.type = type
        switch type {
        case .ipfs:
            self.setupContainer(with: model.ipfs_orepool_models)
        case .btc:
            self.setupContainer(with: model.btc_orepool_models)
        case .eth:
            self.setupContainer(with: model.eth_orepool_models)
        case .chia:
            self.setupContainer(with: model.chia_orepool_models)
        }
    }
}

// MARK: - Event Function
extension FPHomeOrePoolView {
    ///
    @objc fileprivate func typeViewClick(_ typeView: FPHomeOrePoolTypeView) -> Void {
        self.delegate?.orePoolView(self, didClickedType: typeView)
    }

}

// MARK: - Extension Function
extension FPHomeOrePoolView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension FPHomeOrePoolView {

}
