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
    /// 区块数据
    var ipfs: FPHomeIPFSModel? = nil
    ///
    var btc: FPHomeCurrencyModel? = nil
    ///
    var eth: FPHomeCurrencyModel? = nil
    ///
    var chia: FPHomeChiaModel? = nil
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
        btc <- map["btc"]
        eth <- map["eth"]
        chia <- map["chia"]
        quotations <- map["real_time"]
    }
    
}

extension FirstPageHomeModel {

    ///
    var ipfs_orepool_models: [FPOrePoolItemModel] {
        var models: [FPOrePoolItemModel] = []
//        models.append(contentsOf: [
//                        FPOrePoolItemModel.init(title: "全网有效算力", icon: nil, bg: UIImage.init(named: "IMG_img_home_bg_pib"), title_unit: "PIB", title_icon: UIImage.init(named: "IMG_home_icon_youxiao"), value: self.ipfs?.total_power),
//                        FPOrePoolItemModel.init(title: "最新区块高度", icon: nil, bg: UIImage.init(named: "IMG_img_home_bg_qkgd"), title_unit: nil, title_icon: UIImage.init(named: "IMG_home_icon_nandu"), value: self.ipfs?.tipset_height),
//                        FPOrePoolItemModel.init(title: "24h平均提供存储服务收益", icon: UIImage.init(named: "IMG_img_home_bg_reward"), bg: nil, title_unit: "FIL/TiB", title_icon: UIImage.init(named: "IMG_home_icon_reward"), value: self.ipfs?.mining_income_str_one_day),
//                        FPOrePoolItemModel.init(title: "近24h产出量", icon: UIImage.init(named: "IMG_img_home_bg_time"), bg: nil, title_unit: "FIL", title_icon: UIImage.init(named: "IMG_home_icon_time"), value: self.ipfs?.one_day_fil_str),
//                        FPOrePoolItemModel.init(title: "活跃存储提供者", icon: UIImage.init(named: "IMG_img_home_bg_number"), bg: nil, title_unit: "人", title_icon: UIImage.init(named: "IMG_home_icon_number"), value: self.ipfs?.active_miners),
//                        FPOrePoolItemModel.init(title: "流通总量", icon: UIImage.init(named: "IMG_img_home_bg_liutong"), bg: nil, title_unit: "FIL", title_icon: UIImage.init(named: "IMG_home_icon_liutong"), value: self.ipfs?.current_fil_str)
//        ])
        let model1 = FPOrePoolItemModel.init(title: "全网有效算力", icon: nil, bg: UIImage.init(named: "IMG_home_img_card1"), title_unit: "PIB", title_icon: nil, value: self.ipfs?.total_power)
        let model2 = FPOrePoolItemModel.init(title: "活跃矿工人数", icon: nil, bg: UIImage.init(named: "IMG_home_img_card2"), title_unit: "人", title_icon: nil, value: self.ipfs?.active_miners)
        let model3 = FPOrePoolItemModel.init(title: "24h平均挖矿收益", icon: nil, bg: UIImage.init(named: "IMG_home_img_card3"), title_unit: "FIL/TiB", title_icon: nil, value: self.ipfs?.mining_income_str_one_day)
        let model4 = FPOrePoolItemModel.init(title: "新增算力成本", icon: nil, bg: UIImage.init(named: "IMG_home_img_card4"), title_unit: "FIL/TiB", title_icon: nil, value: self.ipfs?.add_power_cost)
        let model5 = FPOrePoolItemModel.init(title: "当前扇区质押量", icon: nil, bg: UIImage.init(named: "IMG_home_img_card5"), title_unit: "FIL/32Gib", title_icon: nil, value: self.ipfs?.now_pledge_collateral)
        let model6 = FPOrePoolItemModel.init(title: "FIL质押量", icon: nil, bg: UIImage.init(named: "IMG_home_img_card6"), title_unit: "FIL", title_icon: nil, value: self.ipfs?.pledge_collateral)
        models.append(contentsOf: [model1, model2, model3, model4, model5, model6])
        return models
    }
    ///
    var btc_orepool_models: [FPOrePoolItemModel] {
        var models: [FPOrePoolItemModel] = []
        models.append(contentsOf: [
                        FPOrePoolItemModel.init(title: "全网算力", icon: nil, bg: UIImage.init(named: "IMG_img_home_bg_pib"), title_unit: "MH/S", title_icon: UIImage.init(named: "IMG_home_icon_youxiao"), value: self.btc?.network_computing_power),
                        FPOrePoolItemModel.init(title: "当前算力难度", icon: nil, bg: UIImage.init(named: "IMG_img_home_bg_qkgd"), title_unit: "P", title_icon: UIImage.init(named: "IMG_home_icon_nandu"), value: self.btc?.current_computing_difficulty),
            FPOrePoolItemModel.init(title: "当前价格", icon: UIImage.init(named: "IMG_img_home_bg_jiage"), bg: nil, title_unit: "CNY", title_icon: UIImage.init(named: "IMG_home_icon_jiage"), value: self.btc?.current_currency_price),
            FPOrePoolItemModel.init(title: "1T产出量/天", icon: UIImage.init(named: "IMG_img_home_bg_chanchu"), bg: nil, title_unit: nil, title_icon: UIImage.init(named: "IMG_home_icon_chanchu"), value: self.btc?.every_m_output_per_day)
        ])
        return models
    }
    ///
    var eth_orepool_models: [FPOrePoolItemModel] {
        var models: [FPOrePoolItemModel] = []
        models.append(contentsOf: [
                        FPOrePoolItemModel.init(title: "全网算力", icon: nil, bg: UIImage.init(named: "IMG_img_home_bg_pib"), title_unit: "MH/S", title_icon: UIImage.init(named: "IMG_home_icon_youxiao"), value: self.eth?.network_computing_power),
                        FPOrePoolItemModel.init(title: "当前算力难度", icon: nil, bg: UIImage.init(named: "IMG_img_home_bg_qkgd"), title_unit: "P", title_icon: UIImage.init(named: "IMG_home_icon_nandu"), value: self.eth?.current_computing_difficulty),
            FPOrePoolItemModel.init(title: "当前价格", icon: UIImage.init(named: "IMG_img_home_bg_jiage"), bg: nil, title_unit: "CNY", title_icon: UIImage.init(named: "IMG_home_icon_jiage"), value: self.eth?.current_currency_price),
            FPOrePoolItemModel.init(title: "1M产出量/天", icon: UIImage.init(named: "IMG_img_home_bg_chanchu"), bg: nil, title_unit: nil, title_icon: UIImage.init(named: "IMG_home_icon_chanchu"), value: self.eth?.every_m_output_per_day)
        ])
        return models
    }
    ///
    var chia_orepool_models: [FPOrePoolItemModel] {
        var models: [FPOrePoolItemModel] = []
        models.append(contentsOf: [
            FPOrePoolItemModel.init(title: "全网总算力", icon: nil, bg: UIImage.init(named: "IMG_img_home_bg_pib"), title_unit: "PiB", title_icon: UIImage.init(named: "IMG_home_icon_youxiao"), value: self.chia?.netspace),
            FPOrePoolItemModel.init(title: "区块高度", icon: nil, bg: UIImage.init(named: "IMG_img_home_bg_qkgd"), title_unit: nil, title_icon: UIImage.init(named: "IMG_home_icon_nandu"), value: self.chia?.height),
            FPOrePoolItemModel.init(title: "24H爆块", icon: UIImage.init(named: "IMG_img_home_bg_jiage"), bg: nil, title_unit: nil, title_icon: UIImage.init(named: "IMG_home_icon_jiage"), value: self.chia?.block_count_day),
            FPOrePoolItemModel.init(title: "产出XCH/1PiB/天", icon: UIImage.init(named: "IMG_img_home_bg_chanchu"), bg: nil, title_unit: nil, title_icon: UIImage.init(named: "IMG_home_icon_chanchu"), value: self.chia?.xchPerDay)
        ])
        return models
    }
}
