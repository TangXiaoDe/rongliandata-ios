//
//  BrandModel.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/6/28.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  品牌商模型

import Foundation
import ObjectMapper

class BrandModel: Mappable {
    var id: Int = 0
    /// 品牌商名称
    var name: String = ""
    /// 品牌商头像
    var avatar: String = ""
    /// fil采购总量
    var fil: Double = 0
    /// xch采购总量
    var xch: Double = 0
    /// bzz节点数
    var bzz: Double = 0

    /// 头像url
    var avatarUrl: URL? {
        return UrlManager.fileUrl(name: self.avatar)
    }

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        avatar <- map["avatar"]
        fil <- (map["fil"], DoubleStringTransform.default)
        xch <- (map["xch"], DoubleStringTransform.default)
        bzz <- (map["bzz"], DoubleStringTransform.default)
    }
}

