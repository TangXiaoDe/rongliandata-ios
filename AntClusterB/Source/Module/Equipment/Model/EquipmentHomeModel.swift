//
//  EquipmentHomeModel.swift
//  AntClusterB
//
//  Created by 小唐 on 2020/12/4.
//  Copyright © 2020 ChainOne. All rights reserved.
//

import Foundation
import ObjectMapper

class EquipmentHomeModel: Mappable {
    
    var total: Double = 0
    var list: [EquipmentListModel] = []
        
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        total <- (map["total"], DoubleStringTransform.default)
        list <- map["list"]
    }
    
}
