//
//  BrandBonusModel.swift
//  RongLianData
//
//  Created by 小唐 on 2021/7/26.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import Foundation
import ObjectMapper

class BrandBonusModel: Mappable {
    var logs: [BrandBonusListModel] = []
    var total: Double = 0

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        logs <- map["logs"]
        total <- (map["total"], DoubleStringTransform.default)
    }
}
