//
//  ReturnListModel.swift
//  SassProject
//
//  Created by 小唐 on 2021/7/27.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//

import Foundation
import ObjectMapper

class ReturnListModel: Mappable {
    
    ///
    var id: Int = 0
    ///
    var order_id: Int = 0
    
    ///
    var amount: Double = 0
    ///
    var pledge: Double = 0
    ///
    var gas: Double = 0
    ///
    var interest: Double = 0
    ///
    var should_interest: Double = 0
    ///
    var arrears_interest: Double = 0
    
    ///
    var created_at: Date = Date.init()
    ///
    var updated_at: Date = Date.init()

    
    required init?(map: Map) {

    }
    func mapping(map: Map) {
        id <- map["id"]
        order_id <- map["order_id"]
        
        amount <- (map["amount"], DoubleStringTransform.default)
        pledge <- (map["pledge"], DoubleStringTransform.default)
        gas <- (map["gas"], DoubleStringTransform.default)
        interest <- (map["interest"], DoubleStringTransform.default)
        should_interest <- (map["should_interest"], DoubleStringTransform.default)
        arrears_interest <- (map["arrears_interest"], DoubleStringTransform.default)
        
        created_at <- (map["created_at"], DateStringTransform.current)
        updated_at <- (map["updated_at"], DateStringTransform.current)
    }
    
    /// 实还利息
    var real_return_interest: Double {
        return interest > should_interest ? should_interest : interest
    }
    /// 归还累计欠款利息：
    var return_arrears_interest: Double {
        return interest > should_interest ? interest - should_interest : 0
    }
    
}
