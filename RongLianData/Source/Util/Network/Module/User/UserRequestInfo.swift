//
//  UserRequestInfo.swift
//  iMeet
//
//  Created by 小唐 on 2019/6/5.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  用户相关请求信息

import Foundation


/// 用户相关请求信息
class UserRequestInfo {
    /// 获取用户信息
    static let getCurrentUser = RequestInfo<CurrentUserModel>.init(method: .get, path: "user", replaceds: [])
    /// 更新用户信息
    static let updateCurrentUser = RequestInfo<CurrentUserModel>.init(method: .patch, path: "user", replaceds: [])
    /// 获取用户设置 - 当前用户
    static let getUserSetting = RequestInfo<Empty>.init(method: .post, path: "setting", replaceds: [])
    /// 用户设置修改 - 当前用户
    static let updateUserSetting = RequestInfo<Empty>.init(method: .patch, path: "setting", replaceds: [])

    /// 获取指定用户信息
    static let getUserById = RequestInfo<CommonUserDetailModel>.init(method: .get, path: "users/{id}", replaceds: ["{id}"])
    /// 获取指定用户信息
    static let searchUser = RequestInfo<SimpleUserModel>.init(method: .get, path: "user/info", replaceds: [])

    /// 主页背景图
    static let background = RequestInfo<Empty>.init(method: .post, path: "user/background", replaceds: [])

    /// 等级规则
//    static let levelRule = RequestInfo<LevelRuleModel>.init(method: .get, path: "grade", replaceds: [])


    /// 获取所有的用户标签及分组
//    static let allUserTags = RequestInfo<UserTagSectionModel>.init(method: .get, path: "user/tags", replaceds: [])

    /// 推荐用户
    static let recommendUsers = RequestInfo<SimpleUserModel>.init(method: .get, path: "recommend/users", replaceds: [])


//    /// 提交用户信息上链
//    static let submitUpChain = RequestInfo<UpChainResultModel>.init(method: .post, path: "up/fisco", replaceds: [])
//    /// 获取用户上链信息
//    static let getUpChain = RequestInfo<UpChainInfoModel>.init(method: .get, path: "get/fisco", replaceds: [])
}
