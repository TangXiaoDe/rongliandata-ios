//
//  MiningLogModel.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/1/12.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  挖矿明细模型 - 部分参考AssetListModel

import Foundation
import ObjectMapper

typealias MiningLogModel = AssetListModel
//class MiningLogModel: Mappable {
//
//    var id: Int = 0
//    /// 标题
//    var title: String = ""
//    /// 资产流水类型
//    var type_value: String = ""
//    /// 金额
//    var amount: Double = 0
//    /// 用户id
//    var user_id: Int = 0
//    /// 贡献的用户
//    var target_user_id: Int = 0
//    ///
//    var target_id: Int = 0
//    /// 动作: 1-收入 2-支出
//    var action_value: Int = 0
//    /// 0-待处理 1-成功 2-失败
//    var status_value: Int = 0
//    /// 币种
//    var coin_value: String = ""
//    /// 创建时间
//    var createDate: Date = Date()
//    /// 修改时间
//    var updateDate: Date = Date()
//
//    /// 扩展字段
//    var extend: MiningLogExtendModel? = nil
//    /// 当前用户
//    var user: SimpleUserModel?
//    /// 对方用户
//    var target_user: SimpleUserModel?
//    /// 目标类型
//    var target_type_value: String = ""
//
//    required init?(map: Map) {
//
//    }
//    func mapping(map: Map) {
//        id <- map["id"]
//        title <- map["title"]
//        type_value <- map["type"]
//        amount <- (map["amount"], DoubleStringTransform.default)
//        user_id <- map["user_id"]
//        target_user_id <- map["target_user_id"]
//        target_id <- map["target_id"]
//        action_value <- map["action"]
//        status_value <- map["status"]
//        coin_value <- map["currency"]
//        createDate <- (map["created_at"], DateStringTransform.current)
//        updateDate <- (map["updated_at"], DateStringTransform.current)
//        extend <- map["extend"]
//
//        user <- map["user"]
//        target_user <- map["target_user"]
//        target_type_value <- map["target_type"]
//    }
//    var action: AssetAction {
//        if let action = AssetAction.init(rawValue: self.action_value) {
//            return action
//        }
//        return AssetAction.income
//    }
//    /// 值标题
//    var valueTitle: String {
//        var title: String = ""
//        switch self.action {
//        case .income:
//            title = "+" + self.amount.decimalValidDigitsProcess(digits: 8)
//        case .outcome:
//            title = "-" + self.amount.decimalValidDigitsProcess(digits: 8)
//        }
//        return title
//    }
//    /// 值颜色
//    var valueColor: UIColor {
//        var color: UIColor = UIColor.init(hex: 0xF4CF4B)
//        switch self.action {
//        case .income:
//            color = UIColor.init(hex: 0xF04F0F)
//        case .outcome:
//            color = AppColor.mainText
//        }
//        return color
//    }
//}
//
//
//class MiningLogExtendModel: Mappable {
//
//    /// 挖矿数
//    var amount: Double = 0
//    /// 封装数
//    var fz_num: Double = 0
//
//    required init?(map: Map) {
//
//    }
//    func mapping(map: Map) {
//        amount <- (map["amount"], DoubleStringTransform.default)
//        fz_num <- (map["fz_num"], DoubleStringTransform.default)
//    }
//
//}

