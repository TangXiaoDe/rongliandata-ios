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

    /// 资产余额
    var balance: String = "0.0"
    /// 总收益
    var income: String = "0.0"
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
    var withdrawable: Double = 0.0
    
    /// 币种
    var coinValue: String = ""
    var currency: CurrencyType {
        if let type = CurrencyType(rawValue: self.coinValue) {
            return type
        }
        return CurrencyType.usdt
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
        withdrawable <- (map["withdrawable"], DoubleStringTransform.default)
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
            withdrawAddress = userModel.currencyAddress.fil_address
        case .usdt:
            if self.currencyType == .erc20 {
                withdrawAddress = userModel.currencyAddress.erc_address
            } else {
                withdrawAddress = userModel.currencyAddress.usdt_trx_address
            }
        default:
            break
        }
        return withdrawAddress
    }
    /// 是否绑定提币地址
    var isBindWithdrawAddress: Bool {
        if !self.withdrawAddress.isEmpty {
            return true
        }
        return false
    }
    /// 资产余额(fil和其他资产公用)
    var lfbalance: Double {
        var balance: Double = 0
        if self.currency == .fil {
            balance = self.withdrawable
        } else {
            balance = self.ore
        }
        return balance
    }
}
