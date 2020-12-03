//
//  WalletPlaceModel.swift
//  JXProject
//
//  Created by zhaowei on 2020/10/15.
//  Copyright © 2020 ChainOne. All rights reserved.
//

import Foundation
import ObjectMapper

/// 用户Fil数据模型
class WalletFilInfoModel: Mappable {
    /// 累计收益
    var income: String = "0.0"
    /// 保证金金额
    var security: String = "0.0"
    /// 可提现金额
    var withdrawable: String = "0.0"
    /// 提现中金额
    var withdraw_ing: String = "0.0"
    /// 已提现金额
    var withdraw_finish: String = "0.0"
    /// 锁仓金额
    var lock: String = "0.0"
    /// 抵押金额
    var pawn: String = "0.0"
    /// Fil资产余额折算人民币金额
    var fil_to_cny: String = "0.0"
    // fil 充币地址
    var address: String = ""
    /// 提币地址:null未绑定
    var withdrawal_address: String?
    
    /// 总存力
//    var total_save_power: String = "0.0"
    var str_total_save_power: String = ""
    var int_total_save_power: Int = 0
    var total_save_power: String {
        var power: String = self.str_total_save_power
        if self.str_total_save_power.isEmpty {
            if self.int_total_save_power >= 0 {
                power = "\(self.int_total_save_power)"
            }
        }
        return power
    }
    
    /// Fil资产余额
    var fil_balance: String {
        if let withdrawable = Double(withdrawable), let lock = Double(lock), let pawn = Double(pawn), let security = Double(security) {
            let balance = withdrawable + lock + pawn + security
            return balance.decimalValidDigitsProcess(digits: 4)
        }
        return ""
    }
    /// 可用余额
    var canUse_balance: String {
        if let security = Double(security), let withdrawable = Double(withdrawable) {
            let balance = security + withdrawable
            return balance.decimalValidDigitsProcess(digits: 4)
        }
        return ""
    }
    /// 可用比例
    var canUse_bili: CGFloat {
        if let canUse_balance = Double(self.canUse_balance), let config = AppConfig.share.server?.filConfig, let canUseTotal = Double(config.total_enable) {
            return CGFloat(canUse_balance/canUseTotal)
        }
        return 0.0
    }
    /// 锁仓比例
    var lock_bili: CGFloat {
        if let lock_balance = Double(self.lock), let config = AppConfig.share.server?.filConfig, let lockTotal = Double(config.total_lock) {
            return CGFloat(lock_balance/lockTotal)
        }
        return 0.0
    }
    /// 抵押比例
    var pawn_bili: CGFloat {
        if let pawn_balance = Double(self.pawn), let config = AppConfig.share.server?.filConfig, let pawnTotal = Double(config.total_pawn) {
            return CGFloat(pawn_balance/pawnTotal)
        }
        return 0.0
    }
    /// 是否绑定提币地址
    var isBindWithdrawAddress: Bool {
        if let address = self.withdrawal_address, !address.isEmpty {
            return true
        }
        return false
    }
    /// tips
    var tips: String {
        if let config = AppConfig.share.server?.filConfig {
            return config.tips
        }
        return ""
    }
    /// 已封存数量：XXTB，计算方式为钱包抵押金额除以 全局钱包config archive
    var cunNum: CGFloat {
        if let pawn = Double(pawn), let config = AppConfig.share.server?.filConfig, let archive = Double(config.archive) {
            if (pawn/archive).isNaN {
                return 0
            }
            return CGFloat(pawn/archive)
        }
        return 0
    }
    /// 已封存数量除以总存力
    var cunProgress: String {
        if let total_save_power = Double(self.total_save_power) {
            var cunProgress = self.cunNum/CGFloat(total_save_power)
            if cunProgress.isNaN {
                cunProgress = 0
            }
            return Double(cunProgress * 100).decimalValidDigitsProcess(digits: 0)
        }
        return "0"
    }
    
    required init?(map: Map) {

    }
    func mapping(map: Map) {
        income <- map["income"]
        security <- map["security"]
        withdrawable <- map["withdrawable"]
        withdraw_ing <- map["withdraw_ing"]
        withdraw_finish <- map["withdraw_finish"]
        lock <- map["lock"]
        pawn <- map["pawn"]
        fil_to_cny <- map["fil_to_cny"]
        withdrawal_address <- map["withdrawal_address"]
        address <- map["address"]
//        total_save_power <- map["total_save_power"]
        int_total_save_power <- map["total_save_power"]
        str_total_save_power <- map["total_save_power"]
    }

}
