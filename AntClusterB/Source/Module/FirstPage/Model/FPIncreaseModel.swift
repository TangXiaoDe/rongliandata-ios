//
//  FPIncreaseModel.swift
//  MallProject
//
//  Created by 小唐 on 2020/11/17.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  首页币价涨幅数据模型

import Foundation
import ObjectMapper

/// 首页币价涨幅数据模型
class FPIncreaseModel: Mappable {

    ///
    var eth: FPCurrencyIncreaseModel?
    ///
    var btc: FPCurrencyIncreaseModel?
    ///
    var ipfs: FPCurrencyIncreaseModel?
    ///
    var usdt: FPCurrencyIncreaseModel?
    ///
    var chia: FPCurrencyIncreaseModel?
    ///
    var bzz: FPCurrencyIncreaseModel?


    required init?(map: Map) {

    }
    func mapping(map: Map) {
        eth <- map["eth"]
        btc <- map["btc"]
        ipfs <- map["fil"]  // map["ipfs"]
        usdt <- map["usdt"]
        chia <- map["xch"]  // map["chia"]
        bzz <- map["bzz"]
        self.commonInit()
    }

    ///
    fileprivate func commonInit() -> Void {
        self.eth?.type = .eth
        self.btc?.type = .btc
        self.ipfs?.type = .ipfs
        self.usdt?.type = .usdt
        self.chia?.type = .chia
        self.bzz?.type = .bzz
    }

}


/// 货币类型
enum FPCurrencyType: String {
    case eth
    case btc
    case ipfs
    case usdt
    case chia
    case bzz
}
/// 首页单个币价涨幅数据模型
class FPCurrencyIncreaseModel: Mappable {

    ///
    var price: Double = 0
    ///
    var increase: String = ""

    ///
    var type: FPCurrencyType = .ipfs

    /// price的Double值，兑换人民币的价格
    var to_cny: Double {
//        var to_cny: Double = 1
//        if let lfprice = Double(self.price) {
//            to_cny = lfprice
//        }
//        return to_cny
        return self.price
    }


    init() {

    }
    required init?(map: Map) {

    }
    func mapping(map: Map) {
        price <- (map["price"], DoubleStringTransform.default)
        increase <- map["increase"]
    }

    /// 是否上涨
    var isUp: Bool {
        let flag: Bool = self.increase.hasPrefix("-") ? false : true
        return flag
    }

    ///
    var str_increase: String {
        let symbol: String = self.isUp ? "+" : ""
        return symbol + self.increase + "%"
    }

    ///
    var valueColor: UIColor {
        // 价格、涨跌幅颜色  上涨：48A782  下跌：CE586E
        let color: UIColor = self.isUp ? UIColor.init(hex: 0x48A782) : UIColor.init(hex: 0xCE586E)
        return color
    }

}
