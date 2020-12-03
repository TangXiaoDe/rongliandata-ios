//
//  SettingHomeModel.swift
//  ProjectTemplate-Swift
//
//  Created by 小唐 on 2019/1/10.
//  Copyright © 2019 TangXiaoDe. All rights reserved.
//
//  设置主页的数据模型
//  可考虑移除，请参考SettingItemModel

import Foundation
import UIKit

class SettingHomeModel {
    var icon: UIImage?
    var title: String?
    var detail: String?
    var accessory: UIImage?

    init(icon: UIImage? = nil, title: String? = nil, detail: String? = nil, accessory: UIImage? = nil) {
        self.icon = icon
        self.title = title
        self.detail = detail
        self.accessory = accessory
    }

}
