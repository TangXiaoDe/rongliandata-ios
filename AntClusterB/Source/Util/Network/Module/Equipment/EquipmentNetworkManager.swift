//
//  EquipmentNetworkManager.swift
//  AntClusterB
//
//  Created by 小唐 on 2020/12/4.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  设备相关请求接口

import Foundation

/// 设备相关请求接口
class EquipmentNetworkManager {

}

extension EquipmentNetworkManager {

    /// 主页数据
    class func getHomeData(complete: @escaping((_ status: Bool, _ msg: String?, _ model: EquipmentHomeModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = EquipmentRequestInfo.homeData
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
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

}


