//
//  WithdrawConfigModel.swift
//  StorageChain
//
//  Created by zhaowei on 2020/10/27.
//  Copyright © 2020 ChainOne. All rights reserved.
//

import Foundation
import ObjectMapper

/// 钱包提现配置数据模型
class WalletWithdrawConfigModel: Mappable {
    /// erc提现配置
    var xchWithdrawConfigModel: WithdrawConfigModel?
    /// fil提现配置
    var filWithdrawConfigModel: WithdrawConfigModel?

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        xchWithdrawConfigModel <- map["xch"]
        filWithdrawConfigModel <- map["fil"]
    }

}
