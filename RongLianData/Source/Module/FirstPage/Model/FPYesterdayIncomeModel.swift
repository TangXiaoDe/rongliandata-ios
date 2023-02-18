//
//  FPYesterdayIncomeModel.swift
//  MallProject
//
//  Created by 小唐 on 2020/11/17.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  首页昨日收益数据模型

import Foundation
import ObjectMapper

/// 首页昨日收益数据模型
class FPYesterdayIncomeModel: Mappable {

    ///
    var fil: String = ""
    ///
    var btc: String = ""
    ///
    var eth: String = ""
    ///
    var chia: String = ""
    ///
    var bzz: String = ""


    required init?(map: Map) {

    }
    func mapping(map: Map) {
        fil <- map["fil"]
        btc <- map["btc"]
        eth <- map["eth"]
        chia <- map["xch"]
        bzz <- map["bzz"]
    }

}
