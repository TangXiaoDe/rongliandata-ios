//
//  PreReturnResultModel.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/8/5.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  提前还款结果数据模型

import Foundation
import ObjectMapper

class PreReturnResultModel: Mappable {
    
    ///
    var type_value: String = ""
    /// 质押币
    var pledge: Double = 0
    /// gas
    var gas: Double = 0
    ///
    var interest: Double = 0

    ///
    var createdDate: Date = Date.init()


    init() {
        
    }
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        type_value <- map["type"]
        pledge <- (map["pledge"], DoubleStringTransform.default)
        gas <- (map["gas"], DoubleStringTransform.default)
        interest <- (map["interest"], DoubleStringTransform.default)
        createdDate <- (map["time"], DateStringTransform.current)
    }
    
    
    var type: PreReturnType {
        var value: PreReturnType = PreReturnType.all
        if let realValue = PreReturnType.init(rawValue: self.type_value) {
            value = realValue
        }
        return value
    }
    
    var totalReturnAmount: Double {
        return self.pledge + self.gas + self.interest
    }

}

