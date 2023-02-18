//
//  RealNameCertModel.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  实名认证数据模型

import Foundation
import ObjectMapper


/// 认证状态 - 返回数据
enum CertificationStatus: Int {
    case wait = 0
    case success
    case failure
}


/// 实名认证数据模型
class RealNameCertModel: Mappable {

    var id: Int = 0
//    var examiner: Int = 0
    var userId = 0
//    var certName: String = ""
    var updateDate: Date = Date()
    var createDate: Date = Date()
    /// 状态: 0-待审核 1-审核通过 2-被驳回，状态在0或1情况下，不能进行更改
    var statusValue: Int?
    /// 认证内容
//    var data: RealNameCertDataModel?

    var status: CertificationStatus {
        var status: CertificationStatus = CertificationStatus.wait
        if let statusValue = self.statusValue, let realStatus = CertificationStatus.init(rawValue: statusValue) {
            status = realStatus
        }
        return status
    }
    var userCertStatus: UserCertificationStatus {
        var certStatus: UserCertificationStatus = UserCertificationStatus.unCertified
        switch self.status {
        case .wait:
            certStatus = .waiting
        case .failure:
            certStatus = .failure
        case .success:
            certStatus = .certified
        }
        return certStatus
    }
    /// 正面照
    var strFront: String = ""
    /// 反面照
    var strBack: String = ""
    /// 手持照 [注]已取消
    var strHand: String = ""
    /// 证件号码
    var idNumber: String = ""
    /// 证件人姓名
    var name: String = ""
    /// 证件类型:id-card 身份证
    var type: String = ""
    /// status为1存在该字段，认证通过描述
    var desc: String? = nil
    /// status为2存在该字段，认证被驳回描述
    var reason: String? = nil

    var frontUrl: URL? {
        return UrlManager.fileUrl(name: self.strFront)
    }
    var backUrl: URL? {
        return UrlManager.fileUrl(name: self.strBack)
    }
    var handUrl: URL? {
        return UrlManager.fileUrl(name: self.strHand)
    }



    required init?(map: Map) {

    }
    func mapping(map: Map) {
        id <- map["id"]
//        examiner <- map["examiner"]
        userId <- map["user_id"]
//        certName <- map["certification_name"]
        updateDate <- (map["updated_at"], DateStringTransform.current)
        createDate <- (map["created_at"], DateStringTransform.current)
        statusValue <- map["status"]
//        data <- map["data"]
        strFront <- map["fpic"]
        strBack <- map["bpic"]
        strHand <- map["hpic"]
        idNumber <- map["number"]
        name <- map["name"]
        type <- map["type"]
        desc <- map["desc"]
        reason <- map["reason"]
    }

}

/// 个人认证实际数据模型
class RealNameCertDataModel: Mappable {

    /// 正面照
    var strFront: String = ""
    /// 反面照
    var strBack: String = ""
    /// 手持照 [注]已取消
    var strHand: String = ""
    /// 证件号码
    var idNumber: String = ""
    /// 证件人姓名
    var name: String = ""
    /// 证件类型:id-card 身份证
    var type: String = ""
    /// status为1存在该字段，认证通过描述
    var desc: String? = nil
    /// status为2存在该字段，认证被驳回描述
    var reason: String? = nil

    var frontUrl: URL? {
        return UrlManager.fileUrl(name: self.strFront)
    }
    var backUrl: URL? {
        return UrlManager.fileUrl(name: self.strBack)
    }
    var handUrl: URL? {
        return UrlManager.fileUrl(name: self.strHand)
    }


    required init?(map: Map) {

    }
    func mapping(map: Map) {
        strFront <- map["front"]
        strBack <- map["back"]
        strHand <- map["hand"]
        idNumber <- map["number"]
        name <- map["name"]
        type <- map["type"]
        desc <- map["desc"]
        reason <- map["reason"]
    }

}
