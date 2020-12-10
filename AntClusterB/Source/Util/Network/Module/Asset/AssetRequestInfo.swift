//
//  AssetRequestInfo.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/4.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  资产请求相关信息

import Foundation

/// 资产请求相关信息
class AssetRequestInfo {
    /// 资产信息
    static let assetInfo = RequestInfo<AssetInfoModel>.init(method: .get, path: "wallet/asstes", replaceds: [])
    /// 全部资产信息
    static let allAssetInfo = RequestInfo<AssetInfoModel>.init(method: .get, path: "wallet/all", replaceds: [])
    /// 资产流水
    static let assetList = RequestInfo<AssetListModel>.init(method: .get, path: "wallet/logs", replaceds: [])
    /// 绑定地址
    static let bindAddress = RequestInfo<Empty>.init(method: .post, path: "fil/withdrawal-address", replaceds: [])
    
    /// 钱包相关
    struct Wallet {
        /// Fil信息
        static let filInfo = RequestInfo<WalletFilInfoModel>.init(method: .get, path: "fil/wallet", replaceds: [])
        static let filWithdrawal = RequestInfo<WalletWithdrawResultModel>.init(method: .post, path: "fil/withdrawal", replaceds: [])
        static let ercWithdrawal = RequestInfo<WalletWithdrawResultModel>.init(method: .post, path: "erc/withdrawal", replaceds: [])
        static let config = RequestInfo<WalletWithdrawConfigModel>.init(method: .get, path: "fil/withdrawal-configs", replaceds: [])
    }
    /// 充值
    struct Recharge {
        /// 获取收款方式列表
        static let list = RequestInfo<ReceiptAccountInfoModel>.init(method: .get, path: "receive-payments", replaceds: [])
        //
        static let rechargeRecords = RequestInfo<Empty>.init(method: .get, path: "recharge/records", replaceds: [])
    }
}

//class AssetRequestInfo {


//    /// 获取代币的价格
//    static let currencyPrice = RequestInfo<Empty>.init(method: .get, path: "currency/:currency/price", replaceds: [":currency"])
//    /// 资产详情列表
//    static let assetDetailList = RequestInfo<AssetDetailModel>.init(method: .get, path: "wallets", replaceds: [])
//    /// 单个资产详情
//    static let assetDetail = RequestInfo<AssetDetailModel>.init(method: .get, path: "wallet/:currency/info", replaceds: [":currency"])

//    /// 提现手续费率
//    static let withdrawalServiceChargeRatio = RequestInfo<Empty>.init(method: .get, path: "cash/ratio", replaceds: [])
//    /// 提现
//    static let withdrawal = RequestInfo<Empty>.init(method: .post, path: "cash", replaceds: [])
//    /// 同步充值——资产列表轮询接口
//    static let walletSync = RequestInfo<Empty>.init(method: .get, path: "wallet/sync", replaceds: [])
//}
