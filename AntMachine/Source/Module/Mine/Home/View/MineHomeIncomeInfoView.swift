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
    func incomeInfoView(_ view: MineHomeIncomeInfoView, clickAllIncomeControl: UIControl) -> Void
    //点击单个
    func incomeInfoView(_ view: MineHomeIncomeInfoView, clickItemControl: UIControl) -> Void
}

class MineHomeIncomeInfoView: UIControl {

    // MARK: - Internal Property
    let viewWidth: CGFloat
    static let topHeight: CGFloat = 50
    static let viewHeight: CGFloat = 125
    
    var model: AssetInfoModel? {
        didSet {
            self.setupModel(model)
        }
    }
    weak var delegate: MineHomeIncomeInfoViewProtocol?

    fileprivate let mainView: UIView = UIView()
    fileprivate let topView: UIControl = UIControl()
    fileprivate let myIncomeLabel: UILabel = UILabel()
    fileprivate let allIncomeBtn: UIButton = UIButton(type: .custom)

    fileprivate let bottomView: UIView = UIView()
    
    fileprivate let itemTagBase: Int = 250
    /// 待结算
    fileprivate var withdrawMoneyView: TopTitleBottomTitleControl!
    /// 可提现
    fileprivate var soonMoneyView: TopTitleBottomTitleControl!
    /// 累计收益
    fileprivate var totalMoneyView: TopTitleBottomTitleControl!
    
    fileprivate let bottomMargin: CGFloat = 15
    
    fileprivate let lrMargin: CGFloat = 15

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
        let topViewH: CGFloat = MineHomeIncomeInfoView.topHeight
        let bottomViewH: CGFloat = MineHomeIncomeInfoView.viewHeight - MineHomeIncomeInfoView.topHeight
        // 1. topView
        mainView.addSubview(self.topView)
        self.initialTopView(self.topView)
        self.topView.addTarget(self, action: #selector(myIncomeControlClick(_:)), for: .touchUpInside)
        self.topView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(topViewH)
        }
        self.topView.addLineWithSide(.inBottom, color: UIColor(hex: 0xe2e2e2), thickness: 0.5, margin1: lrMargin, margin2: lrMargin)
        // 2. bottomView
        mainView.addSubview(self.bottomView)
        self.initialBottomView(self.bottomView)
        self.bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom)
            make.height.equalTo(bottomViewH)
        }
    }
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        // 1. myIncomeLabel
        topView.addSubview(self.myIncomeLabel)
        self.myIncomeLabel.set(text: "我的收益", font: UIFont.systemFont(ofSize: 15), textColor: UIColor(hex: 0x333333))
        self.myIncomeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(self.lrMargin)
        }
        // 2. allIncomeBtn
        topView.addSubview(self.allIncomeBtn)
        self.allIncomeBtn.contentHorizontalAlignment = .right
        self.allIncomeBtn.addTarget(self, action: #selector(allIncomeBtnClick(_:)), for: .touchUpInside)
        self.allIncomeBtn.set(title: nil, titleColor: UIColor.init(hex: 0x333333), for: .normal)
        self.allIncomeBtn.set(font: UIFont.systemFont(ofSize: 12))
        self.allIncomeBtn.isUserInteractionEnabled = false
        self.allIncomeBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-lrMargin)
        }
        // allIncomeBtnRightIcon
        let accessory: UIImage? = UIImage(named: "IMG_common_detail")
        let accessorySize: CGSize = accessory?.size ?? CGSize.zero
        let accessoryView: UIImageView = UIImageView(image: accessory)
        self.allIncomeBtn.addSubview(accessoryView)
        accessoryView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(accessorySize)
        }
        self.allIncomeBtn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: accessorySize.width + 5)
    }
    fileprivate func initialBottomView(_ bottomView: UIView) -> Void {
//        let items: [String] = ["待结算", "可提现", "累计收益"]
        let items: [String] = ["可提现", "累计收益"]
        // MARK: - TODO item布局应重新划分，主要是item的宽度计算问题
        let itemMaxW: CGFloat = CGFloat(Int((self.viewWidth - lrMargin * 2.0) / CGFloat(items.count)))
        let itemWidth: CGFloat = 54
        for (index, item) in items.enumerated() {
            let itemView: TopTitleBottomTitleControl = TopTitleBottomTitleControl()
            itemView.topLabel.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(itemView.snp.centerY).offset(-2)
                make.left.right.equalToSuperview()
            }
            itemView.bottomLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(itemView.topLabel.snp.bottom).offset(0)
                make.centerX.equalToSuperview()
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            itemView.bottomLabel.text = item
            itemView.topLabel.textColor = AppColor.themeYellow
            itemView.topLabel.font = UIFont.pingFangSCFont(size: 18, weight: .medium)
            itemView.bottomLabel.textColor = UIColor.init(hex: 0x333333)
            itemView.bottomLabel.textAlignment = .center
            itemView.addTarget(self, action: #selector(mineIncomeBtnClick(_:)), for: .touchUpInside)
            bottomView.addSubview(itemView)
            itemView.tag = index + self.itemTagBase
            itemView.snp.makeConstraints { (make) in
                make.width.lessThanOrEqualTo(itemMaxW)
                make.width.greaterThanOrEqualTo(itemWidth)
                make.height.equalTo(60)
                //make.top.equalToSuperview()
                make.centerY.equalToSuperview()
                let centerXMargin: CGFloat = lrMargin + itemMaxW * (CGFloat(index) + 0.5)
                make.centerX.equalTo(bottomView.snp.leading).offset(centerXMargin)
            }
        }
//        self.soonMoneyView = (bottomView.viewWithTag(self.itemTagBase + 0) as! TopTitleBottomTitleControl)
        self.withdrawMoneyView = (bottomView.viewWithTag(self.itemTagBase + 0) as! TopTitleBottomTitleControl)
        self.totalMoneyView = (bottomView.viewWithTag(self.itemTagBase + 1) as! TopTitleBottomTitleControl)
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
    fileprivate func setupModel(_ model: AssetInfoModel?) -> Void {
        guard let model = model else {
            return
        }
        /// 可提现
//        var withdrawAtt = NSAttributedString.textAttTuples()
//        withdrawAtt.append((str: "可提现", font: UIFont.pingFangSCFont(size: 12, weight: .regular), color: AppColor.mainText))
//        withdrawAtt.append((str: "(CNY)", font: UIFont.pingFangSCFont(size: 12, weight: .regular), color: UIColor.init(hex: 0x999999)))
//        self.withdrawMoneyView.bottomLabel.attributedText = NSAttributedString.attribute(withdrawAtt)
//        self.withdrawMoneyView.topLabel.text = model.balance.decimalProcess(digits: 2)
//        /// 累计收益
//        var totalAtt = NSAttributedString.textAttTuples()
//        totalAtt.append((str: "累计收益", font: UIFont.pingFangSCFont(size: 12, weight: .regular), color: AppColor.mainText))
//        totalAtt.append((str: "(CNY)", font: UIFont.pingFangSCFont(size: 12, weight: .regular), color: UIColor.init(hex: 0x999999)))
//        self.totalMoneyView.bottomLabel.attributedText = NSAttributedString.attribute(totalAtt)
//        self.totalMoneyView.topLabel.text = model.total.decimalProcess(digits: 2)

        self.layoutIfNeeded()
    }
}

// MARK: - Event Function
extension MineHomeIncomeInfoView {
    /// 我的收入按钮点击
    @objc fileprivate func myIncomeControlClick(_ control: UIControl) -> Void {
        self.delegate?.incomeInfoView(self, clickAllIncomeControl: control)
    }
    /// 全部收入按钮点击
    @objc fileprivate func allIncomeBtnClick(_ button: UIButton) -> Void {
        self.delegate?.incomeInfoView(self, clickAllIncomeControl: button)
    }

    /// 我的收入点击响应
    @objc fileprivate func mineIncomeBtnClick(_ control: UIControl) {
        self.delegate?.incomeInfoView(self, clickItemControl: control)
    }
}


// MARK: - Extension Function
