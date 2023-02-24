//
//  EquipmentListModel.swift
//  RongLianData
//
//  Created by 小唐 on 2020/12/3.
//  Copyright © 2020 ChainOne. All rights reserved.
//

import Foundation
import ObjectMapper

/// 设备状态
enum EquipmentStatus: Int {
    /// 部署中
    case deploying = 1
    /// 运行中
    case mining
    /// 已关闭
    case closed
    
    var title: String {
        var title: String = ""
        switch self {
        case .deploying:
            title = "部署中"
        case .mining:
            title = "工作中" //"运行中"
        case .closed:
            title = "已关闭"
        }
        return title
    }
    
    /// 状态标题颜色
    var titleColor: UIColor {
        var color: UIColor
        switch self {
        case .deploying:
            color = UIColor.init(hex: 0xE16940)
        case .mining:
            color = UIColor.init(hex: 0x4444FF)
        case .closed:
            color = UIColor.init(hex: 0x999999)
        }
        return color
    }

}

/// 封装状态
enum EquipPackageStatus {
    /// 部署中
    case deploying
    /// 进行中
    case doing
    /// 已完成
    case done
    /// 已关闭
    case closed
    
    /// 封装标题
    var title: String {
        var title: String = ""
        switch self {
        case .deploying:
            title = "部署中"
        case .doing:
            title = "工作中" //"进行中"
        case .done:
            title = "已完成"
        case .closed:
            title = "已关闭"
        }
        return title
    }
    
    /// 状态标题颜色
    var titleColor: UIColor {
        var color: UIColor
        switch self {
        case .doing:
            color = UIColor.init(hex: 0x4444FF)
        case .deploying:
            color = UIColor.init(hex: 0xE16940)
        case .done:
            color = UIColor.init(hex: 0x999999)
        case .closed:
            color = UIColor.init(hex: 0x999999)
        }
        return color
    }
    
}

/// 设备质押类型：资本垫付、自付
enum EquipZhiyaType: Int {
    case dianfu = 0
    case zifu = 1
}

class EquipmentListModel: Mappable {
    
    var id: Int = 0
    /// 单号
    var eq_no: String = ""
    /// 当前T数
    var t_num: Int = 0
    ///
    var user_id: Int = 0
    /// 累计收益
    var total_ming: Double = 0
    /// 抵押金额
    var mortgage_fee: Double = 0
    /// 封存数量/封装数量
    var seal_num: Double = 0
    ///
    var amin_id: Int = 0
    /// 期号，如：2020111201
    var fil_level: String = ""
    /// 规格，如：1个月
    var spec_level: String = ""
    /// 状态 1部署中  2运行中 3关闭
    var status_value: Int = 0
    ///
    var createdDate: Date = Date()
    ///
    var updatedDate: Date = Date()
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


    init(no: String) {
        self.eq_no = no
    }
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        eq_no <- map["eq_no"]
        t_num <- map["t_num"]
        user_id <- map["user_id"]
        total_ming <- (map["total_ming"], DoubleStringTransform.default)
        mortgage_fee <- (map["mortgage_fee"], DoubleStringTransform.default)
        seal_num <- (map["seal_num"], DoubleStringTransform.default)
        amin_id <- map["amin_id"]
        fil_level <- map["fil_level"]
        spec_level <- map["spec_level"]
        createdDate <- (map["created_at"], DateStringTransform.current)
        updatedDate <- (map["updated_at"], DateStringTransform.current)
        status_value <- map["status"]
        zoneValue <- map["zone"]
        type_value <- (map["type"], IntegerStringTransform.default)
        group <- map["group"]
    }
    
    /// 设备状态
    var status: EquipmentStatus {
        var status: EquipmentStatus = EquipmentStatus.deploying
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
     
    
    
    // 注：封装数量由后台返回，前端不再计算。
//    /// 封装数量=  抵押金额 / (后台配置封存配比 * 当期T数)
//    var fengzhuang_num: Double {
//        guard let config = AppConfig.share.server?.filConfig else {
//            return 0
//        }
//        if config.equip_archive < 0.000001 {
//            return 0
//        }
//        let num = self.mortgage_fee / (config.equip_archive * Double(self.t_num))
//        return num
//    }

    /// 封存进度=封装数量 / 当期T数
    var fengcun_progress: Double {
        if self.t_num <= 0 {
            return 0
        }
        var progress: Double = self.seal_num / Double(self.t_num)
        progress = min(progress, 1)
        return progress
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


extension EquipmentListModel {

    
    /// 0x2381FB运行中 | 0x333333部署中 | 0x999999已关闭
    /// 状态标题颜色
    var statusColor: UIColor {
        var color: UIColor
        switch self.status {
        case .deploying:
            color = UIColor.init(hex: 0xC9A063)
        case .mining:
            color = UIColor.init(hex: 0x00B8FF)
        case .closed:
            color = UIColor.init(hex: 0x666666)
        }
        return color
    }
    
    ///
    var iconColor: UIColor {
        var color: UIColor
        switch self.status {
        case .deploying:
            color = UIColor.init(hex: 0xD26C2F)
        case .mining:
            color = UIColor.init(hex: 0x2EA7E0)
        case .closed:
            color = UIColor.init(hex: 0x666666)
        }
        return color
    }
    
    ///
    var totalNumColor: UIColor {
        //let color: UIColor = self.status == .closed ? UIColor.init(hex: 0xFFB6C0) : UIColor.init(hex: 0xD26C2F)
        //return color
        return AppColor.themeRed
    }
    ///
    var titleColor: UIColor {
        let color: UIColor = self.status == .closed ? UIColor.init(hex: 0x999999) : UIColor.init(hex: 0x333333)
        return color
    }

    var totalUnit: String {
        return self.zone == .bzz ? " 节点" : " T"
    }
}
