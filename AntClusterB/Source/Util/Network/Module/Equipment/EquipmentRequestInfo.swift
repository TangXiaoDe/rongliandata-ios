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
    /// 挖矿日志
    static let miningLogs = RequestInfo<MiningLogModel>.init(method: .get, path: "eqs/logs/{id}", replaceds: ["{id}"])

    /// 设备详情
    static let equipmentDetail = RequestInfo<EquipmentDetailModel>.init(method: .get, path: "equipments/{order}", replaceds: ["{order}"])
    /// 设备资产归还明细流水
    static let assetBackList = RequestInfo<EDAssetReturnListModel>.init(method: .get, path: "equipments/return_log/{order_id}", replaceds: ["{order_id}"])
    /// 锁仓线性释放
    static let linear_release = RequestInfo<LockDetailListModel>.init(method: .get, path: "equipments/linear_release/{order_id}", replaceds: ["{order_id}"])
    
    /// 资产详情
    static let assetDetail = RequestInfo<MiningLogModel>.init(method: .get, path: "eqs/logs/{id}", replaceds: ["{id}"])
    
}
