//
//  MineHomeIncomeInfoItemView.swift
//  AntClusterB
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

    fileprivate let lrMargin: CGFloat = 12
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
        mainView.backgroundColor = UIColor.white
        mainView.set(cornerRadius: 10)
        mainView.addSubview(self.bgImgView)
//        self.bgImgView.isUserInteractionEnabled = false
        self.bgImgView.image = UIImage.init(named: "IMG_mine_fil_bg")
        self.bgImgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
//        self.bgImgView.isUserInteractionEnabled = true
//        self.bgImgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(allIncomeBtnClick(_:))))

        mainView.addSubview(self.totalMoneyView)
        self.totalMoneyView.isUserInteractionEnabled = false
        self.totalMoneyView.topLabel.set(text: "FIL累计收入", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.white, alignment: .left)
        self.totalMoneyView.bottomLabel.set(text: "0.00", font: UIFont.pingFangSCFont(size: 28, weight: .regular), textColor: UIColor.init(hex: 0xFFFFFF), alignment: .left)
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
        self.moreIconView.image = UIImage.init(named: "IMG_mine_fil_arrow_go")
        self.moreIconView.snp.makeConstraints { (make) in
            make.left.equalTo(self.totalMoneyView.topLabel.snp.right).offset(6)
            make.centerY.equalTo(self.totalMoneyView.topLabel)
            make.width.equalTo(4)
            make.height.equalTo(8)
        }
    
        // soonMoneyView
        mainView.addSubview(self.soonMoneyView)
        self.soonMoneyView.isUserInteractionEnabled = false
        self.soonMoneyView.topLabel.set(text: "可提现余额(FIL)", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.white, alignment: .left)
        self.soonMoneyView.bottomLabel.set(text: "0.00", font: UIFont.pingFangSCFont(size: 18, weight: .regular), textColor: UIColor.init(hex: 0xFFFFFF), alignment: .left)
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
        // balanceMoneyView
        mainView.addSubview(self.balanceMoneyView)
        self.balanceMoneyView.isUserInteractionEnabled = false
        self.balanceMoneyView.topLabel.set(text: "资产余额(FIL)", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.white, alignment: .left)
        self.balanceMoneyView.bottomLabel.set(text: "0.00", font: UIFont.pingFangSCFont(size: 18, weight: .regular), textColor: UIColor.init(hex: 0xFFFFFF), alignment: .left)
        self.balanceMoneyView.snp.makeConstraints { (make) in
            make.left.equalTo(self.soonMoneyView.snp.right)
            make.width.equalTo(self.itemMaxWidth)
            make.bottom.equalTo(self.soonMoneyView.snp.bottom)
        }
        self.balanceMoneyView.bottomLabel.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(self.balanceMoneyView.topLabel.snp.centerY).offset(21)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Event Function
extension MineHomeIncomeInfoItemView {
    /// 全部收入按钮点击
    @objc fileprivate func allIncomeBtnClick(_ tapGR: UITapGestureRecognizer) {
        guard  let view = tapGR.view else {
            return
        }
        
//        self.delegate?.incomeInfoView(self, clickAllIncomeControl: view)
    }
    
    fileprivate func setupModel(_ model: WalletAllInfoModel?) {
        self.bgImgView.image = UIImage(named: model?.currency == "fil" ? "IMG_mine_fil_bg" : "IMG_mine_xch_bg")

        self.totalMoneyView.topLabel.text = model?.currency == "fil" ? "FIL累计收入" : "XCH累计收入"
        self.totalMoneyView.bottomLabel.text = model!.income.decimalProcess(digits: 4)

        self.soonMoneyView.topLabel.text = model?.currency == "fil" ? "可提现余额(FIL)" : "可提现余额(XCH)"
        self.soonMoneyView.bottomLabel.text = model?.currency == "fil" ? model!.withdrawable.decimalProcess(digits: 4) : model!.expend.decimalProcess(digits: 4)

        self.balanceMoneyView.topLabel.text = model?.currency == "fil" ? "资产余额(FIL)" : "资产余额(XCH)"
        self.balanceMoneyView.bottomLabel.text = model!.balance.decimalProcess(digits: 4)
    }
}
