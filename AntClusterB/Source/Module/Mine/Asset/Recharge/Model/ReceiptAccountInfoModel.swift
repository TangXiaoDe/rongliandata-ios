//
//  ReceiptAccountInfoModel.swift
//  ChuangYe
//
//  Created by zhaowei on 2020/8/20.
//  Copyright © 2020 ChainOne. All rights reserved.
//
import Foundation
import ObjectMapper

class ReceiptAccountInfoModel: Mappable {
    /// 名字
    var name: String = ""
    /// 账号
    var number: String = ""
    /// 收款码
    var code_pic: String = ""
    
    var coinValue: String = ""
    
    /// 二维码url
    var codeUrl: URL? {
        return UrlManager.fileUrl(name: self.code_pic)
    }

    init() {
        
    }

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        name <- map["name"]
        number <- map["number"]
        code_pic <- map["code_pic"]
        coinValue <- map["type"]
    }
}
