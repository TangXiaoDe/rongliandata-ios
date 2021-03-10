//
//  ProductDetailModel.swift
//  RenRenProject
//
//  Created by 小唐 on 2020/11/3.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  商品详情数据模型

import Foundation
import ObjectMapper

/// 商品专区类型
//专区: btc/eth/ipfs
enum ProductZone: String {
    /// BTC
    case btc
    /// ETH
    case eth
    /// IPFS
    case ipfs = "fil"
    
    var title: String {
        var title: String = self.rawValue.uppercased()
        switch self {
        case .btc:
            title = "BTC"
        case .eth:
            title = "ETH"
        case .ipfs:
            title = "IPFS"
        }
        return title
    }

}

/// 商品类型 —— Special
// 商品类型:商品类型:common-普通/register-注册可领/novice-新手特供
enum ProductType: String {
    /// 普通
    case common
    /// 注册可领
    case register
    /// 新手特供
    case novice
}

typealias MallProductModel = ProductDetailModel
/// 商品详情数据模型
class ProductDetailModel: Mappable {

    /// 商品ID
    var id: Int = 0
    /// 名称
    var name: String = ""
    /// 图片集合,第一张为首图
    var image_names: [String] = []
    /// 订单中商品图片使用image字段
    var image_name: String? = nil
    /// 售卖价格
    var price: Double = 0
    /// 市场价
    var market_price: Double = 0
    /// 库存
    var stock: Int = 0
    /// T量
    var spec: Int = 0
    /// 年限
    var years: Int = 0
    /// 专区类型
    var zone_value: String = ""
    /// 产品回报率：55%-80%
    var rate: String = ""
    /// 回报率描述
    var rate_desc: String = ""
    /// 限时购买截止时间，可能为空
    var endDate: Date? = nil
    /// 结束秒数，-1表示非限时商品
    var end_seconds: Int = -1
    ///
    var is_delete: Bool = false
    ///
    var createdDate: Date = Date()
    ///
    var updatedDate: Date = Date()

    /// 限制数量 0-无限制
    var limit: Int = 0
    /// 矿机算力(MH/S)
    var power: String = ""
    /// 矿机功耗KW
    var power_waste: String = ""
    /// 日产出(天/台
    var daily_output: String = ""
    /// 运营维护费回本前(百分比)
    var before: Double = 0
    /// 运营维护费回本后(百分比)
    var after: Double = 0
    /// 单台矿机耗电(度数/天)
    var electric_degree: Double = 0
    /// 托管费率
    var custody_rate: String = ""
    /// 风险说
    var risk_description: String = ""
    /// 业务说明
    var business_description: String = ""
    /// 商品类型:商品类型:common-普通/register-注册可领/novice-新手特供
    var type_value: String = ""
    ///
    var period_id: Int = 0
    ///
    var period: ProductPeriodModel? = nil
    /// 电费包天数
    var electric_days: [Int] = []
    /// 回本周期
    var cycle: Int = 0
    /// power_type 0:不要电费  1:全年电价  2:全年显卡电价  3:沣枯转换
    var power_type: Int = 0
    /// 电价(元/度)
    var electric_price: Double {
        return self.config_electric_price
    }
    
    /// 请求时间，用于倒计时计算
    var requestDate: Date = Date()

    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        image_names <- map["images"]
        image_name <- map["image"]
        price <- (map["price"], DoubleStringTransform.default)
        market_price <- (map["market_price"], DoubleStringTransform.default)
        stock <- map["stock"]
        spec <- map["spec"]
        years <- map["years"]
        zone_value <- map["zone"]
        rate <- map["rate"]
        rate_desc <- map["rate_desc"]
        endDate <- (map["end_time"], DateStringTransform.current)
        end_seconds <- map["end_seconds"]
        is_delete <- map["is_delete"]
        createdDate <- (map["created_at"], DateStringTransform.current)
        updatedDate <- (map["updated_at"], DateStringTransform.current)
        
        limit <- map["limit"]
        power <- map["power"]
        power_waste <- map["power_waste"]
        daily_output <- map["daily_output"]
        cycle <- (map["cycle"], IntegerStringTransform.default)
        before <- (map["before"], DoubleStringTransform.default)
        after <- (map["after"], DoubleStringTransform.default)
        //electric_price <- (map["electric_price"], DoubleStringTransform.default)
        electric_degree <- (map["electric_degree"], DoubleStringTransform.default)
        power_type <- map["power_type"]
        custody_rate <- map["custody_rate"]
        risk_description <- map["risk_description"]
        business_description <- map["business_description"]
        type_value <- map["type"]
        period_id <- map["period_id"]
        period <- map["period"]
        electric_days <- map["electric_days_list"]
//        // 限时抢购：已结束状态
//        self.end_seconds = -123
//        //  限时抢购：已抢光状态
//        self.stock = 0
//        //  限时抢购变更为正常商品：已售罄状态
//        self.endDate = nil
//        self.end_seconds = -1
//        self.stock = 0
    }
        
    ///
    var image_urls: [String] {
        var image_urls: [String] = []
        for imageName in self.image_names {
            if let strImageUrl = UrlManager.strFileUrl(name: imageName)as? String {
                image_urls.append(strImageUrl)
            }
        }
        return image_urls
    }
    ///
    var image_url: URL? {
        var url: URL? = nil
        if let image_name = self.image_name, !image_name.isEmpty {
            url = UrlManager.fileUrl(name: image_name)
        } else if let str_image_url = self.image_urls.first {
            url = URL.init(string: str_image_url)
        }
        return url
    }
    /// 
    var sku: String {
        let term: String = self.years > 0 ? "\(self.years)年" : "永久"
        return "\(self.spec)T/" + term
    }
    
    ///
    var zone: ProductZone {
        var zone: ProductZone = ProductZone.ipfs
        if let realZone = ProductZone.init(rawValue: self.zone_value) {
            zone = realZone
        }
        return zone
    }
    
    var type: ProductType {
        var type: ProductType = ProductType.common
        if let realType = ProductType.init(rawValue: self.type_value) {
            type = realType
        }
        return type
    }
    
    /// 是否售罄
    var is_sell_out: Bool {
        let is_sell_out: Bool = self.stock <= 0
        return is_sell_out
    }
    /// 最大购买数：库存限制 + 购买个数限制
    var buy_max_num: Int {
        var num: Int = 1
        num = max(1, self.stock)
        if self.limit > 0 {
            num = min(num, self.limit)
        }
        return num
    }
    
    /// 限时商品判断
    var is_limit_time: Bool {
        let flag: Bool = self.end_seconds != -1 && self.endDate != nil
        return flag
    }
    /// 限时结束判断
    var is_time_end: Bool {
        let flag: Bool = !(self.is_limit_time && self.left_seconds > 0)
        return flag
    }
    /// 倒计时剩余秒数
    var left_seconds: Int {
        let pass_seconds: Int = Int(Date().timeIntervalSince(self.requestDate))
        let left_seconds: Int = self.end_seconds - pass_seconds
        let seconds: Int = max(0, left_seconds)
        return seconds
    }
    
    /// 不需要电费包
    var need_efp: Bool {
        //let need_efp: Bool = (self.zone == .ipfs || self.type != .common) ? false : true
        //return need_efp
        // 三期更新为所有的都不需要电费包
        return false
    }

    
}

extension ProductDetailModel {

    /// config 电价
    var config_electric_price: Double {
//        var config_electric_price: Double = 0
//        guard let config = AppConfig.share.server?.electricityModel else {
//            return config_electric_price
//        }
//        // power_type 0:不要电费  1:全年电价  2:全年显卡电价  3:沣枯转换
//        switch self.power_type {
//        case 0:
//            break
//        case 1:
//            config_electric_price = config.year
//        case 2:
//            config_electric_price = config.gpu_year
//        case 3:
//            let monthDay: (month: Int, day: Int) = Date.init().getMonthDay()
//            if monthDay.month >= config.start_month && monthDay.month <= config.end_month {
//                config_electric_price = config.full_water
//            } else {
//                config_electric_price = config.low_water
//            }
//        default:
//            break
//        }
//        return config_electric_price
        return 0
    }
    
    /// 托管电费 x/天/台
    var trust_electric_fee: Double {
        let priceNum = NSDecimalNumber.init(value: self.electric_price)
        let degreeNum = NSDecimalNumber.init(value: self.electric_degree)
        let resultNum = priceNum.multiplying(by: degreeNum)
        return resultNum.doubleValue
    }
    
    /// USDT价格
    var usdt_price: Double {
        return 0
//        guard let usdt = AppConfig.share.currencyPrice?.usdt else {
//            return self.price
//        }
//        let usdt_to_cny: Double = usdt.to_cny
//        let priceNum = NSDecimalNumber.init(value: self.price)
//        let scaleNum = NSDecimalNumber.init(value: usdt_to_cny)
//        let resultNum = priceNum.dividing(by: scaleNum)
//        let result = resultNum.doubleValue
//        return result
    }
    
    /// 当日币价
    var currency_price: Double? {
        return 0
//        var currencyPrice: Double? = nil
//        guard let currency = AppConfig.share.currencyPrice else {
//            return currencyPrice
//        }
//        switch self.zone {
//        case .btc:
//            currencyPrice = currency.btc?.to_cny
//        case .eth:
//            currencyPrice = currency.eth?.to_cny
//        case .ipfs:
//            currencyPrice = currency.ipfs?.to_cny
//        }
//        return currencyPrice
    }

    /// 日产出人民币
    var str_dayout_cny: String {
        var result: String = ""
        guard let dayout_zone = Double(self.daily_output), let currencyPrice = self.currency_price else {
            return result
        }
        let dayoutNum = NSDecimalNumber.init(value: dayout_zone)
        let priceNum = NSDecimalNumber.init(value: currencyPrice)
        let resultNum = priceNum.multiplying(by: dayoutNum)
        result = resultNum.doubleValue.decimalValidDigitsProcess(digits: 2)
        return result
    }
    
//    /// 电费包选项
//    var efp_options: [ProductEFPItemModel] {
//        var models: [ProductEFPItemModel] = []
//        for day in electric_days {
//            let dailyPriceNum = NSDecimalNumber.init(value: self.trust_electric_fee)
//            let daysNum = NSDecimalNumber.init(value: day)
//            let resultNum = dailyPriceNum.multiplying(by: daysNum)
//            let model = ProductEFPItemModel.init(days: day, price: resultNum.doubleValue)
//            models.append(model)
//        }
//        return models
//    }
    
    /// 算力费 ￥xx/T
    var power_price: Double {
        if self.spec == 0 {
            return 0
        }
        let totalPriceNum = NSDecimalNumber.init(value: self.price)
        let specNum = NSDecimalNumber.init(value: self.spec)
        let resultNum = totalPriceNum.dividing(by: specNum)
        return resultNum.doubleValue
    }
    /// 算力费单位：区分ETH（M），BTC（T）,IPFS（T）
    var power_price_unit: String {
        var unit: String = ""
        switch self.zone {
        case .btc:
            unit = "T"
        case .eth:
            unit = "M"
        case .ipfs:
            unit = "T"
        }
        return unit
    }
    /// 算力描述
    var power_desc: String {
        // IPFS专区的算力显示xxT
        var desc: String = ""
        switch self.zone {
        case .btc:
            desc = "\(self.power) TH/S"
        case .eth:
            desc = "\(self.power) MH/S"
        case .ipfs:
            desc = "\(self.spec) T"
        }
        return desc
    }

}

extension ProductDetailModel {
    
    /// 是否可购买
    var could_buy: Bool {
        // 限时判断、限时结束判断、库存判断
        let isLimitTime: Bool = self.is_limit_time
        let isTimeEnd: Bool = self.is_time_end
        let hasStock: Bool = self.stock > 0
        var flag: Bool = hasStock
        if isLimitTime && isTimeEnd {
            flag = false
        }
        return flag
    }
    
    /// 列表按钮
    var list_btn_title: String {
        var title: String = ""
        // 限时判断、限时结束判断、库存判断：已结束|已抢光|已售罄|抢 购|购 买
        let isLimitTime: Bool = self.is_limit_time
        let isTimeEnd: Bool = self.is_time_end
        let hasStock: Bool = self.stock > 0
        if isLimitTime {
            if isTimeEnd {
                title = "已结束"
            } else {
                title = hasStock ? "抢 购" : "已抢光"
            }
        } else {
            title = hasStock ? "购 买" : "已售罄"
        }
        return title
    }
    var detail_btn_title: String {
        var title: String = ""
        switch self.list_btn_title {
        case "抢 购":
            title = "立即抢购"
        case "购 买":
            title = "立即购买"
        case "已抢光":
            title = "已抢光"
        case "已结束":
            title = "已结束"
        case "已售罄":
            title = "已售罄"
        default:
            break
        }
        return title
    }
    
    /// 列表价格颜色
    var list_price_color: UIColor {
        var color: UIColor = UIColor.init(hex: 0xE06236)
        if self.is_sell_out || (self.is_limit_time && self.is_time_end) {
            color = UIColor.init(hex: 0x8C97AC)
        } else {
            color = UIColor.init(hex: 0xE06236)
        }
        return color
    }
        
    var donebtn_bgColors: [CGColor] {
        var colors: [CGColor] = [UIColor.init(hex: 0x2EA7E0).cgColor, UIColor.init(hex: 0x4AC2D0).cgColor]
        switch self.list_btn_title {
        case "抢 购":
            colors = [UIColor.init(hex: 0xE06236).cgColor, UIColor.init(hex: 0xFCB61F).cgColor]
        case "已抢光":
            fallthrough
        case "已结束":
            fallthrough
        case "已售罄":
            colors = [UIColor.init(hex: 0xBFC3D9).cgColor, UIColor.init(hex: 0xCFD2E7).cgColor]
        case "购 买":
            colors = [UIColor.init(hex: 0x2EA7E0).cgColor, UIColor.init(hex: 0x4AC2D0).cgColor]
        default:
            break
        }
        return colors
    }

}

extension ProductDetailModel {
    
    /// 专区标记背景色
    var zoneFlagBgColor: UIColor {
        // ETH(4365B3)、IPFS(58B1B1)、BTC(DF8929)
        var color: UIColor = AppColor.pageBg
        switch self.zone {
        case .eth:
            color = UIColor.init(hex: 0x4365B3)
        case .ipfs:
            color = UIColor.init(hex: 0x58B1B1)
        case .btc:
            color = UIColor.init(hex: 0xDF8929)
        }
        return color
    }
    
}



/// 期数
class ProductPeriodModel: Mappable {
    
    ///
    var id: Int = 0
    /// 期数名称
    var name: String = ""
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
}

