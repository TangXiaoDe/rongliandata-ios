//
//  FPOrePoolItemModel.swift
//  MallProject
//
//  Created by 小唐 on 2021/3/8.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import Foundation

/// 矿池类型
enum FPOrePoolType {
    ///
    case btc
    ///
    case eth
    ///
    case ipfs
    ///
    case chia

    ///
    var title: String {
        var text: String = ""
        switch self {
        case .btc:
            text = "BTC"
        case .eth:
            text = "ETH"
        case .ipfs:
            text = "IPFS"
        case .chia:
            text = "CHIA"
        }
        return text
    }

    ///
    var icon: UIImage? {
        var image: UIImage? = nil
        switch self {
        case .btc:
            image = UIImage.init(named: "IMG_home_icon_btc")
        case .eth:
            image = UIImage.init(named: "IMG_home_icon_eth")
        case .ipfs:
            image = UIImage.init(named: "IMG_home_icon_fil")
        case .chia:
            image = UIImage.init(named: "IMG_home_icon_chia")
        }
        return image
    }

}

class FPOrePoolItemModel {

    var title: String = ""
    var title_unit: String? = nil
    var icon: UIImage? = nil
    var bg: UIImage? = nil
    var title_icon: UIImage? = nil
    var value: String? = nil

    init(title: String, icon: UIImage?, bg: UIImage?, title_unit: String?, title_icon: UIImage?, value: String?) {
        self.title = title
        self.icon = icon
        self.bg = bg
        self.title_unit = title_unit
        self.title_icon = title_icon
        self.value = value
    }

    ///
    var strTitleUnit: String {
        var content: String = ""
        if let unit = self.title_unit, !unit.isEmpty {
            content = "(\(unit))"
        }
        return content
    }

}
