//
//  EquipmentNetworkManager.swift
//  AntClusterB
//
//  Created by 小唐 on 2020/12/4.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  设备相关请求接口

import Foundation

enum EquipmentAssetType: String {
    case all = ""
    case fil_lock = "fil:lock"
    case fil_available = "fil:available"
    case fil_pawn = "fil:pawn"
    case miner_release = "miner:release"
    
    var title: String {
        var title = ""
        switch self {
        case .all:
            title = "全部"
        case .fil_lock:
            title = "锁仓"
        case .fil_available:
            title = "可用"
        case .fil_pawn:
            title = "抵押"
        case .miner_release:
            title = "挖坑"
        }
        return title
    }
}

/// 设备相关请求接口
class EquipmentNetworkManager {

}

extension EquipmentNetworkManager {

    /// 主页数据
    class func getHomeData(offset: Int, limit: Int, complete: @escaping((_ status: Bool, _ msg: String?, _ model: EquipmentHomeModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = EquipmentRequestInfo.homeData
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        let parameter: [String: Any] = ["offset": offset, "limit": limit]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error".localized, nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.model)
            }
        }
    }
    
    /// 挖矿日志/记录/明细/流水
    class func getMiningLogs(id: Int, offset: Int, limit: Int, complete: @escaping((_ status: Bool, _ msg: String?, _ models: [MiningLogModel]?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = EquipmentRequestInfo.miningLogs
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: ["\(id)"])
        // 2.配置参数
        let parameter: [String: Any] = ["offset": offset, "limit": limit]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error".localized, nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.models)
            }
        }
    }

}


extension EquipmentNetworkManager {

    /// 设备详情
    class func getEquipmentDetail(id: Int, complete: @escaping((_ status: Bool, _ msg: String?, _ model: EquipmentDetailModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = EquipmentRequestInfo.equipmentDetail
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: ["\(id)"])
        // 2.配置参数
        let parameter: [String: Any] = [ :]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.model)
            }
        }
    }
    /// 资产明细
    /// 锁仓 fil:lock , 可用 fil:available,抵押'fil:pawn',挖矿 miner:release
    class func getEquipAssetDetail(order_id: Int, action: AssetActionType, type: EquipmentAssetType, offset: Int, limit: Int, complete: @escaping((_ status: Bool, _ msg: String?, _ models: [MiningLogModel]?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = EquipmentRequestInfo.assetDetail
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: ["\(order_id)"])
        // 2.配置参数
        var parameter: [String: Any] = ["offset": offset, "limit": limit]
        if !action.title.isEmpty {
            parameter["action"] = action.title
        }
        if !type.rawValue.isEmpty {
            parameter["type"] = type.rawValue
        }
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.models)
            }
        }
    }
    /// 锁仓线性释放
    class func getEquipLinearRelease(order_id: String, offset: Int, limit: Int, complete: @escaping((_ status: Bool, _ msg: String?, _ model: LockDetailListModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = EquipmentRequestInfo.linear_release
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: ["\(order_id)"])
        // 2.配置参数
        let parameter: [String: Any] = ["offset": offset, "limit": limit]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.model)
            }
        }
    }
    
    /// 设备资产归还明细流水
    class func getAssetBackList(order_id: Int, offset: Int, limit: Int, complete: @escaping((_ status: Bool, _ msg: String?, _ models: [EDAssetReturnListModel]?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = EquipmentRequestInfo.assetBackList
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: ["\(order_id)"])
        // 2.配置参数
        let parameter: [String: Any] = ["offset": offset, "limit": limit]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.models)
            }
        }
    }

}


extension EquipmentNetworkManager {
    
    /// 设备详情页请求封装
    class func refreshEquipmentDetailData(id: Int, offset: Int, limit: Int, complete: @escaping((_ status: Bool, _ msg: String?, _ data: (detail: EquipmentDetailModel, returns: [EDAssetReturnListModel])?) -> Void)) -> Void {
        let group = DispatchGroup.init()

        var detailStatus: Bool = false
        var detailMsg: String? = nil
        var detailModel: EquipmentDetailModel? = nil
        var returnStatus: Bool = false
        var returnMsg: String? = nil
        var returnModels: [EDAssetReturnListModel]? = nil

        // 设备详情
        group.enter()
        Self.getEquipmentDetail(id: id) { (status, msg, model) in
            detailStatus = status
            detailMsg = msg
            detailModel = model
            group.leave()
        }

        // 资产归还流水
        group.enter()
        Self.getAssetBackList(order_id: id, offset: offset, limit: limit) { (status, msg, models) in
            returnStatus = status
            returnMsg = msg
            returnModels = models
            
            // 临时测试代码
            returnModels = []
            for _ in 0...10 {
                let item = EDAssetReturnListModel.init()
                item.gas = 0.123
                item.pledge = 1.23123
                item.interest = 1.201
                returnModels?.append(item)
            }
            
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            let status: Bool = detailStatus && returnStatus
            var msg: String? = nil
            if !detailStatus {
                msg = detailMsg
            } else if !returnStatus {
                msg = returnMsg
            }
            var data: (detail: EquipmentDetailModel, returns: [EDAssetReturnListModel])? = nil
            if let detailModel = detailModel, let returnModels = returnModels {
                data = (detail: detailModel, returns: returnModels)
            }
            complete(status, msg, data)
        }
    }
    
}
