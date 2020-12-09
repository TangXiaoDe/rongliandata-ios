//
//  FPHomeIPFSModel.swift
//  HZProject
//
//  Created by 小唐 on 2020/11/13.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  首页IPFS数据模型

import Foundation
import ObjectMapper

/// 首页行情子模型
class FPHomeIPFSModel: Mappable
{
    
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
    }
    
}
