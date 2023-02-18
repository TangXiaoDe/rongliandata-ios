//
//  CommonDoneBtn.swift
//  RongLianData
//
//  Created by 小唐 on 2019/5/29.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  CommonDoneButton 通用的确定按钮
//  normal下的显示渐变背景色

import UIKit

/// 通用的确定按钮
typealias AppDoneBtn = CommonDoneBtn
/// 通用的确定按钮，注：需对gradientLayer指定大小
class CommonDoneBtn: BaseButton {


    fileprivate let normalColors: [CGColor] = [AppColor.theme.cgColor, AppColor.theme.cgColor]
    fileprivate let disableColors: [CGColor] = [UIColor.init(hex: 0xC5CED9).cgColor, UIColor.init(hex: 0xC5CED9).cgColor]
    fileprivate let highlightedColors: [CGColor] = [AppColor.theme.cgColor, AppColor.theme.cgColor]

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        //fatalError("init(coder:) has not been implemented")
    }

    fileprivate func commonInit() -> Void {
        self.gradientLayer.colors = self.normalColors
    }

    override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            self.gradientLayer.colors = isEnabled ? self.normalColors : self.disableColors
        }
    }

    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            self.gradientLayer.colors = isHighlighted ? self.highlightedColors : self.normalColors
        }
    }

}
