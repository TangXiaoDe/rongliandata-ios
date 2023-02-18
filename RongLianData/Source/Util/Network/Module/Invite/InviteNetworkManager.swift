//
//  InviteNetworkManager.swift
//  iMeet
//
//  Created by 小唐 on 2019/4/11.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  邀请相关网络请求接口

import Foundation

/// 邀请相关网络请求接口
class InviteNetworkManager {

}

extension InviteNetworkManager {
    /// 填写邀请码
    class func fillInInviteCode(_ code: String, complete: @escaping((_ status: Bool, _ msg: String?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = InviteRequestInfo.fillInCode
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        let parameter: [String: Any] = ["code": code]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error")
            case .failure(let failure):
                complete(false, failure.message)
            case .success(let response):
                complete(true, response.message)
            }
        }
    }

    /// 邀请海报
    class func getInvitePosters(complete: @escaping((_ status: Bool, _ msg: String?, _ models: [InvitePosterModel]?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = InviteRequestInfo.posters
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
                complete(true, response.message, response.models)
            }
        }
    }

    /// 邀请数
    class func getInviteCount(complete: @escaping((_ status: Bool, _ msg: String?, _ model: InviteCountModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = InviteRequestInfo.count
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

    /// 重置未读邀请数
    class func resetInviteUnreadCount(complete: @escaping((_ status: Bool, _ msg: String?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = InviteRequestInfo.resetUnreadCount
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error")
            case .failure(let failure):
                complete(false, failure.message)
            case .success(let response):
                complete(true, response.message)
            }
        }
    }

}
