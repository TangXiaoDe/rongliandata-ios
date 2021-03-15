//
//  WalletHomeMainView.swift
//  JXProject
//
//  Created by zhaowei on 2020/10/21.
//  Copyright © 2020 ChainOne. All rights reserved.
//

protocol WalletHomeMainViewProtocol {
    func mainView(view: WalletHomeMainView, didClickRechargeBtn btn: UIButton)
    func mainView(view: WalletHomeMainView, didClickWithdrwalBtn btn: UIButton)
    func mainView(view: WalletHomeMainView, didClickLockDetailBtn btn: UIButton)
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
    fileprivate let withdrwalingView = TopTitleBottomTitleControl()
    /// 已提现
    fileprivate let withdrwaledView = TopTitleBottomTitleControl()
    /// 充值按钮
    fileprivate let rechargeBtn = UIButton.init(type: .custom)
    /// 提现按钮
    fileprivate let withdrwalBtn = UIButton.init(type: .custom)
    /// 设备列表按钮
    fileprivate let lockDetailBtn = UIButton.init(type: .custom)
    
    fileprivate let bottomView: UIView = UIView()
    fileprivate let bottomTitleLabel: UILabel = UILabel()
    fileprivate let canUseItem = WalletBalanceItem.init(type: .canUse)
    fileprivate let mortgageItem = WalletBalanceItem.init(type: .mortgage)
    fileprivate let lockUpItem = WalletBalanceItem.init(type: .lockUp)
    fileprivate let securityItem = WalletBalanceItem.init(type: .security)
    fileprivate let frozenItem = WalletBalanceItem.init(type: .frozen)
    

    fileprivate var topBgSize: CGSize = CGSize.init(width: 375, height: 190 - 20).scaleAspectForWidth(kScreenWidth)
    fileprivate let centerViewTopMargin: CGFloat = -44 // topView
    fileprivate let bottomViewTopMargin: CGFloat = -16 // topView
    fileprivate let centerViewHeight: CGFloat = CGSize.init(width: 375, height: 134).scaleAspectForWidth(kScreenWidth).height
    
    fileprivate let withdrawBtnSize: CGSize = CGSize.init(width: 64, height: 28)
    fileprivate let lockDetailBtnSize: CGSize = CGSize.init(width: 64, height: 28)
    
    fileprivate let bgTopMargin: CGFloat = 0
    fileprivate let lrMargin: CGFloat = 15
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
            make.top.equalTo(self.centerView.snp.bottom).offset(bottomViewTopMargin)
            make.bottom.equalToSuperview()
        }
        self.bottomView.setupCorners([UIRectCorner.topRight, UIRectCorner.topLeft], selfSize: CGSize.init(width: kScreenWidth, height: kScreenHeight - (self.topBgSize.height + kStatusBarHeight + centerViewTopMargin + self.centerViewHeight + bottomViewTopMargin)), cornerRadius: 16)
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
        self.withdrwalMoneyView.topLabel.set(text: "可提现金额(FIL)", font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: UIColor.init(hex: 0xFFF9F4).withAlphaComponent(0.8), alignment: .left)
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
        self.rechargeBtn.setTitleColor(UIColor.init(hex: 0x19A8B1), for: .normal)
        self.rechargeBtn.backgroundColor = UIColor.white
        self.rechargeBtn.set(cornerRadius: 3)
        self.rechargeBtn.snp.makeConstraints { (make) in
            make.size.equalTo(self.withdrawBtnSize)
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.centerY.equalTo(self.withdrwalMoneyView)
        }
        centerView.addSubview(self.withdrwalBtn)
        self.withdrwalBtn.addTarget(self, action: #selector(withdrwalBtnClick(_:)), for: .touchUpInside)
        self.withdrwalBtn.set(font: UIFont.pingFangSCFont(size: 14, weight: .medium))
        self.withdrwalBtn.setTitle("提币", for: .normal)
        self.withdrwalBtn.setTitleColor(UIColor.init(hex: 0x19A8B1), for: .normal)
        self.withdrwalBtn.backgroundColor = UIColor.white
        self.withdrwalBtn.set(cornerRadius: 3)
        self.withdrwalBtn.snp.makeConstraints { (make) in
            make.size.equalTo(self.withdrawBtnSize)
            make.right.equalTo(self.rechargeBtn.snp.left).offset(-12)
            make.centerY.equalTo(self.withdrwalMoneyView)
        }
        centerView.addSubview(self.withdrwalingView)
        self.withdrwalingView.topLabel.set(text: "提现中(FIL)", font: UIFont.pingFangSCFont(size: 12, weight: .regular), textColor: UIColor.init(hex: 0xFFF9F4).withAlphaComponent(0.8), alignment: .left)
        self.withdrwalingView.bottomLabel.set(text: "0.00", font: UIFont.pingFangSCFont(size: 12, weight: .regular), textColor: UIColor.white.withAlphaComponent(0.8), alignment: .left)
        self.withdrwalingView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(lrMargin)
            make.right.lessThanOrEqualTo(topBgView.snp.centerX).offset(0)
            make.top.equalTo(centerView.snp.centerY)
            make.width.greaterThanOrEqualTo(65)
        }
        self.withdrwalingView.bottomLabel.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.withdrwalingView.topLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview().offset(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
        }
        centerView.addSubview(self.withdrwaledView)
        self.withdrwaledView.topLabel.set(text: "已提现(FIL)", font: UIFont.pingFangSCFont(size: 12, weight: .regular), textColor: UIColor.init(hex: 0xFFF9F4).withAlphaComponent(0.8), alignment: .left)
        self.withdrwaledView.bottomLabel.set(text: "0.00", font: UIFont.pingFangSCFont(size: 12, weight: .regular), textColor: UIColor.white.withAlphaComponent(0.8), alignment: .left)
        self.withdrwaledView.snp.makeConstraints { (make) in
            make.left.equalTo(self.withdrwalingView.snp.right).offset(30)
            make.right.lessThanOrEqualTo(topBgView.snp.centerX).offset(0)
            make.centerY.equalTo(self.withdrwalingView.snp.centerY)
            make.width.greaterThanOrEqualTo(65)
        }
        self.withdrwaledView.bottomLabel.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.withdrwaledView.topLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview().offset(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
        }
        centerView.addSubview(self.lockDetailBtn)
        self.lockDetailBtn.addTarget(self, action: #selector(lockDetailBtnClick(_:)), for: .touchUpInside)
        self.lockDetailBtn.set(font: UIFont.pingFangSCFont(size: 13, weight: .medium))
        self.lockDetailBtn.setTitle("锁仓详情", for: .normal)
        self.lockDetailBtn.setTitleColor(UIColor.init(hex: 0xE9C483), for: .normal)
        self.lockDetailBtn.backgroundColor = UIColor.init(hex: 0x333333).withAlphaComponent(0.5)
        self.lockDetailBtn.set(cornerRadius: 3)
        self.lockDetailBtn.snp.makeConstraints { (make) in
            make.size.equalTo(self.lockDetailBtnSize)
            make.right.equalTo(self.rechargeBtn.snp.right)
            make.centerY.equalTo(self.withdrwaledView)
        }
    }
    fileprivate func initialBottomView(_ bottomView: UIView) -> Void {
        bottomView.backgroundColor = UIColor.white
        // bottomTitle
        bottomView.addSubview(self.bottomTitleLabel)
        self.bottomTitleLabel.set(text: "其他金额", font: UIFont.pingFangSCFont(size: 14, weight: .medium), textColor: UIColor.init(hex: 0x333333))
        self.bottomTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.centerY.equalTo(bottomView.snp.top).offset(27)
        }
        bottomView.addSubview(self.canUseItem)
        self.canUseItem.snp.makeConstraints { (make) in
            make.top.equalTo(self.bottomTitleLabel.snp.centerY).offset(20)
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
        bottomView.addSubview(self.securityItem)
        self.securityItem.snp.makeConstraints { (make) in
            make.top.equalTo(self.lockUpItem.snp.bottom).offset(self.itemVerMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(WalletBalanceItem.viewHeight)
//            make.bottom.equalToSuperview()
        }
        bottomView.addSubview(self.frozenItem)
        self.frozenItem.snp.makeConstraints { (make) in
            make.top.equalTo(self.securityItem.snp.bottom).offset(self.itemVerMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(WalletBalanceItem.viewHeight)
//            make.bottom.equalToSuperview()
        }
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
        self.totalMoneyView.bottomLabel.text = model.income.decimalProcess(digits: 8)
        self.balancelMoneyView.bottomLabel.text = model.fil_balance.decimalProcess(digits: 8)
        self.cnyValueLabel.text = "≈￥\(model.fil_to_cny.decimalProcess(digits: 2))"
        self.withdrwalMoneyView.bottomLabel.text = model.withdrawable
        self.withdrwalingView.bottomLabel.text = model.withdraw_ing
        self.withdrwaledView.bottomLabel.text = model.withdraw_finish

        // tipLabel

        // item
        self.canUseItem.model = model
        self.mortgageItem.model = model
        self.lockUpItem.model = model
        self.securityItem.model = model
        self.frozenItem.model = model
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
    @objc fileprivate func lockDetailBtnClick(_ btn: UIButton) {
        self.delegate?.mainView(view: self, didClickLockDetailBtn: btn)
    }
}

// MARK: - Extension Function
extension WalletHomeMainView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension WalletHomeMainView {

}
