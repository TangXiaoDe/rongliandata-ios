//
//  AssetInfoModel.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/4.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  用户资产数据模型

import Foundation
import ObjectMapper

/// 用户资产数据模型
class AssetInfoModel: Mappable {
    /// 累计收益
    var income: String = "0.0"
    /// 保证金金额
    var security: String = "0.0"
    /// 提现中金额
    var withdraw_ing: String = "0.0"
    /// 已提现金额
    var withdraw_finish: String = "0.0"
    /// 冻结金额
    var frozen: Double = 0
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
    /// 已封存数量
    var total_seal: Double = 0
    /// 总存力
    var total_save_power: Double = 0

    /// 资产余额
    var balance: String = "0.0"
    /// 总收益
    var total: String = "0.0"
    /// 总支出
    var expend: String = "0.0"
    /// 待反还
    var wait: String = "0.0"
    /// 能量值
    var power: Int = 0
    
    /// 资产余额
    var ore: Double = 0.0
    // 手动赋值 判断地址
    var currencyType: AssetCurrencyType = .none
    /// 可提现金额
    var withdrawable: String = "0.0"
    
    /// 币种
    var coinValue: String = ""
    var currency: CurrencyType {
        if let type = CurrencyType(rawValue: self.coinValue) {
            return type
        }
        return CurrencyType.fil
    }
    
    /// 标题
    var title: String {
        var title: String = self.coinValue.uppercased()
        if self.coinValue == CurrencyType.usdt.rawValue {
             title = "USDT"
        }
        if self.coinValue == CurrencyType.fil.rawValue {
             title = "FIL"
        }
        if self.coinValue == CurrencyType.chia.rawValue {
            title = "XCH"
        }
        return title
    }
    
    /// Fil资产余额
    var fil_balance: String {
        if let withdrawable = Double(withdrawable), let lock = Double(lock), let pawn = Double(pawn), let security = Double(security) {
            let balance = withdrawable + lock + pawn + security + self.frozen
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
        if self.withdrawal_address != nil && !self.withdrawal_address!.isEmpty {
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
    /// 注：已封存数量从后台返回
//    /// 已封存数量：XXTB，计算方式为钱包抵押金额除以 全局钱包config archive
//    var cunNum: CGFloat {
//        if let pawn = Double(pawn), let config = AppConfig.share.server?.filConfig, let archive = Double(config.archive) {
//            if (pawn/archive).isNaN {
//                return 0
//            }
//            return CGFloat(pawn/archive)
//        }
//        return 0
//    }
    /// 已封存数量除以总存力
    var cunProgress: String {
        if self.total_save_power <= 0.000001 {
            return "0"
        }
        let progress = self.total_seal/total_save_power
        return Double(progress * 100).decimalValidDigitsProcess(digits: 2)
    }
    
    init() {
        
    }
    init(currency: String) {
        self.coinValue = currency
    }

    required init?(map: Map) {

    }
    func mapping(map: Map) {
        balance <- map["balance"]
        income <- map["income"]
        total <- map["total"]
        expend <- map["expend"]
        wait <- map["wait"]
        power <- map["power"]
        coinValue <- map["currency"]
        ore <- (map["balance"], DoubleStringTransform.default)
        withdrawable <- map["withdrawable"]
        
        security <- map["security"]
        withdraw_ing <- map["withdraw_ing"]
        withdraw_finish <- map["withdraw_finish"]
        lock <- map["lock"]
        pawn <- map["pawn"]
        fil_to_cny <- map["fil_to_cny"]
        withdrawal_address <- map["withdrawal_address"]
        address <- map["address"]
        total_seal <- (map["total_seal"], DoubleStringTransform.default)
        total_save_power <- (map["total_save_power"], DoubleStringTransform.default)
        frozen <- (map["frozen"], DoubleStringTransform.default)
    }
    // 提现手续费
    var withdrawFee: Double {
        var withdrawFee: Double = 0.0
        guard let withdrawModel = AppConfig.share.server?.getWithdrawalConfig(with: self.currency) else {
            return withdrawFee
        }
        switch self.currency {
        case .fil:
            withdrawFee = withdrawModel.fil_fee
        case .usdt:
            if self.currencyType == .erc20 {
                withdrawFee = withdrawModel.usdt_erc_fee
            } else {
                withdrawFee = withdrawModel.usdt_trx_fee
            }
        case .chia:
            withdrawFee = withdrawModel.xch_fee
        default:
            withdrawFee = withdrawModel.erc_fee
        }
        return withdrawFee
    }
    // 最低提现
    var withdrawMin: Double {
        var user_min: Double = 0.0
        guard let withdrawModel = AppConfig.share.server?.getWithdrawalConfig(with: self.currency) else {
            return user_min
        }
        switch self.currency {
        case .fil:
            user_min = withdrawModel.user_min
        default:
            user_min = withdrawModel.user_min
        }
        return user_min
    }
    var withdrawAddress: String {
        var withdrawAddress: String = ""
        guard let userModel = AccountManager.getCurrentInfo() else {
            return withdrawAddress
        }
        switch self.currency {
        case .fil:
            withdrawAddress = userModel.withdrawal_address
        case .usdt:
            if self.currencyType == .erc20 {
                withdrawAddress = userModel.withdrawal_address
            } else {
                withdrawAddress = userModel.withdrawal_address
            }
        case .chia:
            withdrawAddress = userModel.withdrawal_address
        default:
            break
        }
        return withdrawAddress
    }
    /// 资产余额(fil和其他资产公用)
    var lfbalance: Double {
        var balance: Double = 0
        if self.currency == .fil {
            balance = Double(self.withdrawable) ?? 0
        } else {
            balance = self.ore
        }
        return balance
    }
}
