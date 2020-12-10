//
//  FirstPageRequestInfo.swift
//  HZProject
//
//  Created by 小唐 on 2020/11/13.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  首页相关请求信息

import Foundation

/// 首页相关请求信息
class FirstPageRequestInfo
{
    /// 主页相关信息
    static let home = RequestInfo<FirstPageHomeModel>.init(method: .get, path: "home", replaceds: [])
    
    /// USDT兑人民币比例
    static let usdtToRmb = RequestInfo<Empty>.init(method: .get, path: "usdt/price", replaceds: [])
    
}
