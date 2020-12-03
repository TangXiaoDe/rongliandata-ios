//
//  AssetListExtendModel.swift
//  iMeet
//
//  Created by 小唐 on 2019/9/25.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  资产列表的扩展数据模型 - 社群升级相关附加信息

import Foundation
import ObjectMapper

enum GroupUpgradeRecordPayType: String {
    case ctpay = "ctpay"
    case alipay = "alipay"
    case wxpay = "wxpay"
}

class AssetListExtendModel: Mappable {
    /// 支付方式ctpay-矿石支付 alipay-支付宝 wxpay-微信支付
    var pay_mode: String = ""
    /// 升级套餐ID
    var upgrade_id: Int = 0
    /// 套餐类型
    var upgrade_type: String = "year"
    /// 套餐等级
    var upgrade_level: Int = 1
    /// 有效开始日期
    var stratDate: Date = Date()
    /// 有效结束日期
    var endDate: Date = Date()

    var payType: GroupUpgradeRecordPayType {
        var type = GroupUpgradeRecordPayType.ctpay
        if let realType = GroupUpgradeRecordPayType.init(rawValue: self.pay_mode) {
            type = realType
        }
        return type
    }


    required init?(map: Map) {

    }
    func mapping(map: Map) {
        pay_mode <- map["pay_mode"]
        upgrade_id <- map["upgrade_id"]
        upgrade_type <- map["upgrade_type"]
        upgrade_level <- map["upgrade_level"]
        stratDate <- (map["start_date"], DateStringTransform.current)
        endDate <- (map["end_date"], DateStringTransform.current)
    }

}
