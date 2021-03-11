//
//  WalletBalanceItem.swift
//  JXProject
//
//  Created by zhaowei on 2020/10/21.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  其他余额

enum WalletBalanceType {
    case canUse
    case mortgage
    case lockUp
    case security
    
    var icon: UIImage {
        var icon = UIImage()
        switch self {
        case .canUse:
            icon = UIImage.init(named: "IMG_wallet_icon_ky") ?? UIImage()
        case .mortgage:
            icon = UIImage.init(named: "IMG_wallet_icon_dy") ?? UIImage()
        case .lockUp:
            icon = UIImage.init(named: "IMG_wallet_icon_sc") ?? UIImage()
        case .security:
            icon = UIImage.init(named: "IMG_qb_fil_bzj") ?? UIImage()
        }
        return icon
    }
    var progressBgColor: UIColor {
        var progressColor = UIColor.init(hex: 0x000000)
        switch self {
        case .canUse:
            progressColor = UIColor.init(hex: 0xF0F4FF)
        case .mortgage:
            progressColor = UIColor.init(hex: 0xF3EFFF)
        case .lockUp:
            progressColor = UIColor.init(hex: 0xEEF1FF)
        case .security:
            progressColor = UIColor.init(hex: 0xEEF1FF)
        }
        return progressColor
    }
    var progressColor: UIColor {
        var progressColor = UIColor.init(hex: 0x000000)
        switch self {
        case .canUse:
            progressColor = UIColor.init(hex: 0x3E5DBD)
        case .mortgage:
            progressColor = UIColor.init(hex: 0x9E79FF)
        case .lockUp:
            progressColor = UIColor.init(hex: 0x7C8EF3)
        case .security:
            progressColor = UIColor.init(hex: 0x7C8EF3)
        }
        return progressColor
    }
    var title: String {
        var title = ""
        switch self {
        case .canUse:
            title = "可用金额(FIL)"
        case .mortgage:
            title = "抵押金额(FIL)"
        case .lockUp:
            title = "锁仓金额(FIL)"
        case .security:
            title = "安全保障金(FIL)"
        }
        return title
    }
}

import UIKit

class WalletBalanceItem: UIView {

    // MARK: - Internal Property
    static let viewHeight: CGFloat = 60
    
    var model: WalletFilInfoModel? {
        didSet {
            self.setupWithModel(model)
        }
    }

    // MARK: - Private Property
    fileprivate let type: WalletBalanceType

    fileprivate let mainView: UIView = UIView()
    
    fileprivate let iconImgView: UIImageView = UIImageView()
    fileprivate let titleLabel: UILabel = UILabel()
    fileprivate let progressView: WalletBalanceProgressView = WalletBalanceProgressView()
    fileprivate let valueLabel: UILabel = UILabel()
    
    fileprivate let lrMargin: CGFloat = 15
    fileprivate let iconWH: CGFloat = 43
    fileprivate let titleLeftMargin: CGFloat = 10
    fileprivate let progressViewHeight: CGFloat = 5
    fileprivate let progressViewWidth: CGFloat = 94


    // MARK: - Initialize Function
    init(type: WalletBalanceType) {
        self.type = type
        super.init(frame: CGRect.zero)
        self.initialUI()
        self.setUpAsDemo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Internal Function
extension WalletBalanceItem {

}

// MARK: - LifeCircle Function
extension WalletBalanceItem {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension WalletBalanceItem {

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
        // 0.iconImgView
        mainView.addSubview(self.iconImgView)
        self.iconImgView.set(cornerRadius: 0)
        self.iconImgView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.width.height.equalTo(self.iconWH)
            make.centerY.equalToSuperview()
        }
        // 1.titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: UIColor.init(hex: 0x333333))
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.iconImgView.snp.right).offset(self.titleLeftMargin)
        }
        // 2.progressView
        mainView.addSubview(self.progressView)
        self.progressView.isHidden = true
        self.progressView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.iconImgView.snp.bottom).offset(-5)
            make.left.equalTo(self.titleLabel)
            make.height.equalTo(self.progressViewHeight)
            make.width.equalTo(self.progressViewWidth)
        }
        // 3.valueLabel
        mainView.addSubview(self.valueLabel)
        self.valueLabel.set(text: "0.00", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor.init(hex: 0x333333))
        self.valueLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-lrMargin)
        }
    }


}
// MARK: - Private UI Xib加载后处理
extension WalletBalanceItem {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension WalletBalanceItem {
    func setUpAsDemo() {
        self.iconImgView.image = self.type.icon
        self.titleLabel.text = self.type.title
        self.progressView.mainView.backgroundColor = self.type.progressBgColor
        self.progressView.progressView.backgroundColor = self.type.progressColor
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: WalletFilInfoModel?) -> Void {
        guard let model = model else {
            return
        }
        switch self.type {
        case .canUse:
            self.valueLabel.text = model.canUse_balance.decimalProcess(digits: 8)
            self.progressView.setProgressBili(model.canUse_bili)
        case .mortgage:
            self.valueLabel.text = model.pawn.decimalProcess(digits: 8)
            self.progressView.setProgressBili(model.pawn_bili)
        case .lockUp:
            self.valueLabel.text = model.lock.decimalProcess(digits: 8)
            self.progressView.setProgressBili(model.lock_bili)
        case .security:
            self.valueLabel.text = model.security.decimalProcess(digits: 8)
            self.progressView.setProgressBili(model.lock_bili)
        }
        
    }
}

// MARK: - Event Function
extension WalletBalanceItem {

}

// MARK: - Extension Function
extension WalletBalanceItem {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension WalletBalanceItem {

}
