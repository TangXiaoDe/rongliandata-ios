//
//  MineHomeIncomeInfoView.swift
//  LianYouPin
//
//  Created by zhaowei on 2020/1/8.
//  Copyright © 2020 COMC. All rights reserved.
//
// 我的主页收益view

import Foundation
import UIKit

protocol MineHomeIncomeInfoViewProtocol: class {
    //点击全部
    func incomeInfoView(_ view: MineHomeIncomeInfoView, clickAllIncomeControl: UIView) -> Void
}

class MineHomeIncomeInfoView: UIControl {

    static var viewHeight: CGFloat {
        return CGSize.init(width: 351, height: 140).scaleAspectForWidth(kScreenWidth - 2 * 12).height
    }
    // MARK: - Internal Property
    let viewWidth: CGFloat
    
    var model: WalletFilInfoModel? {
        didSet {
            self.setupModel(model)
        }
    }
    weak var delegate: MineHomeIncomeInfoViewProtocol?

    fileprivate let mainView: UIView = UIView()
    fileprivate let bgImgView: UIImageView = UIImageView()
    /// 累计收益
    fileprivate var totalMoneyView: TopTitleBottomTitleControl = TopTitleBottomTitleControl()
    /// 可提现
    fileprivate var soonMoneyView: TopTitleBottomTitleControl = TopTitleBottomTitleControl()
    /// 资产余额
    fileprivate var balanceMoneyView: TopTitleBottomTitleControl = TopTitleBottomTitleControl()
    
    fileprivate let moreIconView = UIImageView()

    
    fileprivate let bottomMargin: CGFloat = 15
    
    fileprivate let lrMargin: CGFloat = 12
    
    fileprivate let bgViewSize: CGSize = CGSize.init(width: 351, height: 140).scaleAspectForWidth(kScreenWidth - 2 * 12)
    
    fileprivate var itemMaxWidth: CGFloat {
        return (kScreenWidth - 2 * self.lrMargin)/3
    }

    // MARK: - Private Property

    // MARK: - Initialize Function
    init(viewWidth: CGFloat) {
        self.viewWidth = viewWidth
        super.init(frame: CGRect.zero)
        self.initialUI()
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension MineHomeIncomeInfoView {

}

// MARK: - LifeCircle Function
extension MineHomeIncomeInfoView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension MineHomeIncomeInfoView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = UIColor.white
        mainView.set(cornerRadius: 10)
        mainView.addSubview(self.bgImgView)
        self.bgImgView.isUserInteractionEnabled = false
        self.bgImgView.image = UIImage.init(named: "IMG_mine_fil_bg")
        self.bgImgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.bgImgView.isUserInteractionEnabled = true
        self.bgImgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(allIncomeBtnClick(_:))))

        mainView.addSubview(self.totalMoneyView)
        self.totalMoneyView.isUserInteractionEnabled = false
        self.totalMoneyView.topLabel.set(text: "FIL累计收入", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0xDBEBFF), alignment: .left)
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
        self.soonMoneyView.topLabel.set(text: "可提现余额(FIL)", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0xDBEBFF), alignment: .left)
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
        self.balanceMoneyView.topLabel.set(text: "资产余额(FIL)", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0xDBEBFF), alignment: .left)
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
// MARK: - Private UI Xib加载后处理
extension MineHomeIncomeInfoView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension MineHomeIncomeInfoView {
    fileprivate func setupModel(_ model: WalletFilInfoModel?) -> Void {
        guard let model = model else {
            return
        }
        self.totalMoneyView.bottomLabel.text = model.income.decimalProcess(digits: 4)
        self.soonMoneyView.bottomLabel.text = model.withdrawable.decimalProcess(digits: 4)
        self.balanceMoneyView.bottomLabel.text = model.fil_balance.decimalProcess(digits: 4)
    }
}

// MARK: - Event Function
extension MineHomeIncomeInfoView {
    /// 全部收入按钮点击
    @objc fileprivate func allIncomeBtnClick(_ tapGR: UITapGestureRecognizer) -> Void {
        guard  let view = tapGR.view else {
            return
        }
        self.delegate?.incomeInfoView(self, clickAllIncomeControl: view)
    }
}


// MARK: - Extension Function
