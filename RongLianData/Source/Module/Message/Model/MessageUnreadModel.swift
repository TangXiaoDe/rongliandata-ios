//
//  MessageUnreadModel.swift
//  CCMall
//
//  Created by 小唐 on 2019/2/22.
//  Copyright © 2019 COMC. All rights reserved.
//
//  消息未读模型

import Foundation
import ObjectMapper

class MessageUnreadModel: Mappable {

    /// 订单未读消息
    var order: UnreadItemModel = UnreadItemModel()
    /// 系统未读消息
    var system: UnreadItemModel = UnreadItemModel()
    /// 未读消息数
    var count: Int = 0

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        order <- map["order"]
        system <- map["system"]
        count <- map["count"]
        self.order.type = .order
        self.system.type = .system
    }

}

/// 未读消息数据模型
class UnreadItemModel: Mappable {

    /// 未读数量
    var unreadCount: Int = 0
    /// 最新未读消息
    var newest: String = ""

    var type: MessageType = .system

    init() {
    }

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        unreadCount <- map["unread"]
        newest <- map["newest"]
    }

}
