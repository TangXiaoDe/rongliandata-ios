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
    /// 我的资产
    func optionView(_ optionView: MineHomeOptionView, didSelectedAsset itemView: MineHomeOptionItemControl) -> Void
    /// 我的市场
    func optionView(_ optionView: MineHomeOptionView, didSelectedMarket itemView: MineHomeOptionItemControl) -> Void
    /// 我的任务
    func optionView(_ optionView: MineHomeOptionView, didSelectedTask itemView: MineHomeOptionItemControl) -> Void
    /// 邀请好友
    func optionView(_ optionView: MineHomeOptionView, didSelectedInviteUser itemView: MineHomeOptionItemControl) -> Void
    /// 设置
    func optionView(_ optionView: MineHomeOptionView, didSelectedSetting itemView: MineHomeOptionItemControl) -> Void
}
extension MineHomeOptionViewProtocol {
    func optionView(_ optionView: MineHomeOptionView, didSelectedCurrentVersion itemView: MineHomeOptionItemControl) -> Void {

    }
}

class MineHomeOptionView: UIView {

    // MARK: - Internal Property

    weak var delegate: MineHomeOptionViewProtocol?

    // MARK: - Private Property

    /// 注：我的资产、绑定iFuture 可能更改
    fileprivate var sections: [[[String: String]]] = [[[:]]]

    fileprivate let lrMargin: CGFloat = 0
    fileprivate let verMargin: CGFloat = 12
    fileprivate let tbMargin: CGFloat = 0
    fileprivate let itemTagBase: Int = 250
    fileprivate weak var versionItemControl: MineHomeOptionItemControl!
    fileprivate weak var inviteCodeItemControl: MineHomeOptionItemControl!
//    fileprivate weak var inviteRecordItemControl: MineHomeOptionItemControl!
//    fileprivate weak var ecologicalItemControl: MineHomeOptionItemControl!

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
        let walletItem: [String: String] = ["title":"我的钱包", "image":"IMG_mine_icon_list_tianxie"]
        let marketItem: [String: String] = ["title":"我的市场", "image":"IMG_mine_icon_list_shezhi"]
        let taskItem: [String: String] = ["title":"我的任务", "image":"IMG_mine_icon_list_kefu"]
        let inviteItem: [String: String] = ["title":"邀请好友", "image":"IMG_mine_icon_list_bangzhu"]
        let settingItem: [String: String] = ["title":"设置", "image":"IMG_mine_icon_list_banben"]
        let normalItems: [[[String: String]]] = [[walletItem, marketItem, taskItem, inviteItem, settingItem]]
        let shieldItems: [[[String: String]]] = [[inviteItem, settingItem]]
        self.sections = AppConfig.share.shield.currentNeedShield ? shieldItems : normalItems
        self.setupWithSections(self.sections)
    }

    /// 数据加载
    fileprivate func setupWithSections(_ sections: [[[String: String]]]) -> Void {
        self.removeAllSubView()
        var topView: UIView = self
        var itemIndex: Int = 0
        for (index, dictArray) in sections.enumerated() {
            let sectionView = UIView()
            self.addSubview(sectionView)
            sectionView.backgroundColor = UIColor.white
            sectionView.set(cornerRadius: 10)
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
                itemControl.showImage = false
                sectionView.addSubview(itemControl)
                itemControl.title = dict["title"]
                itemControl.tag = self.itemTagBase + itemIndex
                itemControl.addTarget(self, action: #selector(itemControlClick(_:)), for: .touchUpInside)
                itemControl.bottomLine.isHidden = (jndex == dictArray.count - 1)
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
        case "我的钱包":
            self.delegate?.optionView(self, didSelectedAsset: itemControl)
        case "我的市场":
            self.delegate?.optionView(self, didSelectedMarket: itemControl)
        case "我的任务":
            self.delegate?.optionView(self, didSelectedTask: itemControl)
        case "邀请好友":
            self.delegate?.optionView(self, didSelectedInviteUser: itemControl)
        case "设置":
            self.delegate?.optionView(self, didSelectedSetting: itemControl)
        default:
            break
        }
    }

}

// MARK: - Extension Function
extension MineHomeOptionView {
    // 数据加载

}
