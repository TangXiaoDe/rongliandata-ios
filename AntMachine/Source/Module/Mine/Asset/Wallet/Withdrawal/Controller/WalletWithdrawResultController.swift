//
//  WalletWithdrawResultController.swift
//  HuoTuiVideo
//
//  Created by 小唐 on 2020/6/11.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  ERC FIL提现结果页、提现详情页

typealias ERCWithdrawResultController = WalletWithdrawResultController
typealias FILWithdrawResultController = WalletWithdrawResultController
import UIKit

class WalletWithdrawResultController: BaseViewController
{
    // MARK: - Internal Property
    
    var model: WalletWithdrawResultModel?
    
    // MARK: - Private Property
    
    fileprivate let topPromptView: UIView = UIView()
    fileprivate let promptIconView: UIImageView = UIImageView.init()
    fileprivate let promptTitleLabel: UILabel = UILabel.init()
    fileprivate let promptInfoLabel: UILabel = UILabel.init()
    
    fileprivate let withdrawalInfoView: UIView = UIView()
    fileprivate let withdrawalAmountView: DoubleTitleControl = DoubleTitleControl.init()    // 提现数量
    fileprivate let withdrawalFeeView: DoubleTitleControl = DoubleTitleControl.init()       // 手续费
    fileprivate let withdrawalStatusView: DoubleTitleControl = DoubleTitleControl.init()    // 提现状态(审核中、提现成功、提现失败)
    fileprivate let withdrawalDateView: DoubleTitleControl = DoubleTitleControl.init()      // 申请时间
    
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let promptIconTopMargin: CGFloat = 50
    fileprivate let promptIconSize: CGSize = CGSize.init(width: 97, height: 58)
    fileprivate let promptTitleTopMargin: CGFloat = 40
    fileprivate let promptInfoTopMargin: CGFloat = 10
    fileprivate let topPromptViewHeight: CGFloat = 254
    
    fileprivate let withdrawalInfoSingleH: CGFloat = 55
    
    
    // MARK: - Initialize Function
    
    init(result: WalletWithdrawResultModel? = nil) {
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
extension WalletWithdrawResultController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }
    
}

// MARK: - UI
extension WalletWithdrawResultController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.minor
        // navbar
        self.navigationItem.title = "提现"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "IMG_navbar_back"), style: .plain, target: self, action: #selector(navLeftItemClick))
        // topPromptView
        self.view.addSubview(self.topPromptView)
        self.initialTopPromptView(self.topPromptView)
        self.topPromptView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.topPromptViewHeight)
        }
        // withdrawalInfoView
        self.view.addSubview(self.withdrawalInfoView)
        self.initialWithdrawalInfoView(self.withdrawalInfoView)
        self.withdrawalInfoView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.topPromptView.snp.bottom)
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
        self.promptInfoLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 16), textColor: AppColor.mainText, alignment: .center)
        self.promptInfoLabel.numberOfLines = 2
        self.promptInfoLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.promptTitleLabel.snp.bottom).offset(self.promptInfoTopMargin)
        }
    }
    /// withdrawalInfoView布局
    fileprivate func initialWithdrawalInfoView(_ infoView: UIView) -> Void {
        // 1. withdrawalAmount
        infoView.addSubview(self.withdrawalAmountView)
        self.withdrawalAmountView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.withdrawalInfoSingleH)
        }
        self.withdrawalAmountView.firstLabel.set(text: "申请提现个数", font: UIFont.pingFangSCFont(size: 14), textColor: UIColor.init(hex: 0x8C97AC), alignment: .left)
        self.withdrawalAmountView.firstLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(self.lrMargin)
        }
        self.withdrawalAmountView.secondLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14), textColor: UIColor.init(hex: 0x333333), alignment: .right)
        self.withdrawalAmountView.secondLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.lrMargin)
        }
        self.withdrawalAmountView.addLineWithSide(.inTop, color: AppColor.dividing, thickness: 0.5, margin1: self.lrMargin, margin2: self.lrMargin)
        self.withdrawalAmountView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: self.lrMargin, margin2: self.lrMargin)
        // 2. withdrawalFeeView
        infoView.addSubview(self.withdrawalFeeView)
        self.withdrawalFeeView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.withdrawalAmountView.snp.bottom)
            make.height.equalTo(self.withdrawalInfoSingleH)
        }
        self.withdrawalFeeView.firstLabel.set(text: "手续费", font: UIFont.pingFangSCFont(size: 14), textColor: UIColor.init(hex: 0x8C97AC), alignment: .left)
        self.withdrawalFeeView.firstLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(self.lrMargin)
        }
        self.withdrawalFeeView.secondLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14), textColor: UIColor.init(hex: 0x333333), alignment: .right)
        self.withdrawalFeeView.secondLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.lrMargin)
        }
        self.withdrawalFeeView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: self.lrMargin, margin2: self.lrMargin)
        // 3. withdrawalStatusView
        infoView.addSubview(self.withdrawalStatusView)
        self.withdrawalStatusView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.withdrawalFeeView.snp.bottom)
            make.height.equalTo(self.withdrawalInfoSingleH)
        }
        self.withdrawalStatusView.firstLabel.set(text: "提现状态", font: UIFont.pingFangSCFont(size: 14), textColor: UIColor.init(hex: 0x8C97AC), alignment: .left)
        self.withdrawalStatusView.firstLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(self.lrMargin)
        }
        self.withdrawalStatusView.secondLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14), textColor: UIColor.init(hex: 0x333333), alignment: .center)
        self.withdrawalStatusView.secondLabel.backgroundColor = UIColor.init(hex: 0xF2F8FF)
        self.withdrawalStatusView.secondLabel.set(cornerRadius: 2)
        self.withdrawalStatusView.secondLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.size.equalTo(CGSize.init(width: 64, height: 25))
        }
        self.withdrawalStatusView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: self.lrMargin, margin2: self.lrMargin)
        // 3. withdrawalDate
        infoView.addSubview(self.withdrawalDateView)
        self.withdrawalDateView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.withdrawalStatusView.snp.bottom)
            make.height.equalTo(self.withdrawalInfoSingleH)
            make.bottom.equalToSuperview()
        }
        self.withdrawalDateView.firstLabel.set(text: "申请时间", font: UIFont.pingFangSCFont(size: 14), textColor: UIColor.init(hex: 0x8C97AC), alignment: .left)
        self.withdrawalDateView.firstLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(self.lrMargin)
        }
        self.withdrawalDateView.secondLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14), textColor: UIColor.init(hex: 0x333333), alignment: .right)
        self.withdrawalDateView.secondLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.lrMargin)
        }
        self.withdrawalDateView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: self.lrMargin, margin2: self.lrMargin)
    }

}

// MARK: - Data(数据处理与加载)
extension WalletWithdrawResultController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
//        self.setupAsDemo()
        if let model = self.model {
            self.setupData(with: model)
        }
    }
    
    fileprivate func setupAsDemo() -> Void {
        //
        self.withdrawalAmountView.secondLabel.text = "100FIL"
        self.withdrawalFeeView.secondLabel.text = "1FIL"
        self.promptIconView.image = UIImage.init(named: "IMG_wallet_tixian_succese")    // IMG_wallet_tixian_succese/IMG_wallet_tixian_fail
        self.promptTitleLabel.text = "提交成功" // 提交成功、提现成功、提现失败、
        self.promptInfoLabel.text = "提现申请已提交，等待审核"  // 提现FIL已成功到账、审核未通过，提现失败，FIL自动返回可提现余额
        self.withdrawalStatusView.secondLabel.text = "审核中"  // 审核中、提现成功、提现失败
        self.withdrawalStatusView.secondLabel.textColor = UIColor.init(hex: 0x007FFF)   // 0x007FFF、0x333333、E68E40
        self.withdrawalStatusView.secondLabel.backgroundColor = UIColor.init(hex: 0xF2F8FF) // 0xF2F8FF、0xF5F5F5、0xFFFBF7
        self.withdrawalDateView.secondLabel.text = Date().string(format: "yyyy-MM-dd HH:mm:ss", timeZone: .current)
    }
    fileprivate func setupData(with model: WalletWithdrawResultModel) -> Void {
        self.withdrawalAmountView.secondLabel.text = model.amount.decimalProcess(digits: 4) + model.currency.uppercased()
        self.withdrawalFeeView.secondLabel.text = model.fee.decimalProcess(digits: 4) + model.currency.uppercased()
        self.withdrawalDateView.secondLabel.text = model.createdDate.string(format: "yyyy-MM-dd HH:mm:ss", timeZone: .current)
        switch model.status {
        case .applying:
            // 审核中
            self.promptIconView.image = UIImage.init(named: "IMG_wallet_tixian_succese")    // IMG_wallet_tixian_fail
            self.promptTitleLabel.text = "提交成功" // 提交成功、提现成功、提现失败、
            self.promptInfoLabel.text = "提现申请已提交，等待审核"  // 提现已成功到账、审核未通过，提现失败，自动返回可提现余额
            self.withdrawalStatusView.secondLabel.text = "审核中"  // 审核中、提现成功、提现失败
            self.withdrawalStatusView.secondLabel.textColor = UIColor.init(hex: 0x007FFF)   // 0x007FFF、0x333333、E68E40
            self.withdrawalStatusView.secondLabel.backgroundColor = UIColor.init(hex: 0xF2F8FF) // 0xF2F8FF、0xF5F5F5、0xFFFBF7
        case .success:
            // 提现成功
            self.promptIconView.image = UIImage.init(named: "IMG_wallet_tixian_succese")    // IMG_wallet_tixian_succese/IMG_wallet_tixian_fail
            self.promptTitleLabel.text = "提现成功" // 提交成功、提现成功、提现失败、
            self.promptInfoLabel.text = "提现\(model.currency.uppercased())已成功到账"  // 提现已成功到账、审核未通过，提现失败，自动返回可提现余额
            self.withdrawalStatusView.secondLabel.text = "提现成功"  // 审核中、提现成功、提现失败
            self.withdrawalStatusView.secondLabel.textColor = UIColor.init(hex: 0x333333)   // 0x007FFF、0x333333、E68E40
            self.withdrawalStatusView.secondLabel.backgroundColor = UIColor.init(hex: 0xF5F5F5) // 0xF2F8FF、0xF5F5F5、0xFFFBF7
        case .fail:
            // 提现失败
            self.promptIconView.image = UIImage.init(named: "IMG_wallet_tixian_fail")    // IMG_wallet_tixian_succese
            self.promptTitleLabel.text = "提现失败" // 提交成功、提现成功、提现失败、
            self.promptInfoLabel.text = "提现失败，FIL自动返回可提现余额"  // 提现已成功到账、审核未通过，提现失败，自动返回可提现余额
            self.withdrawalStatusView.secondLabel.text = "提现失败"  // 审核中、提现成功、提现失败
            self.withdrawalStatusView.secondLabel.textColor = UIColor.init(hex: 0xE68E40)   // 0x007FFF、0x333333、0xE68E40
            self.withdrawalStatusView.secondLabel.backgroundColor = UIColor.init(hex: 0xFFFBF7) // 0xF2F8FF、0xF5F5F5、0xFFFBF7
        }
    }

}

// MARK: - Event(事件响应)
extension WalletWithdrawResultController {
    @objc fileprivate func navLeftItemClick() -> Void {
        // 1. 优先处理通过present方式弹出的
        if let _ = self.navigationController?.presentingViewController {
            self.navigationController?.dismiss(animated: false, completion: nil)
            return
        }
        guard let childVCList = self.navigationController?.children else {
            return
        }
        // 2.2 判断指定界面push过来的
        for (_, childVC) in childVCList.reversed().enumerated() {
            // 集合：[MineHomeController/AssetDetailController
            if let childVC = childVC as? WalletDetailHomeController {
                self.navigationController?.popToViewController(childVC, animated: true)
                return
            }
            if let childVC = childVC as? WalletHomeController {
                self.navigationController?.popToViewController(childVC, animated: true)
                return
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }

}

// MARK: - Enter Page
extension WalletWithdrawResultController {
    
}

// MARK: - Notification
extension WalletWithdrawResultController {
    
}

// MARK: - Extension Function
extension WalletWithdrawResultController {
    
}

// MARK: - Delegate Function

// MARK: - <>
extension WalletWithdrawResultController {
    
}

