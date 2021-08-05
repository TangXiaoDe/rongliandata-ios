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

    var model: String?

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

    init(result: String? = nil) {
        self.model = result
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
        self.setupAsDemo()
//        if let model = self.model {
//            self.setupData(with: model)
//        }
    }

    fileprivate func setupAsDemo() -> Void {
        //
        self.promptIconView.image = UIImage.init(named: "IMG_common_acc_icon")
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
    fileprivate func setupData(with model: String) -> Void {
        self.setupAsDemo()
        
//        self.withdrawalAmountView.secondLabel.text = model.amount.decimalValidDigitsProcess(digits: 8) + " " + model.currency.uppercased()
//        self.withdrawalFeeView.secondLabel.text = model.fee.decimalValidDigitsProcess(digits: 8) + " " + model.currency.uppercased()
//        self.withdrawalDateView.secondLabel.text = model.createdDate.string(format: "yyyy-MM-dd HH:mm:ss", timeZone: .current)
//        switch model.status {
//        case .applying:
//            // 审核中
//            self.promptIconView.image = UIImage.init(named: "IMG_common_acc_icon")    // IMG_wallet_tixian_fail
//            self.promptTitleLabel.text = "提交成功" // 提交成功、提现成功、提现失败、
//            self.promptInfoLabel.text = "提币申请已提交，等待审核"  // 提现已成功到账、审核未通过，提现失败，自动返回可提现余额
////            self.withdrawalStatusView.secondLabel.text = "审核中"  // 审核中、提现成功、提现失败
////            self.withdrawalStatusView.secondLabel.textColor = UIColor.init(hex: 0x007FFF)   // 0x007FFF、0x333333、E68E40
////            self.withdrawalStatusView.secondLabel.backgroundColor = UIColor.init(hex: 0xF2F8FF) // 0xF2F8FF、0xF5F5F5、0xFFFBF7
//        case .success:
//            // 提现成功
//            self.promptIconView.image = UIImage.init(named: "IMG_common_acc_icon")    // IMG_common_acc_icon/IMG_wallet_tixian_fail
//            self.promptTitleLabel.text = "提币成功" // 提交成功、提现成功、提现失败、
//            self.promptInfoLabel.text = "提币\(model.currency.uppercased())已成功到账"  // 提现已成功到账、审核未通过，提现失败，自动返回可提现余额
////            self.withdrawalStatusView.secondLabel.text = "提币成功"  // 审核中、提现成功、提现失败
////            self.withdrawalStatusView.secondLabel.textColor = AppColor.mainText   // 0x007FFF、0x333333、E68E40
////            self.withdrawalStatusView.secondLabel.backgroundColor = AppColor.pageBg // 0xF2F8FF、0xF5F5F5、0xFFFBF7
//        case .fail:
//            // 提现失败
//            self.promptIconView.image = UIImage.init(named: "IMG_wallet_tixian_fail")    // IMG_common_acc_icon
//            self.promptTitleLabel.text = "提币失败" // 提交成功、提现成功、提现失败、
//            self.promptInfoLabel.text = "提币失败，FIL自动返回可提现余额"  // 提现已成功到账、审核未通过，提现失败，自动返回可提现余额
////            self.withdrawalStatusView.secondLabel.text = "提币失败"  // 审核中、提现成功、提现失败
////            self.withdrawalStatusView.secondLabel.textColor = UIColor.init(hex: 0xE68E40)   // 0x007FFF、0x333333、0xE68E40
////            self.withdrawalStatusView.secondLabel.backgroundColor = UIColor.init(hex: 0xFFFBF7) // 0xF2F8FF、0xF5F5F5、0xFFFBF7
//        }
    }

}

// MARK: - Event(事件响应)
extension PreReturnResultController {
    
    @objc fileprivate func navLeftItemClick() -> Void {
//        // 1. 优先处理通过present方式弹出的
//        if let _ = self.navigationController?.presentingViewController {
//            self.navigationController?.dismiss(animated: false, completion: nil)
//            return
//        }
//        guard let childVCList = self.navigationController?.children else {
//            return
//        }
//        // 2.2 判断指定界面push过来的
//        for (_, childVC) in childVCList.reversed().enumerated() {
//            // 集合：[MineHomeController/AssetDetailController
//            if let childVC = childVC as? WalletDetailHomeController {
//                self.navigationController?.popToViewController(childVC, animated: true)
//                return
//            }
//            if let childVC = childVC as? WalletHomeController {
//                self.navigationController?.popToViewController(childVC, animated: true)
//                return
//            }
//            if let childVC = childVC as? AssetHomeController {
//                self.navigationController?.popToViewController(childVC, animated: true)
//                return
//            }
//        }
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
