//
//  FPOrePoolTypeSelectItemView.swift
//  MallProject
//
//  Created by 小唐 on 2021/3/8.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  

import UIKit

class FPOrePoolTypeSelectItemView: UIControl {

    // MARK: - Internal Property

    static let viewHeight: CGFloat = 56

    var type: FPOrePoolType? {
        didSet {
            self.titleLabel.text = type?.title
            self.iconView.image = type?.icon
        }
    }

    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            self.selectedView.isHidden = !isSelected
            self.backgroundColor = isSelected ? UIColor.init(hex: 0xEEF5FF) : AppColor.pageBg
            self.layer.borderColor = isSelected ? AppColor.theme.cgColor : UIColor.clear.cgColor
        }
    }


    let iconView: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    let selectedView: UIImageView = UIImageView.init()



    // MARK: - Private Property

    fileprivate let iconSize: CGSize = CGSize.init(width: 32, height: 32)
    fileprivate let selectedSize: CGSize = CGSize.init(width: 24, height: 24)
    fileprivate let iconTitleVerMargin: CGFloat = 6
    fileprivate let iconTopMargin: CGFloat = 12


    // MARK: - Initialize Function

    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    /// 通用初始化：UI、配置、数据等
    fileprivate func commonInit() -> Void {
        self.initialUI()
    }

}

// MARK: - Internal Function
extension FPOrePoolTypeSelectItemView {

}

// MARK: - LifeCycle/Override Function
extension FPOrePoolTypeSelectItemView {

}

// MARK: - UI Function
extension FPOrePoolTypeSelectItemView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.backgroundColor = AppColor.pageBg
        // 1. iconView
        self.addSubview(self.iconView)
        self.iconView.set(cornerRadius: 0)
        self.iconView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(self.iconSize)
            make.top.equalToSuperview().offset(self.iconTopMargin)
        }
        // 2. titleLabel
        self.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 15), textColor: AppColor.mainText, alignment: .center)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.iconView.snp.bottom).offset(self.iconTitleVerMargin)
        }
        // 3. selectedView
        self.addSubview(self.selectedView)
        self.selectedView.set(cornerRadius: 0)
        self.selectedView.image = UIImage.init(named: "IMG_home_icon_selected")
        self.selectedView.isHidden = true    // 默认隐藏
        self.selectedView.snp.makeConstraints { (make) in
            make.trailing.top.equalToSuperview()
            make.size.equalTo(self.selectedSize)
        }
    }

}

// MARK: - Data Function
extension FPOrePoolTypeSelectItemView {


}

// MARK: - Event Function


// MARK: - Notification Function

// MARK: - Extension Function

// MARK: - Delegate Function
