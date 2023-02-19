//
//  EquipmentDetailView.swift
//  MallProject
//
//  Created by 小唐 on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  设备详情视图

import UIKit

protocol EquipmentDetailViewProtocol: class {
    
    /// 资产明细入口点击
    func detailView(_ detailView: EquipmentDetailView, didClickedAssetDetail addetDetailView: UIView) -> Void
    /// 锁仓详情入口点击
    func detailView(_ detailView: EquipmentDetailView, didClickedLockDetail lockDetailView: UIView) -> Void
    /// 提前归还点击回调
    func detailView(_ detailView: EquipmentDetailView, didClickedPreReturn returnView: UIView) -> Void
    /// 归还流水点击回调
    func detailView(_ detailView: EquipmentDetailView, didClickedReturnDetail returnDetailView: UIView) -> Void

}

class EquipmentDetailView: UIView
{
    
    // MARK: - Internal Property
    
    var model: EquipmentDetailModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    var returns: [EDAssetReturnListModel]? {
        didSet {
            self.backAssetDetailView.models = returns
        }
    }

    /// 回调处理
    weak var delegate: EquipmentDetailViewProtocol?
    
    
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    
    /// 封装详情
    fileprivate let packageDetailView: EDUniversalSubjectView = EDUniversalSubjectView.init()
    /// 资产概况
    fileprivate let assetSurveyView: EDAssetSurveyView = EDAssetSurveyView.init()
    
    
    /// 借贷资本明细
    fileprivate let loanCapitalView: EDUniversalSubjectView = EDUniversalSubjectView.init()
    /// 已归还
    fileprivate let backedAssetView: EDUniversalSubjectView = EDUniversalSubjectView.init()
    /// 待归还
    fileprivate let unbackAssetView: EDUnbackSubjectView = EDUnbackSubjectView.init()
    /// 归还资本明细
    fileprivate let backAssetDetailView: EDBackAssetDetailView = EDBackAssetDetailView.init()
    
    
    fileprivate let itemVerMargin: CGFloat = 0
    fileprivate let itemTopMargin: CGFloat = 0
    fileprivate let itemBottomMargin: CGFloat = 15 + kBottomHeight
    
    
    
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
extension EquipmentDetailView {

    class func loadXib() -> EquipmentDetailView? {
        return Bundle.main.loadNibNamed("EquipmentDetailView", owner: nil, options: nil)?.first as? EquipmentDetailView
    }

}

// MARK: - LifeCircle/Override Function
extension EquipmentDetailView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
    
    /// 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupCorners(UIRectCorner.init([UIRectCorner.topLeft, UIRectCorner.topRight]), selfSize: self.bounds.size, cornerRadius: 15)
    }
    
}
// MARK: - UI Function
extension EquipmentDetailView {
    
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
        mainView.backgroundColor = UIColor.white
        //
        //let itemViews: [UIView] = [self.packageDetailView, self.assetSurveyView, self.loanCapitalView, self.backedAssetView, self.unbackAssetView, self.backAssetDetailView]
        let itemViews: [UIView] = [self.packageDetailView, self.assetSurveyView]
        var topView: UIView = mainView
        for (index, itemView) in itemViews.enumerated() {
            mainView.addSubview(itemView)
            itemView.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                if 0 == index {
                    make.top.equalToSuperview().offset(self.itemTopMargin)
                } else {
                    make.top.equalTo(topView.snp.bottom).offset(self.itemVerMargin)
                }
                if index == itemViews.count - 1 {
                    make.bottom.equalToSuperview().offset(-self.itemBottomMargin)
                }
            }
            topView = itemView
        }
        //
        self.assetSurveyView.model = nil
        self.assetSurveyView.delegate = self
        self.backAssetDetailView.models = nil
        self.unbackAssetView.delegate = self
        self.backAssetDetailView.delegate = self
    }
    
}
// MARK: - UI Xib加载后处理
extension EquipmentDetailView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension EquipmentDetailView {

    ///
    fileprivate func setupAsDemo() -> Void {
        //
        self.packageDetailView.model = ("封装详情", .ipfs)
        self.packageDetailView.status = .deploying
        self.packageDetailView.zhiyaItemView.valueLabel.text = "23.4512"
        self.packageDetailView.xiaohaoItemView.valueLabel.text = "0"
        //
        self.assetSurveyView.model = (EDAssetModel.init(), .ipfs)
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: EquipmentDetailModel?) -> Void {
        self.setupAsDemo()
        return
        guard let model = model, let asset = model.assets else {
            return
        }
        // 子控件数据加载
        self.packageDetailView.zhiyaItemView.valueLabel.text = asset.used_pledge.decimalValidDigitsProcess(digits: 8)
        self.packageDetailView.xiaohaoItemView.valueLabel.text = asset.used_gas.decimalValidDigitsProcess(digits: 8)
//        self.loanCapitalView.zhiyaItemView.valueLabel.text = asset.pledge.decimalValidDigitsProcess(digits: 8)
//        self.loanCapitalView.xiaohaoItemView.valueLabel.text = asset.gas.decimalValidDigitsProcess(digits: 8)
//        self.backedAssetView.zhiyaItemView.valueLabel.text = asset.return_pledge.decimalValidDigitsProcess(digits: 8)
//        self.backedAssetView.xiaohaoItemView.valueLabel.text = asset.return_gas.decimalValidDigitsProcess(digits: 8)
        //
        self.packageDetailView.status = model.pkg_status
//        self.backAssetDetailView.model = model
        self.assetSurveyView.model = (asset, model.zone)
        //
//        self.unbackAssetView.model = model
//        //
        self.packageDetailView.model = ("封装详情", model.zone)
//        self.loanCapitalView.model = ("借贷资本明细", model.zone)
//        self.backedAssetView.model = ("已归还", model.zone)
        
    }
    
}

// MARK: - Event Function
extension EquipmentDetailView {


}

// MARK: - Notification Function
extension EquipmentDetailView {
    
}

// MARK: - Extension Function
extension EquipmentDetailView {
    
}

// MARK: - Delegate Function

// MARK: - <EDAssetSurveyViewProtocol>
extension EquipmentDetailView: EDAssetSurveyViewProtocol {
    /// 资产明细入口点击
    func assetSurveyView(_ assetSurveyView: EDAssetSurveyView, didClickedAssetDetail assetDetailView: UIView) -> Void {
        //print("EquipmentDetailView assetSurveyView didClickedAssetDetail")
        self.delegate?.detailView(self, didClickedAssetDetail: assetDetailView)
    }
    /// 锁仓详情入口点击
    func assetSurveyView(_ assetSurveyView: EDAssetSurveyView, didClickedLockDetail lockDetailView: UIView) -> Void {
        //print("EquipmentDetailView assetSurveyView didClickedLockDetail")
        self.delegate?.detailView(self, didClickedLockDetail: lockDetailView)
    }

}

// MARK: - <EDUnbackSubjectViewProtocol>
extension EquipmentDetailView: EDUnbackSubjectViewProtocol {
    
    /// 提前归还点击回调
    func unbackView(_ unbackView: EDUnbackSubjectView, didClickedPreReturn returnView: UIView) -> Void {
        self.delegate?.detailView(self, didClickedPreReturn: returnView)
    }
    
}

// MARK: - <EDBackAssetDetailViewProtocol>
extension EquipmentDetailView: EDBackAssetDetailViewProtocol {
    
    /// 归还流水点击回调
    func assetDetailView(_ detailView: EDBackAssetDetailView, didClickedReturnDetail returnDetailView: UIView) -> Void {
        self.delegate?.detailView(self, didClickedReturnDetail: detailView)
    }
    
}



