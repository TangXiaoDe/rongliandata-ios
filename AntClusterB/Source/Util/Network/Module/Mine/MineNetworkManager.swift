//
//  MineNetworkManager.swift
//  iMeet
//
//  Created by 小唐 on 2019/6/20.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  我的相关请求接口

import Foundation

class MineNetworkManager {

}

extension MineNetworkManager
{
    /// 我的主页刷新数据请求
    class func refreshHomeData(complete: @escaping((_ status: Bool, _ msg: String?, _ data: (user: CurrentUserModel, filModel: [WalletAllInfoModel])?) -> Void)) -> Void {
        let group = DispatchGroup.init()

        var userStatus: Bool = false
        var userMsg: String? = nil
        var userModel: CurrentUserModel? = nil
        var assetStatus: Bool = false
        var assetMsg: String? = nil
        var assetModels: [WalletAllInfoModel]? = nil

        // 当前用户
        group.enter()
        UserNetworkManager.getCurrentUser { (status, msg, model) in
            userStatus = status
            userMsg = msg
            userModel = model
            group.leave()
        }

        // 收益信息
        group.enter()
        AssetNetworkManager.getWalletAllInfo { (status, msg, models) in
            assetStatus = status
            assetMsg = msg
            assetModels = models
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) {
            let status: Bool = userStatus && assetStatus
            var msg: String? = nil
            if !userStatus {
                msg = userMsg
            } else if !assetStatus {
                msg = assetMsg
            }
            var data: (user: CurrentUserModel, filModel: [WalletAllInfoModel])? = nil
            if let userModel = userModel, let assetModels = assetModels {
                data = (user: userModel, filModel: assetModels)
            }
            complete(status, msg, data)
        }
    }
}
