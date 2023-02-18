//
//  JiYanConfigModel.swift
//  ChainGame
//
//  Created by crow on 2021/8/5.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit
import ObjectMapper

class JiYanConfigModel: Mappable {
    static let api_1 = "\(AppConfig.share.serverAddr.address)api/first_register"
    static let api_2 = "\(AppConfig.share.serverAddr.address)api/verification-codes"
    
    // api_1返回数据
    var success: NSNumber = 0
    var gt: String = ""
    var challenge: String = ""
    var new_captcha: Bool = false

    // api_2返回数据
    
    required init?(map: Map) {

    }
    func mapping(map: Map) {
        success <- map["success"] // , IntegerStringTransform.default)
        gt <- map["gt"]
        challenge <- map["challenge"]
        new_captcha <- map["new_captcha"]
    }

}
