//
//  AssetListModel.swift
//  iMeet
//
//  Created by 小唐 on 2019/2/14.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  资产明细列表数据模型

import Foundation
import ObjectMapper

typealias AssetListType = AssetActionType
enum AssetActionType: Int {
    case all = 0
    case income = 1
    case outcome = 2
    
    var title: String {
        var title: String = ""
        switch self {
        case .all:
            title = ""
        case .income:
            title = "income"
        case .outcome:
            title = "expend"
        }
        return title
    }
}

/// 资产动作
enum AssetAction: Int {
    /// 收入
    case income = 1
    /// 支出
    case outcome

    /// +- 符号
    var strSysbol: String {
        var strSysbol: String = ""
        switch self {
        case .income:
            strSysbol = "+"
        case .outcome:
            strSysbol = "-"
        }
        return strSysbol
    }

}
/// 资产状态
enum AssetStatus: Int {
    /// 待处理
    case wait = 0
    /// 成功
    case success
    /// 失败
    case failure
}

/// 明细类型
enum TypeStatus: String {
    /// 订单商品抵扣
    case goodsDeduct = "goods:deduct"
    /// 退还订单商品抵扣
    case returnDeduct = "return:deduct"
    /// 销售提成
    case saleCommission = "sale:commission"
    /// 代理商培育奖励
    case agentReward = "agent:reward"
    /// 现金提现
    case cnyWithdrawal = "cny:withdrawal"
    /// 挖矿
    case ore = "dig:ore"
    /// 转账收益
    case tranferIncome = "transfer:income"
    /// 转账支出
    case tranferExpend = "transfer:expend"
    /// Fil
    case filIssue = "fil:issue"
    /// Fil提现
    case filWithDrawal = "fil:withdrawal"
}

/// 资产Target类型
//enum AssetTargetType {
//    /// 红包
//    case bonus
//    /// 挖矿
//    /// 转账
//    /// 社群升级
//    /// 提现
//}

/// 资产流水类型
//enum AssetDetailType {
//
//}


class AssetListModel: Mappable {

    var id: Int = 0
    /// 标题
    var title: String = ""
    /// 资产流水类型
    var type_value: String = ""
    /// 金额
    var amount: Double = 0
    /// 用户id
    var user_id: Int = 0
    /// 贡献的用户
    var target_user_id: Int = 0
    /// 0-待处理 1-成功 2-失败
    var statusValue: Int = 0
    ///
    var target_id: Int = 0
    /// 动作: 1-收入 2-支出
    var action_value: Int = 0
    /// 0-待处理 1-成功 2-失败
    var status_value: Int = 0
    /// 币种
    var coin_value: String = ""
    /// 创建时间
    var createDate: Date = Date()
    /// 修改时间
    var updateDate: Date = Date()
    
    /// 扩展字段
    var extend: AssetListExtendModel? = nil
    /// 当前用户
    var user: SimpleUserModel?
    /// 对方用户
    var target_user: SimpleUserModel?
    /// 目标类型
    var target_type_value: String = ""
    
    /// 外界传入字段
    var zone: ProductZone?

    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        type_value <- map["type"]
        amount <- (map["amount"], DoubleStringTransform.default)
        user_id <- map["user_id"]
        target_user_id <- map["target_user_id"]
        target_id <- map["target_id"]
        action_value <- map["action"]
        status_value <- map["status"]
        coin_value <- map["currency"]
        createDate <- (map["created_at"], DateStringTransform.current)
        updateDate <- (map["updated_at"], DateStringTransform.current)
        extend <- map["extend"]
        
        statusValue <- map["status"]
        user <- map["user"]
        target_user <- map["target_user"]
        target_type_value <- map["target_type"]
    }
    var action: AssetAction {
        if let action = AssetAction.init(rawValue: self.action_value) {
            return action
        }
        return AssetAction.income
    }
    /// 值标题
    var valueTitle: String {
        var title: String = ""
        switch self.action {
        case .income:
            title = "+" + self.amount.decimalValidDigitsProcess(digits: 8)
        case .outcome:
            title = "-" + self.amount.decimalValidDigitsProcess(digits: 8)
        }
        return title
    }
    /// 值颜色
    var valueColor: UIColor {
        var color: UIColor = UIColor.init(hex: 0xF4CF4B)
        switch self.action {
        case .income:
            color = UIColor.init(hex: 0xF04F0F)
        case .outcome:
            color = AppColor.mainText
        }
        return color
    }
    var status: AssetStatus {
        if let status = AssetStatus.init(rawValue: self.statusValue) {
            return status
        }
        return AssetStatus.wait
    }

}
