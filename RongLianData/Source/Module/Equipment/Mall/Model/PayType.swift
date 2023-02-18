//
//  PayType.swift
//  RenRenProject
//
//  Created by 小唐 on 2021/1/22.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import Foundation

typealias MallPayWay = MallPayType
/// 商城支付方式
enum MallPayType: String {
    /// USDT
    case usdt = "usdt"
    /// 银行卡
    case bankcard = "bank"
    /// 支付宝
    case alipay = "alipay"
    /// 微信
    case wechat = "wechat"

    ///
    var icon: UIImage? {
        var icon: UIImage? = nil
        switch self {
        case .usdt:
            icon = UIImage.init(named: "IMG_order_icon_pay_usdt")
        case .bankcard:
            icon = UIImage.init(named: "IMG_order_icon_pay_yhk")
        case .alipay:
            icon = UIImage.init(named: "IMG_order_icon_pay_alipay")
        case .wechat:
            icon = UIImage.init(named: "IMG_order_icon_pay_wechat")
        }
        return icon
    }
    ///
    var title: String {
        var title: String = ""
        switch self {
        case .usdt:
            title = "USDT"
        case .bankcard:
            title = "银行卡"
        case .alipay:
            title = "支付宝"
        case .wechat:
            title = "微信"
        }
        return title
    }

}


typealias OfflinePayType = VoucherPayType
/// 凭证支付类型
enum VoucherPayType: String {

    /// 银行卡
    case bankcard = "bank"
    /// 支付宝
    case alipay = "alipay"
    /// 微信
    case wechat = "wechat"
    
    ///
    var mall_paytype: MallPayType {
        var paytype: MallPayType = .bankcard
        if let realType = MallPayType.init(rawValue: self.rawValue) {
            paytype = realType
        }
        return paytype
    }
    
    //
    var tips: String {
        var tips: String = ""
        switch self {
        case .bankcard:
            tips = "说明：请在2小时内完成该笔订单的转款操作，并上传转款的电子回单，超时系统将自动关闭此订单"
        default:
            tips = "说明：请在2小时内完成该笔订单的转款操作，并上传转款成功的截图，超时系统将自动关闭此订单"
        }
        return tips
    }

}
