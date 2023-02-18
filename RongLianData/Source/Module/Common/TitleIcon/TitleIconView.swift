//
//  TitleIconView.swift
//  ChuangYe
//
//  Created by 小唐 on 2020/8/11.
//  Copyright © 2020 ChainOne. All rights reserved.
//

import UIKit

typealias IconTitleContainer = IconTitleView
typealias IconTitleView = TitleIconView
typealias TitleIconContainer = TitleIconView
class TitleIconView: BaseView
{

    // MARK: - Internal Property

    let titleLabel: UILabel = UILabel()
    let iconView: UIImageView = UIImageView()


    // MARK: - Private Property

    // MARK: - Initialize Function

    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    /// 通用初始化
    func commonInit() -> Void {
        self.initialUI()
    }

}

// MARK: - Internal Function
extension TitleIconView {

}

// MARK: - Override Function

// MARK: - Private  UI
extension TitleIconView {
    /// 界面布局
    fileprivate func initialUI() -> Void {
        // 1. titleLabel
        self.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.systemFont(ofSize: 15), textColor: UIColor.lightGray)
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
        }
        // 2. iconView
        self.addSubview(self.iconView)
        self.iconView.set(cornerRadius: 0)
        self.iconView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.titleLabel.snp.trailing)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

}

// MARK: - Private  数据(处理 与 加载)

// MARK: - Private  事件
