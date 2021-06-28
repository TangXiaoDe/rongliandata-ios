//
//  WithdrawAddressBindResultController.swift
//  HuoTuiVideo
//
//  Created by 小唐 on 2020/7/6.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  提币地址绑定成功界面：绑定成功，3秒后自动返回

import UIKit
import ChainOneKit

class WithdrawAddressBindResultController: BaseViewController
{
    // MARK: - Internal Property
    
    // MARK: - Private Property
    
    fileprivate let resultView: UIView = UIView.init()
    fileprivate let resultIconView: UIImageView = UIImageView.init()
    fileprivate let resultTitleLabel: UILabel = UILabel.init()
    fileprivate let countdownLabel: UILabel = UILabel.init()
    
    fileprivate let iconSize: CGSize = CGSize.init(width: 97, height: 58)
    fileprivate let titleTopMargin: CGFloat = 20
    fileprivate let countdownTopMargin: CGFloat = 15 // 20
    
    /// 定时器相关
    fileprivate let maxLeftSecond: Int = 3
    fileprivate var leftSecond: Int = 60
    fileprivate var timer: Timer? = nil
    
    // MARK: - Initialize Function
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    deinit {
        self.stopTimer()
    }
    
    // MARK: Override Property
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle & Override Function
extension WithdrawAddressBindResultController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }
    
    /// 控制器的view将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    /// 控制器的view即将消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.startTimer()
        }
    }
    
}

// MARK: - UI
extension WithdrawAddressBindResultController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.init(hex: 0xF5F5F5)
        // navbar
        self.navigationItem.title = "绑定成功"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "IMG_navbar_back"), style: .plain, target: self, action: #selector(navLeftItemClick))
        // resultView
        self.view.addSubview(self.resultView)
        self.initialResultView(self.resultView)
        self.resultView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(0)
        }
    }
    fileprivate func initialResultView(_ resultView: UIView) -> Void {
        // 1. iconView
        resultView.addSubview(self.resultIconView)
        self.resultIconView.set(cornerRadius: 0)
        self.resultIconView.image = UIImage.init(named: "IMG_wallet_tixian_succese")
        self.resultIconView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.size.equalTo(self.iconSize)
        }
        // 2. titleLabel
        resultView.addSubview(self.resultTitleLabel)
        self.resultTitleLabel.set(text: "绑定成功", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: UIColor.init(hex: 0x333333), alignment: .center)
        self.resultTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.resultIconView.snp.bottom).offset(self.titleTopMargin)
        }
        // 3. countdownLabel
        resultView.addSubview(self.countdownLabel)
        self.countdownLabel.set(text: "\(self.maxLeftSecond)s后返回", font: UIFont.pingFangSCFont(size: 16), textColor: UIColor.init(hex: 0x333333), alignment: .center)
        self.countdownLabel.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
            make.top.equalTo(self.resultTitleLabel.snp.bottom).offset(self.countdownTopMargin)
        }
    }

}

// MARK: - Data(数据处理与加载)
extension WithdrawAddressBindResultController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        
    }

}

// MARK: - Event(事件响应)
extension WithdrawAddressBindResultController {
    @objc fileprivate func navLeftItemClick() -> Void {
        self.backProcess()
    }

}

// MARK: - Enter Page
extension WithdrawAddressBindResultController {
    /// 返回处理
    fileprivate func backProcess() -> Void {
        // 1. 优先处理通过present方式弹出的
        if let _ = self.navigationController?.presentingViewController {
            self.navigationController?.dismiss(animated: false, completion: nil)
            return
        }
        guard let childVCList = self.navigationController?.children else {
            return
        }
        // 2.2 判断指定界面push过来的
        for (_, childVC) in childVCList.reversed().enumerated() {
            // 集合：[MineHomeController/AssetDetailController
            if let childVC = childVC as? WalletDetailHomeController {
                self.navigationController?.popToViewController(childVC, animated: true)
                return
            }
            if let childVC = childVC as? WalletHomeController {
                self.navigationController?.popToViewController(childVC, animated: true)
                return
            }
            if let childVC = childVC as? AssetHomeController {
                self.navigationController?.popToViewController(childVC, animated: true)
                return
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }

}

// MARK: - Notification
extension WithdrawAddressBindResultController {
    
}

// MARK: - Extension Function
extension WithdrawAddressBindResultController {
    
}

// MARK: - Timer
extension WithdrawAddressBindResultController {
    /// 开启计时器
    fileprivate func startTimer() -> Void {
        // 相关控件设置
        self.countdownLabel.text = "\(self.maxLeftSecond)" + "s后返回"
        self.leftSecond = self.maxLeftSecond
        // 开启倒计时
        self.stopTimer()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(countdown), object: nil)
        let timer = XDPackageTimer.timerWithInterval(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        timer.fire()
        self.timer = timer
    }
    /// 停止计时器
    fileprivate func stopTimer() -> Void {
        self.timer?.invalidate()
        self.timer = nil
    }
    /// 计时器回调 - 倒计时
    @objc fileprivate func countdown() -> Void {
        if self.leftSecond - 1 > 0 {
            self.leftSecond -= 1
            self.countdownLabel.text = "\(self.leftSecond)" + "s后返回"
        } else {
            self.stopTimer()
            self.backProcess()
        }
    }
}

// MARK: - Delegate Function

// MARK: - <>
extension WithdrawAddressBindResultController {
    
}

