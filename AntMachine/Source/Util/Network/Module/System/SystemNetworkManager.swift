//
//  SystemNetworkManager.swift
//  iMeet
//
//  Created by 小唐 on 2019/6/14.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  系统相关请求接口

import Foundation

/// 系统相关请求接口
class SystemNetworkManager {
    /// 应用服务器配置
    class func appServerConfig(complete: @escaping((_ status: Bool, _ msg: String?, _ model: ServerConfigModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = SystemRequestInfo.serverConfig
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

    /// 当前版本 —— 获取最新版本，从本地服务器上
    class func getLatestVersion(complete: @escaping((_ status: Bool, _ msg: String?, _ model: ServerVesionModel?) -> Void)) -> Void {
        // 1.请求 url
        // 版本类型 0: android 1: ios
        var requestInfo = SystemRequestInfo.latestVersion
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: ["ios"])
        // 2.配置参数: type、id、limit
        //let parameter: [String: Any] = ["type": "iOS"]
        //requestInfo.parameter = parameter
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
