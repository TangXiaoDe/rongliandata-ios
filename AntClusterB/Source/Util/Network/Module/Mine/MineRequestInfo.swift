//
//  MineRequestInfo.swift
//  iMeet
//
//  Created by 小唐 on 2019/6/20.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  我的相关请求信息

import Foundation

class MineRequestInfo {

    /// 我的APIKEY
    static let myApiKey = RequestInfo<MyApiKeyModel>.init(method: .get, path: "api_key", replaceds: [])
    
}
