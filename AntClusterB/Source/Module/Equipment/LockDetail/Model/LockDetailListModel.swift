//
//  LockDetailListModel.swift
//  MallProject
//
//  Created by zhaowei on 2021/3/10.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  锁仓线性释放模型

import Foundation
import ObjectMapper

class LockDetailListModel: Mappable {
    /// 已释放(FIL)
    var already: Double = 0
    /// 累计收益(FIL)
    var total: Double = 0
    /// 明细
    var logs: [LockDetailLogModel]?

    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        already <- (map["already"], DoubleStringTransform.default)
        total <- (map["total"], DoubleStringTransform.default)
        logs <- map["logs"]
    }
    
}
class LockDetailLogModel: Mappable {
    /// 金额
    var amount: Double = 0
    /// 创建时间
    var created_at: Date = Date()

    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        amount <- (map["amount"], DoubleStringTransform.default)
        created_at <- (map["created_at"], DateStringTransform.current)
    }
}
