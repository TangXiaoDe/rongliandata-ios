//
//  ApiKeyModel.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/9/23.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  ApiKey模型

import Foundation
import ObjectMapper

///
class MyApiKeyModel: Mappable {

    var api_key: String = ""
    var api_secret: String = ""

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        api_key <- map["api_key"]
        api_secret <- map["api_secret"]
    }

}
