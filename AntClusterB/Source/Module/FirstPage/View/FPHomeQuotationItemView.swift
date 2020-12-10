//
//  FPHomeQuotationItemView.swift
//  HZProject
//
//  Created by 小唐 on 2020/11/13.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//

import UIKit

class FPHomeQuotationItemView: UIView
{
    
    // MARK: - Internal Property
    
    static let viewHeight: CGFloat = 64
    
    
    var model: FPHomeQuotationItemModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView()
    
    fileprivate let iconView: UIImageView = UIImageView.init()      // 图标
    fileprivate let nameLabel: UILabel = UILabel.init()             // 名称
    fileprivate let volumeLabel: UILabel = UILabel.init()           // 成交量
    fileprivate let usdPriceLabel: UILabel = UILabel.init()         // USD价格
    fileprivate let rmbPriceLabel: UILabel = UILabel.init()         // 人民币价格
    fileprivate let rangeView: TitleView = TitleView.init()         // 涨跌幅
    
    fileprivate let iconWH: CGFloat = 32
    fileprivate let lrMargin: CGFloat = 10
    fileprivate let iconTbMargin: CGFloat = 16
    fileprivate let rangeViewSize: CGSize = CGSize.init(width: 74, height: 28)
    fileprivate let nameCenterYTopMargin: CGFloat = 6       // icon.top
    fileprivate let volumeCenterYBottomMargin: CGFloat = 6
    fileprivate let nameLeftMargin: CGFloat = 8
    fileprivate let priceLeftMargin: CGFloat = 7    // super.centerX
    
    
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
extension FPHomeQuotationItemView {
    class func loadXib() -> FPHomeQuotationItemView? {
        return Bundle.main.loadNibNamed("FPHomeQuotationItemView", owner: nil, options: nil)?.first as? FPHomeQuotationItemView
    }

}

// MARK: - LifeCircle Function
extension FPHomeQuotationItemView {
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
extension FPHomeQuotationItemView {
    
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
    ///
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. iconView
        mainView.addSubview(self.iconView)
        self.iconView.set(cornerRadius: self.iconWH * 0.5)
        self.iconView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.iconWH)
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.top.equalToSuperview().offset(self.iconTbMargin)
            make.bottom.equalToSuperview().offset(-self.iconTbMargin)
        }
        // 2. nameLabel
        mainView.addSubview(self.nameLabel)
        self.nameLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: UIColor.init(hex: 0x333333))
        self.nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.iconView.snp.trailing).offset(self.nameLeftMargin)
            make.centerY.equalTo(self.iconView.snp.top).offset(self.nameCenterYTopMargin)
        }
        // 3. volumeLabel
        mainView.addSubview(self.volumeLabel)
        self.volumeLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x999999))
        self.volumeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.nameLabel)
            make.centerY.equalTo(self.iconView.snp.bottom).offset(-self.volumeCenterYBottomMargin)
        }
        // 4. usdPriceLabel
        mainView.addSubview(self.usdPriceLabel)
        self.usdPriceLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: UIColor.init(hex: 0x333333))
        self.usdPriceLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(mainView.snp.centerX).offset(-self.priceLeftMargin)
            make.centerY.equalTo(self.nameLabel)
        }
        // 5. rmbPriceLabel
        mainView.addSubview(self.rmbPriceLabel)
        self.rmbPriceLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x999999))
        self.rmbPriceLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.usdPriceLabel)
            make.centerY.equalTo(self.volumeLabel)
        }
        // 6. rangeView
        mainView.addSubview(self.rangeView)
        self.rangeView.set(cornerRadius: 5)
        self.rangeView.backgroundColor = UIColor.init(hex: 0x4DAA92)    // 绿色0x4DAA92 红色C66865
        self.rangeView.snp.makeConstraints { (make) in
            make.size.equalTo(self.rangeViewSize)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.lrMargin)
        }
        self.rangeView.label.set(text: nil, font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: UIColor.white, alignment: .center)
        self.rangeView.label.snp.remakeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
    
}
// MARK: - Private UI Xib加载后处理
extension FPHomeQuotationItemView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension FPHomeQuotationItemView {
    ///
    fileprivate func setupAsDemo() -> Void {
        // 
        self.iconView.image = UIImage.init(named: "IMG_home_icon_fil")
        self.nameLabel.text = "FIL"
        self.volumeLabel.text = "24H量 125478"
        self.usdPriceLabel.text = "1.04"
        self.rmbPriceLabel.text = "¥6.57"
        // 绿色0x4DAA92 红色C66865
        self.rangeView.backgroundColor = UIColor.init(hex: 0xC66865)
        self.rangeView.label.text = "-0.22%"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: FPHomeQuotationItemModel?) -> Void {
        //self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 子控件数据加载
        self.iconView.image = model.symbol.icon
        self.nameLabel.text = model.symbol_value
        self.volumeLabel.text = "24H量 " + model.volume_24h_usd_format
        self.usdPriceLabel.text = model.price_usd
        self.rmbPriceLabel.text = "¥" + model.str_price_rmb
        // 绿色0x4DAA92 红色C66865
        self.rangeView.backgroundColor = model.change_bgColor
        self.rangeView.label.text = model.str_percent_change_24h + "%"
    }
    
}

// MARK: - Event Function
extension FPHomeQuotationItemView {
    
}

// MARK: - Extension Function
extension FPHomeQuotationItemView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension FPHomeQuotationItemView {
    
}


