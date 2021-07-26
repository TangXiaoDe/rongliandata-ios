//
//  WalletAllInfoModel.swift
//  AntClusterB
//
//  Created by crow on 2021/5/17.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit
import ObjectMapper

class WalletAllInfoModel: Mappable {
    var id: Int = 0
    var user_id: Int = 0
    var balance: String = "0"
    var currency: String = "xch"
    var expend: String = ""
    var wait: String = ""
    var income: String = ""
    var withdrawable: String = ""

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        balance <- map["balance"]
        currency <- map["currency"]
        withdrawable <- map["withdrawable"]
        income <- map["income"]
        expend <- map["expend"]
        wait <- map["wait"]
    }
}

extension WalletAllInfoModel {
    var currencyType: CurrencyType {
        var type: CurrencyType = .fil
        if self.currency == "fil" {
            type = .fil
        } else if self.currency == "xch" {
            type = .chia
        } else if self.currency == "bzz" {
            type = .bzz
        }
        return type
    }
    
    var bgImage: UIImage {
        var imgStr: String = "IMG_mine_fil_bg"
        switch self.currencyType {
        case .fil:
            imgStr = "IMG_mine_fil_bg"
        case .chia:
            imgStr = "IMG_mine_xch_bg"
        case .bzz:
            imgStr = "IMG_mine_bzz_bg"
        default:
            break
        }
        return UIImage(named: imgStr)!
    }
}

//class WalletFilModel: Mappable {
//    var id: Int = 0
//    var user_id: Int = 0
//    var balance: String = "0"
//    var currency: String = "fil"
//    var withdrawable: String = ""
//    var income: String = ""
//    
//    required init?(map: Map) {
//
//    }
//    func mapping(map: Map) {
//        id <- map["id"]
//        user_id <- map["user_id"]
//        balance <- map["balance"]
//        currency <- map["currency"]
//        withdrawable <- map["withdrawable"]
//        income <- map["income"]
//    }
//}
//
//class WalletXchModel: Mappable {
//    var id: Int = 0
//    var user_id: Int = 0
//    var balance: String = "0"
//    var currency: String = "xch"
//    var expend: String = ""
//    var wait: String = ""
//    var income: String = ""
//
//    required init?(map: Map) {
//
//    }
//    func mapping(map: Map) {
//        id <- map["id"]
//        user_id <- map["user_id"]
//        balance <- map["balance"]
//        currency <- map["currency"]
//        expend <- map["expend"]
//        wait <- map["wait"]
//        income <- map["income"]
//    }
//}

