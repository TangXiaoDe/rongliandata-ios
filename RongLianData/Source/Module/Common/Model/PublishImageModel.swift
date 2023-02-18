//
//  PublishImageModel.swift
//  RongLianData
//
//  Created by zhaowei on 2019/6/17.
//  Copyright © 2019 ChainOne. All rights reserved.
//  动态上传图片模型/封面模型

import Foundation
import ObjectMapper

//  图片
typealias ImageUploadModel = PublishImageModel

class PublishImageModel: Mappable {
    var mime: String = "png"
    var width: CGFloat = 0
    var height: CGFloat = 0
    var filename: String = ""

    init(filename: String = "", width: CGFloat = 0, height: CGFloat = 0) {
        self.filename = filename
        self.width = width
        self.height = height
    }
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }

    required init?(map: Map) {
    }

    // Mappable
    func mapping(map: Map) {
        mime <- map["mime"]
        width <- map["width"]
        height <- map["height"]
        filename <- map["filename"]
    }
}
