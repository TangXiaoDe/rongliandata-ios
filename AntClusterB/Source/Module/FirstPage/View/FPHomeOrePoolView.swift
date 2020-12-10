//
//  FPHomeOrePoolView.swift
//  HZProject
//
//  Created by 小唐 on 2020/11/13.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  首页矿池数据视图

import UIKit

typealias FPHomeOrePoolDataView = FPHomeOrePoolView
class FPHomeOrePoolView: UIView
{
    
    // MARK: - Internal Property
    
    var model: FirstPageHomeModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView()
    
    fileprivate let titleView: TitleView = TitleView.init()
    
    fileprivate let container: UIView = UIView.init()
    fileprivate let bolckRewardItemView: FPHomeOrePoolItemView = FPHomeOrePoolItemView.init()    // 区块奖励(FIL)
    fileprivate let avgBlockTimeItemView: FPHomeOrePoolItemView = FPHomeOrePoolItemView.init()    // 平均出块时间(S)
    fileprivate let activeMinerItemView: FPHomeOrePoolItemView = FPHomeOrePoolItemView.init()    // 活跃矿工数(人)
    fileprivate let totalFilItemView: FPHomeOrePoolItemView = FPHomeOrePoolItemView.init()    // 流通总量(FIL)

    
    fileprivate let titleViewHeight: CGFloat = 40
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
        self.titleView.label.set(text: "矿池数据", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor.init(hex: 0x333333))
        self.titleView.label.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
        }
        // 2. container
        mainView.addSubview(self.container)
        self.initialContainer(self.container)
        self.container.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.titleView.snp.bottom)
        }
    }
    ///
    fileprivate func initialContainer(_ container: UIView) -> Void {
        self.container.removeAllSubviews()
        let itemViews: [FPHomeOrePoolItemView] = [self.bolckRewardItemView, self.avgBlockTimeItemView, self.activeMinerItemView, self.totalFilItemView]
        let titels: [String] = ["24h平均挖矿收益(FIL/TiB)", "近24h产出量(FIL)", "活跃矿工数(人)", "流通总量(FIL)"]
        let iconNames: [String] = ["IMG_img_home_bg_reward", "IMG_img_home_bg_time", "IMG_img_home_bg_number", "IMG_img_home_bg_liutong"]
        let nameIconNames: [String] = ["IMG_home_icon_reward", "IMG_home_icon_time", "IMG_home_icon_number", "IMG_home_icon_liutong"]
        for (index, itemView) in itemViews.enumerated() {
            let row: Int = index / self.itemColCount
            let col: Int = index % self.itemColCount
            self.container.addSubview(itemView)
            itemView.set(cornerRadius: 5)
            itemView.iconView.image = UIImage.init(named: iconNames[index])
            itemView.nameView.iconView.image = UIImage.init(named: nameIconNames[index])
            itemView.nameView.titleLabel.text = titels[index]
            itemView.nameView.titleLabel.font = UIFont.pingFangSCFont(size: 10)
            itemView.snp.makeConstraints { (make) in
                make.height.equalTo(self.itemHeight)
                make.width.equalTo(self.itemWidth)
                let leftMargin: CGFloat = self.lrMargin + (self.itemWidth + self.itemHorMargin) * CGFloat(col)
                let topMargin: CGFloat = self.itemTopMargin + (self.itemHeight + self.itemVerMargin) * CGFloat(row)
                let rightMargin: CGFloat = kScreenWidth - leftMargin - self.itemWidth
                make.top.equalToSuperview().offset(topMargin)
                make.leading.equalToSuperview().offset(leftMargin)
                if index == itemViews.count - 1 {
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
        self.bolckRewardItemView.valueLabel.text = "32.19"
        self.avgBlockTimeItemView.valueLabel.text = "30"
        self.activeMinerItemView.valueLabel.text = "684"
        self.totalFilItemView.valueLabel.text = "5415661211"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: FirstPageHomeModel?) -> Void {
        //self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 子控件数据加载
        self.bolckRewardItemView.valueLabel.text = model.ipfs?.mining_income_str_one_day
        self.avgBlockTimeItemView.valueLabel.text = model.ipfs?.one_day_fil_str
        self.activeMinerItemView.valueLabel.text = model.ipfs?.active_miners
        self.totalFilItemView.valueLabel.text = model.ipfs?.current_fil.decimalValidDigitsProcess(digits: 4)
    }
    
}

// MARK: - Event Function
extension FPHomeOrePoolView {
    
}

// MARK: - Extension Function
extension FPHomeOrePoolView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension FPHomeOrePoolView {
    
}


