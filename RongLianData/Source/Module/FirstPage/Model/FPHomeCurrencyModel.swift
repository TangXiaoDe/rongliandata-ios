//
//  FPHomeCurrencyModel.swift
//  AntsCloudProject
//
//  Created by 小唐 on 2020/11/13.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  首页IPFS数据模型

import Foundation
import ObjectMapper

///
class FPHomeCurrencyModel: Mappable {

    /// 全网算力(MH/S)
    var network_computing_power: String = ""
    /// 当前算力难度(P)
    var current_computing_difficulty: String = ""
    /// 当前价格(CNY)
    var current_currency_price: String = ""
    /// 1M产出量/天
    var every_m_output_per_day: String = ""

    init() {

    }
    required init?(map: Map) {

    }
    func mapping(map: Map) {
        network_computing_power <- map["network_computing_power"]
        current_computing_difficulty <- map["current_computing_difficulty"]
        current_currency_price <- map["current_currency_price"]
        every_m_output_per_day <- map["every_m_output_per_day"]
    }

}

///
class FPHomeChiaModel: Mappable {

    /// 区块高度
    var height: String = ""
    /// 全网地址数
    var addressCount: String = ""
    /// 全网总算力
    var netspace: String = ""
    /// 日产出
    var xchPerDay: String = ""
    /// 24H爆块
    var block_count_day: String = ""
    
    init() {

    }
    required init?(map: Map) {

    }
    func mapping(map: Map) {
        height <- map["height"]
        addressCount <- map["addressCount"]
        netspace <- map["netspace"]
        xchPerDay <- map["xchPerDay"]
        block_count_day <- map["block_count_day"]
    }

}

/// 首页行情子模型
class FPHomeIPFSModel: Mappable {

    /// 全网总算力
    var total_power: String = ""
    /// 最新区块高度
    var tipset_height: String = ""
    /// 区块奖励
    var block_reward: String = ""
    /// FIL单价
    var unit_price: String = ""
    /// 涨跌幅
    var alteration: String = ""
    /// 平均出块时间
    var avg_block_time: String = ""
    /// 24小时消息增量
    var one_day_messages: String = ""
    /// 平均gas单价
    var avg_gas_premium: String = ""
    /// 流通市值
    var capitalization: String = ""
    /// 当前基础费率
    var current_base_fee_str: String = ""
    /// 平均每个高度区块数
    var avg_blocks_in_tipset_str: String = ""
    /// 平均每个高度消息数
    var avg_messages_tipset: String = ""
    /// 旷工数
    var active_miners: String = ""
    /// 24小时FIL增量
    var one_day_fil_str: String = ""
    /// 流通总量
    var current_fil: Double = 0
    var current_fil_str: String = ""
    /// 24小时成交额
    var last_turnover_str: String = ""
    /// FIL总量
    var total_fil_str: String = ""
    /// FIL流通率
    var flow_rate: String = ""
    /// 24小时平均挖矿收益(T)
    var mining_income_str_one_day: String = ""
    /// 总质压
    var pledge_collateral: String = ""
    /// 当前扇区质押量
    var now_pledge_collateral: String = ""
    /// 总账户数
    var total_account: String = ""
    /// 平均区块间隔
    var avg_block_tipset: String = ""
    /// 新增算力成本
    var add_power_cost: String = ""
    /// FIL销毁量
    var fil_destroy_total: String = ""

    init() {

    }
    required init?(map: Map) {

    }
    func mapping(map: Map) {
        total_power <- map["total_power"]
        tipset_height <- map["tipset_height"]
        block_reward <- map["block_reward"]
        unit_price <- map["unit_price"]
        alteration <- map["alteration"]
        avg_block_time <- map["avg_block_time"]
        one_day_messages <- map["one_day_messages"]
        avg_gas_premium <- map["avg_gas_premium"]
        capitalization <- map["capitalization"]
        current_base_fee_str <- map["current_base_fee_str"]
        avg_blocks_in_tipset_str <- map["avg_blocks_in_tipset_str"]
        avg_messages_tipset <- map["avg_messages_tipset"]
        active_miners <- map["active_miners"]
        one_day_fil_str <- map["one_day_fil_str"]
        current_fil <- (map["current_fil"], DoubleStringTransform.default)
        current_fil_str <- map["current_fil_str"]
        last_turnover_str <- map["last_turnover_str"]
        total_fil_str <- map["total_fil_str"]
        flow_rate <- map["flow_rate"]
        mining_income_str_one_day <- map["mining_income_str_one_day"]
        pledge_collateral <- map["pledge_collateral"]
        now_pledge_collateral <- map["now_pledge_collateral"]
        total_account <- map["total_account"]
        avg_block_tipset <- map["avg_block_tipset"]
        add_power_cost <- map["add_power_cost"]
        fil_destroy_total <- map["fil_destroy_total"]
    }

}
