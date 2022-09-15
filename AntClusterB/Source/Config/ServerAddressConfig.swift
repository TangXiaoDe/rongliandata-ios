//
//  ServerAddressConfig.swift
//  ProjectTemplate-Swift
//
//  Created by 小唐 on 2018/11/29.
//  Copyright © 2018 TangXiaoDe. All rights reserved.
//
//  服务器配置

import Foundation

struct ServerAddressConfig {
    /// 服务器地址
    var address: String = ""
    /// 接口版本 api/v2/ —— 单独的接口请求中可配置接口对应的版本
    /// 端口

    static let develop: ServerAddressConfig = ServerAddressConfig(address: "http://8.136.196.224/")
    static let release: ServerAddressConfig = ServerAddressConfig(address: "http://106.12.254.209:52525/")

    init(address: String) {
        self.address = address
    }

}
