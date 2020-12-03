//
//  MessageRequestInfo.swift
//  CCMall
//
//  Created by 小唐 on 2019/2/22.
//  Copyright © 2019 COMC. All rights reserved.
//
//  通知相关的请求信息

import Foundation

class MessageRequestInfo {
    /// 未读消息数
    static let unreadCount = RequestInfo<MessageUnreadModel>.init(method: .get, path: "message-count", replaceds: [])
    /// 消息列表
    static let list = RequestInfo<MessageListModel>.init(method: .get, path: "messages", replaceds: [])
}
