//
//  WithdrawConfigModel.swift
//  JXProject
//
//  Created by zhaowei on 2020/10/27.
//  Copyright © 2020 ChainOne. All rights reserved.
//

import Foundation
import ObjectMapper

/// FIL提现配置数据模型
class WithdrawConfigModel: Mappable {

    /// 提现服务费
    var service_charge: String = ""
    /// 单次最低提币数量
    var user_min: Double = 0.0
    /// 每日提现上限
    var user_day_limit: Double = 0.0
    /// 提现说明
    var instr: String = ""
    /// 绑定地址说明
    var bind_explain: String = ""


    required init?(map: Map) {

    }
    func mapping(map: Map) {
        service_charge <- map["fee"]
        user_min <- (map["min"], DoubleStringTransform.default)
        user_day_limit <- (map["limit"], DoubleStringTransform.default)
        instr <- map["drawal_explain"]
        bind_explain <- map["bind_explain"]
    }

}
