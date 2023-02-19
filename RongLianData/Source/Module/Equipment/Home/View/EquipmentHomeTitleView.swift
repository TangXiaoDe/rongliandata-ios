//
//  EquipmentHomeTitleView.swift
//  MallProject
//
//  Created by zhaowei on 2021/3/10.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit

protocol EquipmentHomeTitleViewProtocol: class {
    func titleView(_ titleView: EquipmentHomeTitleView, didClickedAt index: Int, with title: String) -> Void
}

class EquipmentHomeTitleView: UIView {

    // MARK: - Internal Property

    static let viewHeight: CGFloat = 44

    weak var delegate: EquipmentHomeTitleViewProtocol?
    var titleClickAction:((_ titleView: EquipmentHomeTitleView, _ index: Int, _ title: String) -> Void)?

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
    fileprivate let slider: UIImageView = UIImageView()
    fileprivate let titleBtnTagBase: Int = 250

    fileprivate var titles: [String] = [ProductZone.ipfs.title, ProductZone.chia.title]
    fileprivate let lrMargin: CGFloat = 0
    fileprivate let sliderViewW: CGFloat = 16
    fileprivate let sliderViewH: CGFloat = 8
    fileprivate let titleViewH: CGFloat = kNavigationBarHeight
    fileprivate let titleBtnMaxW: CGFloat = 60
    fileprivate let horMargin: CGFloat = 0

    fileprivate var selectedBtn: UIButton? = nil

    // MARK: - Initialize Function
    init(titles: [String] = [ProductZone.ipfs.title, ProductZone.chia.title]) {
        self.titles = titles
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
extension EquipmentHomeTitleView {
    class func loadXib() -> EquipmentHomeTitleView? {
        return Bundle.main.loadNibNamed("EquipmentHomeTitleView", owner: nil, options: nil)?.first as? EquipmentHomeTitleView
    }
}

// MARK: - LifeCircle Function
extension EquipmentHomeTitleView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension EquipmentHomeTitleView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        // 0. bg
        self.backgroundColor = UIColor.clear
        // 2. mainView
        self.addSubview(self.mainView)
        self.mainView.backgroundColor = UIColor.clear
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
        self.slider.isHidden = self.titles.count <= 1
    }
    fileprivate func initialTitleView(_ titleView: UIView) -> Void {
        var leftView: UIView = titleView
        // 1. titleBtn
        for (index, title) in self.titles.enumerated() {
            let button = UIButton.init(type: .custom)
            titleView.addSubview(button)
            button.titleLabel?.font = UIFont.pingFangSCFont(size: 16, weight: .regular)
            button.set(title: title, titleColor: AppColor.mainText.withAlphaComponent(0.5), for: .normal)
            button.set(title: title, titleColor: AppColor.mainText, for: .selected)
            button.tag = self.titleBtnTagBase + index
            button.addTarget(self, action: #selector(titleBtnClick(_:)), for: .touchUpInside)
            button.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.height.equalTo(self.titleViewH)
                make.width.equalTo(titleBtnMaxW)
                if index == 0 {
                    make.leading.equalToSuperview().offset(-lrMargin)
                } else {
                    make.leading.equalTo(leftView.snp.trailing).offset(self.horMargin)
                }
                if self.titles.count - 1 == index {
                    make.trailing.equalToSuperview().offset(-lrMargin)
                }
            }
            leftView = button
        }
        // 2. slider
        titleView.addSubview(self.slider)
        self.slider.image = UIImage.init(named: "IMG_mine_sb_dot_nav")
        self.slider.isHidden = true
        self.slider.set(cornerRadius: 0)
        // 默认选中
        if let button = titleView.viewWithTag(self.titleBtnTagBase + self.selectedIndex) as? UIButton {
            button.isSelected = true
            button.titleLabel?.font = UIFont.pingFangSCFont(size: 18, weight: .medium)
            self.selectedBtn = button
            self.slider.snp.makeConstraints { (make) in
                make.width.equalTo(sliderViewW)
                make.bottom.equalToSuperview()
                make.height.equalTo(self.sliderViewH)
                make.centerX.equalTo(button)
            }
        }
    }

}
// MARK: - Private UI Xib加载后处理
extension EquipmentHomeTitleView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension EquipmentHomeTitleView {
    /// 索引选中时
    fileprivate func didSetupSelectedIndex(_ selectedIndex: Int) -> Void {
        // selectedBtn
        self.selectedBtn?.isSelected = false
        self.selectedBtn?.titleLabel?.font = UIFont.pingFangSCFont(size: 16)
        guard let button = self.titleView.viewWithTag(self.titleBtnTagBase + selectedIndex) as? UIButton else {
            return
        }
        button.isSelected = true
        button.titleLabel?.font = UIFont.pingFangSCFont(size: 18, weight: .medium)
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
extension EquipmentHomeTitleView {
    @objc fileprivate func titleBtnClick(_ button: UIButton) -> Void {
        let index = button.tag - self.titleBtnTagBase
        let title = self.titles[index]
        self.delegate?.titleView(self, didClickedAt: index, with: title)
        self.titleClickAction?(self, index, title)
    }
}
