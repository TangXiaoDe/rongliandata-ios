//
//  AccountRequestInfo.swift
//  iMeet
//
//  Created by 小唐 on 2019/6/5.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  账号相关请求信息
//  登录、注册、注销、验证码、

import Foundation

class AccountRequestInfo {
    /// 登录
    static let login = RequestInfo<AccountTokenModel>.init(method: .post, path: "user/login", replaceds: [])
    /// 注册
    static let register = RequestInfo<AccountTokenModel>.init(method: .post, path: "user/register", replaceds: [])
    /// 注销
    static let logout = RequestInfo<Empty>.init(method: .post, path: "user/logout", replaceds: [])
    /// 换绑手机号
    static let updateBindPhone = RequestInfo<Empty>.init(method: .patch, path: "binding/phone", replaceds: [])

    /// 验证码
    struct SMSCode {
//        /// 验证码发送 - 无需认证登录
//        static let send_unauth = RequestInfo<Empty>.init(method: .post, path: "verification-codes", replaceds: [])
//        /// 验证码发送 - 需认证登录
//        static let send_auth = RequestInfo<Empty>.init(method: .post, path: "verification-codes", replaceds: [])
//        /// 验证码校验 - 无需认证登录
//        static let verify_unauth = RequestInfo<Empty>.init(method: .get, path: "verification-codes/check", replaceds: [])
//        /// 验证码校验 - 需认证登录
//        static let verify_auth = RequestInfo<Empty>.init(method: .get, path: "verification-codes/check", replaceds: [])
        /// 发送验证码
        static let sendSMS = RequestInfo<Empty>.init(method: .post, path: "verification-codes", replaceds: [])
        /// 验证验证码(是否有效)
        static let validSMS = RequestInfo<Empty>.init(method: .get, path: "verification-codes/check", replaceds: [])
    }


}
