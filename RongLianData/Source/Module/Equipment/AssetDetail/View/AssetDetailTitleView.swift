//
//  AssetDetailTitleView.swift
//  iMeet
//
//  Created by 小唐 on 2019/2/18.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  资产收支标题选择控件

import UIKit

protocol AssetDetailTitleViewProtocol: class {
    func titleView(_ titleView: AssetDetailTitleView, didClickedAt index: Int, with title: String) -> Void
}

class AssetDetailTitleView: UIView {

    // MARK: - Internal Property

    static let viewHeight: CGFloat = 40

    weak var delegate: AssetDetailTitleViewProtocol?
    var titleClickAction:((_ titleView: AssetDetailTitleView, _ index: Int, _ title: String) -> Void)?

    /// 选中
    var selectedIndex: Int = 0 {
        didSet {
            if oldValue == selectedIndex {
                return
            }
            self.didSetupSelectedIndex(selectedIndex)
        }
    }
    
    fileprivate var themeColor: UIColor = AppColor.mainText

    // MARK: - Private Property
    fileprivate let mainView: UIView = UIView()
    fileprivate weak var allBtn: UIButton!
    fileprivate weak var incomeBtn: UIButton!
    fileprivate weak var outcomeBtn: UIButton!
    fileprivate let slider: UIView = UIView()
    fileprivate let titleBtnTagBase: Int = 250

    fileprivate let titles: [String] = ["全部", "收入", "支出"]
    fileprivate let lrMargin: CGFloat = 15
    fileprivate let sliderViewW: CGFloat = 24
    fileprivate let sliderViewH: CGFloat = 3

    fileprivate var selectedBtn: UIButton? = nil

    // MARK: - Initialize Function
    init(themeColor: UIColor = AppColor.mainText) {
        self.themeColor = themeColor
        super.init(frame: CGRect.zero)
        self.initialUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension AssetDetailTitleView {
    class func loadXib() -> AssetDetailTitleView? {
        return Bundle.main.loadNibNamed("AssetDetailTitleView", owner: nil, options: nil)?.first as? AssetDetailTitleView
    }
}

// MARK: - LifeCircle Function
extension AssetDetailTitleView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension AssetDetailTitleView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.backgroundColor = AppColor.minor
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        let titleBtnMaxW: CGFloat = (kScreenWidth - self.lrMargin * 2.0) / CGFloat(self.titles.count)
        // 1. titleBtn
        for (index, title) in titles.enumerated() {
            let button = UIButton.init(type: .custom)
            mainView.addSubview(button)
            button.titleLabel?.font = UIFont.pingFangSCFont(size: 16, weight: .medium)
            button.set(title: title, titleColor: UIColor(hex: 0x666666), for: .normal)
            button.set(title: title, titleColor: self.themeColor, for: .selected)
            button.tag = self.titleBtnTagBase + index
            button.addTarget(self, action: #selector(titleBtnClick(_:)), for: .touchUpInside)
        }
        self.allBtn = (mainView.viewWithTag(self.titleBtnTagBase + 0) as! UIButton)
        self.incomeBtn = (mainView.viewWithTag(self.titleBtnTagBase + 1) as! UIButton)
        self.outcomeBtn = (mainView.viewWithTag(self.titleBtnTagBase + 2) as! UIButton)
        self.allBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(mainView.snp.leading).offset(titleBtnMaxW * 0.5)
        }
        self.incomeBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        self.outcomeBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(mainView.snp.trailing).offset(-titleBtnMaxW * 0.5)
        }
        // 2. slider
        mainView.addSubview(self.slider)
        self.slider.backgroundColor = self.themeColor
        // 默认选中
        if let button = mainView.viewWithTag(self.titleBtnTagBase + self.selectedIndex) as? UIButton {
            button.isSelected = true
            button.titleLabel?.font = UIFont.pingFangSCFont(size: 15, weight: .medium)
            self.selectedBtn = button
            self.slider.snp.makeConstraints { (make) in
                make.width.equalTo(sliderViewW)
                make.bottom.equalToSuperview()
                make.height.equalTo(self.sliderViewH)
                make.centerX.equalTo(button)
            }
        }
        // 3. bottomLine
//        mainView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: 0, margin2: 0)
    }

}
// MARK: - Private UI Xib加载后处理
extension AssetDetailTitleView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension AssetDetailTitleView {
    /// 索引选中时
    fileprivate func didSetupSelectedIndex(_ selectedIndex: Int) -> Void {
        // selectedBtn
        guard let button = self.mainView.viewWithTag(self.titleBtnTagBase + selectedIndex) as? UIButton else {
            return
        }
        self.selectedBtn?.isSelected = false
        button.isSelected = true
        self.selectedBtn = button
        // slider
        self.slider.snp.remakeConstraints { (make) in
            make.width.equalTo(sliderViewW)
            make.bottom.equalToSuperview()
            make.height.equalTo(self.sliderViewH)
            make.centerX.equalTo(button)
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Event Function
extension AssetDetailTitleView {
    @objc fileprivate func titleBtnClick(_ button: UIButton) -> Void {
        let index = button.tag - self.titleBtnTagBase
        let title = self.titles[index]
        self.selectedIndex = index
        self.delegate?.titleView(self, didClickedAt: index, with: title)
        self.titleClickAction?(self, index, title)
    }
}

// MARK: - Extension Function
