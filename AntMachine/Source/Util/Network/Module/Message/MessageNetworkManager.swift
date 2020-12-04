//
//  MessageNetworkManager.swift
//  CCMall
//
//  Created by 小唐 on 2019/2/22.
//  Copyright © 2019 COMC. All rights reserved.
//

import Foundation

class MessageNetworkManager {
}


extension MessageNetworkManager {

    /// 获取未读消息数
    class func getUnreadMessage(complete: @escaping((_ status: Bool, _ msg: String?, _ model: MessageUnreadModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = MessageRequestInfo.unreadCount
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "网络不可用，请检查！", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.model)
            }
        }
    }

    /// 获取消息列表
    class func getMessagList(type: MessageType, offset: Int, limit: Int, complete: @escaping((_ status: Bool, _ msg: String?, _ models: [MessageListModel]?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = MessageRequestInfo.list
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        let parameter: [String: Any] = ["type": type.rawValue, "offset": offset, "limit": limit]
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
