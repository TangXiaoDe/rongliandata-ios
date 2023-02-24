//
//  EquipmentHomeHeaderView.swift
//  RongLianData
//
//  Created by 小唐 on 2020/12/3.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//

import UIKit

///
class EquipmentHomeHeaderView: UIView {
    
    // MARK: - Internal Property
    
    static let viewHeight: CGFloat = 100
//        CGSize.init(width: 375, height: 194).scaleAspectForWidth(kScreenWidth).height
    
//    static var valueBottomMargin: CGFloat {
//        let height: CGFloat = EquipmentHomeHeaderView.viewHeight
//        let header = EquipmentHomeHeaderView.init()
//        let bottomMargin: CGFloat = height - header.titleCenterYTopMargin - header.valueCenterYTopMargin - 15.0 - 15.0
//        return min(60, max(0, bottomMargin))
//    }
    
    var model: EquipmentHomeModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    fileprivate let bgView: UIImageView = UIImageView.init()
    fileprivate let titleLabel: UILabel = UILabel.init()        // 设备总量
    fileprivate let valueLabel: UILabel = UILabel.init()
    
    fileprivate let lrMargin: CGFloat = 12
//    fileprivate let titleCenterYTopMargin: CGFloat = kStatusBarHeight + 32  // super.top
//    fileprivate let valueCenterYTopMargin: CGFloat = 45     // title.centerY
    
    fileprivate let valueCenterYTopMargin = 30
    fileprivate let titleCenterYBottomMargin = 30
    
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
extension EquipmentHomeHeaderView {

    class func loadXib() -> EquipmentHomeHeaderView? {
        return Bundle.main.loadNibNamed("EquipmentHomeHeaderView", owner: nil, options: nil)?.first as? EquipmentHomeHeaderView
    }

}

// MARK: - LifeCircle/Override Function
extension EquipmentHomeHeaderView {

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
extension EquipmentHomeHeaderView {
    
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
//        // 1. bgView
//        mainView.addSubview(self.bgView)
//        self.bgView.set(cornerRadius: 0)
//        //self.bgView.image = UIImage.init(named: "IMG_sb_top_bg")
//        self.bgView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        // 3. valueLabel
        mainView.addSubview(self.valueLabel)
        self.valueLabel.set(text: "0", font: UIFont.pingFangSCFont(size: 35, weight: .medium), textColor: UIColor.init(hex: 0x4444FF), alignment: .center)
        self.valueLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerY.equalTo(mainView.snp.top).offset(self.valueCenterYTopMargin)
//                .equalTo(self.titleLabel.snp.centerY)
        }
        // 2. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: "设备总量(T)", font: UIFont.pingFangSCFont(size: 16, weight: .regular), textColor: UIColor.init(hex: 0x333333), alignment: .center)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerY.equalTo(mainView.snp.bottom).offset(-self.titleCenterYBottomMargin)
        }

    }
    
}
// MARK: - UI Xib加载后处理
extension EquipmentHomeHeaderView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension EquipmentHomeHeaderView {

    ///
    fileprivate func setupAsDemo() -> Void {
        self.valueLabel.text = "5,100"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: EquipmentHomeModel?) -> Void {
        //self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 子控件数据加载
        self.valueLabel.text = model.total.decimalValidDigitsProcess(digits: 2)
    }
    
}

// MARK: - Event Function
extension EquipmentHomeHeaderView {

    //
    @objc fileprivate func doneBtnClick(_ doneBtn: UIButton) -> Void {
        print("EquipmentHomeHeaderView doneBtnClick")
    }

}

// MARK: - Notification Function
extension EquipmentHomeHeaderView {
    
}

// MARK: - Extension Function
extension EquipmentHomeHeaderView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension EquipmentHomeHeaderView {
    
}

