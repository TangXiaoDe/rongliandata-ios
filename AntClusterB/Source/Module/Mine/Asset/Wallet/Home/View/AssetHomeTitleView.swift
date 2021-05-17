//
//  AssetHomeTitleView.swift
//  StorageChain
//
//  Created by zhaowei on 2020/5/7.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit

protocol AssetHomeTitleViewProtocol: class {
    func titleView(_ titleView: AssetHomeTitleView, didClickedAt index: Int, with title: String) -> Void
}

class AssetHomeTitleView: UIView {

    // MARK: - Internal Property

    static let viewHeight: CGFloat = 32

    weak var delegate: AssetHomeTitleViewProtocol?
    var titleClickAction:((_ titleView: AssetHomeTitleView, _ index: Int, _ title: String) -> Void)?

    /// 选中
    var selectedIndex: Int = 0 {
        didSet {
            if oldValue == selectedIndex {
                return
            }
            self.didSetupSelectedIndex(selectedIndex)
        }
    }

    // MARK: - Private Property
    fileprivate let mainView: UIView = UIView()
    fileprivate let titleView: UIView = UIView.init()
    fileprivate weak var allBtn: UIButton!
    fileprivate weak var incomeBtn: UIButton!
    fileprivate weak var outcomeBtn: UIButton!
    fileprivate let slider: UIView = UIView()
    fileprivate let titleBtnTagBase: Int = 250

    fileprivate let titles: [String] = ["全部", "收入", "支出"]
    fileprivate let lrMargin: CGFloat = 15
    fileprivate let sliderViewW: CGFloat = 24
    fileprivate let sliderViewH: CGFloat = 3
    fileprivate let titleViewH: CGFloat = 32

    fileprivate var selectedBtn: UIButton? = nil

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
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension AssetHomeTitleView {
    class func loadXib() -> AssetHomeTitleView? {
        return Bundle.main.loadNibNamed("AssetHomeTitleView", owner: nil, options: nil)?.first as? AssetHomeTitleView
    }
}

// MARK: - LifeCircle Function
extension AssetHomeTitleView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension AssetHomeTitleView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        // 0. bg
        self.backgroundColor = UIColor.white
        // 2. mainView
        self.addSubview(self.mainView)
        self.mainView.backgroundColor = UIColor.white
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 3. titleView/titleContainer
        self.addSubview(self.titleView)
        self.initialTitleView(self.titleView)
        self.titleView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.bottom.equalToSuperview()
            make.height.equalTo(self.titleViewH)
        }
    }
    fileprivate func initialTitleView(_ titleView: UIView) -> Void {
        let titleBtnMaxW: CGFloat = (kScreenWidth - self.lrMargin * 2.0) / CGFloat(self.titles.count)
        // 1. titleBtn
        for (index, title) in titles.enumerated() {
            let button = UIButton.init(type: .custom)
            titleView.addSubview(button)
            button.titleLabel?.font = UIFont.pingFangSCFont(size: 15, weight: .medium)
            button.set(title: title, titleColor: UIColor(hex: 0x333333), for: .normal)
            button.set(title: title, titleColor: AppColor.mainText, for: .selected)
            button.tag = self.titleBtnTagBase + index
            button.addTarget(self, action: #selector(titleBtnClick(_:)), for: .touchUpInside)
        }
        self.allBtn = (titleView.viewWithTag(self.titleBtnTagBase + 0) as! UIButton)
        self.incomeBtn = (titleView.viewWithTag(self.titleBtnTagBase + 1) as! UIButton)
        self.outcomeBtn = (titleView.viewWithTag(self.titleBtnTagBase + 2) as! UIButton)
        self.allBtn.snp.makeConstraints { (make) in
            make.centerY.top.bottom.equalToSuperview()
            //make.leading.equalToSuperview()
            //make.width.equalTo(titleBtnW)
            make.centerX.equalTo(titleView.snp.leading).offset(titleBtnMaxW * 0.5)
        }
        self.incomeBtn.snp.makeConstraints { (make) in
            make.centerY.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            //make.width.equalTo(titleBtnW)
        }
        self.outcomeBtn.snp.makeConstraints { (make) in
            make.centerY.top.bottom.equalToSuperview()
            //make.trailing.equalToSuperview()
            //make.width.equalTo(titleBtnW)
            make.centerX.equalTo(titleView.snp.trailing).offset(-titleBtnMaxW * 0.5)
        }
        // 2. slider
        titleView.addSubview(self.slider)
        self.slider.backgroundColor = UIColor.init(hex: 0x1A1F26)
        // 默认选中
        if let button = titleView.viewWithTag(self.titleBtnTagBase + self.selectedIndex) as? UIButton {
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
        //mainView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: 0, margin2: 0)
    }

}
// MARK: - Private UI Xib加载后处理
extension AssetHomeTitleView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension AssetHomeTitleView {
    /// 索引选中时
    fileprivate func didSetupSelectedIndex(_ selectedIndex: Int) -> Void {
        // selectedBtn
        self.selectedBtn?.isSelected = false
        self.selectedBtn?.titleLabel?.font = UIFont.pingFangSCFont(size: 15)
        guard let button = self.titleView.viewWithTag(self.titleBtnTagBase + selectedIndex) as? UIButton else {
            return
        }
        button.isSelected = true
        button.titleLabel?.font = UIFont.pingFangSCFont(size: 15, weight: .medium)
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
extension AssetHomeTitleView {
    @objc fileprivate func titleBtnClick(_ button: UIButton) -> Void {
        let index = button.tag - self.titleBtnTagBase
        let title = self.titles[index]
        self.delegate?.titleView(self, didClickedAt: index, with: title)
        self.titleClickAction?(self, index, title)
    }
}
