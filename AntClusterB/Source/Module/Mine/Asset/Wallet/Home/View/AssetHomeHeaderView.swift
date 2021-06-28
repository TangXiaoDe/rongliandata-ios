//
//  AssetHomeHeaderView.swift
//  LianYouPin
//
//  Created by zhaowei on 2020/1/8.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  我的收益顶部view

import Foundation
import UIKit

protocol AssetHomeHeaderViewProtocol: class {
    /// 切换资产类型
    func assetHeaderView(_ headerView: AssetHomeHeaderView, didClickedChangeType btn: UIButton) -> Void
}

class AssetHomeHeaderView: UIControl {

    // MARK: - Internal Property
    static let viewHeight: CGFloat = 130 + 42 + 12

    weak var delegate: AssetHomeHeaderViewProtocol?

    var model: AssetInfoModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    // 昨日收益
    var incomeModel: FPYesterdayIncomeModel? {
        didSet {
            self.setupWithIncomeModel(incomeModel)
        }
    }
    // 货币单价
    var priceModel: FPIncreaseModel? {
        didSet {
            self.setupWithPriceModel(priceModel)
        }
    }

    fileprivate let mainView: UIView = UIView()
    fileprivate let topView: UIView = UIView()
    fileprivate let currencyTypeLabel: UILabel = UILabel()
    fileprivate let changeTypeBtn: UIButton = UIButton.init(type: .custom)
    /// 资产余额
    fileprivate let balanceItemView = TopTitleBottomTitleControl()
    /// 昨日收益
    fileprivate let incomeItemView = TopTitleBottomTitleControl()
    fileprivate let cnyValueLabel: UILabel = UILabel()

    fileprivate let bottomView: UIView = UIView()
    fileprivate let bottomTitleLabel: UILabel = UILabel()

    fileprivate let lrMargin: CGFloat = 13
    fileprivate let currencyCenterYMargin: CGFloat = 30 // to superview
    fileprivate let topViewHeight: CGFloat = 130
    fileprivate let bottomViewHeight: CGFloat = 42
    fileprivate let dividingViewHeight: CGFloat = 12

    // MARK: - Private Property

    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
        self.initialUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension AssetHomeHeaderView {

}

// MARK: - LifeCircle Function
extension AssetHomeHeaderView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension AssetHomeHeaderView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = AppColor.pageBg
        // 1. topView
        mainView.addSubview(self.topView)
        self.initialTopView(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(self.topViewHeight)
            make.bottom.equalToSuperview().offset(-10)
        }
//        // 2. bottomView
//        mainView.addSubview(self.bottomView)
//        self.initialBottomView(self.bottomView)
//        self.bottomView.snp.makeConstraints { (make) in
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(self.topView.snp.bottom).offset(dividingViewHeight)
//            make.bottom.equalToSuperview()
//            make.height.equalTo(self.bottomViewHeight)
//        }
    }
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        topView.backgroundColor = UIColor.white
        // currencyTypeLabel
        topView.addSubview(self.currencyTypeLabel)
        self.currencyTypeLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 28, weight: .medium), textColor: AppColor.theme)
        self.currencyTypeLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.centerY.equalTo(topView.snp.top).offset(currencyCenterYMargin)
            make.height.equalTo(20)
        }
        // changeTypeBtn
        topView.addSubview(self.changeTypeBtn)
        self.changeTypeBtn.isHidden = true
        self.changeTypeBtn.addTarget(self, action: #selector(changeTypeBtnClick(_:)), for: .touchUpInside)
        self.changeTypeBtn.setImage(UIImage.init(named: "IMG_zc_select"), for: .normal)
        self.changeTypeBtn.contentMode = .center
        self.changeTypeBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.bottom.equalTo(self.currencyTypeLabel.snp.bottom).offset(14)
            make.left.equalTo(self.currencyTypeLabel.snp.right).offset(-4)
        }
        // balanceItemView
        topView.addSubview(self.balanceItemView)
        self.balanceItemView.topLabel.set(text: "资产余额", font: UIFont.pingFangSCFont(size: 12, weight: .regular), textColor: AppColor.grayText, alignment: .left)
        self.balanceItemView.bottomLabel.set(text: "0.00", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.mainText, alignment: .left)
        self.balanceItemView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.top.equalTo(topView.snp.centerY).offset(-4)
        }
        self.balanceItemView.bottomLabel.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(self.balanceItemView.topLabel.snp.centerY).offset(21)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        topView.addSubview(self.cnyValueLabel)
        self.cnyValueLabel.isHidden = true
        self.cnyValueLabel.set(text: "≈0.0 CNY", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: AppColor.grayText, alignment: .left)
        self.cnyValueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.balanceItemView.snp.left)
            make.centerY.equalTo(self.balanceItemView.bottomLabel.snp.centerY).offset(18)
        }
        // incomeItemView
        topView.addSubview(self.incomeItemView)
        self.incomeItemView.isHidden = true
        self.incomeItemView.topLabel.set(text: "昨日收益", font: UIFont.pingFangSCFont(size: 12, weight: .regular), textColor: AppColor.grayText, alignment: .left)
        self.incomeItemView.bottomLabel.set(text: "0.00", font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: AppColor.themeYellow, alignment: .right)
        self.incomeItemView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.top.equalTo(self.balanceItemView)
        }
        self.incomeItemView.bottomLabel.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(self.balanceItemView.topLabel.snp.centerY).offset(21)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    fileprivate func initialBottomView(_ bottomView: UIView) -> Void {
        bottomView.backgroundColor = UIColor.white
        // bottomTitle
        bottomView.addSubview(self.bottomTitleLabel)
        self.bottomTitleLabel.set(text: "账单明细", font: UIFont.pingFangSCFont(size: 14), textColor: UIColor.init(hex: 0x313B49))
        self.bottomTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.centerY.equalToSuperview()
        }
    }
}
// MARK: - Private UI Xib加载后处理
extension AssetHomeHeaderView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension AssetHomeHeaderView {
    /// 数据加载
    fileprivate func setupWithModel(_ model: AssetInfoModel?) -> Void {
        guard let model = model else {
            return
        }
        self.currencyTypeLabel.text = model.currency.title
        self.balanceItemView.bottomLabel.text = model.realBalance.decimalValidDigitsProcess(digits: 8)
        if model.currency == .usdt || model.currency == .cny {
            self.incomeItemView.isHidden = true
        } else {
            self.incomeItemView.isHidden = false
        }
        if model.currency == .cny {
            self.cnyValueLabel.isHidden = true
        } else {
            self.cnyValueLabel.isHidden = false
        }
    }

    fileprivate func setupWithIncomeModel(_ priceModel: FPYesterdayIncomeModel?) {
        guard let model = self.model else {
            return
        }
        guard let incomeModel = incomeModel else {
            return
        }
        var incomeStr: String = ""
        switch model.currency {
//        case .btc:
//            incomeStr = incomeModel.btc
//        case .eth:
//            incomeStr = incomeModel.eth
        case .fil:
            incomeStr = incomeModel.fil
        case .chia:
            incomeStr = incomeModel.chia
        case .bzz:
            incomeStr = incomeModel.bzz
        default:
            break
        }
        self.incomeItemView.bottomLabel.text = incomeStr.decimalProcess(digits: 8)
    }
    fileprivate func setupWithPriceModel(_ priceModel: FPIncreaseModel?) {
        guard let model = self.model else {
            return
        }
        guard let priceModel = priceModel else {
            return
        }
        var cnyPriceStr: String = ""
        switch model.currency {
//        case .btc:
//            cnyPriceStr = priceModel.btc?.price.decimalValidDigitsProcess(digits: 2) ?? ""
//        case .eth:
//            cnyPriceStr = priceModel.eth?.price.decimalValidDigitsProcess(digits: 2) ?? ""
        case .fil:
            cnyPriceStr = priceModel.ipfs?.price.decimalValidDigitsProcess(digits: 2) ?? ""
        case .usdt:
            cnyPriceStr = priceModel.usdt?.price.decimalValidDigitsProcess(digits: 2) ?? ""
        case .chia:
            cnyPriceStr = priceModel.chia?.price.decimalValidDigitsProcess(digits: 2) ?? ""
        case .bzz:
            cnyPriceStr = priceModel.bzz?.price.decimalValidDigitsProcess(digits: 2) ?? ""
        default:
            break
        }
        if let cnyPriceValue = Double(cnyPriceStr) {
            let currencyNum: NSDecimalNumber = NSDecimalNumber.init(value: model.realBalance)
            let ratioNum: NSDecimalNumber = NSDecimalNumber.init(value: cnyPriceValue)
            let resultNum: NSDecimalNumber = currencyNum.multiplying(by: ratioNum)
            let decimalValue = resultNum.doubleValue.decimalValidDigitsProcess(digits: 2)
            self.cnyValueLabel.text = "≈\(decimalValue) CNY"
        }
    }
}

// MARK: - Event Function
extension AssetHomeHeaderView {
    /// 切换响应
    @objc fileprivate func changeTypeBtnClick(_ btn: UIButton) {
        self.delegate?.assetHeaderView(self, didClickedChangeType: btn)
    }
}


// MARK: - Extension Function
