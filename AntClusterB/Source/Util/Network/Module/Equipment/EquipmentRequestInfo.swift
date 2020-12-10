//
//  EquipmentRequestInfo.swift
//  AntClusterB
//
//  Created by 小唐 on 2020/12/4.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  设备相关请求信息

import Foundation

/// 设备相关请求信息
class EquipmentRequestInfo {

    /// 主页数据
    static let homeData = RequestInfo<EquipmentHomeModel>.init(method: .get, path: "eqs", replaceds: [])

}
