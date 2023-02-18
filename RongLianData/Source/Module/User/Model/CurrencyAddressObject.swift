//
//  CurrencyAddressObject.swift
//  MallProject
//
//  Created by zhaowei on 2021/3/12.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import Foundation
import RealmSwift

/// 提币地址的数据库模型
class CurrencyAddressObject: Object {

    /// fil提币地址
    @objc dynamic var fil_address: String = ""
    /// ETH USDT erc20 提币地址
    @objc dynamic var erc_address: String = ""
    /// btc提币地址
    @objc dynamic var btc_address: String = ""
    /// usdt trc20 提币地址
    @objc dynamic var usdt_trx_address: String = ""

    /// 设置主键
    override static func primaryKey() -> String? {
        return "fil_address"
    }
    /// 设置索引
    override static func indexedProperties() -> [String] {
        return ["fil_address"]
    }
}
