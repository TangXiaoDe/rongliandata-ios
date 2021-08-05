//
//  EquipmentDetailModel.swift
//  MallProject
//
//  Created by 小唐 on 2021/3/10.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  设备详情模型

import Foundation
import ObjectMapper

class EquipmentDetailModel: Mappable {
    
    ///
    var id: Int = 0
    /// 订单号
    var order_no: String = ""
    ///
    var user_id: Int = 0
    /// 数量
    var num: Int = 0
    /// 支付方式:usdt/alipay/bank
    var pay_type_value: String = ""
    /// 实际支付金额(元)
    var pay_price: Double = 0
    /// 总金额(元)
    var total_price: Double = 0
    /// USDT当前的价格 usdt_to_cny
    var usdt_price: Double = 0
    /// 优惠卷抵扣金额(元)
    var coupon_amount: Double = 0
    /// 电费包剩余天数
    var electric_remnant_days: Int = 0
    /// 电费包总天数
    var electric_total_days: Int = 0
    /// 挖矿剩余天数
    var dig_remnant_days: Int = 0
    /// 挖矿总天数
    var dig_total_days: Int = 0

    /// 总产出
    var total_output: Double = 0
    /// 昨日产出
    var yesterday_output: Double = 0
    /// 0-待支付,1-已支付(待确认)，2-已确认(部署中),3-挖矿中,4-挖矿已结束，5-已关闭
    var status_value: Int = 0

    /// 挖矿开始时间
    var digStartDate: Date = Date()
    /// 挖矿结束时间
    var digEndDate: Date = Date()
    /// 订单创建时间
    var createdDate: Date = Date()
    ///
    var updatedDate: Date = Date()
    /// 支付时间
    var payDate: Date = Date()
    /// 确认时间
    var confirmDate: Date = Date()
    /// 关闭时间
    var closeDate: Date = Date()

    /// 关闭剩余描述，支付倒计时，可能为nil
    var close_seconds: Int = 0

    /// '0普通 1永久'
    var order_cate: Int = 0
    /// 回本状态，为1表示回本100%
    var recovery: Double = 0
    /// 备注
    var remark: String = ""
    /// 关闭原因
    var reason: String? = nil
    /// 支付凭证
    var credential: String? = nil

    /// 商品相关
    var product: ProductDetailModel? = nil
    ///
    var assets: EDAssetModel? = nil
    ///
    var bank_info: Any? = nil
    ///
    var extend: EquipmentDetailExtendModel? = nil

    ///
    var admin_id: Int = 0
    ///
    var order_type: Int = 0
    ///
    var return_pledge: Double = 0
    ///
    var return_gas: Double = 0
    ///
    var wait_gas: Double = 0
    ///
    var wait_pledge: Double = 0
    
    ///
    var eq_no: String = ""
    ///
    var t_num: Int  = 0
    ///
    var total_mining: Double = 0
    ///
    var mortgage_fee: Double = 0
    ///
    var fil_level: String = ""
    ///
    var spec_level: String = ""
    ///
    var seal_num: Double = 0
    ///
    var dividend_ratio: Double = 0
    /// 利息
    var interest: Double = 0
    /// `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '期数类型 0资本垫付 1自出币',
    var type_value: Int = 0
    /// 节点号，可以为空，为空则不显示
    var group: String = ""
    ///
    var zoneValue: String = ""
    var zone: ProductZone {
        if let type = ProductZone(rawValue: self.zoneValue) {
            return type
        }
        return ProductZone.ipfs
    }

    
    /// 请求时间
    var requestDate: Date = Date()

    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        order_no <- map["order_no"]
        user_id <- map["user_id"]
        num <- map["num"]
        
        pay_type_value <- map["pay_type"]
        pay_price <- (map["pay_price"], DoubleStringTransform.default)
        total_price <- (map["total_price"], DoubleStringTransform.default)
        usdt_price <- (map["usdt_price"], DoubleStringTransform.default)
        coupon_amount <- (map["coupon_amount"], DoubleStringTransform.default)
        
        electric_remnant_days <- map["electric_remnant_days"]
        electric_total_days <- map["electric_total_days"]
        dig_remnant_days <- map["dig_remnant_days"]
        dig_total_days <- map["dig_total_days"]

        total_output <- (map["total_output"], DoubleStringTransform.default)
        yesterday_output <- (map["yesterday_output"], DoubleStringTransform.default)

        status_value <- map["status"]
        zoneValue <- map["zone"]

        digStartDate <- (map["dig_start_time"], DateStringTransform.current)
        digEndDate <- (map["dig_end_time"], DateStringTransform.current)
        createdDate <- (map["created_at"], DateStringTransform.current)
        updatedDate <- (map["updated_at"], DateStringTransform.current)
        payDate <- (map["pay_time"], DateStringTransform.current)
        confirmDate <- (map["confirm_time"], DateStringTransform.current)
        closeDate <- (map["close_time"], DateStringTransform.current)
        close_seconds <- map["close_seconds"]

        order_cate <- map["order_cate"]
        recovery <- (map["recovery"], DoubleStringTransform.default)
        remark <- map["remark"]
        reason <- map["reason"]
        credential <- map["credential"]
        
        product <- map["goods_order"]
        assets <- map["assets"]
        bank_info <- map["bank_info"]
        extend <- map["extend"]
        
        admin_id <- map["admin_id"]
        order_type <- map["order_type"]
        return_pledge <- (map["return_pledge"], DoubleStringTransform.default)
        return_gas <- (map["return_gas"], DoubleStringTransform.default)
        wait_gas <- (map["wait_gas"], DoubleStringTransform.default)
        wait_pledge <- (map["wait_pledge"], DoubleStringTransform.default)

        eq_no <- map["eq_no"]
        t_num <- map["t_num"]
        fil_level <- map["fil_level"]
        spec_level <- map["spec_level"]
        total_mining <- (map["total_mining"], DoubleStringTransform.default)
        mortgage_fee <- (map["mortgage_fee"], DoubleStringTransform.default)
        seal_num <- (map["seal_num"], DoubleStringTransform.default)
        dividend_ratio <- (map["dividend_ratio"], DoubleStringTransform.default)
        interest <- (map["interest"], DoubleStringTransform.default)
        type_value <- (map["type"], IntegerStringTransform.default)
        group <- map["group"]
    }
    
}
extension EquipmentDetailModel {

//    var status: MiningMachineOrderStatus {
//        var status: MiningMachineOrderStatus = .waitpay
//        if let realStatus = MiningMachineOrderStatus.init(rawValue: self.status_value) {
//            status = realStatus
//        }
//        return status
//    }
    var status: EquipmentStatus {
        var status: EquipmentStatus = .deploying
        if let realStatus = EquipmentStatus.init(rawValue: self.status_value) {
            status = realStatus
        }
        return status
    }
    /// 封装状态
    var pkg_status: EquipPackageStatus {
        var status: EquipPackageStatus = EquipPackageStatus.deploying
        switch self.status {
        case .deploying:
            status = .deploying
        case .closed:
            status = .closed
        case .mining:
            // 封装进度大于 72%，则显示已完成，否则显示进行中
            status = self.fengcun_progress > 0.72 ? .done : .doing
        }
        return status
    }
    
    /// 封存进度=封装数量 / 当期T数
    var fengcun_progress: Double {
        if self.t_num <= 0 {
            return 0
        }
        let progress: Double = self.seal_num / Double(self.t_num)
        return progress
    }
    
    var voucher_url: URL? {
        return UrlManager.fileUrl(name: self.credential)
    }
    
    ///
    var pay_type: MallPayType {
        var pay_type: MallPayType = MallPayType.usdt
        if let real_pay_type: MallPayType = MallPayType.init(rawValue: self.pay_type_value) {
            pay_type = real_pay_type
        }
        return pay_type
    }
    /// 支付倒计时剩余时间
    var left_seconds: Int {
        let total_seconds: Int = self.close_seconds
        let pass_seconds: Int = Int(Date().timeIntervalSince(self.requestDate))
        let real_seconds: Int = max(0, total_seconds - pass_seconds)
        return real_seconds
    }
    /// 电费包预计结束时间
    var expectedDate: Date {
        let timeInterval = TimeInterval(self.electric_remnant_days * 24 * 3_600)
        let endDate: Date = Date.init(timeInterval: timeInterval, since: Date())
        return endDate
    }
    
    /// 是否是永久的
    var isPermanent: Bool {
        return self.order_cate == 1
    }
    
    /// 回本比例
    var recory_progress: Double {
        return 0
//        guard let increase = AppConfig.share.currencyPrice, let product = self.product else {
//            return 0
//        }
//        var currency_price: Double = 0
//        switch product.zone {
//        case .btc:
//            currency_price = increase.btc?.price ?? 0
//        case .eth:
//            currency_price = increase.eth?.price ?? 0
//        case .ipfs:
//            currency_price = increase.ipfs?.price ?? 0
//        }
//        //
//        var progress: Double = 0
//        if self.recovery >= 1 {
//            progress = 1
//        } else if self.total_price <= 0 {
//            progress = 0
//        } else {
//            let outpuNum = NSDecimalNumber.init(value: self.total_output)
//            let currencyPriceNum = NSDecimalNumber.init(value: currency_price)
//            let totalPriceNum = NSDecimalNumber.init(value: self.total_price)
//            let resultNum = outpuNum.multiplying(by: currencyPriceNum).dividing(by: totalPriceNum)
//            //progress = self.total_output * currency_price / self.total_price    // total_price 为现金
//            progress = resultNum.doubleValue
//        }
//        progress = max(0, progress)
//        progress = min(1, progress)
//        return progress
    }
    
    /// 质押类型：资本垫付、自付
    var zhiya_type: EquipZhiyaType {
        var type: EquipZhiyaType = EquipZhiyaType.dianfu
        if let realType = EquipZhiyaType.init(rawValue: self.type_value) {
            type = realType
        }
        return type
    }
    
}

///
class EDAssetModel: Mappable {

    ///
    var id: Int = 0
    ///
    var order_id: Int = 0

    /// 挖矿总数
    var total_ming: Double = 0
    /// 可用数量
    var available: Double = 0
    /// 锁仓数量
    var lock: Double = 0
    /// 冻结数量
    var frozen: Double = 0
    /// 抵押数量
    var pawn: Double = 0
    /// 封装数
    var fz_num: Double = 0
    /// 使用质押币数量
    var pledge: Double = 0
    /// Gas消耗数量
    var gas: Double = 0
    /// 已归还质押币数量
    var return_pledge: Double = 0
    /// 已归还Gas消耗数量
    var return_gas: Double = 0
    /// 待归还累计欠款利息
    var interest: Double = 0
    /// 自付gas
    var used_gas: Double = 0
    /// 自付质押
    var used_pledge: Double = 0

    ///
    var createdDate: Date = Date.init()
    ///
    var updatedDate: Date = Date.init()
    
    /// 待归还
    var wait_pledge: Double {
        return self.pledge - self.return_pledge
    }
    var wait_gas: Double {
        return self.gas - self.return_gas
    }

    /// 待归还总计
    var wait_total: Double {
        return self.wait_pledge + self.wait_gas + self.interest
    }

    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        order_id <- map["order_id"]
        
        total_ming <- (map["total_ming"], DoubleStringTransform.default)
        available <- (map["available"], DoubleStringTransform.default)
        lock <- (map["lock"], DoubleStringTransform.default)
        frozen <- (map["frozen"], DoubleStringTransform.default)
        pawn <- (map["pawn"], DoubleStringTransform.default)
        fz_num <- (map["fz_num"], DoubleStringTransform.default)
        pledge <- (map["pledge"], DoubleStringTransform.default)
        gas <- (map["gas"], DoubleStringTransform.default)
        return_pledge <- (map["return_pledge"], DoubleStringTransform.default)
        return_gas <- (map["return_gas"], DoubleStringTransform.default)
        interest <- (map["interest"], DoubleStringTransform.default)
        used_gas <- (map["used_gas"], DoubleStringTransform.default)
        used_pledge <- (map["used_pledge"], DoubleStringTransform.default)

        createdDate <- (map["created_at"], DateStringTransform.current)
        updatedDate <- (map["updated_at"], DateStringTransform.current)
    }

}


class EquipmentDetailExtendModel: Mappable {
    
    var lock: Double = 0
    var pawn: Double = 0
    var frozen: Double = 0
    var security: Double = 0
    var withdrawable: Double = 0
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        lock <- (map["lock"], DoubleStringTransform.default)
        pawn <- (map["pawn"], DoubleStringTransform.default)
        frozen <- (map["frozen"], DoubleStringTransform.default)
        security <- (map["security"], DoubleStringTransform.default)
        withdrawable <- (map["withdrawable"], DoubleStringTransform.default)
    }
    
}

