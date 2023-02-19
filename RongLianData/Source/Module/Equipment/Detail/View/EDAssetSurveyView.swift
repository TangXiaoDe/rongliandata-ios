//
//  EDAssetSurveyView.swift
//  MallProject
//
//  Created by 小唐 on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  资产概况视图

import UIKit

protocol EDAssetSurveyViewProtocol: class {
    
    /// 资产明细入口点击
    func assetSurveyView(_ assetSurveyView: EDAssetSurveyView, didClickedAssetDetail assetDetailView: UIView) -> Void
    /// 锁仓详情入口点击
    func assetSurveyView(_ assetSurveyView: EDAssetSurveyView, didClickedLockDetail lockDetailView: UIView) -> Void
    
}

///
class EDAssetSurveyView: UIView {
    
    // MARK: - Internal Property
    
    var model: (asset: EDAssetModel, zone: ProductZone)? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    weak var delegate: EDAssetSurveyViewProtocol?
    
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    
    fileprivate let titleView: TitleIconView = TitleIconView.init()     // 标题
    fileprivate let assetDetailControl: IconTitleIconControl = IconTitleIconControl.init()  // 资产详情入口
    
    fileprivate let container: UIView = UIView.init()
    fileprivate let canUseItemView: TitleValueView = TitleValueView.init()       // 可用数量
    fileprivate let diyaItemView: TitleValueView = TitleValueView.init()        // 抵押数量
    fileprivate let lockItemView: TitleValueView = TitleValueView.init()       // 锁仓数量
    fileprivate let frozenItemView: TitleValueView = TitleValueView.init()     // 冻结数量
    
    fileprivate let lockDetailView: TitleIconControl = TitleIconControl.init()  // 锁仓详情入口
    
    fileprivate var itemTitles: [String] = ["可用数量(FIL)", "抵押数量(FIL)", "锁仓数量(FIL)", "冻结数量(FIL)"]
    
    
    fileprivate let titleLeftMargin: CGFloat = 12
    fileprivate let titleViewHeight: CGFloat = 44
    fileprivate let titleViewTopMargin: CGFloat = 8
    fileprivate let titleIconWH: CGFloat = 14

    fileprivate let itemLrMargin: CGFloat = 27
    fileprivate let itemHeight: CGFloat = 56
    fileprivate let itemHorMargin: CGFloat = 12
    fileprivate let itemVerMargin: CGFloat = 8
    fileprivate let itemTopMargin: CGFloat = 0
    fileprivate let itemBottomMargin: CGFloat = 0
    fileprivate let itemInLrMargin: CGFloat = 12
    fileprivate let itemColNum: Int = 1
    fileprivate lazy var itemWidth: CGFloat = {
        let width: CGFloat = (kScreenWidth - self.itemLrMargin * 2.0 - self.itemHorMargin * CGFloat(self.itemColNum - 1)) / CGFloat(self.itemColNum)
        return width
    }()
    
    fileprivate let lockDetailIconWH: CGFloat = 12

    
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
extension EDAssetSurveyView {

    class func loadXib() -> EDAssetSurveyView? {
        return Bundle.main.loadNibNamed("EDAssetSurveyView", owner: nil, options: nil)?.first as? EDAssetSurveyView
    }

}

// MARK: - LifeCircle/Override Function
extension EDAssetSurveyView {

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
extension EDAssetSurveyView {
    
    /// 界面布局
    fileprivate func initialUI() -> Void {
        //self.backgroundColor = UIColor.white
        //
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    /// mainView布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. titleView
        mainView.addSubview(self.titleView)
        self.titleView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.titleLeftMargin)
            make.top.equalToSuperview().offset(self.titleViewTopMargin)
            make.height.equalTo(self.titleViewHeight)
        }
        self.titleView.iconView.set(cornerRadius: 0)
        self.titleView.iconView.image = UIImage.init(named: "IMG_equip_icon_zichan")
        self.titleView.iconView.snp.remakeConstraints { (make) in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(self.titleIconWH)
        }
        self.titleView.titleLabel.set(text: "资产概况", font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: AppColor.mainText, alignment: .left)
        self.titleView.titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(self.titleView.iconView.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        // 2. assetDetailControl
        mainView.addSubview(self.assetDetailControl)
        self.assetDetailControl.addTarget(self, action: #selector(assetDetailViewClick(_:)), for: .touchUpInside)
        self.assetDetailControl.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.itemLrMargin)
            make.centerY.equalTo(self.titleView)
        }
        self.assetDetailControl.leftIconView.set(cornerRadius: 0)
        //self.assetDetailControl.leftIconView.backgroundColor = UIColor.red
        self.assetDetailControl.leftIconView.image = UIImage.init(named: "IMG_equip_icon_zcmx")
        self.assetDetailControl.leftIconView.isHidden = true
        self.assetDetailControl.leftIconView.snp.remakeConstraints { (make) in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 12, height: 12))
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        self.assetDetailControl.rightIconView.set(cornerRadius: 0)
        self.assetDetailControl.rightIconView.image = UIImage.init(named: "IMG_equip_next_blue")
        self.assetDetailControl.rightIconView.snp.remakeConstraints { (make) in
            make.trailing.centerY.equalToSuperview()
            //make.size.equalTo(CGSize.init(width: 6, height: 11))
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        self.assetDetailControl.titleLabel.set(text: "资产明细", font: UIFont.pingFangSCFont(size: 12, weight: .regular), textColor: AppColor.theme, alignment: .right)
        self.assetDetailControl.titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(self.assetDetailControl.leftIconView.snp.trailing).offset(5)
            make.trailing.equalTo(self.assetDetailControl.rightIconView.snp.leading).offset(-5)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        // 3. container
        mainView.addSubview(self.container)
        self.initialContainer(self.container)
        self.container.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.titleView.snp.bottom)
        }
    }
    ///
    fileprivate func initialContainer(_ container: UIView) -> Void {
        //
        container.removeAllSubviews()
        let itemViews: [TitleValueView] = [self.canUseItemView, self.diyaItemView, self.lockItemView, self.frozenItemView]
        var topView: UIView = container
        for (index, itemView) in itemViews.enumerated() {
            container.addSubview(itemView)
            itemView.backgroundColor = UIColor.init(hex: 0xF9F9F9)
            itemView.set(cornerRadius: 8)
            itemView.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(self.itemLrMargin)
                make.trailing.equalToSuperview().offset(-self.itemLrMargin)
                make.height.equalTo(self.itemHeight)
                if 0 == index {
                    make.top.equalToSuperview().offset(self.itemTopMargin)
                } else {
                    make.top.equalTo(topView.snp.bottom).offset(self.itemVerMargin)
                }
                if index == itemViews.count - 1 {
                    make.bottom.equalToSuperview().offset(-self.itemBottomMargin)
                }
            }
            //
            itemView.titleLabel.set(text: self.itemTitles[index], font: UIFont.pingFangSCFont(size: 13), textColor: UIColor.init(hex: 0x666666))
            itemView.titleLabel.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview().offset(self.itemInLrMargin)
                make.centerY.equalToSuperview()
            }
            itemView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 20, weight: .medium), textColor: AppColor.mainText)
            itemView.valueLabel.snp.remakeConstraints { (make) in
                make.trailing.equalToSuperview().offset(-self.itemInLrMargin)
                make.centerY.equalToSuperview()
            }
            //
            topView = itemView
        }
        // lockItemView - detailView
        self.lockItemView.titleLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(self.itemInLrMargin)
            make.centerY.equalTo(self.lockItemView.snp.top).offset(20)
        }
        self.lockItemView.addSubview(self.lockDetailView)
        self.lockDetailView.addTarget(self, action: #selector(loackDetailViewClick(_:)), for: .touchUpInside)
        self.lockDetailView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.lockItemView.titleLabel)
            make.centerY.equalTo(self.lockItemView.titleLabel).offset(17)
        }
        self.lockDetailView.iconView.set(cornerRadius: self.lockDetailIconWH * 0.5)
        //self.lockDetailView.iconView.backgroundColor = UIColor.init(hex: 0x2280FB).withAlphaComponent(0.5)
        self.lockDetailView.iconView.image = UIImage.init(named: "IMG_equip_next_blue")
        self.lockDetailView.iconView.snp.remakeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            //make.width.height.equalTo(self.lockDetailIconWH)
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        self.lockDetailView.titleLabel.set(text: "详情", font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.theme, alignment: .right)
        self.lockDetailView.titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalTo(self.lockDetailView.iconView.snp.leading).offset(-5)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
}
// MARK: - UI Xib加载后处理
extension EDAssetSurveyView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension EDAssetSurveyView {

    ///
    fileprivate func setupAsDemo() -> Void {
        //self.titleView.iconView.backgroundColor = UIColor.red
        self.canUseItemView.valueLabel.text = "34.8756"
        self.diyaItemView.valueLabel.text = "2.87"
        self.lockItemView.valueLabel.text = "4657.7642"
        self.frozenItemView.valueLabel.text = "0"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: (asset: EDAssetModel, zone: ProductZone)?) -> Void {
        self.setupAsDemo()
        return
        guard let model = model else {
            return
        }
        // 子控件数据加载
        self.itemTitles = ["可用数量(\(model.zone.rawValue.uppercased()))", "抵押数量(\(model.zone.rawValue.uppercased()))", "锁仓数量(\(model.zone.rawValue.uppercased()))", "冻结数量(\(model.zone.rawValue.uppercased()))"]
        self.initialContainer(self.container)
        self.canUseItemView.valueLabel.text = model.asset.available.decimalValidDigitsProcess(digits: 8)
        self.diyaItemView.valueLabel.text = model.asset.pawn.decimalValidDigitsProcess(digits: 8)
        self.lockItemView.valueLabel.text = model.asset.lock.decimalValidDigitsProcess(digits: 8)
        self.frozenItemView.valueLabel.text = model.asset.frozen.decimalValidDigitsProcess(digits: 8)
    }

}

// MARK: - Event Function
extension EDAssetSurveyView {
    /// 资产详情入口点击响应
    @objc fileprivate func assetDetailViewClick(_ detailView: UIControl) -> Void {
        self.delegate?.assetSurveyView(self, didClickedAssetDetail: detailView)
    }
    
    /// 锁仓详情入口点击响应
    @objc fileprivate func loackDetailViewClick(_ detailView: UIControl) -> Void {
        self.delegate?.assetSurveyView(self, didClickedLockDetail: detailView)
    }
    
    
}

// MARK: - Notification Function
extension EDAssetSurveyView {
    
}

// MARK: - Extension Function
extension EDAssetSurveyView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension EDAssetSurveyView {
    
}

