//
//  EDAssetReturnListModel.swift
//  MallProject
//
//  Created by 小唐 on 2021/3/10.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import Foundation
import ObjectMapper

class EDAssetReturnListModel: Mappable {

    ///
    var id: Int = 0
    ///
    var order_id: Int = 0
    /// 质押币
    var pledge: Double = 0
    /// gas
    var gas: Double = 0
    /// 利息6%
    var interest: Double = 0
    ///
    var createdDate: Date = Date.init()
    ///
    var updatedDate: Date = Date.init()


    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        order_id <- map["order_id"]
        pledge <- (map["pledge"], DoubleStringTransform.default)
        gas <- (map["gas"], DoubleStringTransform.default)
        interest <- (map["interest"], DoubleStringTransform.default)
        createdDate <- (map["created_at"], DateStringTransform.current)
        updatedDate <- (map["updated_at"], DateStringTransform.current)
    }

}
