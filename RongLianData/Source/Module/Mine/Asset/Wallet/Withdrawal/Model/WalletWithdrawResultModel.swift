//
//  WalletWithdrawResultModel.swift
//  HuoTuiVideo
//
//  Created by 小唐 on 2020/6/11.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  FIL提现结果模型、提现详情模型、提现列表模型

import Foundation
import ObjectMapper

enum WithdrawResultStatus: Int {
    case applying = 0
    case success = 1
    case fail = 2
}

class WalletWithdrawResultModel: Mappable
{
    
    ///
    var id: Int = 0
    /// 用户id
    var user_id: Int = 0
    /// 提现数量
    var amount: Double = 0
    /// 手续费
    var fee: Double = 0
    /// 订单号
    var pid: String = ""
    /// 状态：0待审核/1成功/2驳回
    var status_value: Int = 0
    /// from_address
    var from_address: String = ""
    /// to_address
    var to_address: String = ""
    ///
    var createdDate = Date()
    ///
    var updatedDate = Date()
    /// currency
    var currency: String = ""
    /// data
    var data: String = ""

    
    init() {
        
    }
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        amount <- (map["num"], DoubleStringTransform.default)
        fee <- map["fee"]
        pid <- map["pid"]
        status_value <- map["status"]
        from_address <- map["from_address"]
        to_address <- map["to_address"]
        createdDate <- (map["created_at"], DateStringTransform.current)
        updatedDate <- (map["updated_at"], DateStringTransform.current)
        currency <- map["currency"]
        data <- map["data"]

    }
    init(amount: Double, fee: Double, status: Int, date: Date) {
        self.amount = amount
        self.fee = fee
        self.status_value = status
        self.createdDate = date
        self.updatedDate = date
    }
    init(model: AssetListModel, currency: String) {
        self.amount = model.amount
        self.fee = model.extend?.filWithdrawalFee ?? 0
        self.status_value = model.status_value
        self.createdDate = model.createDate
        self.updatedDate = model.updateDate
        self.currency = currency
    }
    
    var status: WithdrawResultStatus {
        var status: WithdrawResultStatus = .applying
        if let realStatus = WithdrawResultStatus.init(rawValue: self.status_value) {
            status = realStatus
        }
        return status
    }
    
}


