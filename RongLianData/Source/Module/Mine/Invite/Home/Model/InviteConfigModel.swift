//
//  InviteConfigModel.swift
//  iMeet
//
//  Created by 小唐 on 2019/2/19.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  邀请配置数据模型

import Foundation
import ObjectMapper

/// 邀请配置数据模型
class InviteConfigModel: Mappable {

    /// 海报列表
    var posters: [InvitePosterModel] = []
    /// 邀请信息
    var info: InviteInfoModel = InviteInfoModel()

    /// 海报列表
    var items: [String] = []
    /// 邀请链接
    var invitelink: String = ""

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        items <- map["items"]
        invitelink <- map["invite_url"]
        for strItem in items {
            self.posters.append(InvitePosterModel.init(name: "", image: strItem))
        }
    }

}

/// 邀请海报
class InvitePosterModel: Mappable {

    var id: Int = 0
    var name: String = ""
    var image: String = ""
    // 图片路径
    var url: String = ""

    init(name: String = "", image: String = "") {
        self.name = name
        self.image = image
    }

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        image <- map["name"]
        url <- map["url"]
    }
}

/// 邀请信息
class InviteInfoModel: Mappable {

    /// 邀请方式
    var mode: String = ""
    /// 邀请说明
    var rule: String = ""
    /// 邀请链接说明
    var url_rule: String = ""
    /// 邀请链接
    var strUrl: String = ""
    /// 邀请奖励
    //var power: Int = 0
    var f_power: String = ""
    var s_power: String = ""

    init() {

    }

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        mode <- map["mode"]
        rule <- map["rule"]
        strUrl <- map["invite_url"] //
        url_rule <- map["url_rule"]
        //power <- map["power"]
        f_power <- map["f_power"]
        s_power <- map["s_power"]
    }
}
