//
//  LockDetailHeaderView.swift
//  MallProject
//
//  Created by zhaowei on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit

///
class LockDetailHeaderView: UIView {
    
    // MARK: - Internal Property
    
    //static let viewHeight: CGFloat = CGSize.init(width: 375, height: 219).scaleAspectForWidth(kScreenWidth).height - kNavigationStatusBarHeight
    static let viewHeight: CGFloat = 100 + 88

    var zone: ProductZone = .ipfs {
        didSet {
            self.titleLabel.text = "累计收益(\(zone.rawValue.uppercased()))"
            self.waitReleaseNumView.titleLabel.text = "待释放(\(zone.rawValue.uppercased()))"
            self.hasReleaseNumView.titleLabel.text = "已释放(\(zone.rawValue.uppercased()))"
        }
    }
    var model: LockDetailListModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    fileprivate let bgView: UIImageView = UIImageView.init()
    
    fileprivate let topView: UIView = UIView.init()
    fileprivate let titleLabel: UILabel = UILabel.init()        // 设备总量
    fileprivate let valueLabel: UILabel = UILabel.init()
    
    fileprivate let bottomView: UIView = UIView()
    fileprivate let waitReleaseNumView: TitleValueView = TitleValueView.init()   // 待释放
    fileprivate let hasReleaseNumView: TitleValueView = TitleValueView.init()   // 已释放
    
    fileprivate let lrMargin: CGFloat = 12
    
    fileprivate let topViewHeight: CGFloat = 100
    fileprivate let valueCenterYTopMargin: CGFloat = 26     // super.top
    fileprivate let titleCenterYTopMargin: CGFloat = 36  // title.centerY
    
    fileprivate let bottomViewHeight: CGFloat = 88
    fileprivate let itemLrMargin: CGFloat = 15
    fileprivate let itemHorMargin: CGFloat = 20
    fileprivate let itemHeight: CGFloat = 58
    
    
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
extension LockDetailHeaderView {

    class func loadXib() -> LockDetailHeaderView? {
        return Bundle.main.loadNibNamed("LockDetailHeaderView", owner: nil, options: nil)?.first as? LockDetailHeaderView
    }

}

// MARK: - LifeCircle/Override Function
extension LockDetailHeaderView {

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
extension LockDetailHeaderView {
    
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
//        mainView.addSubview(self.bgView)
//        self.bgView.set(cornerRadius: 0)
//        self.bgView.image = UIImage.init(named: "IMG_sb_top_bg")
//        self.bgView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        // 1. topView
        mainView.addSubview(self.topView)
        self.initialTopView(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.topViewHeight)
        }
        // 2. bottomView
        mainView.addSubview(self.bottomView)
        self.initialBottomView(self.bottomView)
        self.bottomView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.height.equalTo(self.bottomViewHeight)
            make.bottom.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom)
        }
    }
    ///
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        // 3. valueLabel
        topView.addSubview(self.valueLabel)
        self.valueLabel.set(text: "0", font: UIFont.pingFangSCFont(size: 35, weight: .medium), textColor: AppColor.theme, alignment: .center)
        self.valueLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(mainView.snp.top).offset(self.valueCenterYTopMargin)
            make.leading.greaterThanOrEqualToSuperview().offset(self.lrMargin)
            make.trailing.lessThanOrEqualToSuperview().offset(-self.lrMargin)
        }
        // 2. titleLabel
        topView.addSubview(self.titleLabel)
        self.titleLabel.set(text: "累计收益(FIL)", font: UIFont.pingFangSCFont(size: 14), textColor: UIColor.init(hex: 0x333333), alignment: .center)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.valueLabel.snp.centerY).offset(self.titleCenterYTopMargin)
            make.leading.greaterThanOrEqualToSuperview().offset(self.lrMargin)
            make.trailing.lessThanOrEqualToSuperview().offset(-self.lrMargin)
        }
    }
    /// bottom
    fileprivate func initialBottomView(_ bottomView: UIView) -> Void {
        //
        bottomView.backgroundColor = UIColor.white
        bottomView.set(cornerRadius: 10)
        // waitReleaseNumView
        bottomView.addSubview(self.waitReleaseNumView)
        self.waitReleaseNumView.snp.makeConstraints { (make) in
            make.height.equalTo(self.itemHeight)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(self.itemLrMargin)
            make.trailing.equalTo(bottomView.snp.centerX).offset(-self.itemHorMargin * 0.5)
        }
        // hasReleaseNumView
        bottomView.addSubview(self.hasReleaseNumView)
        self.hasReleaseNumView.snp.makeConstraints { (make) in
            make.height.equalTo(self.itemHeight)
            make.centerY.equalToSuperview()
            make.leading.equalTo(bottomView.snp.centerX).offset(self.itemHorMargin * 0.5)
            make.trailing.equalToSuperview().offset(-self.itemLrMargin)
        }
        //
        let itemViews: [TitleValueView] = [self.waitReleaseNumView, self.hasReleaseNumView]
        let itemTitles: [String] = ["待释放(FIL)", "已释放(FIL)"]
        for (index, itemView) in itemViews.enumerated() {
            itemView.set(cornerRadius: 8)
            let bgLayer = AppUtil.commonGradientLayer()
            itemView.layer.insertSublayer(bgLayer, below: nil)
            bgLayer.colors = [UIColor.init(hex: 0xE6F1FD).cgColor, UIColor.init(hex: 0xF4F9FF).cgColor]
            let itemWidth: CGFloat = (kScreenWidth - self.lrMargin * 2.0 - self.itemLrMargin * 2.0 - self.itemHorMargin) * 0.5
            bgLayer.frame = CGRect.init(x: 0, y: 0, width: itemWidth, height: self.itemHeight)
            //
            itemView.titleLabel.set(text: itemTitles[index], font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: UIColor.init(hex: 0x999999), alignment: .center)
            itemView.titleLabel.snp.remakeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.centerY.equalTo(itemView.snp.bottom).offset(-17)
            }
            itemView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor.init(hex: 0x333333), alignment: .center)
            itemView.valueLabel.snp.remakeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.centerY.equalTo(itemView.snp.top).offset(20)
            }
        }
        //
    }
}
// MARK: - UI Xib加载后处理
extension LockDetailHeaderView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension LockDetailHeaderView {

    ///
    fileprivate func setupAsDemo() -> Void {
        self.valueLabel.text = "5100"
        self.waitReleaseNumView.valueLabel.text = "102.1031"
        self.hasReleaseNumView.valueLabel.text = "53.5423"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: LockDetailListModel?) -> Void {
        self.setupAsDemo()
        return
        guard let model = model else {
            return
        }
        // 子控件数据加载
        self.valueLabel.text = model.total.decimalValidDigitsProcess(digits: 8)
        self.waitReleaseNumView.valueLabel.text = model.unrelease.decimalValidDigitsProcess(digits: 8)
        self.hasReleaseNumView.valueLabel.text = model.already.decimalValidDigitsProcess(digits: 8)
    }
    
}

// MARK: - Event Function
extension LockDetailHeaderView {


}

// MARK: - Notification Function
extension LockDetailHeaderView {
    
}

// MARK: - Extension Function
extension LockDetailHeaderView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension LockDetailHeaderView {
    
}
