//
//  EquipmentListModel.swift
//  AntMachine
//
//  Created by 小唐 on 2020/12/3.
//  Copyright © 2020 ChainOne. All rights reserved.
//

import Foundation
import ObjectMapper

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
    ///
    var amin_id: Int = 0
    /// 期号，如：2020111201
    var fil_level: String = ""
    /// 规格，如：1个月
    var spec_level: String = ""
    ///
    var createdDate: Date = Date()
    ///
    var updatedDate: Date = Date()

    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        eq_no <- map["eq_no"]
        t_num <- map["t_num"]
        user_id <- map["user_id"]
        total_ming <- (map["total_ming"], DoubleStringTransform.default)
        mortgage_fee <- (map["mortgage_fee"], DoubleStringTransform.default)
        amin_id <- map["amin_id"]
        fil_level <- map["fil_level"]
        spec_level <- map["spec_level"]
        createdDate <- (map["created_at"], DateStringTransform.current)
        updatedDate <- (map["updated_at"], DateStringTransform.current)
    }
    
    
    /// 封装数量=  抵押金额 / (后台配置封存配比 * 当期T数)
    var fengzhuang_num: Double {
        guard let config = AppConfig.share.server?.filConfig else {
            return 0
        }
        if config.equip_archive < 0.000001 {
            return 0
        }
        let num = self.mortgage_fee / (config.equip_archive * Double(self.t_num))
        return num
    }

    /// 封存进度=封装数量 / 当期T数
    var fengcun_progress: Double {
        if self.t_num <= 0 {
            return 0
        }
        let progress: Double = self.fengzhuang_num / Double(self.t_num)
        return progress
    }
    
}
