//
//  PreReturnResultController.swift
//  SassProject
//
//  Created by 小唐 on 2021/7/27.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  提前还币结果页

import UIKit

class PreReturnResultController: BaseViewController {
    // MARK: - Internal Property

    let model: PreReturnResultModel

    // MARK: - Private Property

    fileprivate let scrollView: UIScrollView = UIScrollView.init()
    fileprivate let mainView: UIView = UIView.init()
    
    fileprivate let topPromptView: UIView = UIView()
    fileprivate let promptIconView: UIImageView = UIImageView.init()
    fileprivate let promptTitleLabel: UILabel = UILabel.init()
    fileprivate let promptInfoLabel: UILabel = UILabel.init()

    fileprivate let infoContainer: UIView = UIView()
    fileprivate let waitGasItemView: TitleValueView = TitleValueView.init()    // GAS
    fileprivate let waitInterestItemView: TitleValueView = TitleValueView.init()    // 累计欠款利息
    fileprivate let waitPledgeItemView: TitleValueView = TitleValueView.init()    // 质押
    fileprivate let interestItemView: TitleValueView = TitleValueView.init()    // 利息
    //fileprivate let amountItemView: TitleValueView = TitleValueView.init()    // 数量
    fileprivate let typeItemView: TitleValueView = TitleValueView.init()       // 类型
    fileprivate let statusItemView: TitleValueView = TitleValueView.init()    // 状态
    fileprivate let dateItemView: TitleValueView = TitleValueView.init()      // 时间

    fileprivate let lrMargin: CGFloat = 12
    fileprivate let promptIconTopMargin: CGFloat = 22
    fileprivate let promptIconSize: CGSize = CGSize.init(width: 106, height: 64)
    fileprivate let promptTitleTopMargin: CGFloat = 40
    fileprivate let promptInfoTopMargin: CGFloat = 15
    fileprivate let topPromptViewHeight: CGFloat = 230

    fileprivate let infoItemHeight: CGFloat = 55


    // MARK: - Initialize Function

    init(model: PreReturnResultModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle & Override Function
extension PreReturnResultController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

// MARK: - UI
extension PreReturnResultController {
    
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.white
        // navbar
        self.navigationItem.title = "还币成功"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "IMG_navbar_back"), style: .plain, target: self, action: #selector(navLeftItemClick))
        // scrollView
        self.view.addSubview(self.scrollView)
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.bounces = false
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // mainView
        self.scrollView.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.leading.trailing.width.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    ///
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // topPromptView
        mainView.addSubview(self.topPromptView)
        self.initialTopPromptView(self.topPromptView)
        self.topPromptView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.topPromptViewHeight)
        }
        // infoContainer
        mainView.addSubview(self.infoContainer)
        self.initialInfoContainer(self.infoContainer)
        self.infoContainer.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.topPromptView.snp.bottom)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    /// promptView布局
    fileprivate func initialTopPromptView(_ promptView: UIView) -> Void {
        // 1. iconView
        promptView.addSubview(self.promptIconView)
        self.promptIconView.set(cornerRadius: 0)
        self.promptIconView.snp.makeConstraints { (make) in
            make.size.equalTo(self.promptIconSize)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(self.promptIconTopMargin)
        }
        // 2. promptTitle
        promptView.addSubview(self.promptTitleLabel)
        self.promptTitleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.mainText, alignment: .center)
        self.promptTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.promptIconView.snp.bottom).offset(self.promptTitleTopMargin)
        }
        // 3. promptInfo
        promptView.addSubview(self.promptInfoLabel)
        self.promptInfoLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 24, weight: .medium), textColor: AppColor.mainText, alignment: .center)
        self.promptInfoLabel.numberOfLines = 2
        self.promptInfoLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.promptTitleLabel.snp.bottom).offset(self.promptInfoTopMargin)
        }
    }
    /// container布局
    fileprivate func initialInfoContainer(_ containerView: UIView) -> Void {
        containerView.removeAllSubviews()
        //
        let itemViews: [TitleValueView] = [self.waitGasItemView, self.waitPledgeItemView, self.waitInterestItemView, self.interestItemView, self.typeItemView, self.statusItemView, self.dateItemView]
        let itemTitles: [String] = ["归还本金（GAS消耗）", "归还本金（质押币）", "归还本金（欠款利息）", "归还利息", "还币类型", "还币状态", "还币时间"]
        var lastView: UIView = containerView
        for (index, itemView) in itemViews.enumerated() {
            containerView.addSubview(itemView)
            self.initialItemView(itemView, title: itemTitles[index])
            itemView.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(self.infoItemHeight)
                if 0 == index {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(lastView.snp.bottom)
                }
                if index == itemViews.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
            lastView = itemView
        }
        //
        containerView.addLineWithSide(.inTop, color: AppColor.dividing, thickness: 0.5, margin1: self.lrMargin, margin2: self.lrMargin)
    }
    ///
    fileprivate func initialItemView(_ itemView: TitleValueView, title: String, showBottomLine: Bool = true) -> Void {
        itemView.titleLabel.set(text: title, font: UIFont.pingFangSCFont(size: 14), textColor: AppColor.grayText, alignment: .left)
        itemView.titleLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(self.lrMargin)
        }
        itemView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: AppColor.mainText, alignment: .right)
        itemView.valueLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.lrMargin)
        }
        if showBottomLine {
            itemView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: self.lrMargin, margin2: self.lrMargin)
        }
    }

}
extension PreReturnResultController {
    
    /// container布局
    fileprivate func setupInfoContainer(with itemViews: [UIView]) -> Void {
        self.infoContainer.removeAllSubviews()
        //
        var lastView: UIView = self.infoContainer
        for (index, itemView) in itemViews.enumerated() {
            self.infoContainer.addSubview(itemView)
            itemView.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(self.infoItemHeight)
                if 0 == index {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(lastView.snp.bottom)
                }
                if index == itemViews.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
            lastView = itemView
        }
        //
        self.infoContainer.addLineWithSide(.inTop, color: AppColor.dividing, thickness: 0.5, margin1: self.lrMargin, margin2: self.lrMargin)
    }
    
}


// MARK: - Data(数据处理与加载)
extension PreReturnResultController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
//        self.setupAsDemo()
        
        //
        self.promptIconView.image = UIImage.init(named: "IMG_wallet_tixian_succese")
        self.promptTitleLabel.text = "还币成功"
        self.setupWithModel(self.model)
    }
    
    
    ///
    fileprivate func setupAsDemo() -> Void {
        //
        self.promptIconView.image = UIImage.init(named: "IMG_wallet_tixian_succese")
        self.promptTitleLabel.text = "还币成功"
        self.promptInfoLabel.text = "52.00015FIL"
        //
        self.setupInfoContainer(with: [self.waitPledgeItemView, self.waitGasItemView, self.waitInterestItemView, self.interestItemView, self.typeItemView, self.dateItemView])
        self.waitPledgeItemView.valueLabel.text = "52.00015 FIL"
        self.waitGasItemView.valueLabel.text = "52.00015 FIL"
        self.waitInterestItemView.valueLabel.text = "52.00015 FIL"
        self.interestItemView.valueLabel.text = "52.00015 FIL"
        self.typeItemView.valueLabel.text = "归还全部"
        self.dateItemView.valueLabel.text = "2019-10-12 13:20:45"
    }
    
    ///
    fileprivate func setupWithModel(_ model: PreReturnResultModel?) -> Void {
        guard let model = model else {
            return
        }
        //
        self.promptInfoLabel.text = model.totalReturnAmount.decimalValidDigitsProcess(digits: 8)
        //
        var itemViews: [UIView] = []
        switch model.type {
        case .all:
            itemViews = [self.waitPledgeItemView, self.waitGasItemView, self.waitInterestItemView, self.interestItemView, self.typeItemView, self.dateItemView]
        case .gas:
            itemViews = [self.waitGasItemView, self.interestItemView, self.typeItemView, self.dateItemView]
        case .mortgage:
            itemViews = [self.waitPledgeItemView, self.interestItemView, self.typeItemView, self.dateItemView]
        case .interest:
            itemViews = [self.waitInterestItemView, self.typeItemView, self.dateItemView]
        }
        self.setupInfoContainer(with: itemViews)
        self.waitPledgeItemView.valueLabel.text = "\(model.pledge.decimalValidDigitsProcess(digits: 8))  FIL"
        self.waitGasItemView.valueLabel.text = "\(model.gas.decimalValidDigitsProcess(digits: 8))  FIL"
        self.waitInterestItemView.valueLabel.text = "\(model.interest.decimalValidDigitsProcess(digits: 8))  FIL"
        self.interestItemView.valueLabel.text = "\(model.interest.decimalValidDigitsProcess(digits: 8)) FIL"
        self.typeItemView.valueLabel.text = model.type.title
        self.dateItemView.valueLabel.text = model.createdDate.string(format: "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone.current)
    }
    

}

// MARK: - Event(事件响应)
extension PreReturnResultController {
    
    @objc fileprivate func navLeftItemClick() -> Void {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

// MARK: - Enter Page
extension PreReturnResultController {

}

// MARK: - Notification
extension PreReturnResultController {

}

// MARK: - Extension Function
extension PreReturnResultController {

}

// MARK: - Delegate Function

// MARK: - <>
extension PreReturnResultController {

}
