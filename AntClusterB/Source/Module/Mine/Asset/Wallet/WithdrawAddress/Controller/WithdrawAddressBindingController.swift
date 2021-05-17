//
//  WithdrawAddressBindingController.swift
//  HuoTuiVideo
//
//  Created by 小唐 on 2020/7/6.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  提币地址绑定界面

import UIKit
import TZImagePickerController
import YYKit

class WithdrawAddressBindingController: BaseViewController {
    // MARK: - Internal Property
    fileprivate let assetModel: AssetInfoModel
    fileprivate let currencyType: AssetCurrencyType
    // MARK: - Private Property
    
    fileprivate let scrollView: UIScrollView = UIScrollView.init()
    fileprivate let headerView: WithdrawAddressBindingHeaderView = WithdrawAddressBindingHeaderView.init()
    fileprivate let doneBtn: GradientLayerButton = GradientLayerButton.init(type: .custom)
    //fileprivate let tipsLabel: UILabel = UILabel.init()
    fileprivate let tipsLabel: YYLabel = YYLabel.init()
    
    fileprivate let lrMargin: CGFloat = 15
    fileprivate let topMargin: CGFloat = 12
    
    fileprivate let doneBtnHeight: CGFloat = 44
    fileprivate let doneBtnTopMargin: CGFloat = 20
    fileprivate let tipsTopMargin: CGFloat = 20
    
    fileprivate var currentText: String?
    fileprivate var currentAddressText: String?
    
    fileprivate var selectedQrCode: (image: UIImage, uploaded: PublishImageModel)?
    
    
    // MARK: - Initialize Function
    init(assetModel: AssetInfoModel) {
        self.assetModel = assetModel
        self.currencyType = assetModel.currencyType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Function

// MARK: - LifeCircle & Override Function
extension WithdrawAddressBindingController {
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

    
}

// MARK: - UI
extension WithdrawAddressBindingController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.pageBg
        // navbar
        self.navigationItem.title = "绑定提币地址-\(self.assetModel.title)"
        // scrollView
        self.view.addSubview(self.scrollView)
        self.initialScrollView(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialScrollView(_ scrollView: UIScrollView) -> Void {
        // scrollView
        scrollView.showsVerticalScrollIndicator = false
        // 1. headerView
        scrollView.addSubview(self.headerView)
        self.headerView.delegate = self
        self.headerView.set(cornerRadius: 10)
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.topMargin)
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.width.equalTo(kScreenWidth - self.lrMargin * 2.0)
        }
        // 3. tips
        scrollView.addSubview(self.tipsLabel)
        //self.tipsLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12), textColor: UIColor.init(hex: 0x999999))
        self.tipsLabel.font = UIFont.pingFangSCFont(size: 12)
        self.tipsLabel.textColor = UIColor.init(hex: 0x999999)
        self.tipsLabel.textContainerInset = UIEdgeInsets.zero
        self.tipsLabel.numberOfLines = 0
        self.tipsLabel.preferredMaxLayoutWidth = kScreenWidth - self.lrMargin * 2.0
        self.tipsLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.headerView.snp.bottom).offset(self.tipsTopMargin)
            make.bottom.lessThanOrEqualToSuperview().offset(-self.tipsTopMargin)
        }
        // tips
        //let tips: String = "温馨提示： \n地址绑定之后将不可更改，请仔细核对地址是否正确！ \n若有疑问请联系"
        //self.tipsLabel.text = tips
//        let tipsAttText: NSMutableAttributedString = NSMutableAttributedString.init()
//        tipsAttText.append(NSAttributedString.init(string: "温馨提示： \n地址绑定之后将不可更改，请仔细核对地址是否正确！\n若有疑问请联系", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(hex: 0x999999)]))
//        let kefuAttText: NSMutableAttributedString = NSMutableAttributedString.init()
//        kefuAttText.append(NSAttributedString.init(string: "客服", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(hex: 0x5CB3F5)]))
//        let kefuAttHighlight: YYTextHighlight = YYTextHighlight.init(backgroundColor: UIColor.clear)
//        kefuAttHighlight.tapAction = { (_ containerView: UIView, _ text: NSAttributedString, _ range: NSRange, _ rect: CGRect) in
//            DispatchQueue.main.async {
//                self.enterKefuPage()
//            }
//        }
//        kefuAttText.setTextHighlight(kefuAttHighlight, range: kefuAttText.rangeOfAll())
//        tipsAttText.append(kefuAttText)
//        self.tipsLabel.attributedText = tipsAttText
    }

}

// MARK: - Data(数据处理与加载)
extension WithdrawAddressBindingController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        
    }
}

// MARK: - Event(事件响应)
extension WithdrawAddressBindingController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /// 确定按钮点击
    @objc fileprivate func doneBtnClick(_ doneBtn: UIButton) -> Void {
        guard let address = self.headerView.address, let selectedQrcode = self.selectedQrCode else {
            return
        }
        // 1. 判断地址前缀是否以"0x"开头
//        if !address.hasPrefix("0x") && !address.hasPrefix("0X") {
//            Toast.showToast(title: "提现地址应以0x开头")
//            return
//        }
        self.withdrawAddressBindRequest(address: address, qrcode_filename: selectedQrcode.uploaded.filename)
    }

}

// MARK: - Enter Page
extension WithdrawAddressBindingController {
    /// 进入绑定成功界面
    fileprivate func enterBindResultPage() -> Void {
        let resultVC = WithdrawAddressBindResultController.init()
        self.enterPageVC(resultVC)
    }
    /// 进入客服界面
    fileprivate func enterKefuPage() -> Void {
//        let strUrl = UrlManager.kefuUrl
//        let webVC = XDWKWebViewController.init(type: XDWebViwSourceType.strUrl(strUrl: strUrl))
//        self.enterPageVC(webVC)
//        AppUtil.enterKefuContactPage()
    }

}

// MARK: - Notification
extension WithdrawAddressBindingController {
    
}

// MARK: - Extension Function
extension WithdrawAddressBindingController {
//    /// 绑定请求
//    fileprivate func withdrawAddressBindRequest(address: String, currency: String) -> Void {
//        self.view.isUserInteractionEnabled = false
//        AssetNetworkManager.bindWithdrawAddress(address: address, currency: currency) { [weak self](status, msg) in
//            guard let `self` = self else {
//                return
//            }
//            self.view.isUserInteractionEnabled = true
//            guard status else {
//                Toast.showToast(title: msg)
//                return
//            }
//            NotificationCenter.default.post(name: AppNotificationName.Fil.withdrawAdress, object: nil)
//            self.enterBindResultPage()
//        }
//    }
    
    /// 绑定请求
    fileprivate func withdrawAddressBindRequest(address: String, qrcode_filename: String) -> Void {
        self.view.isUserInteractionEnabled = false
        AssetNetworkManager.bindWithdrawAddress(address: address, currency: self.assetModel.currency.rawValue, currencyType: self.currencyType) { [weak self](status, msg) in
            guard let `self` = self else {
                return
            }
            self.view.isUserInteractionEnabled = true
            guard status else {
                Toast.showToast(title: msg)
                return
            }
            NotificationCenter.default.post(name: AppNotificationName.Asset.withdrawAdress, object: nil)
            self.enterBindResultPage()
        }
    }

}

// MARK: - Delegate Function

// MARK: - <WithdrawAddressBindingHeaderViewProtocol>
extension WithdrawAddressBindingController: WithdrawAddressBindingHeaderViewProtocol {
    func headerView(_ view: WithdrawAddressBindingHeaderView, didClickBind address: String) {
        self.withdrawAddressBindRequest(address: address, qrcode_filename: "")
    }
}
