//
//  AssetHomeBottomView.swift
//  MallProject
//
//  Created by zhaowei on 2020/11/3.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit

protocol AssetHomeBottomViewProtocol: class {
    /// 提币按钮点击回调
    func bottomView(_ bottomView: AssetHomeBottomView, didClickedWithdraw withdrawView: UIButton, with model: AssetInfoModel) -> Void
    /// 充币按钮点击回调
    func bottomView(_ bottomView: AssetHomeBottomView, didClickedRecharge rechargeView: UIButton, with model: AssetInfoModel) -> Void
    /// 兑换按钮点击回调
    func bottomView(_ bottomView: AssetHomeBottomView, didClickedExchange exchangeView: UIButton, with model: AssetInfoModel) -> Void
}

class AssetHomeBottomView: UIView {

    static let viewHeight: CGFloat = 49

    var model: AssetInfoModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    /// 回调
    weak var delegate: AssetHomeBottomViewProtocol?

    fileprivate let menuContainer: UIView = UIView.init()
    fileprivate let rechargeBtn: GradientLayerButton = GradientLayerButton(type: .custom)
    fileprivate let withdrawalBtn: GradientLayerButton = GradientLayerButton(type: .custom)
    fileprivate let exchangeBtn: GradientLayerButton = GradientLayerButton(type: .custom)

    fileprivate let lrMargin: CGFloat = 12
    fileprivate var horMargin: CGFloat = 20

    fileprivate let btnH: CGFloat = 40

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
// MARK: - Private UI 手动布局
extension AssetHomeBottomView {
    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.backgroundColor = AppColor.pageBg
        self.addSubview(self.menuContainer)
        self.menuContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 1. rechargeBtn
        self.rechargeBtn.set(title: "充值", titleColor: UIColor.white, image: nil, bgImage: UIImage.imageWithColor(AppColor.theme), for: .normal)
        // 2. withdrawalBtn
        self.withdrawalBtn.set(title: "提币", titleColor: UIColor.white, image: nil, bgImage: UIImage.imageWithColor(AppColor.theme), for: .normal)
        // 3. withdrawalBtn
        self.exchangeBtn.set(title: "兑换", titleColor: UIColor.white, image: nil, bgImage: UIImage.imageWithColor(AppColor.theme), for: .normal)
    }

    fileprivate func setupMenuContainer(with currency: CurrencyType) -> Void {
        self.menuContainer.removeAllSubviews()
        self.rechargeBtn.snp.removeConstraints()
        self.withdrawalBtn.snp.removeConstraints()
        self.exchangeBtn.snp.removeConstraints()
        var btnWidth: CGFloat = 0
        var items: [GradientLayerButton] = []
        switch currency {
//        case .eth:
//            items = [self.withdrawalBtn, self.rechargeBtn]
//            self.horMargin = 20
//        case .btc:
//            items = [self.withdrawalBtn, self.rechargeBtn]
//            self.horMargin = 20
        case .fil:
            items = [self.withdrawalBtn, self.rechargeBtn]
            self.horMargin = 20
        case .usdt:
            items = [self.withdrawalBtn, self.rechargeBtn]
//        case .chia:
//            items = []
//            self.horMargin = 20
        case .cny:
            items = [self.withdrawalBtn]
            self.horMargin = 10
            self.withdrawalBtn.set(title: "提现", titleColor: UIColor.white, image: nil, bgImage: UIImage.imageWithColor(AppColor.theme), for: .normal)
        default:
            break
        }
        // 按钮宽度计算
        btnWidth = (kScreenWidth - 2 * self.lrMargin - CGFloat(items.count - 1) * self.horMargin) / CGFloat(items.count)
        var leftView: UIView = self.menuContainer
        for(index, itemView) in items.enumerated() {
            self.menuContainer.addSubview(itemView)
            itemView.set(font: UIFont.pingFangSCFont(size: 16, weight: .medium), cornerRadius: self.btnH * 0.5, borderWidth: 0, borderColor: UIColor.clear)
            itemView.addTarget(self, action: #selector(itemViewClick(_:)), for: .touchUpInside)
            itemView.gradientLayer.frame = CGRect.init(x: 0, y: 0, width: btnWidth, height: self.btnH)
            itemView.isEnabled = true
            itemView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.height.equalTo(self.btnH)
                make.width.equalTo(btnWidth)
                if index == 0 {
                    make.leading.equalToSuperview().offset(self.lrMargin)
                } else {
                    make.leading.equalTo(leftView.snp.trailing).offset(self.horMargin)
                }
                if items.count - 1 == index {
                    make.trailing.equalToSuperview().offset(-self.lrMargin)
                }
            }
            leftView = itemView
        }
    }

}

// MARK: - Data Function
extension AssetHomeBottomView {
    /// 数据加载
    fileprivate func setupWithModel(_ model: AssetInfoModel?) -> Void {
        guard let model = model else {
            return
        }
        self.setupMenuContainer(with: model.currency)
        self.setNeedsLayout()
    }
}
// MARK: - Private event
extension AssetHomeBottomView {
    /// itemMenu点击
    @objc fileprivate func itemViewClick(_ button: UIButton) -> Void {
        guard let model = self.model else {
            return
        }
        switch button {
        case self.withdrawalBtn:
            self.delegate?.bottomView(self, didClickedWithdraw: button, with: model)
        case self.rechargeBtn:
            self.delegate?.bottomView(self, didClickedRecharge: button, with: model)
        case self.exchangeBtn:
            self.delegate?.bottomView(self, didClickedExchange: button, with: model)
        default:
            break
        }
    }
}
