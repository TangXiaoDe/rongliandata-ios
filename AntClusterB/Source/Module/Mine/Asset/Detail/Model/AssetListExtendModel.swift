//
//  AssetListExtendModel.swift
//  iMeet
//
//  Created by 小唐 on 2019/9/25.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  资产列表的扩展数据模型 - 社群升级相关附加信息

import Foundation
import ObjectMapper

class AssetListExtendModel: Mappable {
    /// 挖矿数
    var amount: Double = 0
    /// 封装数
    var fz_num: Double = 0
    ///
    var filWithdrawalFee: Double = 0

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        amount <- (map["amount"], DoubleStringTransform.default)
        fz_num <- (map["fz_num"], DoubleStringTransform.default)
        filWithdrawalFee <- (map["fee"], DoubleStringTransform.default)
    }

}
