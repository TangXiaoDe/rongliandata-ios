//
//  PasswordRequestInfo.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/10.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  密码相关请求信息

import Foundation

/// 密码相关请求信息
class PasswordRequestInfo {
    /// 登录密码
    struct LoginPwd {
        /// 修改 - 原密码
        static let update = RequestInfo<Empty>.init(method: .patch, path: "user/password", replaceds: [])
        /// 忘记/重置 - 验证码
        static let forget = RequestInfo<Empty>.init(method: .post, path: "user/forget-password", replaceds: [])
    }

    /// 支付密码
    struct PayPwd {
        /// 修改/忘记/重置/初始化 - 验证码
        static let update = RequestInfo<Empty>.init(method: .patch, path: "user/paypassword", replaceds: [])
    }

}
