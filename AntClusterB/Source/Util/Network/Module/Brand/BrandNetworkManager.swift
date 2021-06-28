//
//  BrandNetworkManager.swift
//  AntClusterB
//
//  Created by zhaowei on 2021/6/28.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  品牌商接口相关

import Foundation

class BrandNetworkManager {
}


extension BrandNetworkManager {
    /// 获取品牌商列表
    class func getBrandList(offset: Int, limit: Int, complete: @escaping((_ status: Bool, _ msg: String?, _ models: [BrandModel]?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = BrandRequestInfo.list
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        let parameter: [String: Any] = ["offset": offset, "limit": limit]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "网络不可用，请检查！", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.models)
            }
        }
    }

}
