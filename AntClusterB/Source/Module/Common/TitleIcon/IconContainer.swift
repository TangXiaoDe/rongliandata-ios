//
//  IconContainer.swift
//  AntClusterB
//
//  Created by 小唐 on 2020/11/30.
//  Copyright © 2020 ChainOne. All rights reserved.
//

import UIKit

typealias IconView = IconContainer
class IconContainer: UIView {

    // MARK: - Internal Property

    let iconView: UIImageView = UIImageView.init()

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
extension IconContainer {
    /// 界面布局
    fileprivate func initialUI() -> Void {
        // 1. icon
        self.addSubview(self.iconView)
        self.iconView.set(cornerRadius: 0)
        self.iconView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

// MARK: - Private  数据(处理 与 加载)

// MARK: - Private  事件
