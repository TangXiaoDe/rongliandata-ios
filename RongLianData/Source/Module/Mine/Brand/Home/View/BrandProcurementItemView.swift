//
//  BrandProcurementItemView.swift
//  RongLianData
//
//  Created by 小唐 on 2021/6/28.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  品牌商采购ItemView

import UIKit

class BrandProcurementItemView: UIView
{
    
    // MARK: - Internal Property
    
    static let viewHeight: CGFloat = 62
    
    var model: Double? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    var zone: ProductZone = .ipfs {
        didSet {
            self.setupWithZone(zone)
        }
    }
    
    var showBottomLine: Bool = true {
        didSet {
            self.bottomLine.isHidden = !showBottomLine
        }
    }

    /// 回调处理
    
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    fileprivate let iconView: UIImageView = UIImageView.init()
    fileprivate let titleLabel: UILabel = UILabel.init()    // 标题
    fileprivate let promptLabel: UILabel = UILabel.init()   // 提示
    fileprivate let valueLabel: UILabel = UILabel.init()    // 数值
    fileprivate let bottomLine: UIView = UIView.init()
    
    fileprivate let lrMargin: CGFloat = 15
    fileprivate let iconWH: CGFloat = 32
    fileprivate let iconTitleMargin: CGFloat = 6
    
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
extension BrandProcurementItemView {

    class func loadXib() -> BrandProcurementItemView? {
        return Bundle.main.loadNibNamed("BrandProcurementItemView", owner: nil, options: nil)?.first as? BrandProcurementItemView
    }

}

// MARK: - LifeCircle/Override Function
extension BrandProcurementItemView {

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
extension BrandProcurementItemView {
    
    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    /// mainView布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        //mainView.backgroundColor = UIColor.white
        // 1. iconView
        mainView.addSubview(self.iconView)
        self.iconView.set(cornerRadius: self.iconWH * 0.5)
        self.iconView.image = UIImage.init(named: "")
        self.iconView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(self.iconWH)
        }
        // 2. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: AppColor.subMainText)
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.iconView.snp.trailing).offset(self.iconTitleMargin)
            make.bottom.equalTo(self.iconView.snp.centerY).offset(0)
        }
        // 3. promptLabel
        mainView.addSubview(self.promptLabel)
        self.promptLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: AppColor.grayText)
        self.promptLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.titleLabel)
            make.top.equalTo(self.iconView.snp.centerY).offset(3)
        }
        // 4. valueLabel
        mainView.addSubview(self.valueLabel)
        self.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.subMainText, alignment: .right)
        self.valueLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.lrMargin)
        }
        // 5. bottomLine
        mainView.addSubview(self.bottomLine)
        self.bottomLine.backgroundColor = AppColor.dividing
        self.bottomLine.isHidden = true
        self.bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.height.equalTo(0.5)
        }
    }
    
}
// MARK: - UI Xib加载后处理
extension BrandProcurementItemView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension BrandProcurementItemView {

    ///
    fileprivate func setupAsDemo() -> Void {
        self.iconView.backgroundColor = UIColor.red
        self.titleLabel.text = "我是标题"
        self.iconView.backgroundColor = UIColor.random
    }
    ///
    fileprivate func setupWithZone(_ zone: ProductZone) -> Void {
        self.iconView.image = zone.icon
        self.titleLabel.text = zone.rawValue.uppercased()
        self.promptLabel.text = zone.brand_promt
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: Double?) -> Void {
        //self.setupAsDemo()
//        guard let _ = model else {
//            return
//        }
        // 子控件数据加载
        self.valueLabel.text = model?.decimalValidDigitsProcess(digits: 2)
    }
    
}

// MARK: - Event Function
extension BrandProcurementItemView {

    //
    @objc fileprivate func doneBtnClick(_ doneBtn: UIButton) -> Void {
        print("BrandProcurementItemView doneBtnClick")
        guard let model = self.model else {
            return
        }
    }

}

// MARK: - Notification Function
extension BrandProcurementItemView {
    
}

// MARK: - Extension Function
extension BrandProcurementItemView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension BrandProcurementItemView {
    
}

