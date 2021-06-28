//
//  AssetNetworkManager.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/4.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  资产请求相关

enum AssetCurrencyRequestType: String {
    case fil
    case btc
    case erc
    case eth
    case usdt
    case chia = "xch"
    case usdtTrx = "usdt-trx"
}
enum AssetCurrencyType: String {
    case none
    case erc20 = "ERC20"
    case trc20 = "TRC20"
}

import Foundation

class AssetNetworkManager {

}

extension AssetNetworkManager {
    /// 全部资产信息
    class func getAllAssetInfo(complete: @escaping((_ status: Bool, _ msg: String?, _ models: [AssetInfoModel]?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = AssetRequestInfo.allAssetInfo
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        let parameter: [String: Any] = [:]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.models)
            }
        }
    }
    /// 获取资产信息
    class func getAssetInfo(_ currency: String, complete: @escaping((_ status: Bool, _ msg: String?, _ model: AssetInfoModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = AssetRequestInfo.assetInfo
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        // 2.配置参数
        var parameter: [String: Any] = ["currency": currency]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.model)
            }
        }
    }

    //    名称    类型    必须    说明
    //    coin    strig    是    流水类型:ore-矿石
    //    action    int    是    收支类型:0-所有 1-支出 2-收入
    //    type
    /// 获取资产明细列表数据
    class func getAssetLogs(_ currency: String, action: AssetActionType, limit: Int, offset: Int, type: String? = nil, complete: @escaping((_ status: Bool, _ msg: String?, _ models: [AssetListModel]?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = AssetRequestInfo.assetList
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        var parameter: [String: Any] = ["action": action.title, "limit": limit, "offset": offset, "currency": currency]
        if let type = type {
            parameter["types"] = type
        }
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.models)
            }
        }
    }

}
/// 钱包相关
extension AssetNetworkManager {
    /// 申请 URC/FIL 提币
    class func withdrawal(currency: String, amount: String, pay_pass: String, currencyType: AssetCurrencyType, complete: @escaping((_ status: Bool, _ msg: String?, _ model: WalletWithdrawResultModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = AssetRequestInfo.Wallet.withdrawal
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        var parameter: [String: Any] = ["num": amount, "pay_password": pay_pass.md5()]
        var type: AssetCurrencyRequestType = .usdt
        if currency == CurrencyType.fil.rawValue {
            type = .fil
        } else if currencyType == .erc20 && currency == CurrencyType.usdt.rawValue {
            type = .usdt
        } else if currencyType == .trc20 && currency == CurrencyType.usdt.rawValue {
            type = .usdtTrx
        }
        parameter["currency"] = type.rawValue
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error".localized, nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.model)
            }
        }
    }
    /// 获取fil资产信息
    class func
    getWalletFilInfo(complete: @escaping((_ status: Bool, _ msg: String?, _ model: AssetInfoModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = AssetRequestInfo.Wallet.filInfo
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        // 2.配置参数
        var parameter: [String: Any] = [: ]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.model)
            }
        }
    }
    class func getWalletAllInfo(complete: @escaping((_ status: Bool, _ msg: String?, _ model: [WalletAllInfoModel]?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = AssetRequestInfo.Wallet.walletAllInfo
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        // 2.配置参数
        let parameter: [String: Any] = [: ]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.models)
            }
        }
    }
    /// 刷新fil首页数据
    class func refreshHomeList(complete: @escaping((_ status: Bool, _ msg: String?, _ model: AssetInfoModel?) -> Void)) -> Void {
        SystemNetworkManager.appServerConfig { (status, msg, model) in
            guard status, let model = model else {
                complete(false, msg, nil)
                return
            }
            AppConfig.share.server = model
            Self.getWalletFilInfo(complete: complete)
        }
    }
    /// 绑定提币地址(FIL/usdt/eoc)
    class func bindWithdrawAddress(address: String, currency: String, currencyType: AssetCurrencyType, complete: @escaping (( _ status: Bool, _ msg: String?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = AssetRequestInfo.bindAddress
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        var type: AssetCurrencyRequestType = .erc
        // 2.配置参数
        if currency == CurrencyType.fil.rawValue {
            type = .fil
        } else if (currencyType == .erc20 && currency == CurrencyType.usdt.rawValue) {
            type = .erc
        } else if currencyType == .trc20 && currency == CurrencyType.usdt.rawValue {
            type = .usdtTrx
        } else if currency == CurrencyType.chia.rawValue {
            type = .chia
        }
        let parameter: [String: Any] = ["address": address, "currency": type.rawValue]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error".localized)
            case .failure(let failure):
                complete(false, failure.message)
            case .success(let response):
                complete(true, response.message)
            }
        }
    }
    /// fil提现结果
    class func filWithdrawal(amount: String, pay_pass: String, complete: @escaping((_ status: Bool, _ msg: String?, _ model: WalletWithdrawResultModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = AssetRequestInfo.Wallet.filWithdrawal
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        // 2.配置参数
        var parameter: [String: Any] = [:]
        parameter["num"] = amount
        parameter["pay_password"] = pay_pass
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.model)
            }
        }
    }
    /// fil提现结果
    class func ercWithdrawal(amount: String, pay_pass: String, currency: String, complete: @escaping((_ status: Bool, _ msg: String?, _ model: WalletWithdrawResultModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = AssetRequestInfo.Wallet.ercWithdrawal
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        // 2.配置参数
        var parameter: [String: Any] = [:]
        parameter["num"] = amount
        parameter["pay_password"] = pay_pass
        parameter["currency"] = currency
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.model)
            }
        }
    }
    /// xch提现结果
    class func xchWithdrawal(amount: String, pay_pass: String, currency: String, complete: @escaping((_ status: Bool, _ msg: String?, _ model: WalletWithdrawResultModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = AssetRequestInfo.Wallet.xchWithdrawal
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        // 2.配置参数
        var parameter: [String: Any] = [:]
        parameter["num"] = amount
        parameter["pay_password"] = pay_pass
        parameter["currency"] = currency
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.model)
            }
        }
    }
    /// bzz提现结果
    class func bzzWithdrawal(amount: String, pay_pass: String, currency: String, complete: @escaping((_ status: Bool, _ msg: String?, _ model: WalletWithdrawResultModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = AssetRequestInfo.Wallet.bzzWithdrawal
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        // 2.配置参数
        var parameter: [String: Any] = [:]
        parameter["num"] = amount
        parameter["pay_password"] = pay_pass
        parameter["currency"] = currency
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.model)
            }
        }
    }
    /// FIL提现配置信息
    class func walletWithdrawalConfig(complete: @escaping((_ status: Bool, _ msg: String?, _ model: WalletWithdrawConfigModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = AssetRequestInfo.Wallet.config
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error".localized, nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.model)
            }
        }
    }
}
/// 充值相关
extension AssetNetworkManager {
    /// 获取收款方式列表
    class func getReceiptList(complete: @escaping((_ status: Bool, _ msg: String?, _ models: [ReceiptAccountInfoModel]?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = AssetRequestInfo.Recharge.list
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        let parameter: [String: Any] = [: ]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error", nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.models)
            }
        }
    }
    /// 获取充值记录
    class func getRechargeRecords(currency: String, complete: @escaping (( _ status: Bool, _ msg: String?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = AssetRequestInfo.Recharge.rechargeRecords
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        let parameter: [String: Any] = ["currency": currency]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error".localized)
            case .failure(let failure):
                complete(false, failure.message)
            case .success(let response):
                complete(true, response.message)
            }
        }
    }
}

//extension AssetNetworkManager {
//
//    /// 钱包同步——资产列表轮询接口
//    class func walletSync(complete: @escaping((_ status: Bool, _ msg: String?) -> Void)) -> Void {
//        // 1.请求 url
//        var requestInfo = AssetRequestInfo.walletSync
//        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
//        // 2.配置参数
//        // 3.发起请求
//        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
//            switch networkResult {
//            case .error(_):
//                complete(false, "prompt.network.error")
//            case .failure(let failure):
//                complete(false, failure.message)
//            case .success(let response):
//                complete(true, response.message)
//            }
//        }
//    }
//
//

//
//}
//
//
//extension AssetNetworkManager {
//    /// 资产详情列表
//    class func getAssetDetailList(for currency: CurrencyType?, complete: @escaping((_ status: Bool, _ msg: String?, _ models: [AssetDetailModel]?) -> Void)) -> Void {
//        // 1.请求 url
//        var requestInfo = AssetRequestInfo.assetDetailList
//        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
//        // 2.配置参数
//        var parameter: [String: Any] = [:]
//        if let currency = currency {
//            parameter["currency"] = currency.rawValue
//        }
//        requestInfo.parameter = parameter
//        // 3.发起请求
//        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
//            switch networkResult {
//            case .error(_):
//                complete(false, "prompt.network.error", nil)
//            case .failure(let failure):
//                complete(false, failure.message, nil)
//            case .success(let response):
//                complete(true, response.message, response.models)
//            }
//        }
//    }
//    /// 单个资产详情
//    class func getAssetDetailInfo(for currency: CurrencyType, complete: @escaping((_ status: Bool, _ msg: String?, _ model: AssetDetailModel?) -> Void)) -> Void {
//        // 1.请求 url
//        var requestInfo = AssetRequestInfo.assetDetail
//        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [currency.rawValue])
//        // 2.配置参数
//        // 3.发起请求
//        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
//            switch networkResult {
//            case .error(_):
//                complete(false, "prompt.network.error", nil)
//            case .failure(let failure):
//                complete(false, failure.message, nil)
//            case .success(let response):
//                complete(true, response.message, response.model)
//            }
//        }
//    }
//
//}
//
//extension AssetNetworkManager {
//    /// 获取代币价格 目前只支持COMC
//    class func getCurrencyPrice(_ currency: CurrencyType, complete: @escaping((_ status: Bool, _ msg: String?, _ price: String?) -> Void)) -> Void {
//        // 1.请求 url
//        var requestInfo = AssetRequestInfo.currencyPrice
//        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [currency.rawValue])
//        // 2.配置参数
//        // 3.发起请求
//        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
//            switch networkResult {
//            case .error(_):
//                complete(false, "prompt.network.error", nil)
//            case .failure(let failure):
//                complete(false, failure.message, nil)
//            case .success(let response):
//                if let dicInfo = response.data as? [String: Any], let price = dicInfo["price"] as? String {
//                    complete(true, response.message, price)
//                } else {
//                    complete(true, response.message, nil)
//                }
//            }
//        }
//    }
//
//}
//
//extension AssetNetworkManager {
//    /// 获取提现手续费率 目前只支持COMC
//    class func getWithdrawalServiceChargeRatio(for currency: CurrencyType, complete: @escaping((_ status: Bool, _ msg: String?, _ ratio: Double?) -> Void)) -> Void {
//        // 1.请求 url
//        var requestInfo = AssetRequestInfo.withdrawalServiceChargeRatio
//        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
//        // 2.配置参数
//        let parameter: [String: Any] = ["currency": currency.rawValue]
//        requestInfo.parameter = parameter
//        // 3.发起请求
//        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
//            switch networkResult {
//            case .error(_):
//                complete(false, "prompt.network.error", nil)
//            case .failure(let failure):
//                complete(false, failure.message, nil)
//            case .success(let response):
//                if let dicInfo = response.data as? [String: Any], let ratio = dicInfo["ratio"] as? Double {
//                    complete(true, response.message, ratio)
//                } else {
//                    complete(true, response.message, nil)
//                }
//            }
//        }
//    }
//
//    /// 发送提现验证码
//    class func sendWithdrawalSmsCode(complete: @escaping((_ status: Bool, _ msg: String?) -> Void)) -> Void {
//        // 1.请求 url
//        var requestInfo = AccountRequestInfo.sendSMS
//        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
//        // 2.配置参数
//        let parameter: [String: Any] = ["scene": "cash"]
//        requestInfo.parameter = parameter
//        // 3.发起请求
//        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
//            switch networkResult {
//            case .error(_):
//                complete(false, "prompt.network.error")
//            case .failure(let failure):
//                complete(false, failure.message)
//            case .success(let response):
//                complete(true, response.message)
//            }
//        }
//    }
//
//    /// 代币提现 目前仅支持comc
//    class func withdrawalCurrency(_ currency: CurrencyType, code: String, walletAddress address: String, withdrawalAmount amount: Double, complete: @escaping((_ status: Bool, _ msg: String?) -> Void)) -> Void {
//        // 1.请求 url
//        var requestInfo = AssetRequestInfo.withdrawal
//        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
//        // 2.配置参数
//        let parameter: [String: Any] = ["currency": currency.rawValue, "code": code, "address": address, "amount": amount]
//        requestInfo.parameter = parameter
//        // 3.发起请求
//        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
//            switch networkResult {
//            case .error(_):
//                complete(false, "prompt.network.error")
//            case .failure(let failure):
//                complete(false, failure.message)
//            case .success(let response):
//                complete(true, response.message)
//            }
//        }
//    }
//
//}
