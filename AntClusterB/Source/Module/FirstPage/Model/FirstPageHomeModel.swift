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
        models.append(contentsOf: [
                        FPOrePoolItemModel.init(title: "全网有效算力", icon: nil, bg: UIImage.init(named: "IMG_img_home_bg_pib"), title_unit: "EIB", title_icon: UIImage.init(named: "IMG_home_icon_youxiao"), value: self.ipfs?.total_power),
                        FPOrePoolItemModel.init(title: "活跃矿工人数", icon: nil, bg: UIImage.init(named: "IMG_img_home_bg_qkgd"), title_unit: "人", title_icon: UIImage.init(named: "IMG_home_icon_huoyue"), value: self.ipfs?.active_miners),
                        FPOrePoolItemModel.init(title: "24h平均挖矿收益", icon: UIImage.init(named: "IMG_img_home_bg_reward"), bg: nil, title_unit: "FIL/TiB", title_icon: UIImage.init(named: "IMG_home_icon_reward"), value: self.ipfs?.mining_income_str_one_day),
                        FPOrePoolItemModel.init(title: "新增算力成本", icon: UIImage.init(named: "IMG_img_home_bg_chengben"), bg: nil, title_unit: "FIL/TiB", title_icon: UIImage.init(named: "IMG_home_icon_chengben"), value: self.ipfs?.add_power_cost),
                        FPOrePoolItemModel.init(title: "当前扇区质押量", icon: UIImage.init(named: "IMG_img_home_bg_shanxing"), bg: nil, title_unit: "FIL/32GiB", title_icon: UIImage.init(named: "IMG_home_icon_shanxing"), value: self.ipfs?.now_pledge_collateral),
                        FPOrePoolItemModel.init(title: "FIL质押量", icon: UIImage.init(named: "IMG_img_home_bg_zhiya"), bg: nil, title_unit: "FIL", title_icon: UIImage.init(named: "IMG_home_icon_zhiya"), value: self.ipfs?.pledge_collateral)
        ])
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
            FPOrePoolItemModel.init(title: "全网算力", icon: nil, bg: UIImage.init(named: "IMG_img_home_bg_pib"), title_unit: "MH/S", title_icon: UIImage.init(named: "IMG_home_icon_youxiao"), value: self.chia?.netspace),
            FPOrePoolItemModel.init(title: "区块高度", icon: nil, bg: UIImage.init(named: "IMG_img_home_bg_qkgd"), title_unit: nil, title_icon: UIImage.init(named: "IMG_home_icon_nandu"), value: self.chia?.height),
            FPOrePoolItemModel.init(title: "全网地址数", icon: UIImage.init(named: "IMG_img_home_bg_jiage"), bg: nil, title_unit: nil, title_icon: UIImage.init(named: "IMG_home_icon_jiage"), value: self.chia?.addressCount),
            FPOrePoolItemModel.init(title: "产出XCH/1T/天", icon: UIImage.init(named: "IMG_img_home_bg_chanchu"), bg: nil, title_unit: nil, title_icon: UIImage.init(named: "IMG_home_icon_chanchu"), value: self.chia?.xchPerDay)
        ])
        return models
    }
}
