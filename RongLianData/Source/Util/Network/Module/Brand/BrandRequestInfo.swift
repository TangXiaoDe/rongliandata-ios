//
//  BrandRequestInfo.swift
//  RongLianData
//
//  Created by zhaowei on 2021/6/28.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  品牌商接口声明

import Foundation

/// 品牌商相关请求信息
class BrandRequestInfo {
    /// 获取品牌商列表
    static let list = RequestInfo<BrandModel>.init(method: .get, path: "markets/brands", replaceds: [])
    /// 2、markets/dividend_logs 渠道分红 有分页 参数：品牌商id:brand_id 资产类型：currency
    static let bonusList = RequestInfo<BrandBonusModel>.init(method: .get, path: "markets/dividend_logs", replaceds: [])
}
