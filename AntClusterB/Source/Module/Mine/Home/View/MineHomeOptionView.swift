//
//  MineHomeOptionView.swift
//  CCMall
//
//  Created by 小唐 on 2019/1/17.
//  Copyright © 2019 COMC. All rights reserved.
//
//  MineHome页底部选项视图
/**
 注1: 之前我的资产未填写时显示我的资产，已填写后显示邀请记录；今需更正为：邀请记录一直存在，我的资产未填写时显示我的资产，已填写后不予显示；
 **/

import UIKit

protocol MineHomeOptionViewProtocol: class {
    /// 账户安全
    func optionView(_ optionView: MineHomeOptionView, didSelectedAccount itemView: MineHomeOptionItemControl) -> Void
    /// 个人资料
    func optionView(_ optionView: MineHomeOptionView, didSelectedUserInfo itemView: MineHomeOptionItemControl) -> Void
    /// 我的品牌商
    func optionView(_ optionView: MineHomeOptionView, didSelectedMyBrandBusiness itemView: MineHomeOptionItemControl) -> Void
    /// 清除缓存
    func optionView(_ optionView: MineHomeOptionView, didSelectedClearCache itemView: MineHomeOptionItemControl) -> Void
    /// 退出登录
    func optionView(_ optionView: MineHomeOptionView, didSelectedLogout itemView: MineHomeOptionItemControl) -> Void
    /// 我的APIKEY
    func optionView(_ optionView: MineHomeOptionView, didSelectedMyApiKey itemView: MineHomeOptionItemControl) -> Void
}
extension MineHomeOptionViewProtocol {

}

class MineHomeOptionView: UIView {

    // MARK: - Internal Property

    weak var delegate: MineHomeOptionViewProtocol?
    
    var cacheSize: UInt? {
        didSet {
            guard let cacheSize = cacheSize  else {
                return
            }
            let strCache = String(format: "%d.0 M", cacheSize / (1024 * 1024))
            self.cacheItemControl.detail = strCache
        }
    }

    // MARK: - Private Property

    /// 注：我的资产、绑定iFuture 可能更改
    fileprivate var sections: [[[String: String]]] = [[[:]]]

    fileprivate let lrMargin: CGFloat = 0
    fileprivate let verMargin: CGFloat = 10
    fileprivate let tbMargin: CGFloat = 0
    fileprivate let itemTagBase: Int = 250
    fileprivate weak var cacheItemControl: MineHomeOptionItemControl!

    fileprivate let inviteCodeIndex: Int = 0
//    fileprivate let inviteRecordIndex: Int = 3
//    fileprivate let ecologicalIndex: Int = 4
    fileprivate let versionIndex: Int = 4

    // MARK: - Initialize Function

    init() {
        super.init(frame: CGRect.zero)
        self.initialUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialUI()
    }

}

// MARK: - Internal Function
extension MineHomeOptionView {
    class func loadXib() -> MineHomeOptionView? {
        return Bundle.main.loadNibNamed("MineHomeOptionView", owner: nil, options: nil)?.first as? MineHomeOptionView
    }
}

// MARK: - LifeCircle Function
extension MineHomeOptionView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}

// MARK: - Private  UI
extension MineHomeOptionView {

    // 界面布局
    fileprivate func initialUI() -> Void {
        let accountItem: [String: String] = ["title": "账户安全", "image": "IMG_mine_icon_zhaq"]
        let userInfoItem: [String: String] = ["title": "个人资料", "image": "IMG_mine_icon_zl"]
        let brandInfoItem: [String: String] = ["title": "我的品牌商", "image": "IMG_mine_icon_pps"]
        let clearItem: [String: String] = ["title": "清除缓存", "image": "IMG_mine_icon_qc"]
        let apiKeyItem: [String: String] = ["title": "我的APIKEY", "image": "IMG_mine_icon_api"]
        let logoutItem: [String: String] = ["title": "退出登录", "image": "IMG_mine_icon_tc"]
        var firstItems: [[String: String]] = [accountItem, userInfoItem]
        if AccountManager.share.currentAccountInfo?.userInfo?.user_type == 1 {
            firstItems.append(brandInfoItem)
        }
        let normalItems: [[[String: String]]] = [firstItems, [apiKeyItem, clearItem, logoutItem]]
        let shieldItems: [[[String: String]]] = [firstItems, [apiKeyItem, clearItem, logoutItem]]
        self.sections = AppConfig.share.shield.currentNeedShield ? shieldItems : normalItems
        self.setupWithSections(self.sections)
    }

    /// 数据加载
    fileprivate func setupWithSections(_ sections: [[[String: String]]]) -> Void {
        self.removeAllSubView()
        self.backgroundColor = AppColor.pageBg
        var topView: UIView = self
        var itemIndex: Int = 0
        for (index, dictArray) in sections.enumerated() {
            let sectionView = UIView()
            self.addSubview(sectionView)
            sectionView.backgroundColor = UIColor.white
//            sectionView.set(cornerRadius: 10)
            sectionView.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(lrMargin)
                make.trailing.equalToSuperview().offset(-lrMargin)
                if 0 == index {
                    make.top.equalToSuperview().offset(tbMargin)
                } else {
                    make.top.equalTo(topView.snp.bottom).offset(verMargin)
                }
                if index == sections.count - 1 {
                    make.bottom.equalToSuperview().offset(-tbMargin)
                }
            }
            topView = sectionView
            // sections
            var jTopView: UIView = sectionView
            for (jndex, dict) in dictArray.enumerated() {
                let itemControl = MineHomeOptionItemControl()
                itemControl.showAccessory = true
                itemControl.showImage = true
                sectionView.addSubview(itemControl)
                itemControl.title = dict["title"]
                itemControl.iconImgView.image = UIImage.init(named: dict["image"] ?? "")
                itemControl.tag = self.itemTagBase + itemIndex
                itemControl.addTarget(self, action: #selector(itemControlClick(_:)), for: .touchUpInside)
                itemControl.bottomLine.isHidden = true
                itemControl.snp.makeConstraints { (make) in
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(MineHomeOptionItemControl.itemHeight)
                    if 0 == jndex {
                        make.top.equalToSuperview()
                    } else {
                        make.top.equalTo(jTopView.snp.bottom)
                    }
                    if jndex == dictArray.count - 1 {
                        make.bottom.equalToSuperview()
                    }
                }
                jTopView = itemControl
                itemIndex += 1
                if dict["title"] == "清除缓存" {
                    self.cacheItemControl = itemControl
                }
            }
        }
        
    }

    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function

// MARK: - Event Function
extension MineHomeOptionView {
    /// item点击响应
    @objc fileprivate func itemControlClick(_ itemControl: MineHomeOptionItemControl) -> Void {
        //let index = itemControl.tag - self.itemTagBase
        guard let title = itemControl.title else {
            return
        }
        switch title {
        case "账户安全":
            self.delegate?.optionView(self, didSelectedAccount: itemControl)
        case "个人资料":
            self.delegate?.optionView(self, didSelectedUserInfo: itemControl)
        case "我的品牌商":
            self.delegate?.optionView(self, didSelectedMyBrandBusiness: itemControl)
        case "清除缓存":
            self.delegate?.optionView(self, didSelectedClearCache: itemControl)
        case "退出登录":
            self.delegate?.optionView(self, didSelectedLogout: itemControl)
        case "我的APIKEY":
            self.delegate?.optionView(self, didSelectedMyApiKey: itemControl)
        default:
            break
        }
    }

}

// MARK: - Extension Function
extension MineHomeOptionView {
    // 数据加载

}
