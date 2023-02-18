//
//  CertificationNetworkManager.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  认证相关请求接口

import Foundation

/// 认证相关请求接口
class CertificationNetworkManager {

    /// 认证获取
    class func getRealNameCertDetail(complete: @escaping((_ status: Bool, _ msg: String?, _ model: RealNameCertModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = CertificationRequestInfo.detail
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

    //    fpic    string    是    证件正面照
    //    bpic    string    是    证件反面照
    //    hpic    string    是    手持证件照
    //    number    string    是    证件号
    //    name    string    是    证件人姓名
    //    type    string    是    证件类型: id-card(身份证)，暂仅支持身份证
    /// 认证申请
    class func applyRealNameCert(frontImg: String, backImg: String, handImg: String, name: String, idNo: String, complete: @escaping((_ status: Bool, _ msg: String?, _ model: RealNameCertModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = CertificationRequestInfo.apply
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        let parameter: [String: Any] = ["type": "id-card", "fpic": frontImg, "bpic": backImg, "hpic": handImg, "name": name, "number": idNo]
        requestInfo.parameter = parameter
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

    /// 认证更新
    class func updateRealNameCert(frontImg: String, backImg: String, handImg: String, name: String, idNo: String, complete: @escaping((_ status: Bool, _ msg: String?, _ model: RealNameCertModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = CertificationRequestInfo.update
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        let parameter: [String: Any] = ["type": "id-card", "fpic": frontImg, "bpic": backImg, "hpic": handImg, "name": name, "number": idNo]
        requestInfo.parameter = parameter
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

}
