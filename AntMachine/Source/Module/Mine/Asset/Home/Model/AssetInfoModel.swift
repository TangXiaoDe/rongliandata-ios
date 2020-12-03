//
//  AssetInfoModel.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/4.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  用户资产数据模型

import Foundation
import ObjectMapper

/// 用户资产数据模型
class AssetInfoModel: Mappable {

    /// 资产余额
    var balance: String = "0.0"
    /// 总收益
    var income: String = "0.0"
    /// 总收益
    var total: String = "0.0"
    /// 总支出
    var expend: String = "0.0"
    /// 待反还
    var wait: String = "0.0"
    /// 能量值
    var power: Int = 0
    
    /// 资产余额
    var ore: Double = 0.0
    
    /// 币种
    var coinValue: String = ""
    var currency: CurrencyType {
        if let type = CurrencyType(rawValue: self.coinValue) {
            return type
        }
        return CurrencyType.usdt
    }
    
    /// 标题
    var title: String {
        var title: String = self.coinValue.uppercased()
        if self.coinValue == CurrencyType.usdt.rawValue {
             title = "USDT"
        }
        if self.coinValue == CurrencyType.fil.rawValue {
             title = "FIL"
        }
        return title
    }
    
    init() {
        
    }
    init(currency: String) {
        self.coinValue = currency
    }

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        balance <- map["balance"]
        income <- map["income"]
        total <- map["total"]
        expend <- map["expend"]
        wait <- map["wait"]
        power <- map["power"]
        coinValue <- map["currency"]
        ore <- (map["balance"], DoubleStringTransform.default)
    }

}
