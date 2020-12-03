//
//  BaseView.swift
//  ProjectTemplate-Swift
//
//  Created by 小唐 on 2018/11/27.
//  Copyright © 2018 TangXiaoDe. All rights reserved.
//

import UIKit

class BaseView: UIView {

    let bgView: UIImageView = UIImageView.init()
    let gradientLayer: CAGradientLayer = AppUtil.commonGradientLayer()
    let bottomLine: UIView = UIView.init()
    
    var showBottomLine: Bool = false {
        didSet {
            self.bottomLine.isHidden = !showBottomLine
            self.bringSubviewToFront(self.bottomLine)
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //self.gradientLayer.bounds = self.bounds
    }

    // MARK: - Custom User Interface
    func initialize() {
        // 1. bgView
        self.addSubview(self.bgView)
        self.bgView.set(cornerRadius: 0)
        self.bgView.isHidden = true // 默认隐藏
        self.bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 2. gradientLayer
        self.layer.insertSublayer(self.gradientLayer, below: nil)
        //self.gradientLayer.isHidden = true  // 默认无大小，自动隐藏不显示
        // 3. bottomLine
        self.addSubview(self.bottomLine)
        self.bottomLine.backgroundColor = AppColor.dividing
        self.bottomLine.isHidden = true // 默认隐藏
        self.bottomLine.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

}
