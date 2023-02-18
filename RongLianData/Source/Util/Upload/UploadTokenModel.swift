//
//  UploadTokenModel.swift
//  RongLianData
//
//  Created by zhaowei on 2019/6/15.
//  Copyright © 2019 ChainOne. All rights reserved.
//  上传凭证模型

import Foundation
import ObjectMapper

class UploadTokenModel: Mappable {

    var SecurityToken: String = ""
    var AccessKeyId: String = ""
    var AccessKeySecret: String = ""
    var Expiration: String = ""
    var BucketName: String = ""
    var EndPoint: String = ""

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        SecurityToken <- map["SecurityToken"]
        AccessKeyId <- map["AccessKeyId"]
        AccessKeySecret <- map["AccessKeySecret"]
//        Expiration <- (map["Expiration"], DateStringTransform.current)
        Expiration <- map["Expiration"]
        BucketName <- map["BucketName"]
        EndPoint <- map["EndPoint"]
    }
}
