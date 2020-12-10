//
//  WalletHomeMainView.swift
//  JXProject
//
//  Created by zhaowei on 2020/10/21.
//  Copyright © 2020 ChainOne. All rights reserved.
//

protocol WalletHomeMainViewProtocol {
    func mainView(view: WalletHomeMainView, didClickBondHelpImg imgView: UIImageView)
    func mainView(view: WalletHomeMainView, didClickWithdrwalBtn btn: UIButton)
    func mainView(view: WalletHomeMainView, didClickRechargeBtn btn: UIButton)
}

import UIKit

class WalletHomeMainView: UIView {

    // MARK: - Internal Property

    static let viewHeight: CGFloat = 52 + CGSize.init(width: 351, height: 154).scaleAspectForWidth(kScreenWidth - 12.0 * 2.0).height // 12 + 128 + 40

    var model: WalletFilInfoModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    var delegate: WalletHomeMainViewProtocol?
    // MARK: - Private Property

    fileprivate let mainView: UIView = UIView()

    fileprivate let topBgView: UIImageView = UIImageView()
    /// 累计收入
    fileprivate let totalMoneyView = TopTitleBottomTitleControl()
    /// 资产余额
    fileprivate let balancelMoneyView = TopTitleBottomTitleControl()
    /// 人民币值
    fileprivate let cnyValueLabel = UILabel()

    fileprivate let centerView: UIView = UIView()
    fileprivate let centerBgView: UIImageView = UIImageView()
    /// 可提现
    fileprivate let withdrwalMoneyView = TopTitleBottomTitleControl()
    /// 提现中
    fileprivate let withdrwalingLabel = UILabel()
    /// 已提现
    fileprivate let withdrwaledLabel = UILabel()
    /// 充值按钮
    fileprivate let rechargeBtn = UIButton.init(type: .custom)
    /// 提现按钮
    fileprivate let withdrwalBtn = UIButton.init(type: .custom)

    /// 保证金
    fileprivate let bondView: UIView = UIView()
    fileprivate let bondBgView: UIImageView = UIImageView()
    fileprivate let bondBottomView: UIView = UIView()
    fileprivate let bondLabel: UILabel = UILabel()
    fileprivate let bondHelpImgView: UIImageView = UIImageView()
    
    fileprivate let bottomView: UIView = UIView()
    fileprivate let bottomTitleLabel: UILabel = UILabel()
    fileprivate let canUseItem = WalletBalanceItem.init(type: .canUse)
    fileprivate let mortgageItem = WalletBalanceItem.init(type: .mortgage)
    fileprivate let lockUpItem = WalletBalanceItem.init(type: .LockUp)
    // tipLabel
    fileprivate let dataView = UIView()
    fileprivate let dataTitleLabel = UILabel()
    fileprivate let totalCunView = IconTitleValueView()
    fileprivate let hasCunView = IconTitleValueView()
    fileprivate let cunProgressView = IconTitleValueView()

    fileprivate var topBgSize: CGSize = CGSize.init(width: 375, height: 190 - 20).scaleAspectForWidth(kScreenWidth)
    fileprivate let centerViewTopMargin: CGFloat = -44 // topView
    fileprivate let centerViewHeight: CGFloat = CGSize.init(width: 375, height: 134).scaleAspectForWidth(kScreenWidth).height
    fileprivate let bondViewHeight: CGFloat = CGSize.init(width: 375, height: 40).scaleAspectForWidth(kScreenWidth).height
    fileprivate let bondBottomViewHeight: CGFloat = 30
    
    fileprivate let bgTopMargin: CGFloat = 0
    fileprivate let lrMargin: CGFloat = 15
    fileprivate let titleViewHeight: CGFloat = 40
    fileprivate let bottomMargin: CGFloat = 15
    fileprivate let itemVerMargin: CGFloat = 10

    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
        self.initialUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialUI()
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension WalletHomeMainView {

}

// MARK: - LifeCircle Function
extension WalletHomeMainView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension WalletHomeMainView {

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
        // 1. topBgView
        mainView.addSubview(self.topBgView)
        self.topBgView.isUserInteractionEnabled = true
        self.initialToptopBgView(self.topBgView)
        self.topBgView.image = UIImage.init(named: "IMG_qb_fil_top_bg")
        self.topBgView.set(cornerRadius: 0)
        self.topBgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.bgTopMargin)
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
            make.height.equalTo(self.topBgSize.height + kStatusBarHeight)
        }
        // 2. bottomView
        mainView.addSubview(self.centerView)
        self.initialCenterView(self.centerView)
        self.centerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.topBgView.snp.bottom).offset(centerViewTopMargin)
            make.height.equalTo(self.centerViewHeight)
        }
        // 2. bottomView
        mainView.addSubview(self.bottomView)
        self.initialBottomView(self.bottomView)
        self.bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.centerView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    fileprivate func initialToptopBgView(_ topBgView: UIView) -> Void {
        // 0.totalMoneyView
        topBgView.addSubview(self.totalMoneyView)
        self.totalMoneyView.topLabel.set(text: "累计收入FIL", font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: UIColor.init(hex: 0xA48862), alignment: .left)
        self.totalMoneyView.bottomLabel.set(text: "0.00", font: UIFont.pingFangSCFont(size: 22, weight: .medium), textColor: UIColor.init(hex: 0xE9C483), alignment: .left)
        self.totalMoneyView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(lrMargin)
            make.right.lessThanOrEqualTo(topBgView.snp.centerX).offset(0)
            make.top.equalTo(topBgView.snp.top).offset(6 + kNavigationStatusBarHeight)
            make.width.greaterThanOrEqualTo(65)
        }
        self.totalMoneyView.bottomLabel.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.totalMoneyView.topLabel.snp.bottom).offset(7)
            make.bottom.equalToSuperview().offset(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(17)
        }
        // 1.balancelMoneyView
        topBgView.addSubview(self.balancelMoneyView)
        self.balancelMoneyView.topLabel.set(text: "资产余额FIL", font: UIFont.pingFangSCFont(size: 13), textColor: UIColor.init(hex: 0xA48862), alignment: .left)
        self.balancelMoneyView.bottomLabel.set(text: "0.00", font: UIFont.pingFangSCFont(size: 22, weight: .medium), textColor: UIColor.init(hex: 0xE9C483), alignment: .left)
        self.balancelMoneyView.snp.makeConstraints { (make) in
            make.left.equalTo(topBgView.snp.centerX)
            make.centerY.equalTo(self.totalMoneyView)
            make.width.greaterThanOrEqualTo(65)
        }
        self.balancelMoneyView.bottomLabel.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.balancelMoneyView.topLabel.snp.bottom).offset(7)
            make.bottom.equalToSuperview().offset(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(17)
        }
        topBgView.addSubview(self.cnyValueLabel)
        self.cnyValueLabel.set(text: "≈￥0.0", font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: UIColor.init(hex: 0xA48862), alignment: .left)
        self.cnyValueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.balancelMoneyView.snp.left)
            make.top.equalTo(self.balancelMoneyView.snp.bottom).offset(5)
        }
    }
    fileprivate func initialCenterView(_ centerView: UIView) -> Void {
        // 0.centerBgView
        centerView.addSubview(self.centerBgView)
        self.centerBgView.image = UIImage.init(named: "IMG_tixian_card_bg")
        self.centerBgView.set(cornerRadius: 0)
        self.centerBgView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        centerView.addSubview(self.withdrwalMoneyView)
        self.withdrwalMoneyView.topLabel.set(text: "可提现金额(FIL)", font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: UIColor.init(hex: 0xFFF9F4), alignment: .left)
        self.withdrwalMoneyView.bottomLabel.set(text: "0.00", font: UIFont.pingFangSCFont(size: 20, weight: .medium), textColor: UIColor.white, alignment: .left)
        self.withdrwalMoneyView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(lrMargin)
            make.right.lessThanOrEqualTo(topBgView.snp.centerX).offset(0)
            make.top.equalTo(centerView.snp.top).offset(20)
            make.width.greaterThanOrEqualTo(65)
        }
        self.withdrwalMoneyView.bottomLabel.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.withdrwalMoneyView.topLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview().offset(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
        }
        centerView.addSubview(self.rechargeBtn)
        self.rechargeBtn.addTarget(self, action: #selector(rechargeBtnClick(_:)), for: .touchUpInside)
        self.rechargeBtn.set(font: UIFont.pingFangSCFont(size: 14, weight: .medium))
        self.rechargeBtn.setTitle("充币", for: .normal)
        self.rechargeBtn.setTitleColor(UIColor.init(hex: 0x00B8FF), for: .normal)
        self.rechargeBtn.backgroundColor = UIColor.white
        self.rechargeBtn.set(cornerRadius: 14)
        self.rechargeBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 60, height: 28))
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.centerY.equalTo(self.withdrwalMoneyView)
        }
        centerView.addSubview(self.withdrwalBtn)
        self.withdrwalBtn.addTarget(self, action: #selector(withdrwalBtnClick(_:)), for: .touchUpInside)
        self.withdrwalBtn.set(font: UIFont.pingFangSCFont(size: 14, weight: .medium))
        self.withdrwalBtn.setTitle("提币", for: .normal)
        self.withdrwalBtn.setTitleColor(UIColor.init(hex: 0x00B8FF), for: .normal)
        self.withdrwalBtn.backgroundColor = UIColor.white
        self.withdrwalBtn.set(cornerRadius: 14)
        self.withdrwalBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 60, height: 28))
            make.right.equalTo(self.rechargeBtn.snp.left).offset(-12)
            make.centerY.equalTo(self.withdrwalMoneyView)
        }
        // 1.bondView
        centerView.addSubview(self.bondView)
        self.initialBondView(self.bondView)
//        self.bondView.backgroundColor = UIColor.init(hex: 0x833C11).withAlphaComponent(0.5)
//        self.bondView.setupCorners([UIRectCorner.topLeft, UIRectCorner.topRight], selfSize: CGSize.init(width: kScreenWidth, height: self.bondViewHeight), cornerRadius: 15)
        self.bondView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(self.bondViewHeight)
        }
        // 两个label 预约基于bondView 放最后
        centerView.addSubview(self.withdrwalingLabel)
        self.withdrwalingLabel.set(text: "提现中 0.00", font: UIFont.pingFangSCFont(size: 12), textColor: UIColor.init(hex: 0xFFFFFF), alignment: .left)
        self.withdrwalingLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.centerY.equalTo(self.bondView.snp.top).offset(-16)
        }
        centerView.addSubview(self.withdrwaledLabel)
        self.withdrwaledLabel.set(text: "已提现 0.00", font: UIFont.pingFangSCFont(size: 12), textColor: UIColor.init(hex: 0xFFFFFF), alignment: .left)
        self.withdrwaledLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.withdrwalingLabel.snp.right).offset(20)
            make.centerY.equalTo(self.withdrwalingLabel)
        }
    }
    fileprivate func initialBottomView(_ bottomView: UIView) -> Void {
        bottomView.backgroundColor = UIColor.white
        // bottomTitle
        bottomView.addSubview(self.bottomTitleLabel)
        self.bottomTitleLabel.set(text: "其他金额", font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: UIColor.init(hex: 0x333333))
        self.bottomTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.centerY.equalTo(bottomView.snp.top).offset(12)
        }
        bottomView.addSubview(self.canUseItem)
        self.canUseItem.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(WalletBalanceItem.viewHeight)
        }
        bottomView.addSubview(self.mortgageItem)
        self.mortgageItem.snp.makeConstraints { (make) in
            make.top.equalTo(self.canUseItem.snp.bottom).offset(self.itemVerMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(WalletBalanceItem.viewHeight)
        }
        bottomView.addSubview(self.lockUpItem)
        self.lockUpItem.snp.makeConstraints { (make) in
            make.top.equalTo(self.mortgageItem.snp.bottom).offset(self.itemVerMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(WalletBalanceItem.viewHeight)
        }
        // dataView
        bottomView.addSubview(self.dataView)
        self.dataView.addLineWithSide(.inTop, color: AppColor.dividing, thickness: 0.4, margin1: lrMargin, margin2: lrMargin)
        self.dataView.snp.makeConstraints { (make) in
            make.top.equalTo(self.lockUpItem.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.dataView.addSubview(self.dataTitleLabel)
        self.dataTitleLabel.set(text: "数据概况", font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: AppColor.mainText)
        self.dataTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.dataView.snp.top).offset(23)
            make.leading.equalToSuperview().offset(lrMargin)
        }
        self.dataView.addSubview(self.totalCunView)
        self.totalCunView.iconView.image = UIImage.init(named: "IMG_qb_icon_zcl")
        self.totalCunView.titleLabel.text = "IPFS总存力"
        self.totalCunView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.dataTitleLabel.snp.centerY).offset(29)
            make.leading.equalToSuperview().offset(lrMargin)
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.height.equalTo(28)
        }
        self.dataView.addSubview(self.hasCunView)
        self.hasCunView.iconView.image = UIImage.init(named: "IMG_qb_icon_number")
        self.hasCunView.titleLabel.text = "已封存数量"
        self.hasCunView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.totalCunView.snp.centerY).offset(28)
            make.leading.equalToSuperview().offset(lrMargin)
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.height.equalTo(28)
        }
        self.dataView.addSubview(self.cunProgressView)
        self.cunProgressView.iconView.image = UIImage.init(named: "IMG_qb_icon_jindu")
        self.cunProgressView.titleLabel.text = "已封存进度"
        self.cunProgressView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.hasCunView.snp.centerY).offset(28)
            make.leading.equalToSuperview().offset(lrMargin)
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.height.equalTo(28)
        }

    }
    fileprivate func initialBondView(_ bondView: UIView) -> Void {
        bondView.addSubview(self.bondBgView)
        self.bondBgView.set(cornerRadius: 0)
        self.bondBgView.image = UIImage.init(named: "IMG_qb_bz_bg")
        self.bondBgView.set(cornerRadius: 0)
        self.bondBgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 2.bondBottomView
        bondView.addSubview(self.bondBottomView)
        self.bondBottomView.backgroundColor = UIColor.white
        self.bondBottomView.setupCorners([UIRectCorner.topLeft, UIRectCorner.topRight], selfSize: CGSize.init(width: kScreenWidth, height: self.bondBottomViewHeight), cornerRadius: 15)
        self.bondBottomView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(15)
            make.height.equalTo(bondBottomViewHeight)
        }
        bondView.addSubview(self.bondLabel)
        self.bondLabel.set(text: "安全保障金：0.00", font: UIFont.pingFangSCFont(size: 11, weight: .medium), textColor: UIColor.init(hex: 0x1AF6CA))
        self.bondLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.top.equalTo(self.bondBgView.snp.top)
            make.bottom.equalTo(self.bondBottomView.snp.top)
        }
        bondView.addSubview(self.bondHelpImgView)
        self.bondHelpImgView.isUserInteractionEnabled = true
        self.bondHelpImgView.image = UIImage.init(named: "IMG_wallet_icon_help")
        self.bondHelpImgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(bondHelpImgViewTap(_:))))
        self.bondHelpImgView.set(cornerRadius: 0)
        self.bondHelpImgView.contentMode = .center
        self.bondHelpImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(22)
            make.left.equalTo(self.bondLabel.snp.right).offset(0)
            make.centerY.equalTo(self.bondLabel)
        }
        self.bondHelpImgView.isHidden = true
    }

}
// MARK: - Private UI Xib加载后处理
extension WalletHomeMainView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension WalletHomeMainView {
    /// 数据加载
    fileprivate func setupWithModel(_ model: WalletFilInfoModel?) -> Void {
        guard let model = model else {
            return
        }
        self.totalMoneyView.bottomLabel.text = model.income.decimalProcess(digits: 4)
        self.balancelMoneyView.bottomLabel.text = model.fil_balance.decimalProcess(digits: 4)
        self.cnyValueLabel.text = "≈￥\(model.fil_to_cny.decimalProcess(digits: 2))"
        self.withdrwalMoneyView.bottomLabel.text = model.withdrawable.decimalProcess(digits: 4)
        // withdrwalingLabel
        let withdrwalingAtt: NSMutableAttributedString = NSMutableAttributedString.init()
        withdrwalingAtt.append(NSAttributedString.init(string: "提现中", attributes: [NSAttributedString.Key.font: UIFont.pingFangSCFont(size: 12, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xFFF9F4)]))
        withdrwalingAtt.append(NSAttributedString.init(string: " \(model.withdraw_ing.decimalProcess(digits: 4))FIL", attributes: [NSAttributedString.Key.font: UIFont.pingFangSCFont(size: 12, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xFFFFFFF)]))
        self.withdrwalingLabel.attributedText = withdrwalingAtt
        // withdrwaledLabel
        let withdrwaledAtt: NSMutableAttributedString = NSMutableAttributedString.init()
        withdrwaledAtt.append(NSAttributedString.init(string: "已提现", attributes: [NSAttributedString.Key.font: UIFont.pingFangSCFont(size: 12, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xFFF9F4)]))
        withdrwaledAtt.append(NSAttributedString.init(string: " \(model.withdraw_finish.decimalProcess(digits: 4))FIL", attributes: [NSAttributedString.Key.font: UIFont.pingFangSCFont(size: 12, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xFFFFFFF)]))
        self.withdrwaledLabel.attributedText = withdrwaledAtt
        // bondLabel
        self.bondLabel.text = "安全保障金：\(model.security.decimalProcess(digits: 4))"
        // tipLabel

        // item
        self.canUseItem.model = model
        self.mortgageItem.model = model
        self.lockUpItem.model = model
        
        self.totalCunView.valueLabel.text = "\(model.total_save_power)".decimalProcess(digits: 4) + "T"
        self.hasCunView.valueLabel.text = "\(model.cunNum)".decimalProcess(digits: 4) + "T"
        self.cunProgressView.valueLabel.text = "\(model.cunProgress)".decimalProcess(digits: 4) + "%"
    }
}

// MARK: - Event Function
extension WalletHomeMainView {
    @objc fileprivate func withdrwalBtnClick(_ btn: UIButton) {
        self.delegate?.mainView(view: self, didClickWithdrwalBtn: btn)
    }
    @objc fileprivate func rechargeBtnClick(_ btn: UIButton) {
        self.delegate?.mainView(view: self, didClickRechargeBtn: btn)
    }
    @objc fileprivate func bondHelpImgViewTap(_ tap: UITapGestureRecognizer) {
        self.delegate?.mainView(view: self, didClickBondHelpImg: self.bondHelpImgView)
    }
}

// MARK: - Extension Function
extension WalletHomeMainView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension WalletHomeMainView {

}
