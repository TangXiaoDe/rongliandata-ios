//
//  EquipmentHomeHeaderView.swift
//  AntMachine
//
//  Created by 小唐 on 2020/12/3.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//

import UIKit

///
class EquipmentHomeHeaderView: UIView {
    
    // MARK: - Internal Property
    
    static let viewHeight: CGFloat = CGSize.init(width: 375, height: 194).scaleAspectForWidth(kScreenWidth).height
    
    var model: String? {
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
    fileprivate let titleCenterYTopMargin: CGFloat = kStatusBarHeight + 32  // super.top
    fileprivate let valueCenterYTopMargin: CGFloat = 45     // title.centerY
    
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
        // 1. bgView
        mainView.addSubview(self.bgView)
        self.bgView.set(cornerRadius: 0)
        self.bgView.image = UIImage.init(named: "IMG_sb_top_bg")
        self.bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 2. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: "设备总量(T)", font: UIFont.systemFont(ofSize: 14), textColor: UIColor.init(hex: 0xFFEFBB), alignment: .center)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(mainView.snp.top).offset(self.titleCenterYTopMargin)
        }
        // 3. valueLabel
        mainView.addSubview(self.valueLabel)
        self.valueLabel.set(text: nil, font: UIFont.systemFont(ofSize: 28, weight: .medium), textColor: UIColor.init(hex: 0xFFFFFF), alignment: .center)
        self.valueLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.titleLabel.snp.centerY).offset(self.valueCenterYTopMargin)
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
    fileprivate func setupWithModel(_ model: String?) -> Void {
        self.setupAsDemo()
        guard let _ = model else {
            return
        }
        // 子控件数据加载
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

