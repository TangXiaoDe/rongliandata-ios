//
//  CurrencyType.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/6.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  货币类型

import Foundation

/// 货币类型
enum CurrencyType: String {
    ///
    case cny
    /// USDT
    case usdt
    /// Fil
    case fil

    /// 货币图标
    var icon: UIImage {
        var image: UIImage
        switch self {
        case .usdt:
            image = UIImage.init(named: "IMG_mall_usdt") ?? UIImage()
        case .fil:
            image = UIImage.init(named: "") ?? UIImage()
        case .cny:
            image = UIImage.init(named: "IMG_mall_cny") ?? UIImage()
        }
        return image
    }
    var title: String {
        var title: String = "CNY"
        switch self {
        case .usdt:
            title = "USDT"
        case .fil:
            title = "FIL"
        case .cny:
            title = "CNY"
        }
        return title
    }
//    var bigIcon: UIImage {
//        var image: UIImage
//        switch self {
//        case .comc:
//            image = #imageLiteral(resourceName: "IMG_icon_sex_men")
//        case .ore:
//            image = #imageLiteral(resourceName: "IMG_icon_sex_women")
//        case .ct:
//            image = #imageLiteral(resourceName: "IMG_icon_sex_women")
//        }
//        return image
//    }
//
//    /// 支付方式
//    var payWay: String {
//        var way: String
//        switch self {
//        case .comc:
//            way = "COMC"
//        case .ore:
//            way = "矿石"
//        case .ct:
//            way = "CT"
//        }
//        return way
//    }

}
