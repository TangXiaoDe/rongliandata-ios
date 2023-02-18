//
//  IconTitleIconControl.swift
//  MallProject
//
//  Created by 小唐 on 2021/3/9.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit

class IconTitleIconControl: BaseControl
{

    let leftIconView: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    let rightIconView: UIImageView = UIImageView()

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
    fileprivate func commonInit() -> Void {
        self.initialUI()
    }

}

// MARK: - Internal Function

extension IconTitleIconControl {

}

// MARK: - Override Function

// MARK: - Private  UI
extension IconTitleIconControl {
    /// 界面布局
    fileprivate func initialUI() -> Void {
        // 1. leftIcon
        self.addSubview(self.leftIconView)
        self.leftIconView.set(cornerRadius: 0)
        self.leftIconView.snp.makeConstraints { (make) in
            make.leading.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(0)
            make.bottom.lessThanOrEqualToSuperview().offset(-0)
        }
        // 2. rightIcon
        self.addSubview(self.rightIconView)
        self.rightIconView.set(cornerRadius: 0)
        self.rightIconView.snp.makeConstraints { (make) in
            make.leading.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(0)
            make.bottom.lessThanOrEqualToSuperview().offset(-0)
        }
        // 3. title
        self.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14), textColor: AppColor.mainText, alignment: .right)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.rightIconView.snp.leading).offset(-5)
            make.leading.equalTo(self.leftIconView.snp.trailing).offset(5)
        }
    }

}

// MARK: - Private  数据(处理 与 加载)

// MARK: - Private  事件
