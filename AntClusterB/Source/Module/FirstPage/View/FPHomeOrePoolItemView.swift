//
//  FPHomeOrePoolItemView.swift
//  HZProject
//
//  Created by 小唐 on 2020/11/13.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//

import UIKit

class FPHomeOrePoolItemView: UIView
{
    
    // MARK: - Internal Property
    
    static let viewHeight: CGFloat = 74
    
    var model: String? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView()
    
    let iconView: UIImageView = UIImageView.init()      // 图标，在右侧
    let valueLabel: UILabel = UILabel.init()            // 值
    let nameView: TitleIconView = TitleIconView.init()  // 名称：图标 + 名称

    fileprivate let iconWH: CGFloat = 74
    fileprivate let valueLeftMargin: CGFloat = 15
    fileprivate let nameViewIconWH: CGFloat = 12
    fileprivate let nameViewHorMargin: CGFloat = 6
    fileprivate let valueCenterYTopMargin: CGFloat = 26     // super.top
    fileprivate let nameCenterYTopMargin: CGFloat = 25     // value.centerY


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
extension FPHomeOrePoolItemView {
    class func loadXib() -> FPHomeOrePoolItemView? {
        return Bundle.main.loadNibNamed("FPHomeOrePoolItemView", owner: nil, options: nil)?.first as? FPHomeOrePoolItemView
    }

}

// MARK: - LifeCircle Function
extension FPHomeOrePoolItemView {
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
extension FPHomeOrePoolItemView {
    
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
        self.iconView.set(cornerRadius: 0)
        self.iconView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.iconWH)
            make.centerY.trailing.equalToSuperview()
        }
        // 2. valueLabel
        mainView.addSubview(self.valueLabel)
        self.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 17, weight: .medium), textColor: UIColor.init(hex: 0xFF8605))
        self.valueLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(mainView.snp.top).offset(self.valueCenterYTopMargin)
            make.leading.equalToSuperview().offset(self.valueLeftMargin)
            make.trailing.lessThanOrEqualToSuperview()
        }
        // 3. nameView
        mainView.addSubview(self.nameView)
        self.nameView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.valueLabel)
            make.trailing.lessThanOrEqualToSuperview()
            make.centerY.equalTo(self.valueLabel.snp.centerY).offset(self.nameCenterYTopMargin)
        }
        self.nameView.iconView.set(cornerRadius: 0)
        self.nameView.iconView.snp.remakeConstraints { (make) in
            make.width.height.equalTo(self.nameViewIconWH)
            make.top.bottom.leading.equalToSuperview()
        }
        self.nameView.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12), textColor: UIColor.init(hex: 0x333333))
        self.nameView.titleLabel.snp.remakeConstraints { (make) in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(self.nameView.iconView.snp.trailing).offset(self.nameViewHorMargin)
        }
    }
    
}
// MARK: - Private UI Xib加载后处理
extension FPHomeOrePoolItemView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension FPHomeOrePoolItemView {
    ///
    fileprivate func setupAsDemo() -> Void {
        // 
        self.iconView.image = UIImage.init(named: "IMG_img_home_bg_liutong")
        self.valueLabel.text = "32.19"
        //
        self.nameView.iconView.image = UIImage.init(named: "IMG_home_icon_reward")
        self.nameView.titleLabel.text = "区块奖励(FIL)"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: String?) -> Void {
        self.setupAsDemo()
        guard let _ = model else {
            return
        }
        // 子控件数据加载
    }
    
}

// MARK: - Event Function
extension FPHomeOrePoolItemView {
    
}

// MARK: - Extension Function
extension FPHomeOrePoolItemView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension FPHomeOrePoolItemView {
    
}


