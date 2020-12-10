//
//  RechargeHomeController.swift
//  MTProject
//
//  Created by zhaowei on 2020/11/3.
//  Copyright © 2020 ChainOne. All rights reserved.
//

import UIKit
/// 充值界面
class RechargeHomeController: BaseViewController {
    fileprivate let currency: String
    fileprivate let address: String
    // MARK: - Private Property
    fileprivate let mainView: UIView = UIView()
    fileprivate let bottomView: UIView = UIView()
    // center
    fileprivate let qrCodeTitleLabel: UILabel = UILabel()
    fileprivate let qrCodeImageView: UIImageView = UIImageView()
    fileprivate let qrCodeNumLabel: UILabel = UILabel()
    fileprivate let qrCodePromptLabel: UILabel = UILabel()
    fileprivate let qrCodeCopyBtn: UIButton = UIButton.init(type: .custom)

    fileprivate let topMargin: CGFloat = 9
    fileprivate let lrMargin: CGFloat = 15
    fileprivate var limitSingleMaxNum: Double = 0

    fileprivate let qrCodeSize: CGSize = CGSize.init(width: 144, height: 144)
    fileprivate let copyBtnSize: CGSize = CGSize.init(width: 200, height: 44)
    // MARK: - Initialize Function
    init(currency: String, address: String) {
        self.currency = currency
        self.address = address
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Function

// MARK: - LifeCircle Function
extension RechargeHomeController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI
extension RechargeHomeController {
    fileprivate func initialUI() -> Void {
        self.title = "充币"
        self.view.backgroundColor = AppColor.pageBg
        // mainView - 整体布局，便于扩展，特别是针对分割、背景色、四周间距
        self.view.addSubview(mainView)
        self.initialMainView(self.mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.topMargin)
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
        }
    }

    // 主视图布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = UIColor.white
        mainView.set(cornerRadius: 10)
        mainView.addSubview(self.qrCodeTitleLabel)
        self.qrCodeTitleLabel.text = "扫描二维码，转入创豆"
        self.qrCodeTitleLabel.font = UIFont.pingFangSCFont(size: 16, weight: .regular)
        self.qrCodeTitleLabel.textColor = AppColor.mainText
        self.qrCodeTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(mainView.snp.top).offset(33)
        }
        mainView.addSubview(self.qrCodeImageView)
        self.qrCodeImageView.set(cornerRadius: 0)
        self.qrCodeImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(61)
            make.size.equalTo(self.qrCodeSize)
        }
        mainView.addSubview(self.qrCodePromptLabel)
        self.qrCodePromptLabel.set(text: "钱包地址", font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: UIColor.init(hex: 0x999999), alignment: .center)
        self.qrCodePromptLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.qrCodeImageView.snp.bottom).offset(20)
        }
        mainView.addSubview(self.qrCodeNumLabel)
        self.qrCodeNumLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 13, weight: .medium), textColor: AppColor.mainText, alignment: .center)
        self.qrCodeNumLabel.numberOfLines = 0
        self.qrCodeNumLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(39)
            make.trailing.equalToSuperview().offset(-39)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.qrCodePromptLabel.snp.bottom).offset(15)
        }

        mainView.addSubview(self.qrCodeCopyBtn)
        self.qrCodeCopyBtn.backgroundColor = AppColor.theme
        self.qrCodeCopyBtn.set(title: "复制地址", titleColor: UIColor.white, for: .normal)
        self.qrCodeCopyBtn.set(font: UIFont.pingFangSCFont(size: 18, weight: .medium), cornerRadius: self.copyBtnSize.height/2, borderWidth: 0, borderColor: UIColor.clear)
        self.qrCodeCopyBtn.addTarget(self, action: #selector(qrCodeCopyBtnClick), for: .touchUpInside)
        self.qrCodeCopyBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.qrCodeNumLabel.snp.bottom).offset(35)
            make.bottom.equalToSuperview().offset(-50)
            make.size.equalTo(self.copyBtnSize)
        }
    }

}

// MARK: - Data(数据处理与加载)
extension RechargeHomeController {
    // MARK: - Private  数据处理与加载
    fileprivate func initialDataSource() -> Void {
        self.qrCodeTitleLabel.text = "扫描二维码，转入\(self.currency.uppercased())"
        // demo
        self.qrCodeNumLabel.text = self.address
        let QRImage = self.address.generateQRCode(size: 245.0, logo: self.qrCodeImageView.image)
        self.qrCodeImageView.image = QRImage
        
//        AssetNetworkManager.getReceiptList { [weak self](status, msg, models) in
//            guard let `self` = self else {
//                return
//            }
//            guard status, let models = models else {
//                Toast.showToast(title: msg)
//                return
//            }
//            for(_, model) in models.enumerated() {
//                if model.coinValue == self.currency {
//                    self.qrCodeNumLabel.text = model.number
//                    let QRImage = model.number.generateQRCode(size: 245.0, logo: self.qrCodeImageView.image)
//                    self.qrCodeImageView.image = QRImage
//                }
//            }
//        }
    }
}

// MARK: - Request(网络请求)
extension RechargeHomeController {

}

// MARK: - Event
extension RechargeHomeController {
    //  复制
    @objc func qrCodeCopyBtnClick(_ btn: UIButton) {
        guard let key = self.qrCodeNumLabel.text else {
            return
        }
        AppUtil.copyToPasteProcess(key, indicatorMsg: "复制成功")
    }
}
