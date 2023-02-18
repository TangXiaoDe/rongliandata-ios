//
//  MessageListModel.swift
//  CCMall
//
//  Created by 小唐 on 2019/2/22.
//  Copyright © 2019 COMC. All rights reserved.
//
//  消息列表的数据模型

import Foundation
import ObjectMapper

/// 消息阅读状态
enum MessageReadStatus: Int {
    /// 未阅读
    case unread = 0
    /// 已阅读
    case readed
}

class MessageListModel: Mappable {

    /// id
    var id: Int = 0
    /// 消息标题
    var title: String = ""
    /// 消息类型 order-订单 sysytem-系统
    var typeValue: String = ""
    /// 消息内容
    var content: String = ""
    /// 阅读状态 0-未阅读 1-已阅读
    var read_status: Int = 0
    /// 消息发送时间
    var createDate: Date = Date()
    /// 是否是富文本
    var is_rich: Bool = false
    /// 不带标签的内容
    var intro: String = ""

    var type: MessageType {
        var type: MessageType = MessageType.system
        if let messageType = MessageType.init(rawValue: self.typeValue) {
            type = messageType
        }
        return type
    }
    var status: MessageReadStatus {
        var status: MessageReadStatus = MessageReadStatus.unread
        if let readStatus = MessageReadStatus.init(rawValue: self.read_status) {
            status = readStatus
        }
        return status
    }

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        typeValue <- map["type"]
        content <- map["content"]
        read_status <- map["read_status"]
        createDate <- (map["created_at"], DateStringTransform.current)
        is_rich <- map["is_rich"]
        intro <- map["intro"]
    }

}
