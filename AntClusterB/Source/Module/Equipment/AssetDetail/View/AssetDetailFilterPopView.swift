//
//  AssetDetailFilterPopView.swift
//  MallProject
//
//  Created by zhaowei on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit

protocol AssetDetailFilterPopViewProtocol: class {
    /// 分类点击
    func popView(_ popView: AssetDetailFilterPopView, didClickedCate cateBtn: UIButton, index: Int) -> Void
}


class AssetDetailFilterPopView: UIView
{
    var models: [EquipmentAssetType]? {
        didSet {
           self.setupWithContainerView(models)
        }
    }
    var selectType: EquipmentAssetType = .all
    weak var delegate: AssetDetailFilterPopViewProtocol?
    // MARK: - Internal Property
    // MARK: - Private Property
    let topAlphBtn: UIButton = UIButton.init(type: .custom)
    let coverBtn: UIButton = UIButton.init(type: .custom)
    let mainView: UIView = UIView.init()
    fileprivate let containerView: UIView = UIView()
    
    fileprivate let lrMargin: CGFloat = 16
    //item
    fileprivate let itemHeight: CGFloat = 36
    fileprivate let colCount: Int = 3
    fileprivate let itemVerMargin: CGFloat = 12
    fileprivate var itemHorMargin: CGFloat = 12
    fileprivate var itemWidth: CGFloat {
        let width: CGFloat = (kScreenWidth - self.lrMargin * 2.0 - (CGFloat(self.colCount) - 1.0) * self.itemHorMargin) / CGFloat(self.colCount)
        return width
    }
    fileprivate let topAlphHeight: CGFloat = 40
    fileprivate let itemTBMargin: CGFloat = 20
    fileprivate var itemTagBase: Int = 250

    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        //fatalError("init(coder:) has not been implemented")
    }

    /// 通用初始化：UI、配置、数据等
    func commonInit() -> Void {
        self.initialUI()
    }

}

// MARK: - Internal Function
extension AssetDetailFilterPopView {

}

// MARK: - LifeCircle Function
extension AssetDetailFilterPopView {

}
// MARK: - Private UI 手动布局
extension AssetDetailFilterPopView {

    /// 界面布局 - 子类可重写
    fileprivate func initialUI() -> Void {
        // 0. topAlphBtn
        self.addSubview(self.topAlphBtn)
        self.topAlphBtn.backgroundColor = UIColor.clear
        self.topAlphBtn.addTarget(self, action: #selector(coverBtnClick(_:)), for: .touchUpInside)
        self.topAlphBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.topAlphHeight)
        }
        // 1. coverBtn
        self.addSubview(self.coverBtn)
        self.coverBtn.backgroundColor = UIColor.init(hex: 0x000000).withAlphaComponent(0.5)
        self.coverBtn.addTarget(self, action: #selector(coverBtnClick(_:)), for: .touchUpInside)
        self.coverBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.topAlphHeight)
            make.bottom.leading.trailing.equalToSuperview()
        }
        // 2. mainView
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.topAlphHeight)
            make.leading.trailing.equalToSuperview()
        }
    }
    /// mainView布局 - 子类可重写
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 6. containerView
        mainView.addSubview(self.containerView)
        self.containerView.backgroundColor = UIColor.white
        self.containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(0)
            make.bottom.equalToSuperview()
        }
    }
    /// 数据加载
    fileprivate func setupWithContainerView(_ models: [EquipmentAssetType]?) -> Void {
        guard let models = models else {
            return
        }
        self.containerView.removeAllSubView()
        for (index, model) in models.enumerated() {
            let itemView = UIButton.init(type: .custom)
            self.containerView.addSubview(itemView)
            itemView.addTarget(self, action: #selector(cateBtnClick(_:)), for: .touchUpInside)
            itemView.set(title: model.title, titleColor: AppColor.mainText, image: nil, bgImage: UIImage.imageWithColor(UIColor.init(hex: 0xF1F2F6)), for: .normal)
            itemView.set(title: model.title, titleColor: AppColor.mainText, image: nil, bgImage: UIImage.imageWithColor(AppColor.theme), for: .selected)
            itemView.set(font: UIFont.pingFangSCFont(size: 15, weight: .regular))
            itemView.tag = self.itemTagBase + index
            itemView.set(cornerRadius: 3)
            let currentRow: Int = index / self.colCount
            let currentCol: Int = index % self.colCount
            itemView.snp.makeConstraints { (make) in
                make.width.equalTo(self.itemWidth)
                make.height.equalTo(self.itemHeight)
                let leftMargin: CGFloat = self.lrMargin + CGFloat(currentCol) * (self.itemWidth + self.itemHorMargin)
                let topMargin: CGFloat = self.itemTBMargin + CGFloat(currentRow) * (self.itemHeight + self.itemVerMargin)
                make.leading.equalToSuperview().offset(leftMargin)
                make.top.equalToSuperview().offset(topMargin)
                if index == models.count - 1 {
                    make.bottom.equalToSuperview().offset(-itemTBMargin)
                }
            }
            if self.selectType.rawValue == model.rawValue {
                itemView.isSelected = true
            }
        }
        self.containerView.setNeedsLayout()
        self.mainView.setNeedsLayout()
    }
}
// MARK: - Private UI Xib加载后处理
extension AssetDetailFilterPopView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension AssetDetailFilterPopView {

}

// MARK: - Event Function
extension AssetDetailFilterPopView {
    /// 遮罩点击
    @objc func coverBtnClick(_ button: UIButton) -> Void {
        self.removeFromSuperview()
    }

    @objc func cateBtnClick(_ btn: UIButton) -> Void {
        let index = btn.tag - self.itemTagBase
        self.delegate?.popView(self, didClickedCate: btn, index: index)
        self.removeFromSuperview()
    }
}

// MARK: - Extension Function
extension AssetDetailFilterPopView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension AssetDetailFilterPopView {

}
