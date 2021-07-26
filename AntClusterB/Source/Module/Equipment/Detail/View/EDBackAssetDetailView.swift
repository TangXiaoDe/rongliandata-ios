//
//  EDBackAssetDetailView.swift
//  MallProject
//
//  Created by 小唐 on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  归还资产明细视图

import UIKit

///
class EDBackAssetDetailView: UIView {
    
    // MARK: - Internal Property

    var model: EquipmentDetailModel? {
        didSet {
            guard let model = model else {
                return
            }
            self.formShouldInterestLabel.text = "应还利息\n\(model.interest.decimalValidDigitsProcess(digits: 2))%"
        }
    }
    var models: [EDAssetReturnListModel]? {
        didSet {
            self.setupWithModels(models)
        }
    }
    
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    
    let titleView: TitleIconView = TitleIconView.init()     // 标题
    
    fileprivate let bottomView: UIView = UIView.init()      // contentView
    fileprivate let scrollView: UIScrollView = UIScrollView.init()
    fileprivate let formView: UIView = UIView.init()
    
    fileprivate let formTitleView: UIView = UIView.init()
    fileprivate let formDateLabel: UILabel = UILabel.init()      // 日期
    fileprivate let formZhiyaLabel: UILabel = UILabel.init()     // 质押币
    fileprivate let formGasLabel: UILabel = UILabel.init()       // Gas
    fileprivate let formShouldInterestLabel: UILabel = UILabel.init()  // 应还利息
    fileprivate let formRealInterestLabel: UILabel = UILabel.init()  // 实还利息
    
    fileprivate let formContentContainer: UIView = UIView.init()

    
    fileprivate let titleLeftMargin: CGFloat = 12
    fileprivate let titleViewHeight: CGFloat = 44
    fileprivate let titleIconWH: CGFloat = 14

    fileprivate let formTopMargin: CGFloat = 5
    fileprivate let formBottomMargin: CGFloat = 25
    
    fileprivate let itemOutLrMargin: CGFloat = 24
    fileprivate let itemInLrMargin: CGFloat = 12
    
    fileprivate let itemInMargin: CGFloat = 12
    fileprivate let titleItemHeight: CGFloat = 44
    fileprivate let itemHeight: CGFloat = 36
    fileprivate let itemVerMargin: CGFloat = 12
    fileprivate let itemTopMargin: CGFloat = 5
    fileprivate let itemBottomMargin: CGFloat = 10
    
    fileprivate let itemInLeftMargin: CGFloat = 12
    fileprivate let itemInRightMargin: CGFloat = 12
    fileprivate let itemHorMargin: CGFloat = 5
    fileprivate let itemColNum: Int = 5
    fileprivate let itemWidth: CGFloat = 80
//    fileprivate lazy var itemWidth: CGFloat = {
//        var width: CGFloat = (kScreenWidth - self.itemOutLrMargin * 2.0 - self.itemInLeftMargin - self.itemInRightMargin - self.itemHorMargin * CGFloat(self.itemColNum - 1)) / CGFloat(self.itemColNum)
//        width = CGFloat(floor(Double(width)))
//        return width
//    }()

    fileprivate let formTitleHeight: CGFloat = 36
    
    fileprivate let formContentContainerTopMargin: CGFloat = 0
    fileprivate let formContentContainerBottomMargin: CGFloat = 25
    
    
    
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
extension EDBackAssetDetailView {

    class func loadXib() -> EDBackAssetDetailView? {
        return Bundle.main.loadNibNamed("EDBackAssetDetailView", owner: nil, options: nil)?.first as? EDBackAssetDetailView
    }

}

// MARK: - LifeCircle/Override Function
extension EDBackAssetDetailView {

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
extension EDBackAssetDetailView {
    
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
            make.top.equalToSuperview()
            make.height.equalTo(self.titleViewHeight)
        }
        self.titleView.iconView.set(cornerRadius: 0)
        self.titleView.iconView.image = UIImage.init(named: "IMG_equip_icon_guihuan")
        self.titleView.iconView.snp.remakeConstraints { (make) in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(self.titleIconWH)
        }
        self.titleView.titleLabel.set(text: "归还资本明细", font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: AppColor.mainText, alignment: .left)
        self.titleView.titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(self.titleView.iconView.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        // 2. bottomView
        mainView.addSubview(self.bottomView)
        self.initialBottomView(self.bottomView)
        self.bottomView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.itemOutLrMargin)
            make.trailing.equalToSuperview().offset(-self.itemOutLrMargin)
            make.top.equalTo(self.titleView.snp.bottom)
            make.bottom.equalToSuperview().offset(-self.formBottomMargin)
        }
    }
    
    ///
    fileprivate func initialBottomView(_ bottomView: UIView) -> Void {
        bottomView.set(cornerRadius: 5, borderWidth: 0.5, borderColor: AppColor.dividing)
        // scrollView
        bottomView.addSubview(self.scrollView)
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.bounces = false
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 2. form
        self.scrollView.addSubview(self.formView)
        self.initialFormView(self.formView)
        self.formView.snp.makeConstraints { (make) in
            make.edges.height.equalToSuperview()
        }
    }
    ///
    fileprivate func initialFormView(_ formView: UIView) -> Void {
        // 2.1 formTitle
        self.formView.addSubview(self.formTitleView)
        self.initialformTitleView(self.formTitleView)
        self.formTitleView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.titleItemHeight)
        }
        // 2.2 formContentContainer
        self.formView.addSubview(self.formContentContainer)
        self.formContentContainer.snp.makeConstraints { (make) in
            make.top.equalTo(self.formTitleView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    ///
    fileprivate func initialformTitleView(_ formView: UIView) -> Void {
        //
        formView.backgroundColor = AppColor.pageBg
        //formView.setupCorners(UIRectCorner.init([UIRectCorner.topLeft, UIRectCorner.topRight]), selfSize: CGSize.init(width: kScreenWidth - self.itemOutLrMargin * 2.0, height: self.formTitleHeight), cornerRadius: 5, borderWidth: 0.5, borderColor: AppColor.dividing)
        //
        formView.removeAllSubviews()
        let itemViews: [UILabel] = [self.formDateLabel, self.formZhiyaLabel, self.formGasLabel, self.formShouldInterestLabel, self.formRealInterestLabel]
        let itemTitles: [String] = ["结算时间", "质押币", "Gas", "应还利息", "实还利息"]
        let itemWidth: CGFloat = self.itemWidth
        var leftView: UIView = formView
        for (index, itemView) in itemViews.enumerated() {
            formView.addSubview(itemView)
            itemView.set(text: itemTitles[index], font: UIFont.pingFangSCFont(size: 12), textColor: UIColor.init(hex: 0x666666), alignment: .left)
            itemView.snp.makeConstraints { (make) in
                make.width.equalTo(itemWidth)
                make.top.bottom.equalToSuperview()
                if 0 == index {
                    make.leading.equalToSuperview().offset(self.itemInLeftMargin)
                } else {
                    make.leading.equalTo(leftView.snp.trailing).offset(self.itemHorMargin)
                }
                if index == itemViews.count - 1 {
                    make.trailing.equalToSuperview().offset(-self.itemInRightMargin)
                }
            }
            leftView = itemView
        }
        //
        self.formShouldInterestLabel.numberOfLines = 2
    }

    ///
    fileprivate func setupformContentContainer(with models: [EDAssetReturnListModel]) -> Void {
        self.formContentContainer.removeAllSubviews()
        //
        var topView: UIView = self.formContentContainer
        for (index, model) in models.enumerated() {
            let itemView = EDBackAssetDetailItemView.init(viewWidth: kScreenWidth - self.itemOutLrMargin * 2.0)
            self.formContentContainer.addSubview(itemView)
            itemView.model = model
            itemView.isLast = index == models.count - 1
            itemView.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(self.itemHeight)
                if 0 == index {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(topView.snp.bottom)
                }
                if index == models.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
            topView = itemView
        }
        
        
//        let itemInLrMargin: CGFloat = 10
//        let itemTitleCenterYTopMargin: CGFloat = 20     // super.top
//        let itemValueCenterYBottomMargin: CGFloat = 22  // super.bottom
//
//        formContentContainer.removeAllSubviews()
//        //
//        let itemViews: [TitleValueView] = [self.zhiyaItemView, self.xiaohaoItemView]
//        for (index, itemView) in itemViews.enumerated() {
//            let row: Int = index / self.itemColNum
//            let col: Int = index % self.itemColNum
//            formContentContainer.addSubview(itemView)
//            itemView.backgroundColor = UIColor.init(hex: 0xFDC818).withAlphaComponent(0.08)
//            itemView.set(cornerRadius: 5)
//            itemView.snp.makeConstraints { (make) in
//                make.width.equalTo(self.itemWidth)
//                make.height.equalTo(self.itemHeight)
//                let leftMargin: CGFloat = self.itemLrMargin + (self.itemWidth + self.itemHorMargin) * CGFloat(col)
//                let topMargin: CGFloat = self.itemTopMargin + (self.itemHeight + self.itemVerMargin) * CGFloat(row)
//                make.top.equalToSuperview().offset(topMargin)
//                make.leading.equalToSuperview().offset(leftMargin)
//                if index == itemViews.count - 1 {
//                    let rightMargin: CGFloat = kScreenWidth - leftMargin - self.itemWidth
//                    make.trailing.equalToSuperview().offset(-rightMargin)
//                    make.bottom.equalToSuperview().offset(-self.itemBottomMargin)
//                }
//            }
//            //
//            itemView.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12), textColor: UIColor.init(hex: 0x666666))
//            itemView.titleLabel.snp.remakeConstraints { (make) in
//                make.leading.equalToSuperview().offset(itemInLrMargin)
//                make.trailing.lessThanOrEqualToSuperview()
//                make.centerY.equalTo(itemView.snp.top).offset(itemTitleCenterYTopMargin)
//            }
//            itemView.valueLabel.set(text: "0", font: UIFont.pingFangSCFont(size: 20, weight: .medium), textColor: AppColor.mainText)
//            itemView.valueLabel.snp.remakeConstraints { (make) in
//                make.leading.equalToSuperview().offset(itemInLrMargin)
//                make.trailing.lessThanOrEqualToSuperview()
//                make.centerY.equalTo(itemView.snp.bottom).offset(-itemValueCenterYBottomMargin)
//            }
//        }
    }
    
}
// MARK: - UI Xib加载后处理
extension EDBackAssetDetailView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension EDBackAssetDetailView {

    ///
    fileprivate func setupAsDemo() -> Void {
        //self.titleView.iconView.backgroundColor = UIColor.red
//        self.titleView.titleLabel.text = "我是标题"
        
        self.setupformContentContainer(with: [])
        
//
//        self.statusView.isHidden = false
//        var statusAtts = NSAttributedString.textAttTuples()
//        statusAtts.append((str: "封装状态：", font: UIFont.pingFangSCFont(size: 12), color: UIColor.init(hex: 0x666666)))
//        statusAtts.append((str: "部署中", font: UIFont.pingFangSCFont(size: 16, weight: .medium), color: UIColor.init(hex: 0xE06236)))
//        self.statusView.attributedText = NSAttributedString.attribute(statusAtts)
        
    }
    /// 数据加载
    fileprivate func setupWithTitle(_ title: String?) -> Void {
//        self.setupAsDemo()
        guard let title = title else {
            return
        }
//        // 子控件数据加载
//        self.titleView.titleLabel.text = title
//        self.titleView.iconView.backgroundColor = UIColor.random
//
//        self.zhiyaItemView.backgroundColor = UIColor.init(hex: 0xFDC818).withAlphaComponent(0.08)
//        self.xiaohaoItemView.backgroundColor = UIColor.init(hex: 0xFDC818).withAlphaComponent(0.08)
//        self.statusView.isHidden = true
//
//        var zhiyaTitle: String = ""
//        var xiaohaoTitle: String = ""
//        switch title {
//        case "封装详情":
//            self.statusView.isHidden = false
//            var statusAtts = NSAttributedString.textAttTuples()
//            statusAtts.append((str: "封装状态：", font: UIFont.pingFangSCFont(size: 12), color: UIColor.init(hex: 0x666666)))
//            statusAtts.append((str: "部署中", font: UIFont.pingFangSCFont(size: 16, weight: .medium), color: UIColor.init(hex: 0xE06236)))
//            self.statusView.attributedText = NSAttributedString.attribute(statusAtts)
//
//            zhiyaTitle = "使用质押币数量(FIL)"
//            xiaohaoTitle = "Gas消耗数量(FIL)"
//        case "借贷资本明细":
//            zhiyaTitle = "借贷质押币数量(FIL)"
//            xiaohaoTitle = "借贷Gas消耗数量(FIL)"
//        case "已归还":
//            self.zhiyaItemView.backgroundColor = UIColor.init(hex: 0x2280FB).withAlphaComponent(0.08)
//            self.xiaohaoItemView.backgroundColor = UIColor.init(hex: 0x2280FB).withAlphaComponent(0.08)
//            zhiyaTitle = "质押币数量(FIL)"
//            xiaohaoTitle = "Gas消耗数量(FIL)"
//        case "待归还":
//            zhiyaTitle = "质押币数量(FIL)"
//            xiaohaoTitle = "Gas消耗数量(FIL)"
//        default:
//            break
//        }
//        self.zhiyaItemView.titleLabel.text = zhiyaTitle
//        self.xiaohaoItemView.titleLabel.text = xiaohaoTitle
    }
    fileprivate func setupWithModels(_ models: [EDAssetReturnListModel]?) -> Void {
        //self.setupAsDemo()
        guard let models = models else {
            return
        }
        // 子控件数据加载
        self.setupformContentContainer(with: models)
    }

}

// MARK: - Event Function
extension EDBackAssetDetailView {

}

// MARK: - Notification Function
extension EDBackAssetDetailView {
    
}

// MARK: - Extension Function
extension EDBackAssetDetailView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension EDBackAssetDetailView {
    
}

