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
    var typeValue: String = ""
    /// 金额
    var amount: String = ""
    /// 用户id
    var userId: Int = 0
    /// 贡献的用户
    var targetUserId: Int = 0
    /// 目标类型
    var targetTypeValue: String = ""
    /// 动作: 1-收入 2-支出
    var actionValue: Int = 0
    /// 扩展字段 - 社群升级数据类型
    var extend: AssetListExtendModel? = nil
    /// 0-待处理 1-成功 2-失败
    var satusValue: Int = 0
    /// 币种
    var coinValue: String = ""
    /// 当前用户
    var user: SimpleUserModel?
    /// 对方用户
    var targetUser: SimpleUserModel?
    /// 创建时间
    var createDate: Date = Date()
    /// 修改时间
    var updateDate: Date = Date()
    /// FIL提币手续费
    var filWithdrawalFee: String? = nil


    required init?(map: Map) {

    }
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        typeValue <- map["type"]
        amount <- map["amount"]
        userId <- map["user_id"]
        targetUserId <- map["target_user_id"]
        targetTypeValue <- map["target_type"]
        actionValue <- map["action"]
        extend <- map["extend"]
        satusValue <- map["status"]
        createDate <- (map["created_at"], DateStringTransform.current)
        updateDate <- (map["updated_at"], DateStringTransform.current)
        coinValue <- map["currency"]
        user <- map["user"]
        targetUser <- map["target_user"]
        filWithdrawalFee <- map["extend.fee"]
    }
    
    
    var currency: CurrencyType {
        if let type = CurrencyType(rawValue: self.coinValue) {
            return type
        }
        return CurrencyType.usdt
    }
    var status: AssetStatus {
        if let status = AssetStatus.init(rawValue: self.satusValue) {
            return status
        }
        return AssetStatus.wait
    }
    var action: AssetAction {
        if let action = AssetAction.init(rawValue: self.actionValue) {
            return action
        }
        return AssetAction.income
    }
    var type: TypeStatus {
        if let action = TypeStatus.init(rawValue: self.typeValue) {
            return action
        }
        return TypeStatus.ore
    }

    /// 转账title
    var transferTitle: String {
        var title: String = ""
        switch self.action {
        case .income:
            title = "转账-来自" + (self.user?.name ?? "")
        case .outcome:
            title = "转账-转给" + (self.targetUser?.name ?? "")
        }
        return title
    }
    
    /// 图标
    var icon: UIImage? {
        var icon: UIImage? = AppImage.PlaceHolder.image
        switch self.type {
        case .cnyWithdrawal:
            icon = UIImage.init(named: "IMG_sc_icon_shouyi_zfb")
        case .tranferExpend:
            icon = AppImage.PlaceHolder.avatar
        case .tranferIncome:
            icon = AppImage.PlaceHolder.avatar
        case .agentReward:
            icon = UIImage.init(named: "IMG_sc_icon_shouyi_tuiguang")
        case .saleCommission:
            icon = UIImage.init(named: "IMG_sc_icon_shouyi_tuiguang")
        case .goodsDeduct:
            icon = UIImage.init(named: "IMG_sc_icon_cl_gouwu")
        case .returnDeduct:
            icon = UIImage.init(named: "IMG_sc_icon_cl_gouwu")
        case .ore:
            icon = UIImage.init(named: "IMG_asset_usdt")
        case .filIssue:
            icon = UIImage.init(named: "IMG_asset_fil")
        case .filWithDrawal:
            icon = UIImage.init(named: "IMG_asset_fil")
        default:
            icon = UIImage.init(named: "IMG_asset_usdt")
        }
        return icon
    }

    /// 值标题
    var valueTitle: String {
        var title: String = ""
        switch self.action {
        case .income:
            title = "+" + self.amount.decimalProcess(digits: 8)
        case .outcome:
            title = "-" + self.amount.decimalProcess(digits: 8)
        }
        return title
    }
    /// 值颜色
    var valueColor: UIColor {
        var color: UIColor = UIColor.init(hex: 0xF4CF4B)
        switch self.action {
        case .income:
            color = AppColor.theme
        case .outcome:
            color = AppColor.mainText
        }
        switch self.type {
        case .filWithDrawal:
            switch self.status {
            case .wait:
                color = UIColor.init(hex: 0x333333)
            case .success:
                color = UIColor.init(hex: 0x333333)
            case .failure:
                color = UIColor.init(hex: 0xE68E40)
            }
        default:
            break
        }
        return color
    }
    
    /// 状态描述
    var statusTitle: String {
        var title: String = ""
        switch self.status {
        case .wait:
            title = "待处理"
        case .success:
            title = "成功"
        case .failure:
            title = "交易关闭"
        }
        switch self.type {
        case .cnyWithdrawal:
            switch self.status {
            case .wait:
                title = "提现中"
            case .success:
                title = "已成功"
            case .failure:
                title = "已驳回"
            }
        case .filWithDrawal:
            switch self.status {
            case .wait:
                title = "审核中"
            case .success:
                title = "提现成功"
            case .failure:
                title = "提现失败"
            }
        default:
            break
        }
        return title
    }
    /// 状态颜色
    var statusColor: UIColor {
        var color: UIColor = UIColor.init(hex: 0x8C97AC)
        switch self.status {
        case .wait:
            color = AppColor.theme
        case .success:
            color = AppColor.minorText
        case .failure:
            color = AppColor.themeRed
        }
        switch self.type {
        case .filWithDrawal:
            switch self.status {
            case .wait:
                color = UIColor.init(hex: 0x007FFF)
            case .success:
                color = UIColor.init(hex: 0x333333)
            case .failure:
                color = UIColor.init(hex: 0xE68E40)
            }
        default:
            break
        }
        return color
    }

}
