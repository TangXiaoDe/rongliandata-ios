//
//  EDBackAssetDetailItemView.swift
//  MallProject
//
//  Created by 小唐 on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  归还资产明细行视图
//  注：只复制底部分割线

import UIKit


///
class EDBackAssetDetailItemView: BaseView {
    
    // MARK: - Internal Property
    
    let viewWidth: CGFloat
    // 备注：使用这种方式修改约束，会导致严重的卡顿问题
//    = kScreenWidth {
//        didSet {
//            self.updateLayout()
//        }
//    }
    var isLast: Bool = false {
        didSet {
            self.bottomLine.isHidden = isLast
        }
    }
    
    var model: EDAssetReturnListModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    
    // MARK: - Private Property
    
    
    fileprivate let mainView: UIView = UIView.init()
    
    fileprivate let dateValueLabel: UILabel = UILabel.init()      // 日期
    fileprivate let zhiyaValueLabel: UILabel = UILabel.init()     // 质押数量
    fileprivate let gasValueLabel: UILabel = UILabel.init()       // Gas
    fileprivate let interestShouldLabel: UILabel = UILabel.init()  // 应还利息
    fileprivate let interestRealLabel: UILabel = UILabel.init()  // 实还利息
    
    fileprivate let itemOutLrMargin: CGFloat = 24
    fileprivate let itemInLeftMargin: CGFloat = 12
    fileprivate let itemInRightMargin: CGFloat = 12
    
    fileprivate let itemLeftMargin: CGFloat = 12
    fileprivate let itemRightMargin: CGFloat = 12
    fileprivate let itemHorMargin: CGFloat = 5
    fileprivate let itemColNum: Int = 5
    fileprivate lazy var itemWidth: CGFloat = {
        // 总共有5个item，要求第4个item的正中间显示一半
        let totalWidth: CGFloat = kScreenWidth - self.itemOutLrMargin * 2.0 - self.itemInLeftMargin - self.itemHorMargin * CGFloat(self.itemColNum - 2)
        let showNum: CGFloat = CGFloat(self.itemColNum - 2) + 0.25
        var width: CGFloat = totalWidth / showNum
        width = CGFloat(floor(Double(width)))
        return width
    }()

    
    // MARK: - Initialize Function
    init(viewWidth: CGFloat) {
        self.viewWidth = viewWidth
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.commonInit()
//    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        //self.commonInit()
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 通用初始化：UI、配置、数据等
    func commonInit() -> Void {
        self.initialUI()
    }
    
}

// MARK: - Internal Function
extension EDBackAssetDetailItemView {

    class func loadXib() -> EDBackAssetDetailItemView? {
        return Bundle.main.loadNibNamed("EDBackAssetDetailItemView", owner: nil, options: nil)?.first as? EDBackAssetDetailItemView
    }

}

// MARK: - LifeCircle/Override Function
extension EDBackAssetDetailItemView {

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
extension EDBackAssetDetailItemView {
    
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
    /// mainView布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        //
        mainView.removeAllSubviews()
        let itemViews: [UILabel] = [self.dateValueLabel, self.zhiyaValueLabel, self.gasValueLabel, self.interestShouldLabel, interestRealLabel]
        let itemWidth: CGFloat = self.itemWidth
        var leftView: UIView = mainView
        for (index, itemView) in itemViews.enumerated() {
            mainView.addSubview(itemView)
            itemView.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: AppColor.mainText, alignment: .left)
            itemView.snp.makeConstraints { (make) in
                make.width.equalTo(itemWidth)
                make.top.bottom.equalToSuperview()
                if 0 == index {
                    make.leading.equalToSuperview().offset(self.itemLeftMargin)
                } else {
                    make.leading.equalTo(leftView.snp.trailing).offset(self.itemHorMargin)
                }
                if index == itemViews.count - 1 {
                    make.trailing.equalToSuperview().offset(-self.itemRightMargin)
                }
            }
            leftView = itemView
        }
    }
    
}
// MARK: - UI Xib加载后处理
extension EDBackAssetDetailItemView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension EDBackAssetDetailItemView {

    ///
    fileprivate func setupAsDemo() -> Void {
        self.dateValueLabel.text = "2020.05.01"
        self.zhiyaValueLabel.text = "25.2142"
        self.gasValueLabel.text = "10.1514"
        self.interestShouldLabel.text = "1.021"
        self.interestRealLabel.text = "1.021"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: EDAssetReturnListModel?) -> Void {
        //self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 子控件数据加载
        self.dateValueLabel.text = model.createdDate.string(format: "yyyy.MM.dd", timeZone: .current)
        self.zhiyaValueLabel.text = model.pledge.decimalValidDigitsProcess(digits: 8)
        self.gasValueLabel.text = model.gas.decimalValidDigitsProcess(digits: 8)
        self.interestShouldLabel.text = model.should_interest.decimalValidDigitsProcess(digits: 8)
        self.interestRealLabel.text = model.interest.decimalValidDigitsProcess(digits: 8)
    }
    
    ///
//    fileprivate func updateLayout() -> Void {
//        let itemViews: [UILabel] = [self.dateValueLabel, self.zhiyaValueLabel, self.gasValueLabel, self.interestShouldLabel]
//        let itemWidth: CGFloat = CGFloat(floor(Double((self.viewWidth - self.itemLrMargin * 2.0) / CGFloat(itemViews.count))))
//        for (_, itemView) in itemViews.enumerated() {
//            itemView.snp.updateConstraints { (make) in
//                make.width.equalTo(itemWidth)
//            }
//        }
//        self.layoutIfNeeded()
//    }
    
}

// MARK: - Event Function
extension EDBackAssetDetailItemView {

}

// MARK: - Notification Function
extension EDBackAssetDetailItemView {
    
}

// MARK: - Extension Function
extension EDBackAssetDetailItemView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension EDBackAssetDetailItemView {
    
}

