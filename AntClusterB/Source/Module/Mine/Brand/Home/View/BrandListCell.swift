//
//  BrandListCell.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/6/28.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  品牌商列表Cell

import UIKit

protocol BrandListCellProtocol: class {
    
    /// 渠道分红点击回调
    func brandCell(_ cell: BrandListCell, didClickedBonus bonusView: UIView, with model: BrandModel) -> Void

}

class BrandListCell: UITableViewCell
{
    
    // MARK: - Internal Property

    static let cellHeight: CGFloat = 75
    /// 重用标识符
    static let identifier: String = "BrandListCellReuseIdentifier"
    
    var indexPath: IndexPath?
    var model: BrandModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    /// 回调
    weak var delegate: BrandListCellProtocol?
    
    var showBottomLine: Bool = true {
        didSet {
            self.bottomLine.isHidden = !showBottomLine
        }
    }
    var showTopMargin: Bool = false {
        didSet {
            self.setupShowTopMargin(showTopMargin)
        }
    }
    var showBottomMargin: Bool = true {
        didSet {
            self.setupShowBottomMargin(showBottomMargin)
        }
    }


    // MARK: - fileprivate Property
    
    fileprivate let mainView: UIView = UIView()
    fileprivate let bottomLine: UIView = UIView()
    
    fileprivate let topView: UIView = UIView.init()
    fileprivate let iconView: UIImageView = UIImageView.init()
    fileprivate let titleLabel: UILabel = UILabel.init()
    fileprivate let bonusView: TitleIconControl = TitleIconControl.init() // 渠道分红
    
    
    fileprivate let itemContainer: UIView = UIView.init()
    fileprivate let filItemView: BrandProcurementItemView = BrandProcurementItemView.init()
    fileprivate let xchItemView: BrandProcurementItemView = BrandProcurementItemView.init()
    fileprivate let bzzItemView: BrandProcurementItemView = BrandProcurementItemView.init()
    
    
    fileprivate let topSeparateMargin: CGFloat = 12      // 顶部间距，多用于分组首个cell时的间距展示；
    fileprivate let bottomSeparateMargin: CGFloat = 12   // 底部间距
    fileprivate let mainOutLrMargin: CGFloat = 12
    fileprivate let mainInLrMargin: CGFloat = 10
    
    fileprivate let topViewHeight: CGFloat = 64
    fileprivate let iconWH: CGFloat = 44
    fileprivate let titleIconMargin: CGFloat = 10
    fileprivate let itemHeight: CGFloat = BrandProcurementItemView.viewHeight
    
    
    // MARK: - Initialize Function
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    /// 通用初始化：UI、配置、数据等
    fileprivate func commonInit() -> Void {
        self.initialUI()
    }
    
}

// MARK: - Internal Function
extension BrandListCell {

    /// 便利构造方法
    class func cellInTableView(_ tableView: UITableView, at indexPath: IndexPath? = nil) -> BrandListCell {
        let identifier = BrandListCell.identifier
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if nil == cell {
            cell = BrandListCell.init(style: .default, reuseIdentifier: identifier)
        }
        // 状态重置
        if let cell = cell as? BrandListCell {
            cell.resetSelf()
            cell.indexPath = indexPath
        }
        return cell as! BrandListCell
    }

}

// MARK: - LifeCircle/Override Function
extension BrandListCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

// MARK: - UI Function
extension BrandListCell {

    // 界面布局
    fileprivate func initialUI() -> Void {
        self.contentView.backgroundColor = AppColor.pageBg
        // mainView - 整体布局，便于扩展，特别是针对分割、背景色、四周间距
        self.contentView.addSubview(mainView)
        self.initialMainView(self.mainView)
        mainView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.mainOutLrMargin)
            make.trailing.equalToSuperview().offset(-self.mainOutLrMargin)
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-self.bottomSeparateMargin)
        }
        // bottomLine
        mainView.addSubview(self.bottomLine)
        self.bottomLine.backgroundColor = UIColor.init(hex: 0xE2E2E2)
        self.bottomLine.isHidden = true     // 默认隐藏
        self.bottomLine.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.mainInLrMargin)
            make.trailing.equalToSuperview().offset(-self.mainInLrMargin)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    // 主视图布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = UIColor.white
        mainView.set(cornerRadius: 10)
        // 1. topView
        mainView.addSubview(self.topView)
        self.initialTopView(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.topViewHeight)
        }
        // 2. itemContaner
        mainView.addSubview(self.itemContainer)
        self.initialItemContainer(self.itemContainer)
        self.itemContainer.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom)
        }
    }
    ///
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        // 1. iconView
        topView.addSubview(self.iconView)
        self.iconView.set(cornerRadius: self.iconWH * 0.5)
        self.iconView.image = UIImage.init(named: "")
        self.iconView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.mainInLrMargin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(self.iconWH)
        }
        // 2. titleLabel
        topView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.subMainText)
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.iconView.snp.trailing).offset(self.titleIconMargin)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().offset(-self.mainInLrMargin)
        }
        // 3. bonusView
        topView.addSubview(self.bonusView)
        self.bonusView.addTarget(self, action: #selector(bonusViewClick(_:)), for: .touchUpInside)
        self.bonusView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.mainInLrMargin)
            make.centerY.equalToSuperview()
        }
        self.bonusView.titleLabel.set(text: "渠道分红", font: UIFont.pingFangSCFont(size: 14), textColor: AppColor.mainText)
        self.bonusView.titleLabel.snp.remakeConstraints { (make) in
            make.centerY.leading.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        self.bonusView.iconView.set(cornerRadius: 0)
        self.bonusView.iconView.image = UIImage.init(named: "IMG_icon_arrow_right_gray")
        self.bonusView.iconView.snp.remakeConstraints { (make) in
            let iconSize: CGSize = CGSize.init(width: 6, height: 11)
            make.size.equalTo(iconSize)
            make.trailing.centerY.equalToSuperview()
            make.leading.equalTo(self.bonusView.titleLabel.snp.trailing).offset(5)
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        // 4. bottomLine
        topView.addLineWithSide(.inBottom, color: AppColor.disable, thickness: 0.5, margin1: self.mainInLrMargin, margin2: self.mainInLrMargin)
    }
    ///
    fileprivate func initialItemContainer(_ itemContainer: UIView) -> Void {
        itemContainer.removeAllSubviews()
        //
        var topView: UIView = itemContainer
        let bzzItemViews: [BrandProcurementItemView] = [self.filItemView, self.xchItemView, self.bzzItemView]
        let nobzzItemViews: [BrandProcurementItemView] = [self.filItemView, self.xchItemView]
        let itemViews: [BrandProcurementItemView] = AppConfig.share.isShowBzz ? bzzItemViews : nobzzItemViews
        for (index, itemView) in itemViews.enumerated() {
            itemContainer.addSubview(itemView)
            itemView.showBottomLine = index != itemViews.count - 1
            itemView.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(self.itemHeight)
                if 0 == index {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(topView.snp.bottom)
                }
                if index == itemViews.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
            topView = itemView
        }
        self.filItemView.zone = .ipfs
        self.xchItemView.zone = .chia
        self.bzzItemView.zone = .bzz
    }

}

// MARK: - Data Function
extension BrandListCell {

    /// 顶部间距是否显示
    fileprivate func setupShowTopMargin(_ show: Bool) -> Void {
        let topMargin: CGFloat = show ? self.topSeparateMargin : 0
        mainView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(topMargin)
        }
        self.layoutIfNeeded()
    }
    /// 底部间距是否显示
    fileprivate func setupShowBottomMargin(_ show: Bool) -> Void {
        let bottomMargin: CGFloat = show ? self.bottomSeparateMargin : 0
        mainView.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottomMargin)
        }
        self.layoutIfNeeded()
    }

    /// 重置
    fileprivate func resetSelf() -> Void {
        self.selectionStyle = .none
        self.isSelected = false
        self.showTopMargin = false
        self.showBottomMargin = true
        self.showBottomLine = true
    }
    ///
    fileprivate func setupAsDemo() -> Void {
        self.titleLabel.text = "我是标题"
//        self.detailLabel.text = "我是详情"
        self.iconView.backgroundColor = UIColor.random
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: BrandModel?) -> Void {
        //self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 控件加载数据
        self.iconView.kf.setImage(with: model.avatarUrl, placeholder: AppImage.PlaceHolder.avatar)
        self.titleLabel.text = model.name
        self.filItemView.model = model.fil
        self.xchItemView.model = model.xch
        self.bzzItemView.model = model.bzz
    }

}

// MARK: - Event Function
extension BrandListCell {

    ///
    @objc fileprivate func doneBtnClick(_ doneBtn: UIButton) -> Void {
        print("BrandListCell doneBtnClick")
        guard let model = self.model else {
            return
        }
    }
    
    /// 渠道分红点击
    @objc fileprivate func bonusViewClick(_ bonusView: TitleIconControl) -> Void {
        guard let model = self.model else {
            return
        }
        self.delegate?.brandCell(self, didClickedBonus: bonusView, with: model)
    }
    
}

// MARK: - Notification Function
extension BrandListCell {
    
}

// MARK: - Extension Function
extension BrandListCell {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension BrandListCell {
    
}

