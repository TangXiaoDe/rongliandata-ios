//
//  TitleValueControl.swift
//  ChuangYe
//
//  Created by 小唐 on 2020/8/11.
//  Copyright © 2020 ChainOne. All rights reserved.
//

import UIKit

class TitleValueControl: BaseControl
{

    // MARK: - Internal Property

    let titleLabel: UILabel = UILabel()
    let valueLabel: UILabel = UILabel()



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

// MARK: - Override Function

// MARK: - Private  UI
extension TitleValueControl {
    /// 界面布局
    fileprivate func initialUI() -> Void {
        // 1. titleLabel
        self.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.systemFont(ofSize: 14), textColor: UIColor.darkText)
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(0)
            make.bottom.lessThanOrEqualToSuperview().offset(-0)
        }
        // 2. valueLabel
        self.addSubview(self.valueLabel)
        self.valueLabel.set(text: nil, font: UIFont.systemFont(ofSize: 14), textColor: UIColor.lightGray)
        self.valueLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.titleLabel.snp.trailing)
            make.centerY.trailing.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(0)
            make.bottom.lessThanOrEqualToSuperview().offset(-0)
        }
    }

}

// MARK: - Private  数据(处理 与 加载)

// MARK: - Private  事件
