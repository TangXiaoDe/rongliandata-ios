//
//  WalletBalanceProgressView.swift
//  JXProject
//
//  Created by zhaowei on 2020/10/21.
//  Copyright © 2020 ChainOne. All rights reserved.
//

import UIKit

/// 进度视图
class WalletBalanceProgressView: UIView {

    // MARK: - Internal Property

    let mainView: UIView = UIView()
    let progressView: UIView = UIView()

    // MARK: - Private Property

    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
        self.initialUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialUI()
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension WalletBalanceProgressView {
    class func loadXib() -> WalletBalanceProgressView? {
        return Bundle.main.loadNibNamed("WalletBalanceProgressView", owner: nil, options: nil)?.first as? WalletBalanceProgressView
    }

    /// 进度设置
    func setProgress(_ progress: Int, count: Int) -> Void {
        var multipliedBy: CGFloat = CGFloat(progress) / CGFloat(count)
        multipliedBy = min(1.0, multipliedBy)
        multipliedBy = max(0, multipliedBy)
//        // update崩溃，待研究
//        self.progressView.snp.updateConstraints { (make) in
//            make.width.equalTo(self).multipliedBy(multipliedBy)
//        }
        self.progressView.snp.remakeConstraints { (make) in
            make.leading.top.bottom.equalTo(self)
            make.width.equalTo(self).multipliedBy(multipliedBy)
        }
    }
    /// 进度设置
    func setProgressBili(_ bili: CGFloat) -> Void {
        self.progressView.snp.remakeConstraints { (make) in
            make.leading.top.bottom.equalTo(self)
            make.width.equalTo(self).multipliedBy(bili)
        }
        self.layoutIfNeeded()
    }

}

// MARK: - LifeCircle Function
extension WalletBalanceProgressView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension WalletBalanceProgressView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = UIColor.init(hex: 0xFFFFFF)
        mainView.set(cornerRadius: 2)
        // 1. progressView
        mainView.addSubview(progressView)
        self.progressView.backgroundColor = UIColor.init(hex: 0x4444FF)
        self.progressView.set(cornerRadius: 2)
        progressView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(self)
            make.width.equalTo(self).multipliedBy(0)
        }
    }

}
// MARK: - Private UI Xib加载后处理
extension WalletBalanceProgressView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension WalletBalanceProgressView {

}

// MARK: - Event Function
extension WalletBalanceProgressView {

}

// MARK: - Extension Function
extension WalletBalanceProgressView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension WalletBalanceProgressView {

}
