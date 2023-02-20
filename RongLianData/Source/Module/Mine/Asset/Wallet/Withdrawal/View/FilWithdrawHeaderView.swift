//
//  FilWithdrawHeaderView.swift
//  HuoTuiVideo
//
//  Created by 小唐 on 2020/6/10.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  DSTT提现头视图

import UIKit
import YYKit

protocol FilWithdrawHeaderViewProtocol: class {
    func headerView(_ view: FilWithdrawHeaderView, _ currentNum: String?)
    /// 二维码点击回调
    func headerView(_ view: FilWithdrawHeaderView, didClickedQrcode qrcodView: UIView)
    /// 联系客服点击回调
    func headerView(_ view: FilWithdrawHeaderView, didClickedKefu kefuView: UIView)
}

class FilWithdrawHeaderView: UIView
{
    
    // MARK: - Internal Property
    static let viewHeight: CGFloat = 260 + 12 + 56
    var configModel: WithdrawConfigModel? 
    var assetInfoModel: AssetInfoModel? {
        didSet {
            self.setupWithAssetInfoModel(assetInfoModel)
        }
    }
    var delegate: FilWithdrawHeaderViewProtocol?
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView()
    fileprivate let topView: UIView = UIView()
    fileprivate let bottomView: UIView = UIView()
    // 提现数量相关
    fileprivate let numInputPromptLabel: UILabel = UILabel.init()              // 输入数额提示
    fileprivate let numInputView: UIView = UIView.init()
    fileprivate let numField: UITextField = UITextField.init()
    let numTipsLabel: UILabel = UILabel.init()  // 余额不足
    
    //fileprivate let balanceControl: TopTitleBottomTitleControl = TopTitleBottomTitleControl()
    fileprivate let balanceView: UILabel = UILabel.init()
    fileprivate let allExchangeBtn: UIButton = UIButton.init(type: .custom) // 全部提现
    
    fileprivate let feeView: UIView = UIView.init()         // 手续费view
    fileprivate let feePromptLabel: UILabel = UILabel.init()         // 手续费
    fileprivate let feeValueLabel: UILabel = UILabel.init()         // 手续费
    
    // 上传二维码图片相关
    fileprivate let addressPromptLabel: UILabel = UILabel.init()
    fileprivate let addressLabel: UILabel = UILabel.init()
    //fileprivate let updateTipsLabel: UILabel = UILabel.init()
    fileprivate let updateTipsLabel: YYLabel = YYLabel.init()
    
    fileprivate let lrMargin: CGFloat = 16
    fileprivate let viewVerMargin: CGFloat = 0//12
    fileprivate let numInputCenterYTopMargin: CGFloat = 29
    fileprivate let numInputTopMargin: CGFloat = 20     // numInputPrompt.centerY
    fileprivate let numInputHeight: CGFloat = 56
    fileprivate let balanceTopMargin: CGFloat = 12      // numInput.bottom
    
    fileprivate let feeViewCenterYTopMargin: CGFloat = 20      // balanceLabel.bottom
    fileprivate let uploadPromptCenterYTopMargin: CGFloat = 48      // feeview.bottom
    fileprivate let uploadQrcodeWH: CGFloat = 80
    fileprivate let uploadQrcodeTopMargin: CGFloat = 8                   // uploadPrompt.centerY
    fileprivate let tipsCenterYTopMargin: CGFloat = 15
    fileprivate let tipsCenterYBottomMargin: CGFloat = 19
    fileprivate let feeViewHeight: CGFloat = 56
    fileprivate let topViewHeight: CGFloat = 262
    fileprivate let bottomViewHeight: CGFloat = 58
    
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
extension FilWithdrawHeaderView {
    class func loadXib() -> FilWithdrawHeaderView? {
        return Bundle.main.loadNibNamed("FilWithdrawHeaderView", owner: nil, options: nil)?.first as? FilWithdrawHeaderView
    }
}

// MARK: - LifeCircle Function
extension FilWithdrawHeaderView {
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
extension FilWithdrawHeaderView {
    
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
            make.height.equalTo(self.topViewHeight)
        }
        mainView.addSubview(self.bottomView)
        self.initialBottomView(self.bottomView)
        self.bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom).offset(self.viewVerMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.bottomViewHeight)
        }
    }
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        topView.backgroundColor = UIColor.white
        //topView.set(cornerRadius: 10)
        // 1. numInputPrompt
        topView.addSubview(self.numInputPromptLabel)
        self.numInputPromptLabel.set(text: "请输入FIL数量", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: UIColor.init(hex: 0x333333))
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
        topView.addSubview(self.balanceView)
        self.balanceView.set(text: "可提现 0.00", font: UIFont.pingFangSCFont(size: 12, weight: .regular), textColor: UIColor.init(hex: 0x666666), alignment: .left)
        self.balanceView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.top.equalTo(self.numInputView.snp.bottom).offset(self.balanceTopMargin)
        }
        // 4. allExchange
        topView.addSubview(self.allExchangeBtn)
        self.allExchangeBtn.set(title: "全部提现", titleColor: UIColor.init(hex: 0x4444FF), for: .normal)
        self.allExchangeBtn.set(title: "全部提现", titleColor: UIColor.init(hex: 0x4444FF), for: .highlighted)
        self.allExchangeBtn.set(font: UIFont.pingFangSCFont(size: 12))
        self.allExchangeBtn.addTarget(self, action: #selector(allExchangeBtnClick(_:)), for: .touchUpInside)
        self.allExchangeBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.centerY.equalTo(self.balanceView)
        }
        // lineView
        let lineView: UIView = UIView.init(bgColor: AppColor.dividing)
        topView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.balanceView.snp.bottom).offset(20)
            make.height.equalTo(0.5)
        }
        // 6. addressPrompt
        topView.addSubview(self.addressPromptLabel)
        self.addressPromptLabel.set(text: "提现地址", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: UIColor.init(hex: 0x333333))
        self.addressPromptLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.centerY.equalTo(lineView.snp.bottom).offset(28)
        }
        // 7. addressLabel
        topView.addSubview(self.addressLabel)
        self.addressLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 16), textColor: UIColor.init(hex: 0x333333), alignment: .center)
        //self.addressLabel.numberOfLines = 0
        self.addressLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.addressPromptLabel.snp.centerY).offset(20)
        }
        // 8. updateTipsLabel
        topView.addSubview(self.updateTipsLabel)
        //self.updateTipsLabel.set(text: "如需修改地址，请点击 联系客服", font: UIFont.pingFangSCFont(size: 12), textColor: UIColor.init(hex: 0x999999), alignment: .center)
        self.updateTipsLabel.font = UIFont.pingFangSCFont(size: 12)
        self.updateTipsLabel.textColor = UIColor.init(hex: 0x999999)
        self.updateTipsLabel.textAlignment = .center
        self.updateTipsLabel.textContainerInset = UIEdgeInsets.zero
        self.updateTipsLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.top.equalTo(self.addressLabel.snp.bottom).offset(8)
//            make.centerY.equalTo(topView.snp.bottom).offset(-self.tipsCenterYBottomMargin)
        }
        let tipsAttText: NSMutableAttributedString = NSMutableAttributedString.init()
        tipsAttText.append(NSAttributedString.init(string: "如需修改地址，请点击", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(hex: 0x999999)]))
        let kefuAttText: NSMutableAttributedString = NSMutableAttributedString.init()
        kefuAttText.append(NSAttributedString.init(string: "联系客服", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(hex: 0x4444FF)]))
        let kefuAttHighlight: YYTextHighlight = YYTextHighlight.init(backgroundColor: UIColor.clear)
        kefuAttHighlight.tapAction = { (_ containerView: UIView, _ text: NSAttributedString, _ range: NSRange, _ rect: CGRect) in
            DispatchQueue.main.async {
                self.delegate?.headerView(self, didClickedKefu: self.updateTipsLabel)
            }
        }
        kefuAttText.setTextHighlight(kefuAttHighlight, range: kefuAttText.rangeOfAll())
        tipsAttText.append(kefuAttText)
        tipsAttText.append(NSAttributedString.init(string: "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(hex: 0x999999)]))
        self.updateTipsLabel.attributedText = tipsAttText
        //
        topView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: self.lrMargin, margin2: self.lrMargin)
    }
    fileprivate func initialBottomView(_ bottomView: UIView) -> Void {
        bottomView.backgroundColor = UIColor.white
        //bottomView.set(cornerRadius: 10)
        // 5. fee
        bottomView.addSubview(self.feeView)
        self.feeView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(self.feeViewHeight)
        }
        self.feeView.addSubview(self.feePromptLabel)
        self.feePromptLabel.set(text: "本次手续费", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: UIColor.init(hex: 0x333333))
        self.feePromptLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.centerY.equalToSuperview()
        }
        self.feeView.addSubview(self.feeValueLabel)
        self.feeValueLabel.set(text: "0FIL", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: UIColor.init(hex: 0x333333))
        self.feeValueLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.centerY.equalToSuperview()
        }
        //
        bottomView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: self.lrMargin, margin2: self.lrMargin)
    }
    fileprivate func initialNumInputView(_ numInputView: UIView) -> Void {
        numInputView.backgroundColor = UIColor.init(hex: 0xF5F5F5)
        numInputView.set(cornerRadius: 8, borderWidth: 0, borderColor: UIColor.init(hex: 0xECECEC))
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
        self.numField.set(placeHolder: nil, font: UIFont.pingFangSCFont(size: 20), textColor: UIColor.init(hex: 0x333333))
        self.numField.attributedPlaceholder = NSAttributedString.init(string: "最低提现数 1", attributes: [NSAttributedString.Key.font : UIFont.pingFangSCFont(size: 20), NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xCCCCCC)])
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
extension FilWithdrawHeaderView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension FilWithdrawHeaderView {
    /// 数据加载
    fileprivate func setupWithAssetInfoModel(_ assetModel: AssetInfoModel?) {
        guard let configModel = self.configModel else {
            return
        }
        guard let assetModel = assetModel else {
            return
        }
        // 子控件数据加载
        self.numInputPromptLabel.text = "请输入FIL个数"
        let balance: String = assetModel.withdrawable
        self.balanceView.text = "可提现 " + balance
        self.limitSingleMaxNum = Double(balance) ?? 0.0
        self.limitSingleMinNum = configModel.user_min
        self.numField.attributedPlaceholder = NSAttributedString.init(string: "最低提现数 \(self.limitSingleMinNum)", attributes: [NSAttributedString.Key.font: UIFont.pingFangSCFont(size: 20), NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0x999999)])
        self.feeValueLabel.text = configModel.service_charge + "FIL"
        self.addressLabel.text = assetModel.withdrawal_address
        self.progressConvertNum()
    }
}

// MARK: - Event Function
extension FilWithdrawHeaderView {
    /// 全部提现点击响应
    @objc fileprivate func allExchangeBtnClick(_ button: UIButton) -> Void {
        self.numField.text = "\(self.limitSingleMaxNum)"
        self.delegate?.headerView(self, self.numField.text)
    }
    /// 数字输入框内容变更
    @objc fileprivate func numFieldValueChanged(_ numField: UITextField) -> Void {
        self.delegate?.headerView(self, self.numField.text)
        self.progressConvertNum()
    }
}

// MARK: - Extension Function
extension FilWithdrawHeaderView {
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
extension FilWithdrawHeaderView {
    
}

