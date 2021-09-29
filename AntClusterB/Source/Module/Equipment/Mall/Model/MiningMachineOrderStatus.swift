//
//  MiningMachineOrderStatus.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/3/10.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import Foundation


/// 0-待支付,1-已支付(待确认)，2-已确认(部署中),3-运行中,4-挖矿已结束，5-已关闭, 6-欠电费
typealias MallOrderStatus = MiningMachineOrderStatus
enum MiningMachineOrderStatus: Int {
    /// 待支付
    case waitpay = 0
    /// 已支付(待确认)
    case waitensure
    /// 已确认(部署中)
    case deploying
    /// 运行中
    case digging
    /// 挖矿已结束
    case digged
    /// 已关闭
    case closed
    /// 欠费
    case arrear
    
    
    var title: String {
        // 已结束(0x29313D)、运行中(0x335DF6)、待付款|待商家确认|部署中(0xE06236)、交易关闭(0xCE586E)、
        var title: String = ""
        switch self {
        case .waitpay:
            title = "待付款"
        case .waitensure:
            title = "待商家确认"
        case .deploying:
            title = "部署中"
        case .digging:
            title = "运行中"
        case .digged:
            title = "已结束"
        case .closed:
            title = "交易关闭"
        case .arrear:
            title = "已欠电费"
        }
        return title
    }

    /// 详情页状态图标
    var icon: UIImage? {
        // 待支付(IMG_order_icon_wait)、待商家确认(IMG_order_icon_wait)、部署中(IMG_order_icon_deploy)、
        // 运行中(IMG_order_icon_wakuang)、已结束(IMG_order_icon_end)、订单关闭(IMG_order_icon_close)
        var image: UIImage? = nil
        switch self {
        case .waitpay:
            image = UIImage.init(named: "IMG_order_icon_wait")
        case .waitensure:
            image = UIImage.init(named: "IMG_order_icon_wait")
        case .deploying:
            image = UIImage.init(named: "IMG_order_icon_deploy")
        case .digging:
            image = UIImage.init(named: "IMG_order_icon_wakuang")
        case .digged:
            image = UIImage.init(named: "IMG_order_icon_end")
        case .closed:
            image = UIImage.init(named: "IMG_order_icon_close")
        case .arrear:
            image = UIImage.init(named: "IMG_order_icon_wakuang")
        }
        return image
    }

}



