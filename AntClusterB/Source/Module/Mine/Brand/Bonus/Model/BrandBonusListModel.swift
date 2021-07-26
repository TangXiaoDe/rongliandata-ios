//
//  BrandBonusListModel.swift
//  AntClusterB
//
//  Created by crow on 2021/7/26.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import Foundation
import ObjectMapper

class BrandBonusListModel: Mappable {
    var id: Int = 0
    var title: String = ""
    var user_id: Int = 0
    var target_user_id: Int = 0
    var target_id: Int = 0
    var amount: Double = 0
    var action: Int = 0
    var status: Int = 0
    var currency: String = ""
    var type: String = ""
    var updated_at: String = ""
    var created_at: String = ""
    var extend: BrandBonusExtendModel? = nil

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        user_id <- map["user_id"]
        target_user_id <- map["target_user_id"]
        target_id <- map["target_id"]
        amount <- (map["amount"], DoubleStringTransform.default)
        action <- map["action"]
        status <- map["status"]
        currency <- map["currency"]
        type <- map["type"]
        updated_at <- map["updated_at"]
        created_at <- map["created_at"]
        extend <- map["extend"]
    }
}

class BrandBonusExtendModel: Mappable {
    var all: String = ""
    var amount: String = ""
    var percent: String = ""
    var issue_id: Int = 0

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        all <- map["all"]
        amount <- map["amount"]
        percent <- map["percent"]
        issue_id <- map["issue_id"]
    }
}
