//
//  WithdrawHeaderView.swift
//  HuoTuiVideo
//
//  Created by 小唐 on 2020/6/10.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  DSTT提现头视图

import UIKit
import YYKit

protocol WithdrawHeaderViewProtocol: class {
    func headerView(_ view: WithdrawHeaderView, _ currentNum: String?)
    /// 二维码点击回调
    func headerView(_ view: WithdrawHeaderView, didClickedQrcode qrcodView: UIView)
    /// 联系客服点击回调
    func headerView(_ view: WithdrawHeaderView, didClickedKefu kefuView: UIView)
}

class WithdrawHeaderView: UIView {
    // MARK: - Internal Property
    var configModel: WithdrawConfigModel?
    var assetInfoModel: AssetInfoModel? {
        didSet {
            self.setupWithAssetInfoModel(assetInfoModel)
        }
    }
    var delegate: WithdrawHeaderViewProtocol?

    // MARK: - Private Property

    fileprivate let mainView: UIView = UIView()
    fileprivate let topView: UIView = UIView()
    fileprivate let bottomView: UIView = UIView()
    // 提现数量相关
    fileprivate let numInputPromptLabel: UILabel = UILabel.init()              // 输入数额提示
    fileprivate let numInputView: UIView = UIView.init()
    fileprivate let numField: UITextField = UITextField.init()
    let numTipsLabel: UILabel = UILabel.init()  // 余额不足

    fileprivate let balanceControl: TopTitleBottomTitleControl = TopTitleBottomTitleControl()
    fileprivate let allExchangeBtn: UIButton = UIButton.init(type: .custom) // 全部提出

    fileprivate let lineView: UIView = UIView()

    fileprivate let feeView: UIView = UIView.init()         // 手续费view
    fileprivate let feePromptLabel: UILabel = UILabel.init()         // 手续费
    fileprivate let feeValueLabel: UILabel = UILabel.init()         // 手续费

    // 上传二维码图片相关
    fileprivate let addressPromptLabel: UILabel = UILabel.init()
    fileprivate let addressLabel: UILabel = UILabel.init()
    //fileprivate let updateTipsLabel: UILabel = UILabel.init()
    fileprivate let updateTipsLabel: YYLabel = YYLabel.init()

    fileprivate let lrMargin: CGFloat = 10
    fileprivate let viewVerMargin: CGFloat = 12
    fileprivate let numInputCenterYTopMargin: CGFloat = 28
    fileprivate let numInputTopMargin: CGFloat = 28     // numInputPrompt.centerY
    fileprivate let numInputHeight: CGFloat = 56
    fileprivate let balanceCenterYTopMargin: CGFloat = 18      // ceny to numInput.bottom

    fileprivate let feeViewCenterYTopMargin: CGFloat = 20      // balanceLabel.bottom
    fileprivate let addressPromptCenterYTopMargin: CGFloat = 54      // address.ceny to balance.ceny
    fileprivate let addressTopMargin: CGFloat = 15                   // address.top to addressPrompt.centerY
    fileprivate let tipsCenterYTopMargin: CGFloat = 18
    fileprivate let tipsCenterYBottomMargin: CGFloat = 26
    fileprivate let feeViewHeight: CGFloat = 56
    fileprivate let topViewHeight: CGFloat = 260
    fileprivate let bottomViewHeight: CGFloat = 56
    fileprivate let lineViewTopMargin: CGFloat = 154

    fileprivate let fieldHeight: CGFloat = 30
    fileprivate let fieldLrMargin: CGFloat = 12

    fileprivate var limitSingleMinNum: Double = 1
    fileprivate var limitSingleMaxNum: Double = Double(Int.max)
    fileprivate var conversionDSTT: Double = 0


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
extension WithdrawHeaderView {
    class func loadXib() -> WithdrawHeaderView? {
        return Bundle.main.loadNibNamed("WithdrawHeaderView", owner: nil, options: nil)?.first as? WithdrawHeaderView
    }
}

// MARK: - LifeCircle Function
extension WithdrawHeaderView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }

    /// 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()

    }

}
// MARK: - Private UI 手动布局
extension WithdrawHeaderView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.addSubview(self.topView)
        self.initialTopView(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        mainView.addSubview(self.bottomView)
        self.initialBottomView(self.bottomView)
        self.bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom).offset(self.viewVerMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.bottomViewHeight)
            make.bottom.equalToSuperview()
        }
    }
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        topView.backgroundColor = UIColor.white
        topView.set(cornerRadius: 10)
        // 1. numInputPrompt
        topView.addSubview(self.numInputPromptLabel)
        self.numInputPromptLabel.set(text: "请输入FIL个数", font: UIFont.pingFangSCFont(size: 14), textColor: AppColor.mainText)
        self.numInputPromptLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.centerY.equalTo(mainView.snp.top).offset(self.numInputCenterYTopMargin)
        }
        // 2. numInput
        topView.addSubview(self.numInputView)
        self.initialNumInputView(self.numInputView)
        self.numInputView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.numInputPromptLabel.snp.centerY).offset(self.numInputTopMargin)
            make.height.equalTo(self.numInputHeight)
        }
        // 3. balanceControl
        topView.addSubview(self.balanceControl)
        self.balanceControl.topLabel.set(text: "可提现FIL", font: UIFont.pingFangSCFont(size: 12, weight: .regular), textColor: AppColor.grayText, alignment: .left)
        self.balanceControl.bottomLabel.set(text: "0", font: UIFont.pingFangSCFont(size: 12, weight: .regular), textColor: AppColor.minorText, alignment: .left)
        self.balanceControl.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.centerY.equalTo(self.numInputView.snp.bottom).offset(self.balanceCenterYTopMargin)
        }
        self.balanceControl.topLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        self.balanceControl.bottomLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.balanceControl.topLabel.snp.right).offset(5)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        // 4. allExchange
        topView.addSubview(self.allExchangeBtn)
        self.allExchangeBtn.set(title: "全部提出", titleColor: UIColor.init(hex: 0x5CB3F5), for: .normal)
        self.allExchangeBtn.set(title: "全部提出", titleColor: UIColor.init(hex: 0x5CB3F5), for: .highlighted)
        self.allExchangeBtn.set(font: UIFont.pingFangSCFont(size: 12))
        self.allExchangeBtn.addTarget(self, action: #selector(allExchangeBtnClick(_:)), for: .touchUpInside)
        self.allExchangeBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.centerY.equalTo(self.balanceControl)
        }
        // 5. lineView
        topView.addSubview(self.lineView)
        self.lineView.backgroundColor = AppColor.dividing
        self.lineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(lineViewTopMargin)
            make.leading.equalToSuperview().offset(lrMargin)
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.height.equalTo(0.5)
        }
        // 6. addressPrompt
        topView.addSubview(self.addressPromptLabel)
        self.addressPromptLabel.set(text: "提现地址", font: UIFont.pingFangSCFont(size: 16), textColor: AppColor.mainText)
        self.addressPromptLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.centerY.equalTo(self.balanceControl.snp.centerY).offset(self.addressPromptCenterYTopMargin)
        }
        // 7. addressLabel
        topView.addSubview(self.addressLabel)
        self.addressLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: AppColor.mainText, alignment: .left)
        self.addressLabel.numberOfLines = 0
        self.addressLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.addressPromptLabel.snp.centerY).offset(self.addressTopMargin)
        }
        // 8. updateTipsLabel
        topView.addSubview(self.updateTipsLabel)
        //self.updateTipsLabel.set(text: "（如需修改地址，请点击 联系客服）", font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.grayText, alignment: .center)
        self.updateTipsLabel.font = UIFont.pingFangSCFont(size: 12)
        self.updateTipsLabel.textColor = AppColor.grayText
        self.updateTipsLabel.textAlignment = .center
        self.updateTipsLabel.textContainerInset = UIEdgeInsets.zero
        self.updateTipsLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.addressLabel.snp.bottom).offset(self.tipsCenterYTopMargin)
            make.centerY.equalTo(topView.snp.bottom).offset(-self.tipsCenterYBottomMargin)
        }
        let tipsAttText: NSMutableAttributedString = NSMutableAttributedString.init()
        tipsAttText.append(NSAttributedString.init(string: "（如需修改地址，请点击", attributes: [NSAttributedString.Key.foregroundColor: AppColor.grayText]))
        let kefuAttText: NSMutableAttributedString = NSMutableAttributedString.init()
        kefuAttText.append(NSAttributedString.init(string: "联系客服", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0x5CB3F5)]))
        let kefuAttHighlight: YYTextHighlight = YYTextHighlight.init(backgroundColor: UIColor.clear)
        kefuAttHighlight.tapAction = { (_ containerView: UIView, _ text: NSAttributedString, _ range: NSRange, _ rect: CGRect) in
            DispatchQueue.main.async {
                self.delegate?.headerView(self, didClickedKefu: self.updateTipsLabel)
            }
        }
        kefuAttText.setTextHighlight(kefuAttHighlight, range: kefuAttText.rangeOfAll())
        tipsAttText.append(kefuAttText)
        tipsAttText.append(NSAttributedString.init(string: " ）", attributes: [NSAttributedString.Key.foregroundColor: AppColor.grayText]))
        self.updateTipsLabel.attributedText = tipsAttText
    }
    fileprivate func initialBottomView(_ bottomView: UIView) -> Void {
        bottomView.backgroundColor = UIColor.white
        bottomView.set(cornerRadius: 10)
        // 5. fee
        bottomView.addSubview(self.feeView)
        self.feeView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(self.feeViewHeight)
        }
        self.feeView.addSubview(self.feePromptLabel)
        self.feePromptLabel.set(text: "提现手续费", font: UIFont.pingFangSCFont(size: 14), textColor: AppColor.mainText)
        self.feePromptLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.centerY.equalToSuperview()
        }
        self.feeView.addSubview(self.feeValueLabel)
        self.feeValueLabel.set(text: "0FIL", font: UIFont.pingFangSCFont(size: 14, weight: .regular), textColor: AppColor.mainText)
        self.feeValueLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.centerY.equalToSuperview()
        }
    }
    fileprivate func initialNumInputView(_ numInputView: UIView) -> Void {
        numInputView.backgroundColor = AppColor.pageBg
        numInputView.set(cornerRadius: 5, borderWidth: 1, borderColor: AppColor.dividing)
        // numTips
        numInputView.addSubview(self.numTipsLabel)
        self.numTipsLabel.set(text: "余额不足，无法提现", font: UIFont.pingFangSCFont(size: 12), textColor: UIColor.init(hex: 0xFA3A90), alignment: .right)
        self.numTipsLabel.isHidden = true
        self.numTipsLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.fieldLrMargin)
            make.width.equalTo(115)
        }
        // numField
        numInputView.addSubview(self.numField)
        self.numField.keyboardType = .decimalPad
        self.numField.set(placeHolder: nil, font: UIFont.pingFangSCFont(size: 20), textColor: AppColor.mainText)
        self.numField.attributedPlaceholder = NSAttributedString.init(string: "最低提现个数 1", attributes: [NSAttributedString.Key.font: UIFont.pingFangSCFont(size: 20), NSAttributedString.Key.foregroundColor: AppColor.grayText])
        self.numField.addTarget(self, action: #selector(numFieldValueChanged(_:)), for: .editingChanged)
        self.numField.snp.makeConstraints { (make) in
            make.height.equalTo(self.fieldHeight)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(self.fieldLrMargin)
            //make.trailing.equalToSuperview().offset(-self.numFieldLrMargin)
            make.trailing.equalTo(self.numTipsLabel.snp.leading)
        }
    }

}
// MARK: - Private UI Xib加载后处理
extension WithdrawHeaderView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
    }

}

// MARK: - Data Function
extension WithdrawHeaderView {
    /// 数据加载
    fileprivate func setupWithAssetInfoModel(_ assetModel: AssetInfoModel?) {
        guard let assetModel = assetModel else {
            return
        }
        // 子控件数据加载
        self.numInputPromptLabel.text = "请输入提现数量"
        let balance: String = assetModel.lfbalance.decimalValidDigitsProcess(digits: 8)
        self.balanceControl.topLabel.text = "可提现\(assetModel.currency.title)"
        self.balanceControl.bottomLabel.text = balance
        self.limitSingleMaxNum = Double(balance) ?? 0.0
        guard let configModel = self.configModel else {
            return
        }
        self.limitSingleMinNum = configModel.user_min
        self.numField.attributedPlaceholder = NSAttributedString.init(string: "最低提现个数 " + "\(self.limitSingleMinNum)".decimalProcess(digits: 8), attributes: [NSAttributedString.Key.font: UIFont.pingFangSCFont(size: 20), NSAttributedString.Key.foregroundColor: AppColor.grayText])
        self.feeValueLabel.text = "\(configModel.service_charge)".decimalProcess(digits: 8) + " " + assetModel.currency.title
        self.addressLabel.text = assetModel.withdrawAddress
        self.progressConvertNum()
    }
}

// MARK: - Event Function
extension WithdrawHeaderView {
    /// 全部提出点击响应
    @objc fileprivate func allExchangeBtnClick(_ button: UIButton) -> Void {
        self.numField.text = "\(self.limitSingleMaxNum)".decimalProcess(digits: 8)
        self.delegate?.headerView(self, self.numField.text)
    }
    /// 数字输入框内容变更
    @objc fileprivate func numFieldValueChanged(_ numField: UITextField) -> Void {
        self.delegate?.headerView(self, self.numField.text)
        self.progressConvertNum()
    }
}

// MARK: - Extension Function
extension WithdrawHeaderView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    func progressConvertNum() {
        guard let assetModel = self.assetInfoModel else {
             return
         }
//        guard let text = self.numField.text, let num = Double(text) else {
//            self.feeValueLabel.text = "0" + " " + "FIL"
//            return
//        }
    }
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension WithdrawHeaderView {

}
