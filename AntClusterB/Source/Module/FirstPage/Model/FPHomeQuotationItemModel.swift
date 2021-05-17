//
//  FPHomeQuotationItemModel.swift
//  HZProject
//
//  Created by 小唐 on 2020/11/13.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  首页行情子模型

import Foundation
import ObjectMapper

/// 行情符号分类
enum QuotationSymbolType: String {
    case fil = "FIL"
    case usdt = "USDT"
    case btc = "BTC"
    case eth = "ETH"
    case eos = "EOS"
    case chia = "XCH"
    
    var icon: UIImage? {
        var name: String = ""
        switch self {
        case .fil:
            name = "IMG_home_icon_fil"
        case .usdt:
            name = "IMG_home_icon_usdt"
        case .btc:
            name = "IMG_home_icon_btc"
        case .eth:
            name = "IMG_home_icon_eth"
        case .eos:
            name = "IMG_home_icon_eos"
        case .chia:
            name = "IMG_home_icon_chia"
        }
        let image: UIImage? = UIImage.init(named: name)
        return image
    }
    
}

/// 首页行情子模型
class FPHomeQuotationItemModel: Mappable {
    /// 标识
    var symbol_value: String = ""
    /// usd价格
    var price_usd: String = ""
    /// 涨跌幅
    var percent_change_24h: String = ""
    /// 24小时量(需要乘以usd单价 已亿为单位)
    var volume_24h_usd: String = ""

    /// USDT兑人民币价格，外界传入
    var usdtInRmb: Double = 7.0
    
    // 亿 处理
    var volume_24h_usd_format: String {
        var formatValue = 0.0
        if let doubleValue = Double(volume_24h_usd) {
            formatValue = doubleValue/(10_000 * 10_000)
        }
        return formatValue.decimalValidDigitsProcess(digits: 2) + "亿"
    }
    
    init() {
            
    }
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        symbol_value <- map["symbol"]
        price_usd <- map["price_usd"]
        percent_change_24h <- map["percent_change_24h"]
        volume_24h_usd <- map["volume_24h_usd"]
    }
    
    
    
    ///
    var symbol: QuotationSymbolType {
        var symbol = QuotationSymbolType.fil
        if let realSymbol = QuotationSymbolType.init(rawValue: self.symbol_value) {
            symbol = realSymbol
        }
        return symbol
    }
    
    ///
    var str_percent_change_24h: String {
        let preSymbol: String = self.percent_change_24h.hasPrefix("-") ? "" : "+"
        return preSymbol + self.percent_change_24h
    }
    var change_bgColor: UIColor {
        let bgColor: UIColor = self.percent_change_24h.hasPrefix("-") ? UIColor.init(hex: 0xC66865) : UIColor.init(hex: 0x4DAA92)
        return bgColor
    }
    
    ///
    var str_price_rmb: String {
        var price_rmb: String = ""
        guard let price_usdt = Double(self.price_usd) else {
            return price_rmb
        }
        // TODO: - 乘法计算，可进一步优化
        price_rmb = (price_usdt * self.usdtInRmb).decimalValidDigitsProcess(digits: 2)
        return price_rmb
    }
    
}
