//
//  ServerConfigModel.swift
//  AntMachine
//
//  Created by 小唐 on 2019/2/25.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  服务器配置数据模型

import Foundation
import ObjectMapper

/// 服务器配置数据模型
class ServerConfigModel: Mappable {

    /// cdn域名
    var cdnDomain: String = ""
    /// 商务联系数据模型
    var business: BusinessContactModel?
    /// 退出天数(社群加入社区)
    var quitDay: Int = 0
    /// 红包限制
    var bonusLimit: BonusLimitModel?
    /// 注册协议
    var register_protocol: String = ""
//    /// 是否开启版本管理
//    var isVersionControl: Bool = false
    /// fil配置信息
    var filConfig: FilConfigModel?

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        cdnDomain <- map["cdn_domain"]
        business <- map["business"]
        quitDay <- map["quit_limit_day"]
        bonusLimit <- map["bonus"]
        register_protocol <- map["register_protocol"]
//        isVersionControl <- map["start_version_control"]
        filConfig <- map["fil:issue"]
    }

}

/// 商务联系方式数据模型
class BusinessContactModel: Mappable {

    var qq: String = ""
    var email: String = ""
    var imeet: String = ""
    var wechat: String = ""

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        //qq <- map["qq"]
        //email <- map["email"]
        //imeet <- map["imeet"]
        //wechat <- map["wechat"]
        qq <- map["Q Q"]
        email <- map["邮箱"]
        imeet <- map["链乎"]
        wechat <- map["微信"]
    }

}

/// 红包限制相关
class BonusLimitModel: Mappable {

    /// 红包最小金额
    var amountMin: Double = 0.01
    /// 个人红包最大金额
    var personalAmountMax: Double = 200
    /// 社群红包总金额 自己算
    var groupAmountMax: Double = 20_000
    /// 社群每个红包最大领取用户数
    var groupReceiveUserMax: Int = 100
    /// 单个用户每天能发的红包金额上限？ - 不予处理
    var userDaily: Double = 1_000


    required init?(map: Map) {

    }
    func mapping(map: Map) {
        amountMin <- (map["min_limit"], DoubleStringTransform.default)
        personalAmountMax <- (map["max_limit"], DoubleStringTransform.default)
        //groupAmountMax <- map["group_max_limit"]
        groupReceiveUserMax <- (map["group_num_limit"], IntegerStringTransform.default)
        userDaily <- (map["user_daily_limit"], DoubleStringTransform.default)
    }

}
/// Fil数据模型
class FilConfigModel: Mappable {
    /// 总锁仓
    var total_lock: String = ""
    /// 总抵押
    var total_pawn: String = ""
    /// 总可用
    var total_enable: String = ""
    /// fil钱包主页tips
    var tips: String = ""
    ///
    var archive: String = ""

    /// 设备模块使用的，封存配比
    var pawn: String = ""
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        total_lock <- map["total_lock"]
        total_pawn <- map["total_pawn"]
        total_enable <- map["total_enable"]
        tips <- map["tips"]
        archive <- map["archive"]
        pawn <- map["pawn"]
    }

    /// 设备封装配比
    var equip_pawn: Double {
        var value: Double = 0
        if let realValue = Double(self.pawn) {
            value = realValue
        }
        return value
    }
    
}
