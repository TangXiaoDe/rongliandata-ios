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
    var logs: [LockDetailLogModel] = []

    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        already <- (map["already"], DoubleStringTransform.default)
        total <- (map["total"], DoubleStringTransform.default)
        logs <- map["logs"]
    }
    
    /// 待释放 = 累计收益 - 已释放
    var unrelease: Double {
        return self.total - self.already
    }
    
}
class LockDetailLogModel: Mappable {
    /// 金额
    var amount: Double = 0
    /// 创建时间
    var created_at: Date = Date()

    init() {
        
    }
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        amount <- (map["amount"], DoubleStringTransform.default)
        created_at <- (map["created_at"], DateStringTransform.current)
    }

    
    var days: Int {
        let strToday: String = Date.init().string(format: "yyyy-MM-dd", timeZone: .current)
        let today = Date.dateWithString(strToday + " 00:00:00", format: "yyyy-MM-dd HH:mm:ss", timeZone: .current)
        let strCreateDay: String = self.created_at.string(format: "yyyy-MM-dd", timeZone: .current)
        let createDay = Date.dateWithString(strCreateDay + " 00:00:00", format: "yyyy-MM-dd HH:mm:ss", timeZone: .current)
        
        var days: Int = 1
        if let today = today, let createDay = createDay {
            days = Int(today.timeIntervalSince(createDay) / (24.0 * 60.0 * 60.0)) + 1
        } else {
            days = Int(Date.init().timeIntervalSince(self.created_at) / (24.0 * 60.0 * 60.0)) + 1
        }
        days = min(180, max(1, days))
        return days
    }
    var strProgress: String {
        var result: String = ""
        result = "\(self.days)/180"
        return result
    }
    
    var released: Double {
        let progress: Double = Double(self.days) / 180.0
        let result = progress * amount
        return result
    }
    
}
