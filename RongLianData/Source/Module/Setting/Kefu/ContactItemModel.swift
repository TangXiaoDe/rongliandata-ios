//
//  ContactItemModel.swift
//  SassProject
//
//  Created by 小唐 on 2020/11/23.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  单个联系方式

import Foundation

///
class ContactItemModel {
    /// 标题
    var title: String = ""
    /// 账号
    var account: String = ""


    init(title: String, account: String) {
        self.title = title
        self.account = account
    }

}
