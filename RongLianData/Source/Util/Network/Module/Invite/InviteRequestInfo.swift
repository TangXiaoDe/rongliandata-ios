//
//  InviteRequestInfo.swift
//  iMeet
//
//  Created by 小唐 on 2019/4/11.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  邀请请求信息

import Foundation

/// 邀请相关请求信息
class InviteRequestInfo {
    /// 填写邀请码
    static let fillInCode = RequestInfo<Empty>.init(method: .post, path: "invite/code", replaceds: [])
    /// 邀请海报 - 邀请配置
    static let posters = RequestInfo<InvitePosterModel>.init(method: .get, path: "share/image", replaceds: [])
    /// 邀请数
    static let count = RequestInfo<InviteCountModel>.init(method: .get, path: "invite/count", replaceds: [])
    /// 重置邀请未读数
    static let resetUnreadCount = RequestInfo<Empty>.init(method: .patch, path: "invite/unread", replaceds: [])
}
