//
//  FPHomeQuotationView.swift
//  HZProject
//
//  Created by 小唐 on 2020/11/13.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  首页实时行情视图

import UIKit

class FPHomeQuotationView: UIView
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
    
    fileprivate let sectionView: UIView = UIView.init()
    
    
    fileprivate let container: UIView = UIView.init()

    
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let itemHeight: CGFloat = FPHomeQuotationItemView.viewHeight
    fileprivate let itemVerMargin: CGFloat = 8
    fileprivate let itemTopMargin: CGFloat = 8
    fileprivate let itemBottomMargin: CGFloat = 0
    
    
    
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
extension FPHomeQuotationView {
    class func loadXib() -> FPHomeQuotationView? {
        return Bundle.main.loadNibNamed("FPHomeQuotationView", owner: nil, options: nil)?.first as? FPHomeQuotationView
    }

}

// MARK: - LifeCircle Function
extension FPHomeQuotationView {
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
extension FPHomeQuotationView {
    
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
        //let titleViewHeight: CGFloat = 40
        // 1. titleView
        mainView.addSubview(self.titleView)
        self.titleView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(40)
        }
        self.titleView.label.set(text: "实时行情", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.subMainText)
        self.titleView.label.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
        }
        // 2. sectionView
        mainView.addSubview(self.sectionView)
        self.initialSectionView(self.sectionView)
        self.sectionView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.titleView.snp.bottom).offset(0)
            make.height.equalTo(12)
        }
        // 3. container
        mainView.addSubview(self.container)
        self.container.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.sectionView.snp.bottom)
        }
    }
    ///
    fileprivate func initialSectionView(_ sectionView: UIView) -> Void {
        // 1. nameLabel
        let nameLabel: UILabel = UILabel.init()
        sectionView.addSubview(nameLabel)
        nameLabel.set(text: "名称", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x999999))
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
        }
        // 2. priceLabel
        let priceLabel: UILabel = UILabel.init()
        sectionView.addSubview(priceLabel)
        priceLabel.set(text: "最新价", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x999999), alignment: .left)
        priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(sectionView.snp.centerX).offset(-7)
        }
        // 3. changeLabel
        let changeLabel: UILabel = UILabel.init()
        sectionView.addSubview(changeLabel)
        changeLabel.set(text: "名称", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0x999999), alignment: .right)
        changeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    ///
    fileprivate func setupContainer(with models: [FPHomeQuotationItemModel]) -> Void {
        self.container.removeAllSubviews()
        var topView: UIView = self.container
        for (index, model) in models.enumerated() {
            let itemView: FPHomeQuotationItemView = FPHomeQuotationItemView.init()
            self.container.addSubview(itemView)
            itemView.set(cornerRadius: 5)
            itemView.model = model
            itemView.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(self.lrMargin)
                make.trailing.equalToSuperview().offset(-self.lrMargin)
                make.height.equalTo(self.itemHeight)
                if 0 == index {
                    make.top.equalToSuperview().offset(self.itemTopMargin)
                } else {
                    make.top.equalTo(topView.snp.bottom).offset(self.itemVerMargin)
                }
                if index == models.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
            topView = itemView
        }
    }
    
}
// MARK: - Private UI Xib加载后处理
extension FPHomeQuotationView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension FPHomeQuotationView {
    ///
    fileprivate func setupAsDemo() -> Void {
        //self.setupContainer(with: ["", "", "", "", ""])
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: FirstPageHomeModel?) -> Void {
        //self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 子控件数据加载
        self.setupContainer(with: model.quotations)
    }
    
}

// MARK: - Event Function
extension FPHomeQuotationView {
    
}

// MARK: - Extension Function
extension FPHomeQuotationView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension FPHomeQuotationView {
    
}


