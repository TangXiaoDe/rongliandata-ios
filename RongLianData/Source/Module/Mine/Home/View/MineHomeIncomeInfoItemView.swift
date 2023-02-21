//
//  MineHomeIncomeInfoItemView.swift
//  RongLianData
//
//  Created by crow on 2021/5/17.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit

protocol MineHomeIncomeInfoItemViewProtocol: class {
    //点击全部
    func incomeInfoView(_ view: MineHomeIncomeInfoItemView, didTapPageAt index: Int) -> Void
}

class MineHomeIncomeInfoItemView: UIView {

    fileprivate let bgImgView: UIImageView = UIImageView()
    /// 累计收益
    fileprivate var totalMoneyView: TopTitleBottomTitleControl = TopTitleBottomTitleControl()
    /// 可提现
    fileprivate var soonMoneyView: TopTitleBottomTitleControl = TopTitleBottomTitleControl()
    /// 资产余额
    fileprivate var balanceMoneyView: TopTitleBottomTitleControl = TopTitleBottomTitleControl()
    fileprivate let moreIconView = UIImageView()
//    weak var delegate: MineHomeIncomeInfoViewProtocol?

    fileprivate let lrMargin: CGFloat = 22
    fileprivate var itemMaxWidth: CGFloat {
        return (kScreenWidth - 2 * self.lrMargin)/3
    }
    
    var model: WalletAllInfoModel? {
        didSet {
            self.setupModel(model)
        }
    }

    init() {
        super.init(frame: .zero)
        let mainView = UIView()
        self.addSubview(mainView)
        self.initialFilView(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MineHomeIncomeInfoItemView {
    fileprivate func initialFilView(_ mainView: UIView) -> Void {
//        mainView.backgroundColor = UIColor.white
//        mainView.set(cornerRadius: 10)
        mainView.addSubview(self.bgImgView)
//        self.bgImgView.image = UIImage.init(named: "IMG_mine_fil_bg")
        self.bgImgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        mainView.addSubview(self.totalMoneyView)
        self.totalMoneyView.isUserInteractionEnabled = false
        self.totalMoneyView.topLabel.set(text: "FIL累计收入", font: UIFont.pingFangSCFont(size: 13, weight: .regular), textColor: UIColor(hex: 0x666666), alignment: .left)
        self.totalMoneyView.bottomLabel.set(text: "0.00", font: UIFont.pingFangSCFont(size: 18, weight: .regular), textColor: UIColor.init(hex: 0x4444FF), alignment: .left)
        self.totalMoneyView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.top.equalToSuperview().offset(20)
        }
        self.totalMoneyView.bottomLabel.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(self.totalMoneyView.topLabel.snp.centerY).offset(21)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        mainView.addSubview(self.moreIconView)
        self.moreIconView.image = UIImage.init(named: "IMG_equip_next_black")
        self.moreIconView.snp.makeConstraints { (make) in
            make.left.equalTo(self.totalMoneyView.topLabel.snp.left).offset("FIL累计收入".size(maxSize: CGSize.max, font: UIFont.pingFangSCFont(size: 13, weight: .medium)).width + 5)
            make.centerY.equalTo(self.totalMoneyView.topLabel)
            make.width.equalTo(3.5)
            make.height.equalTo(7)
        }

        // soonMoneyView
        mainView.addSubview(self.soonMoneyView)
        self.soonMoneyView.isUserInteractionEnabled = false
        self.soonMoneyView.topLabel.set(text: "可提现余额(FIL)", font: UIFont.pingFangSCFont(size: 13, weight: .regular), textColor: UIColor(hex: 0x666666), alignment: .left)
        self.soonMoneyView.bottomLabel.set(text: "0.00", font: UIFont.pingFangSCFont(size: 16, weight: .regular), textColor: UIColor.init(hex: 0x333333), alignment: .left)
        self.soonMoneyView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(self.itemMaxWidth)
        }
        self.soonMoneyView.bottomLabel.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(self.soonMoneyView.topLabel.snp.centerY).offset(21)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        let soonMoneyMoreIcon = UIImageView()
        mainView.addSubview(soonMoneyMoreIcon)
        soonMoneyMoreIcon.image = UIImage.init(named: "IMG_equip_next_black")
        soonMoneyMoreIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self.soonMoneyView.topLabel.snp.left).offset("可提现余额(FIL)".size(maxSize: CGSize.max, font: UIFont.pingFangSCFont(size: 13, weight: .medium)).width + 5)
            make.centerY.equalTo(self.soonMoneyView.topLabel)
            make.width.equalTo(3.5)
            make.height.equalTo(7)
        }
        // balanceMoneyView
        mainView.addSubview(self.balanceMoneyView)
        self.balanceMoneyView.isUserInteractionEnabled = false
        self.balanceMoneyView.topLabel.set(text: "资产余额(FIL)", font: UIFont.pingFangSCFont(size: 13, weight: .regular), textColor: UIColor(hex: 0x666666), alignment: .left)
        self.balanceMoneyView.bottomLabel.set(text: "0.00", font: UIFont.pingFangSCFont(size: 16, weight: .regular), textColor: UIColor.init(hex: 0x333333), alignment: .left)
        self.balanceMoneyView.snp.makeConstraints { (make) in
            make.left.equalTo(self.soonMoneyView.snp.right).offset(5)
            make.width.equalTo(self.itemMaxWidth)
            make.bottom.equalTo(self.soonMoneyView.snp.bottom)
        }
        self.balanceMoneyView.bottomLabel.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(self.balanceMoneyView.topLabel.snp.centerY).offset(21)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        let balanceMoneyMoreIcon = UIImageView()
        mainView.addSubview(balanceMoneyMoreIcon)
        balanceMoneyMoreIcon.image = UIImage.init(named: "IMG_equip_next_black")
        balanceMoneyMoreIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self.balanceMoneyView.topLabel.snp.left).offset("资产余额(FIL)".size(maxSize: CGSize.max, font: UIFont.pingFangSCFont(size: 13, weight: .medium)).width + 5)
            make.centerY.equalTo(self.balanceMoneyView.topLabel)
            make.width.equalTo(3.5)
            make.height.equalTo(7)
        }
    }
}

// MARK: - Event Function
extension MineHomeIncomeInfoItemView {
    fileprivate func setupModel(_ model: WalletAllInfoModel?) {
        guard let model = model else {
            return
        }
        self.bgImgView.image = model.bgImage

        self.totalMoneyView.topLabel.text = "\(model.currency.uppercased())累计收入"
        self.totalMoneyView.bottomLabel.text = model.income.decimalProcess(digits: 8)

        self.soonMoneyView.topLabel.text = "可提现余额(\(model.currency.uppercased()))"
        self.soonMoneyView.bottomLabel.text = (model.currency == "fil" || model.currency == "bzz") ? model.withdrawable.decimalProcess(digits: 8) : model.balance.decimalProcess(digits: 8)

        self.balanceMoneyView.topLabel.text = "资产余额(\(model.currency.uppercased()))"
        self.balanceMoneyView.bottomLabel.text = model.balance.decimalProcess(digits: 8)
    }
}
