//
//  CertificationRequestInfo.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  认证相关请求信息

import Foundation

/// 认证相关请求信息
class CertificationRequestInfo {

    /// 获取认证
    static let detail = RequestInfo<RealNameCertModel>.init(method: .get, path: "certification", replaceds: [])
    /// 申请认证
    static let apply = RequestInfo<RealNameCertModel>.init(method: .post, path: "certification", replaceds: [])
    /// 更新认证
    static let update = RequestInfo<RealNameCertModel>.init(method: .put, path: "certification", replaceds: [])

}
