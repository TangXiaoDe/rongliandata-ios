//
//  EquipmentListModel.swift
//  AntClusterB
//
//  Created by 小唐 on 2020/12/3.
//  Copyright © 2020 ChainOne. All rights reserved.
//

import Foundation
import ObjectMapper

enum EquipmentStatus: Int {
    /// 部署中
    case deploying = 1
    /// 挖矿中
    case mining
    /// 已关闭
    case closed
    
    var title: String {
        var title: String = ""
        switch self {
        case .deploying:
            title = "部署中"
        case .mining:
            title = "挖矿中"
        case .closed:
            title = "已关闭"
        }
        return title
    }

}

class EquipmentListModel: Mappable {
    
    var id: Int = 0
    /// 单号
    var eq_no: String = ""
    /// 当前T数
    var t_num: Int = 0
    ///
    var user_id: Int = 0
    /// 挖矿总数
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
    /// 状态 1部署中  2挖矿中 3关闭
    var status_value: Int = 0
    ///
    var createdDate: Date = Date()
    ///
    var updatedDate: Date = Date()


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
    }
    
    /// 状态
    var status: EquipmentStatus {
        var status: EquipmentStatus = EquipmentStatus.deploying
        if let realStatus = EquipmentStatus.init(rawValue: self.status_value) {
            status = realStatus
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
        let progress: Double = self.seal_num / Double(self.t_num)
        return progress
    }
    
}


extension EquipmentListModel {

    
    /// 0x2381FB挖矿中 | 0x333333部署中 | 0x999999已关闭
    /// 状态标题颜色
    var statusColor: UIColor {
        var color: UIColor
        switch self.status {
        case .deploying:
            color = UIColor.init(hex: 0x333333)
        case .mining:
            color = UIColor.init(hex: 0x2381FB)
        case .closed:
            color = UIColor.init(hex: 0x999999)
        }
        return color
    }
    
    ///
    var iconColor: UIColor {
        var color: UIColor
        switch self.status {
        case .deploying:
            color = UIColor.init(hex: 0xFF455E)
        case .mining:
            color = UIColor.init(hex: 0x2280FB)
        case .closed:
            color = UIColor.init(hex: 0xDDDDDD)
        }
        return color
    }
    
    ///
    var totalNumColor: UIColor {
        let color: UIColor = self.status == .closed ? UIColor.init(hex: 0xFFB6C0) : UIColor.init(hex: 0xFF455E)
        return color
    }
    ///
    var titleColor: UIColor {
        let color: UIColor = self.status == .closed ? UIColor.init(hex: 0x999999) : UIColor.init(hex: 0x333333)
        return color
    }
     
    
}
