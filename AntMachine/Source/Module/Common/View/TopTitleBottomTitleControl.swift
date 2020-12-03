//
//  TopTitleBottomTitleControl.swift
//  CCMall
//
//  Created by 小唐 on 2019/2/18.
//  Copyright © 2019 COMC. All rights reserved.
//
//  顶部Title 底部Title 的点击控件

import UIKit

class TopTitleBottomTitleControl: UIControl {

    // MARK: - Internal Property

    var model:(topTitle: String?, bottomTitle: String?)? {
        didSet {
            self.topLabel.text = model?.topTitle
            self.bottomLabel.text = model?.bottomTitle
        }
    }

    let topLabel: UILabel = UILabel()
    let bottomLabel: UILabel = UILabel()

    // MARK: - Private Property
    fileprivate let tbMargin: CGFloat = 0
    fileprivate let verMargin: CGFloat = 5

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
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension TopTitleBottomTitleControl {
    class func loadXib() -> TopTitleBottomTitleControl? {
        return Bundle.main.loadNibNamed("TopTitleBottomTitleControl", owner: nil, options: nil)?.first as? TopTitleBottomTitleControl
    }
}

// MARK: - LifeCircle Function
extension TopTitleBottomTitleControl {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension TopTitleBottomTitleControl {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        // 1. topLabel
        self.addSubview(self.topLabel)
        self.topLabel.set(text: nil, font: UIFont.systemFont(ofSize: 15), textColor: UIColor.white, alignment: .center)
        self.topLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(tbMargin)
            make.centerX.equalToSuperview()
        }
        // 2. bottomLabel
        self.addSubview(self.bottomLabel)
        self.bottomLabel.set(text: nil, font: UIFont.systemFont(ofSize: 12), textColor: UIColor.white, alignment: .center)
        self.bottomLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.topLabel.snp.bottom).offset(verMargin)
            make.bottom.equalToSuperview().offset(-tbMargin)
            make.centerX.equalToSuperview()
        }
    }

}
// MARK: - Private UI Xib加载后处理
extension TopTitleBottomTitleControl {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension TopTitleBottomTitleControl {

}

// MARK: - Event Function
extension TopTitleBottomTitleControl {

}

// MARK: - Extension Function
extension TopTitleBottomTitleControl {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension TopTitleBottomTitleControl {

}
