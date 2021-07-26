//
//  BrandRequestInfo.swift
//  AntClusterB
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
}
