//
//  InviteCountModel.swift
//  iMeet
//
//  Created by 小唐 on 2019/3/18.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  邀请数 的 数据模型：一级好友数和二级好友数

import Foundation
import ObjectMapper

/// 邀请统计数据模型
class InviteCountModel: Mappable {

    /// 一级好友数
    var firstCount: Int = 0
    /// 二级好友数
    var secondCount: Int = 0
    /// 全部好友数
    var totalCount: Int {
        return self.firstCount + self.secondCount
    }
    /// USDT 收益数量
    var usdtTotal: String = ""
    /// 成交用户量
    var dealFriendsCount: Int = 0

    init() {

    }

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        firstCount <- map["directCount"]
        secondCount <- map["indirectCount"]
        usdtTotal <- map["usdtTotal"]
        dealFriendsCount <- map["dealFriendsCount"]
    }

}
