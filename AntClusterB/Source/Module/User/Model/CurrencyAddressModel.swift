//
//  CurrencyAddressModel.swift
//  MallProject
//
//  Created by zhaowei on 2021/3/12.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import Foundation
import ObjectMapper

/// 用户提币地址
class CurrencyAddressModel: Mappable {

    var fil_address: String = ""
    var erc_address: String = ""
    var btc_address: String = ""
    var usdt_trx_address: String = ""

    init() {

    }

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        fil_address <- map["fil_address"]
        erc_address <- map["erc_address"]
        btc_address <- map["btc_address"]
        usdt_trx_address <- map["usdt-trx_address"]
    }

    // MARK: - Realm
    init(object: CurrencyAddressObject) {
        self.fil_address = object.fil_address
        self.erc_address = object.erc_address
        self.btc_address = object.btc_address
        self.usdt_trx_address = object.usdt_trx_address

    }
    func object() -> CurrencyAddressObject {
        let object = CurrencyAddressObject()
        object.fil_address = self.fil_address
        object.erc_address = self.erc_address
        object.btc_address = self.btc_address
        object.usdt_trx_address = self.usdt_trx_address
        return object
    }

}
