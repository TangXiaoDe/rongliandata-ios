//
//  PreReturnInputMainView.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/8/5.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  提前归还输入主界面

import UIKit
import ChainOneKit

protocol PreReturnInputMainViewProtocol: class {
    
    ///
    func didUpdateDoneBtnEnable(with inputMainView: PreReturnInputMainView) -> Void
    
}

///
class PreReturnInputMainView: UIView {
    
    // MARK: - Internal Property

    var model: EquipmentDetailModel?
    
    var type: PreReturnType = .all {
        didSet {
            self.setupWithType(type)
        }
    }
    // Fil总资产
    var totalFil: Double = 0 {
        didSet {
            self.totalAmountLabel.text = "可用FIL " + totalFil.decimalValidDigitsProcess(digits: 8)
            self.setupWithType(self.type)
        }
    }

    fileprivate var waitReturnAmount: Double = 0

    var inputValue: Double? {
        guard let strInput = self.textField.text, let inputValue = Double(strInput) else {
            return nil
        }
        return inputValue
    }
    
    // 利息比例(利息计算公式：本金 * 利率 / 30 * 本月开始与当前时间天数差值 )
    fileprivate var interestRatio: Double {
        return self.model?.interestRatio ?? 0
    }
//    ///
//    fileprivate var intereset: Double {
//        guard let model = self.model, let asset = model.assets else {
//            return 0
//        }
//        var value: Double = 0
//        switch self.type {
//        case .interest:
//            value = 0
//        case .all:
//            value = (asset.wait_gas + asset.wait_pledge) * self.interestRatio
//        case .gas, .mortgage:
//            if let inputValue = self.inputValue, inputValue <= self.waitReturnAmount, inputValue > 0 {
//                value = inputValue * self.interestRatio
//            }
//        }
//        return value
//    }
    
    var totalReturnAmount: Double {
        var returnAmount: Double = 0
        switch self.type {
        case .all:
            returnAmount = self.waitReturnAmount
        case .gas, .mortgage, .interest:
            if let inputValue = self.inputValue, inputValue <= self.waitReturnAmount, inputValue > 0 {
                returnAmount = inputValue
            }
        }
//        return returnAmount + self.intereset
        return returnAmount
    }
    
    var couldDone: Bool {
        var flag: Bool = true
        guard let strInput = self.textField.text, let inputValue = Double(strInput) else {
            return false
        }
        flag = inputValue > 0 && inputValue <= self.totalFil && inputValue <= self.waitReturnAmount && self.totalReturnAmount <= self.totalFil
        return flag
    }

    
    /// 回调处理
    weak var delegate: PreReturnInputMainViewProtocol?
    
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    
    fileprivate let topView: UIView = UIView.init()
    fileprivate let waitReturnView: TitleValueView = TitleValueView.init()  // 待归还
    
    fileprivate let centerView: UIView = UIView.init()
    fileprivate let centerTitleLabel: UILabel = UILabel.init()
    fileprivate let returnAllBtn: UIButton = UIButton.init(type: .custom)   // 还全部
    fileprivate let inputContainer: UIView = UIView.init()
    let textField: UITextField = UITextField.init()
    fileprivate let totalAmountLabel: UILabel = UILabel.init()              // 可用FIL
    fileprivate let tipsLabel: UILabel = UILabel.init()                     // 提示标签，颜色变动
    
//    fileprivate let bottomView: UIView = UIView.init()
//    fileprivate let bottomTitleLabel: UILabel = UILabel.init()
//    fileprivate let itemContainer: UIView = UIView.init()                   //
//    fileprivate let totalWaitItemView: TitleValueView = TitleValueView.init()   // 全部待归还
//    fileprivate let interestWaitItemView: TitleValueView = TitleValueView.init()   // 累计利息
//    fileprivate let interestItemView: TitleValueView = TitleValueView.init()   // 利息数量
//    fileprivate let gasItemView: TitleValueView = TitleValueView.init()   // GAS
//    fileprivate let pledgeItemView: TitleValueView = TitleValueView.init()   // 质押
//    fileprivate let totalNumView: TitleContainer = TitleContainer.init()    // 总计
    
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let topViewHeight: CGFloat = 56
    
    fileprivate let centerTitleCenterYTopMargin: CGFloat = 20.0 + 8.0
    fileprivate let inputContainerTopMargin: CGFloat = 50
    fileprivate let inputContainerHeight: CGFloat = 56
    fileprivate let inputContainerBottomMargin: CGFloat = 64

//    fileprivate let bottomTitleHeight: CGFloat = 45
//    fileprivate let itemViewHeight: CGFloat = 14
//    fileprivate let itemViewVerMargin: CGFloat = 10
//    fileprivate let itemViewTopMargin: CGFloat = 0
//    fileprivate let itemViewBottomMargin: CGFloat = 15
//
//    fileprivate let totalNumHeight: CGFloat = 44

    
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
extension PreReturnInputMainView {

    class func loadXib() -> PreReturnInputMainView? {
        return Bundle.main.loadNibNamed("PreReturnInputMainView", owner: nil, options: nil)?.first as? PreReturnInputMainView
    }

}

// MARK: - LifeCircle/Override Function
extension PreReturnInputMainView {

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
extension PreReturnInputMainView {
    
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
        // 1. topView
        mainView.addSubview(self.topView)
        self.initialTopView(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.topViewHeight)
//            make.bottom.equalToSuperview()
        }
        // 2. centerView
        mainView.addSubview(self.centerView)
        self.initialCenterView(self.centerView)
        self.centerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom)
            make.bottom.equalToSuperview()
        }
//        // 3. bottomView
//        mainView.addSubview(self.bottomView)
//        self.initialBottomView(self.bottomView)
//        self.bottomView.snp.makeConstraints { (make) in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.top.equalTo(self.centerView.snp.bottom)
//        }
    }
    
    ///
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        topView.backgroundColor = UIColor.white
        topView.set(cornerRadius: 10)
        //
        topView.addSubview(self.waitReturnView)
        self.waitReturnView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.waitReturnView.titleLabel.set(text: "待归还数量(FIL)", font: UIFont.pingFangSCFont(size: 15), textColor: AppColor.detailText)
        self.waitReturnView.titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.centerY.equalToSuperview()
        }
        self.waitReturnView.valueLabel.set(text: "0", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.mainText, alignment: .right)
        self.waitReturnView.valueLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            
        }
        // dashLine
        let dashLine: XDDashLineView = XDDashLineView.init(lineColor: AppColor.dividing, lengths: [3.0, 3.0])
        topView.addSubview(dashLine)
        dashLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.height.equalTo(0.5)
        }
    }
    
    ///
    fileprivate func initialCenterView(_ centerView: UIView) -> Void {
        centerView.backgroundColor = UIColor.white
        centerView.set(cornerRadius: 10)
        // 1. title
        centerView.addSubview(self.centerTitleLabel)
        self.centerTitleLabel.set(text: "归还数量", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.mainText)
        self.centerTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.centerY.equalTo(centerView.snp.top).offset(self.centerTitleCenterYTopMargin)
        }
        // 2. returnAll
        centerView.addSubview(self.returnAllBtn)
        self.returnAllBtn.set(title: "还全部", titleColor: UIColor.init(hex: 0x52B5F9), for: .normal)
        self.returnAllBtn.set(title: "还全部", titleColor: UIColor.init(hex: 0x52B5F9), for: .highlighted)
        self.returnAllBtn.set(title: "还全部", titleColor: UIColor.init(hex: 0xCCCCCC), for: .disabled)
        self.returnAllBtn.set(font: UIFont.systemFont(ofSize: 12))
        self.returnAllBtn.addTarget(self, action: #selector(returnAllBtnClick(_:)), for: .touchUpInside)
        self.returnAllBtn.contentHorizontalAlignment = .right
        self.returnAllBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.centerY.equalTo(self.centerTitleLabel.snp.centerY)
        }
        // 3. input
        centerView.addSubview(self.inputContainer)
        self.inputContainer.backgroundColor = AppColor.pageBg
        self.inputContainer.set(cornerRadius: 5)
        self.inputContainer.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(centerView.snp.top).offset(self.inputContainerTopMargin)
            make.height.equalTo(self.inputContainerHeight)
            make.bottom.equalToSuperview().offset(-self.inputContainerBottomMargin)
        }
        self.inputContainer.addSubview(self.textField)
        self.textField.set(placeHolder: nil, font: UIFont.pingFangSCFont(size: 24, weight: .medium), textColor: AppColor.mainText)
        self.textField.setPlaceHolder("请输入归还数量", font: UIFont.pingFangSCFont(size: 20, weight: .medium), color: UIColor.init(hex: 0xCCCCCC))
        self.textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        self.textField.clearButtonMode = .whileEditing
        self.textField.keyboardType = .decimalPad
        //self.textField.delegate = self
        self.textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.height.equalTo(35)
        }
        // 4. totalAmount
        centerView.addSubview(self.totalAmountLabel)
        self.totalAmountLabel.set(text: "可用FIL 0", font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.detailText)
        self.totalAmountLabel.snp.remakeConstraints { (make) in
            make.centerY.equalTo(self.inputContainer.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.lessThanOrEqualToSuperview().offset(-self.lrMargin)
        }
        // 5. tips
        centerView.addSubview(self.tipsLabel)
        self.tipsLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.detailText)
        //self.tipsLabel.isHidden = true  // 默认隐藏
        self.tipsLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self.totalAmountLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.lessThanOrEqualToSuperview()
        }
//        // 6. dashLine
//        let dashLine: XDDashLineView = XDDashLineView.init(lineColor: AppColor.dividing, lengths: [3.0, 3.0])
//        centerView.addSubview(dashLine)
//        dashLine.snp.makeConstraints { (make) in
//            make.bottom.equalToSuperview()
//            make.leading.equalToSuperview().offset(self.lrMargin)
//            make.trailing.equalToSuperview().offset(-self.lrMargin)
//            make.height.equalTo(0.5)
//        }
    }

//    ///
//    fileprivate func initialBottomView(_ bottomView: UIView) -> Void {
//        bottomView.backgroundColor = UIColor.white
//        bottomView.set(cornerRadius: 10)
//        // 1. title
//        bottomView.addSubview(self.bottomTitleLabel)
//        self.bottomTitleLabel.set(text: "当前类型归还明细", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.mainText)
//        self.bottomTitleLabel.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview().offset(self.lrMargin)
//            make.trailing.lessThanOrEqualToSuperview()
//            make.top.equalToSuperview()
//            make.height.equalTo(self.bottomTitleHeight)
//        }
//        // 2. contaienr
//        bottomView.addSubview(self.itemContainer)
//        self.initialItemContainer(self.itemContainer)
//        self.itemContainer.snp.makeConstraints { (make) in
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(self.bottomTitleLabel.snp.bottom)
//        }
//        // 3. dashLine
//        let dashLine: XDDashLineView = XDDashLineView.init(lineColor: AppColor.dividing, lengths: [3.0, 3.0])
//        bottomView.addSubview(dashLine)
//        dashLine.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview().offset(self.lrMargin)
//            make.trailing.equalToSuperview().offset(-self.lrMargin)
//            make.height.equalTo(0.5)
//            make.top.equalTo(self.itemContainer.snp.bottom)
//        }
//        // 4. totalNum
//        bottomView.addSubview(self.totalNumView)
//        self.totalNumView.snp.makeConstraints { (make) in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.top.equalTo(dashLine.snp.bottom)
//            make.height.equalTo(self.totalNumHeight)
//        }
//        self.totalNumView.label.set(text: "总计: 0FIL", font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: AppColor.mainText, alignment: .right)
//        self.totalNumView.label.snp.remakeConstraints { (make) in
//            make.trailing.equalToSuperview().offset(-self.lrMargin)
//            make.centerY.equalToSuperview()
//            make.leading.greaterThanOrEqualToSuperview()
//        }
//    }
//    ///
//    fileprivate func initialItemContainer(_ containerView: UIView) -> Void {
//        containerView.removeAllSubviews()
//        //
//        let itemViews: [TitleValueView] = [self.totalWaitItemView, self.interestWaitItemView, self.interestItemView, self.gasItemView, self.pledgeItemView]
//        let itemTitles: [String] = ["全部待归还数量", "本次归还累计欠款利息数量", "利息数量", "本次归还GAS消耗数量", "本次归还质押数量"]
//        var topView: UIView = containerView
//        for (index, itemView) in itemViews.enumerated() {
//            containerView.addSubview(itemView)
//            self.initialItemView(itemView, with: itemTitles[index])
//            itemView.snp.makeConstraints { (make) in
//                make.leading.trailing.equalToSuperview()
//                make.height.equalTo(self.itemViewHeight)
//                if 0 == index {
//                    make.top.equalToSuperview().offset(self.itemViewTopMargin)
//                } else {
//                    make.top.equalTo(topView.snp.bottom).offset(self.itemViewVerMargin)
//                }
//                if index == itemViews.count - 1 {
//                    make.bottom.equalToSuperview().offset(-self.itemViewBottomMargin)
//                }
//            }
//            topView = itemView
//            //
//        }
//    }
//    ///
//    fileprivate func initialItemView(_ itemView: TitleValueView, with title: String) -> Void {
//        //
//        itemView.titleLabel.set(text: title, font: UIFont.pingFangSCFont(size: 13), textColor: AppColor.grayText)
//        itemView.titleLabel.snp.remakeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.leading.equalToSuperview().offset(self.lrMargin)
//        }
//        //
//        itemView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: AppColor.grayText, alignment: .right)
//        itemView.valueLabel.snp.remakeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.trailing.equalToSuperview().offset(-self.lrMargin)
//        }
//    }

    
}
extension PreReturnInputMainView {
    
//    ///
//    fileprivate func setupItemContainer(with itemViews: [UIView]) -> Void {
//        self.itemContainer.removeAllSubviews()
//        //
//        var topView: UIView = self.itemContainer
//        for (index, itemView) in itemViews.enumerated() {
//            self.itemContainer.addSubview(itemView)
//            itemView.snp.makeConstraints { (make) in
//                make.leading.trailing.equalToSuperview()
//                make.height.equalTo(self.itemViewHeight)
//                if 0 == index {
//                    make.top.equalToSuperview().offset(self.itemViewTopMargin)
//                } else {
//                    make.top.equalTo(topView.snp.bottom).offset(self.itemViewVerMargin)
//                }
//                if index == itemViews.count - 1 {
//                    make.bottom.equalToSuperview().offset(-self.itemViewBottomMargin)
//                }
//            }
//            topView = itemView
//            //
//        }
//    }
    
}

// MARK: - UI Xib加载后处理
extension PreReturnInputMainView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension PreReturnInputMainView {

    ///
    fileprivate func setupAsDemo() -> Void {

    }
    
    ///
    fileprivate func setupWithType(_ type: PreReturnType?) -> Void {
        guard let type = type else {
            return
        }
        //
        self.returnAllBtn.isEnabled = type != .all
        self.textField.isUserInteractionEnabled = type != .all
        self.waitReturnAmount = self.model?.waitReturnAmount(for: self.type) ?? 0
        self.waitReturnView.valueLabel.text = self.waitReturnAmount.decimalValidDigitsProcess(digits: 8)
        //
//        var itemViews: [UIView] = []
        switch type {
        case .all:
            self.textField.text = self.waitReturnAmount.decimalValidDigitsProcess(digits: 8)
//            itemViews = [self.totalWaitItemView, self.interestItemView]
        case .gas:
            self.textField.text = nil //min(self.waitReturnAmount, self.totalFil).decimalValidDigitsProcess(digits: 8)
//            itemViews = [self.gasItemView, self.interestItemView]
        case .mortgage:
            self.textField.text = nil //min(self.waitReturnAmount, self.totalFil).decimalValidDigitsProcess(digits: 8)
//            itemViews = [self.pledgeItemView, self.interestItemView]
        case .interest:
            self.textField.text = nil //min(self.waitReturnAmount, self.totalFil).decimalValidDigitsProcess(digits: 8)
//            itemViews = [self.interestWaitItemView, UIView.init()]
        }
//        self.setupItemContainer(with: itemViews)
        //[self.totalWaitItemView, self.interestWaitItemView, self.interestItemView, self.gasItemView, self.pledgeItemView]
//        if let model = self.model, let asset = model.assets {
//            self.totalWaitItemView.valueLabel.text = "\(asset.wait_total.decimalValidDigitsProcess(digits: 8))FIL"
//        }
//        if let inputValue = self.inputValue {
//            self.interestWaitItemView.valueLabel.text = "\(inputValue.decimalValidDigitsProcess(digits: 8))FIL"
//            self.gasItemView.valueLabel.text = "\(inputValue.decimalValidDigitsProcess(digits: 8))FIL"
//            self.pledgeItemView.valueLabel.text = "\(inputValue.decimalValidDigitsProcess(digits: 8))FIL"
//        }
//        self.interestItemView.valueLabel.text = "\(self.intereset.decimalValidDigitsProcess(digits: 8))FIL"
//        self.totalNumView.label.text = "\(self.totalReturnAmount.decimalValidDigitsProcess(digits: 8))FIL"
        //
        self.updateTips()
        self.delegate?.didUpdateDoneBtnEnable(with: self)
    }
    
    ///
    fileprivate func updateTips() -> Void {
        // Tips:
        var tipsColor: UIColor = AppColor.grayText
        var tips: String = ""
        switch self.type {
        case .all:
            if self.totalReturnAmount <= self.totalFil {
                tips = "*归还类型为全部还清，不可修改归还数量"
            } else {
                tips = "*全部待归还数量超过可用FIL数"
                tipsColor = UIColor.init(hex: 0xE06236)
            }
        case .gas, .mortgage, .interest:
            if let inputValue = self.inputValue {
                if inputValue > self.waitReturnAmount {
                    tips = "*您当前输入的归还数量已超过待还数量，请重新输入"
                    tipsColor = UIColor.init(hex: 0xE06236)
                } else if inputValue > self.totalFil {
                    tips = "*输入金额超过可用FIL数，请重新输入"
                    tipsColor = UIColor.init(hex: 0xE06236)
                }
            }
//            if tips.isEmpty && self.totalReturnAmount > self.totalFil {
//                tips = "*总计归还金额超过可用FIL数，请重新输入"
//                tipsColor = UIColor.init(hex: 0xE06236)
//            }
        }
        self.waitReturnView.titleLabel.text = self.type.tips + "(FIL)"
        self.tipsLabel.text = tips
        self.tipsLabel.textColor = tipsColor
    }
    
}

// MARK: - Event Function
extension PreReturnInputMainView {
    
    /// 
    @objc func textFieldValueChanged(_ textField: UITextField) {
        if let inputValue = self.inputValue {
//            self.interestWaitItemView.valueLabel.text = "\(inputValue.decimalValidDigitsProcess(digits: 8))FIL"
//            self.gasItemView.valueLabel.text = "\(inputValue.decimalValidDigitsProcess(digits: 8))FIL"
//            self.pledgeItemView.valueLabel.text = "\(inputValue.decimalValidDigitsProcess(digits: 8))FIL"
        }
//        self.interestItemView.valueLabel.text = "\(self.intereset.decimalValidDigitsProcess(digits: 8))FIL"
//        self.totalNumView.label.text = "\(self.totalReturnAmount.decimalValidDigitsProcess(digits: 8))FIL"
        self.updateTips()
        self.delegate?.didUpdateDoneBtnEnable(with: self)
    }
    
    ///
    @objc fileprivate func returnAllBtnClick(_ button: UIButton) -> Void {
        switch self.type {
        case .all:
            break
        case .gas, .mortgage, .interest:
            self.textField.text = self.waitReturnAmount.decimalValidDigitsProcess(digits: 8)
//            self.interestWaitItemView.valueLabel.text = "\(self.waitReturnAmount.decimalValidDigitsProcess(digits: 8))FIL"
//            self.gasItemView.valueLabel.text = "\(self.waitReturnAmount.decimalValidDigitsProcess(digits: 8))FIL"
//            self.pledgeItemView.valueLabel.text = "\(self.waitReturnAmount.decimalValidDigitsProcess(digits: 8))FIL"
//            self.interestItemView.valueLabel.text = "\(self.intereset.decimalValidDigitsProcess(digits: 8))FIL"
//            self.totalNumView.label.text = "\(self.totalReturnAmount.decimalValidDigitsProcess(digits: 8))FIL"
            self.updateTips()
        }
        self.delegate?.didUpdateDoneBtnEnable(with: self)
    }


}

// MARK: - Notification Function
extension PreReturnInputMainView {
    
}

// MARK: - Extension Function
extension PreReturnInputMainView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension PreReturnInputMainView {
    
}

