//
//  UserNetworkManager.swift
//  iMeet
//
//  Created by 小唐 on 2019/6/5.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  用户相关请求接口

import Foundation

class UserNetworkManager {

}

// MARK: - 用户信息
extension UserNetworkManager {
    /// 获取用户信息
    class func getCurrentUser(complete: @escaping((_ status: Bool, _ msg: String?, _ model: CurrentUserModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = UserRequestInfo.getCurrentUser
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
                if let model = response.model {
                    AccountManager.share.updateCurrentAccount(userInfo: model)
                    if !AppConfig.share.internal.settedJPushAlias {
                        JPushHelper.instance.setAlias("\(model.id)")
                    }
                }
            }
        }
    }

    /// 获取指定用户信息
    class func getUserInfoByUserId(_ userId: Int, complete: @escaping((_ status: Bool, _ msg: String?, _ model: CommonUserDetailModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = UserRequestInfo.getUserById
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: ["\(userId)"])
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
    
    /// 搜索用户
    class func searchUser(phone: String, complete: @escaping((_ status: Bool, _ msg: String?, _ model: SimpleUserModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo: RequestInfo<SimpleUserModel> = UserRequestInfo.searchUser
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        let parameter: [String: Any] = ["phone": phone]
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

    /// 背景图
    class func updateUserBackground(_ bgd: String, complete: @escaping((_ status: Bool, _ msg: String?, _ model: Any?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = UserRequestInfo.background
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        var parameter: [String: Any] = ["bgd": bgd]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error".localized, nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.sourceData)
            }
        }
    }
}

// MARK: - 修改用户信息
extension UserNetworkManager {
//    /// 更新用户信息
    class func updateCurrentUser(name: String? = nil, sex: Int? = nil, avatar: String? = nil, complete: @escaping (( _ status: Bool, _ msg: String?, _ model: CurrentUserModel?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = UserRequestInfo.updateCurrentUser
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        var parameter: [String: Any] = [:]
        if let name = name {
            parameter["name"] = name
        }
        if let sex = sex {
            parameter["sex"] = sex
        }
        if let avatar = avatar {
            parameter["avatar"] = avatar
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
                complete(true, response.message, response.model)
                if let model = response.model {
                    AccountManager.share.updateCurrentAccount(userInfo: model)
                }
            }
        }
    }
    /// 头像修改
    class func updateCurrentUser(icon: UIImage, complete: @escaping (( _ status: Bool, _ msg: String?, _ model: CurrentUserModel?) -> Void)) -> Void {
        // 1. 上传图片
        UploadManager.share.uploadImages([icon], ModuleName: "") { (status, msg, models) in
            guard status, let model = models?.first else {
                complete(status, msg, nil)
                return
            }
            // 2. 更新头像
            self.updateCurrentUser(name: nil, sex: nil, avatar: model.filename, complete: complete)
        }
    }

}

extension UserNetworkManager {
//    /// 获取等级规则
//    class func getLevelRule(complete: @escaping (( _ status: Bool, _ msg: String?, _ model: LevelRuleModel?) -> Void)) -> Void {
//        // 1.请求 url
//        var requestInfo = UserRequestInfo.levelRule
//        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
//        // 2.配置参数
//        // 3.发起请求
//        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
//            switch networkResult {
//            case .error(_):
//                complete(false, "prompt.network.error".localized, nil)
//            case .failure(let failure):
//                complete(false, failure.message, nil)
//            case .success(let response):
//                complete(true, response.message, response.model)
//            }
//        }
//    }

}

extension UserNetworkManager {
//    /// 获取所有的用户标签
//    class func getAllUserTags(complete: @escaping (( _ status: Bool, _ msg: String?, _ models: [UserTagSectionModel]?) -> Void)) -> Void {
//        // 1.请求 url
//        var requestInfo = UserRequestInfo.allUserTags
//        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
//        // 2.配置参数
//        // 3.发起请求
//        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
//            switch networkResult {
//            case .error(_):
//                complete(false, "prompt.network.error".localized, nil)
//            case .failure(let failure):
//                complete(false, failure.message, nil)
//            case .success(let response):
//                complete(true, response.message, response.models)
//            }
//        }
//    }

}

extension UserNetworkManager {
    /// 获取推荐用户列表
    class func getRecommendUserList(type: RecommendUserType, offset: Int, limit: Int, complete: @escaping (( _ status: Bool, _ msg: String?, _ models: [SimpleUserModel]?) -> Void)) -> Void {
        // 1.请求 url
        var requestInfo = UserRequestInfo.recommendUsers
        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
        // 2.配置参数
        let parameter: [String: Any] = ["type": type.rawValue, "offset": offset, "limit": limit]
        requestInfo.parameter = parameter
        // 3.发起请求
        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(false, "prompt.network.error".localized, nil)
            case .failure(let failure):
                complete(false, failure.message, nil)
            case .success(let response):
                complete(true, response.message, response.models)
            }
        }
    }

    /// 自动刷新-推荐用户：当请求结果列表为空时，重置offset为0进行请求
    class func getRecommendUserListAutoRefresh(type: RecommendUserType, offset: Int, limit: Int, complete: @escaping((_ status: Bool, _ msg: String?, _ data: (models: [SimpleUserModel], isRefresh: Bool)?) -> Void)) -> Void {
        // 1. 正常请求
        self.getRecommendUserList(type: type, offset: offset, limit: limit) { (status, msg, models) in
            guard status, let models = models else {
                complete(status, msg, nil)
                return
            }
            // 2. 判断是否需要刷新
            if !models.isEmpty {
                let data = (models: models, isRefresh: false)
                complete(status, msg, data)
                return
            }
            // 3. 需要刷新时则刷新
            self.getRecommendUserList(type: type, offset: 0, limit: limit, complete: { (status, msg, models) in
                guard status, let models = models else {
                    complete(status, msg, nil)
                    return
                }
                let data = (models: models, isRefresh: true)
                complete(status, msg, data)
            })
        }
    }

}

// MARK: - 上链相关
extension UserNetworkManager {
    
//    class func submitUpChain(user: CurrentUserModel, complete: @escaping((_ status: Bool, _ msg: String?, _ model: UpChainResultModel?) -> Void)) -> Void {
//        let gradeIcon: String = user.grade?.smallIconFileName ?? ""
//        let strTag: String = user.tagJoin(with: " ") ?? ""
//        UserNetworkManager.submitUpChain(nickName: user.name, gradeIcon: gradeIcon, tags: strTag, complete: complete)
//    }
//    // tags    string    是    用户标签:各标签间用空格隔开(社区 完美 大师)
//    // grade    string    是    用户等级图标
//    // nick_name    string    是    用户昵称
//    /// 提交用户信息上链
//    class func submitUpChain(nickName: String, gradeIcon: String, tags: String, complete: @escaping((_ status: Bool, _ msg: String?, _ model: UpChainResultModel?) -> Void)) -> Void {
//        // 1.请求 url
//        var requestInfo = UserRequestInfo.submitUpChain
//        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
//        // 2.配置参数
//        let parameter: [String: Any] = ["nick_name": nickName, "grade": gradeIcon, "tags": tags]
//        requestInfo.parameter = parameter
//        // 3.发起请求
//        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
//            switch networkResult {
//            case .error(_):
//                complete(false, "prompt.network.error".localized, nil)
//            case .failure(let failure):
//                complete(false, failure.message, nil)
//            case .success(let response):
//                complete(true, response.message, response.model)
//            }
//        }
//    }
//    /// 获取用户上链信息
//    class func getUpChain(complete: @escaping((_ status: Bool, _ msg: String?, _ model: UpChainInfoModel?) -> Void)) -> Void {
//        // 1.请求 url
//        var requestInfo = UserRequestInfo.getUpChain
//        requestInfo.urlPath = requestInfo.fullPathWith(replacers: [])
//        // 2.配置参数
//        // 3.发起请求
//        NetworkManager.share.request(requestInfo: requestInfo) { (networkResult) in
//            switch networkResult {
//            case .error(_):
//                complete(false, "prompt.network.error".localized, nil)
//            case .failure(let failure):
//                complete(false, failure.message, nil)
//            case .success(let response):
//                complete(true, response.message, response.model)
//            }
//        }
//    }

}
