//
//  FirstPageHomeModel.swift
//  HZProject
//
//  Created by 小唐 on 2020/11/13.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  首页模块主页模型

import Foundation
import ObjectMapper

/// 首页模块主页模型
class FirstPageHomeModel: Mappable
{
    /// 矿池数据
    var ipfs: FPHomeIPFSModel? = nil
    /// 实时行情
    var quotations: [FPHomeQuotationItemModel] = []
    
    /// 广告
    var averts: [AdvertModel] = []
    /// 最新系统消息
    var newstNotice: MessageListModel?
    
    /// 初始值，乱给的
    var usdtToRmb: Double = 7 {
        didSet {
            for model in quotations {
                model.usdtInRmb = usdtToRmb
            }
        }
    }
    
    init() {
        
    }
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        ipfs <- map["ipfs"]
        quotations <- map["real_time"]
    }
    
}


