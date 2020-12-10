//
//  FirstPageNetworkManager.swift
//  HZProject
//
//  Created by 小唐 on 2020/11/13.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  首页相关请求接口

import Foundation

/// 首页相关请求接口
class FirstPageNetworkManager {
    
}


extension FirstPageNetworkManager
{
    /// 主页相关信息
    class func getHomeData(complete: @escaping((_ status: Bool, _ msg: String?, _ model: FirstPageHomeModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = FirstPageRequestInfo.home
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
    
    /// 获取USDT兑人民币比例
    class func getUsdtToRmb(complete: @escaping((_ status: Bool, _ msg: String?, _ model: Double?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = FirstPageRequestInfo.usdtToRmb
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
                if let strPrice = response.data as? String, let lfPrice = Double(strPrice) {
                    complete(true, response.message, lfPrice)
                } else {
                    complete(false, response.message, nil)
                }
            }
        }
    }

}

extension FirstPageNetworkManager
{
    /// 主页全部数据：广告、系统通知、主页数据
    class func getHomeTotalData(complete: @escaping((_ status: Bool, _ msg: String?, _ model: FirstPageHomeModel?) -> Void)) -> Void {
        
        let group = DispatchGroup.init()

        var advertStatus: Bool = false
        var advertMsg: String? = nil
        var advertModels: [AdvertModel] = []
        var noticeStatus: Bool = false
        var noticeMsg: String? = nil
        var noticeModel: MessageListModel? = nil
        var homeStatus: Bool = false
        var homeMsg: String? = nil
        var homeModel: FirstPageHomeModel? = nil
        var priceStatus: Bool = false
        var priceMsg: String? = nil
        var priceModel: Double? = nil

        let spaceType: AdvertSpaceType = AdvertSpaceType.home
        if let spaceId = DataBaseManager().advert.getSpaceId(for: spaceType) {
            group.enter()
            AdvertNetworkManager.getAdverts(spaceId: spaceId, spaceFlag: spaceType.rawValue, specialId: nil, complete: { (status, msg, models) in
                advertStatus = status
                advertMsg = msg
                advertModels = models ?? []
                group.leave()
            })
        }

        group.enter()
        MessageNetworkManager.getMessagList(type: .system, offset: 0, limit: 1) { (status, msg, models) in
            noticeStatus = status
            noticeMsg = msg
            noticeModel = models?.first
            group.leave()
        }

        group.enter()
        Self.getHomeData { (status, msg, model) in
            homeStatus = status
            homeMsg = msg
            homeModel = model
            group.leave()
        }
        
        group.enter()
        Self.getUsdtToRmb { (status, msg, model) in
            priceStatus = status
            priceMsg = msg
            priceModel = model
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) {
            let status: Bool = homeStatus && priceStatus
            var msg: String? = nil
            if !homeStatus {
                msg = homeMsg
            } else if !priceStatus {
                msg = priceMsg
            }
            if let priceModel = priceModel {
                homeModel?.usdtToRmb = priceModel
            }
            homeModel?.averts = advertModels
            homeModel?.newstNotice = noticeModel
            complete(status, msg, homeModel)
        }
        
    }
    
    
}
