//
//  PasswordNetworkManager.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/10.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  密码相关请求接口

import Foundation

class PasswordNetworkManager {

}

// MARK: - LoginPwd
extension PasswordNetworkManager {

    //    old_password    string    是    旧密码
    //    password    string    是    新密码
    //    password_confirmation    string    是    确认新密码
    /// 修改 - 原密码
    class func updateLoginPwd(oldPwd: String, newPwd: String, confirmPwd: String, complete: @escaping((_ status: Bool, _ msg: String?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = PasswordRequestInfo.LoginPwd.update
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        let parameter: [String: Any] = ["old_password": oldPwd, "password": newPwd, "password_confirmation": confirmPwd]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error".localized)
            case .failure(let failure):
                complete(false, failure.message)
            case .success(let response):
                complete(true, response.message)
            }
        }
    }

    //    phone    string    是    手机号
    //    code    string    是    验证码
    //    password    string    是    新密码
    //    password_confirmation    string    是    确认密码
    /// 忘记/重置 - 验证码
    class func forgetLoginPwd(phone: String, code: String, newPwd: String, confirmPwd: String, complete: @escaping((_ status: Bool, _ msg: String?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = PasswordRequestInfo.LoginPwd.forget
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        let parameter: [String: Any] = ["phone": phone, "code": code, "password": newPwd, "password_confirmation": confirmPwd]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error".localized)
            case .failure(let failure):
                complete(false, failure.message)
            case .success(let response):
                complete(true, response.message)
            }
        }
    }

}


// MARK: - PayPwd
extension PasswordNetworkManager {

    //    pay_pass    string    是    密码
    //    code    string    是    验证码
    /// 修改/忘记/重置/初始化 - 验证码
    class func updatePayPwd(code: String, password: String, complete: @escaping((_ status: Bool, _ msg: String?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = PasswordRequestInfo.PayPwd.update
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        let parameter: [String: Any] = ["code": code, "password": password]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error".localized)
            case .failure(let failure):
                complete(false, failure.message)
            case .success(let response):
                complete(true, response.message)
            }
        }
    }

}
