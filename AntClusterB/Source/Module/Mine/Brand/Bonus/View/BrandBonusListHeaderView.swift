//
//  BrandBonusListHeaderView.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/7/26.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit

///
class BrandBonusListHeaderView: UIView {
    
    // MARK: - Internal Property
    
    static let viewHeight: CGFloat = 95
//        CGSize.init(width: 375, height: 194).scaleAspectForWidth(kScreenWidth).height
    
//    static var valueBottomMargin: CGFloat {
//        let height: CGFloat = BrandBonusListHeaderView.viewHeight
//        let header = BrandBonusListHeaderView.init()
//        let bottomMargin: CGFloat = height - header.titleCenterYTopMargin - header.valueCenterYTopMargin - 15.0 - 15.0
//        return min(60, max(0, bottomMargin))
//    }
    
    var model: BrandBonusModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    fileprivate let bgView: UIImageView = UIImageView.init()
    fileprivate let titleLabel: UILabel = UILabel.init()        // 总计数
    fileprivate let valueLabel: UILabel = UILabel.init()
    
    fileprivate let lrMargin: CGFloat = 12
    
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
extension BrandBonusListHeaderView {

    class func loadXib() -> BrandBonusListHeaderView? {
        return Bundle.main.loadNibNamed("BrandBonusListHeaderView", owner: nil, options: nil)?.first as? BrandBonusListHeaderView
    }

}

// MARK: - LifeCircle/Override Function
extension BrandBonusListHeaderView {

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
extension BrandBonusListHeaderView {
    
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
        // 3. valueLabel
        mainView.addSubview(self.valueLabel)
        self.valueLabel.set(text: "0", font: UIFont.systemFont(ofSize: 28, weight: .bold), textColor: AppColor.mainText, alignment: .center)
        self.valueLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerY.equalTo(mainView.snp.top).offset(self.valueCenterYTopMargin)
//                .equalTo(self.titleLabel.snp.centerY)
        }
        // 2. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: "总计数", font: UIFont.systemFont(ofSize: 14, weight: .medium), textColor: AppColor.mainText.withAlphaComponent(0.5), alignment: .center)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerY.equalTo(mainView.snp.bottom).offset(-self.titleCenterYBottomMargin)
        }
    }
}
// MARK: - UI Xib加载后处理
extension BrandBonusListHeaderView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }
}

// MARK: - Data Function
extension BrandBonusListHeaderView {

    ///
    fileprivate func setupAsDemo() -> Void {
        self.valueLabel.text = "5,100"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: BrandBonusModel?) -> Void {
        //self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 子控件数据加载
        self.valueLabel.text = model.total.decimalValidDigitsProcess(digits: 8)
    }
}

// MARK: - Event Function
extension BrandBonusListHeaderView {

    //
    @objc fileprivate func doneBtnClick(_ doneBtn: UIButton) -> Void {
        print("BrandBonusListHeaderView doneBtnClick")
    }

}

// MARK: - Notification Function
extension BrandBonusListHeaderView {

}

// MARK: - Extension Function
extension BrandBonusListHeaderView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension BrandBonusListHeaderView {

}
