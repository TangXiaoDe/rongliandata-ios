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
    
    static let viewHeight: CGFloat = CGSize.init(width: 375, height: 219).scaleAspectForWidth(kScreenWidth).height - kNavigationStatusBarHeight

    var model: LockDetailListModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    fileprivate let bgView: UIImageView = UIImageView.init()
    fileprivate let titleLabel: UILabel = UILabel.init()        // 设备总量
    fileprivate let valueLabel: UILabel = UILabel.init()
    fileprivate let bottomView: UIView = UIView()
    fileprivate let waitReleaseNumView: TitleValueView = TitleValueView.init()   // 待释放
    fileprivate let hasReleaseNumView: TitleValueView = TitleValueView.init()   // 已释放
    
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let valueCenterYTopMargin: CGFloat = 30     // super.top
    fileprivate let titleCenterYTopMargin: CGFloat = 29  // title.centerY
    fileprivate let bottomViewHeight: CGFloat = 70
    
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
        // 3. valueLabel
        mainView.addSubview(self.valueLabel)
        self.valueLabel.set(text: "0", font: UIFont.pingFangSCFont(size: 28, weight: .medium), textColor: UIColor.init(hex: 0x333333), alignment: .center)
        self.valueLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(mainView.snp.top).offset(self.valueCenterYTopMargin)
            
        }
        // 2. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: "累计收益(FIL)", font: UIFont.pingFangSCFont(size: 14), textColor: UIColor.init(hex: 0x333333).withAlphaComponent(0.8), alignment: .center)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.valueLabel.snp.centerY).offset(self.titleCenterYTopMargin)
        }
        mainView.addSubview(self.bottomView)
        self.initialBottomView(self.bottomView, [self.waitReleaseNumView, self.hasReleaseNumView])
        self.bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.bottomViewHeight)
            make.bottom.equalToSuperview()
        }
        self.bottomView.backgroundColor = UIColor.init(R: 255, G: 250, B: 232)
        self.bottomView.setupCorners([UIRectCorner.topLeft, UIRectCorner.topRight], selfSize: CGSize.init(width: kScreenWidth, height: self.bottomViewHeight), cornerRadius: 16)
    }
    /// bottom
    fileprivate func initialBottomView(_ bottomView: UIView, _ itemViews: [TitleValueView]) -> Void {
        bottomView.removeAllSubviews()
        let titleCenterYBottomMargin: CGFloat = 30 // super.bottom
        let valueCenterYTopMargin: CGFloat = 20    // super.top
        var leftView: UIView = bottomView
        for (index, itemView) in itemViews.enumerated() {
            bottomView.addSubview(itemView)
            itemView.snp.makeConstraints { (make) in
                make.width.equalToSuperview().multipliedBy(1.0 / 2.0)
                if 0 == index {
                    make.leading.equalToSuperview()
                } else {
                    make.leading.equalTo(leftView.snp.trailing)
                }
                if itemViews.count - 1 == index {
                    make.trailing.equalToSuperview()
                }
            }
            itemView.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .regular), textColor: UIColor.init(hex: 0xCCAD78), alignment: .center)
            itemView.titleLabel.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.leading.greaterThanOrEqualToSuperview()
                make.trailing.lessThanOrEqualToSuperview()
                make.centerY.equalTo(bottomView.snp.bottom).offset(-titleCenterYBottomMargin)
            }
            itemView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor.init(hex: 0xCCAD78), alignment: .center)
            itemView.valueLabel.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.leading.greaterThanOrEqualToSuperview()
                make.trailing.lessThanOrEqualToSuperview()
                make.centerY.equalTo(bottomView.snp.top).offset(valueCenterYTopMargin)
            }
            leftView = itemView
        }
        self.waitReleaseNumView.titleLabel.text = "待释放(FIL)"
        self.hasReleaseNumView.titleLabel.text = "已释放(FIL)"
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
        self.valueLabel.text = "5,100"
        self.initialBottomView(self.bottomView, [self.waitReleaseNumView, self.hasReleaseNumView])
        self.waitReleaseNumView.valueLabel.text = "102.1031"
        self.hasReleaseNumView.valueLabel.text = "53.5423"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: LockDetailListModel?) -> Void {
        //self.setupAsDemo()
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
