//
//  FPHomeOrePoolTypeView.swift
//  MallProject
//
//  Created by 小唐 on 2021/3/8.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  矿池类型视图，可点击

import UIKit

class FPHomeOrePoolTypeView: UIControl {

    // MARK: - Internal Property

    static let viewHeight: CGFloat = 56

    var type: FPOrePoolType? {
        didSet {
            self.titleLabel.text = type?.title
        }
    }

    let iconView: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    let arrowView: UIImageView = UIImageView()



    // MARK: - Private Property

    fileprivate let iconSize: CGSize = CGSize.init(width: 13, height: 13)
    fileprivate let arrowSize: CGSize = CGSize.init(width: 6, height: 11)
    fileprivate let iconTitleHorMargin: CGFloat = 5


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
extension FPHomeOrePoolTypeView {

}

// MARK: - LifeCycle/Override Function
extension FPHomeOrePoolTypeView {

}

// MARK: - UI Function
extension FPHomeOrePoolTypeView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        //self.backgroundColor = UIColor.white
        // 1. iconView
        self.addSubview(self.iconView)
        self.iconView.set(cornerRadius: 0)
        self.iconView.image = UIImage.init(named: "IMG_home_icon_select")
        self.iconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(self.iconSize)
            make.leading.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        // 2. titleLabel
        self.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 13), textColor: AppColor.mainText, alignment: .right)
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.iconView.snp.trailing).offset(self.iconTitleHorMargin)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        // 3. arrowView
        self.addSubview(self.arrowView)
        self.arrowView.set(cornerRadius: 0)
        self.arrowView.image = UIImage.init(named: "IMG_common_detail")
        self.arrowView.snp.makeConstraints { (make) in
            make.centerY.trailing.equalToSuperview()
            make.size.equalTo(self.arrowSize)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(self.iconTitleHorMargin)
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

}

// MARK: - Data Function
extension FPHomeOrePoolTypeView {


}

// MARK: - Event Function


// MARK: - Notification Function

// MARK: - Extension Function

// MARK: - Delegate Function
