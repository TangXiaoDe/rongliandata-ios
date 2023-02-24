//
//  AsssetDetailCateView.swift
//  RongLianData
//
//  Created by 小唐 on 2023/2/19.
//  Copyright © 2023 ChainOne. All rights reserved.
//
//

import UIKit
import ChainOneKit

protocol AsssetDetailCateViewProtocol: class {
    ///
    func titleView(_ titleView: AsssetDetailCateView, didClickedAt index: Int, with cate: EquipmentAssetType) -> Void
}

class AsssetDetailCateView: UIView {

    // MARK: - Internal Property

    static let viewHeight: CGFloat = 52

    fileprivate var btnMaxW: CGFloat = 0

    weak var delegate: AsssetDetailCateViewProtocol?
    var titleClickAction: ((_ titleView: AsssetDetailCateView, _ index: Int, _ cate: EquipmentAssetType) -> Void)?

    private(set) var selectedIndex: Int = 0

    var models: [EquipmentAssetType] = [] {
        didSet {
            self.setupWithModels(models)
        }
    }


    // MARK: - Private Property

    fileprivate let mainView: UIView = UIView()
    fileprivate let scrollView: UIScrollView = UIScrollView()
    fileprivate let itemContainer: UIView = UIView()
    fileprivate let sliderView: UIView = UIView()

    fileprivate let itemMinWidth: CGFloat = 70
    fileprivate let itemHeight: CGFloat = 28
    fileprivate let itemLrMargin: CGFloat = 12
    fileprivate let itemHorMargin: CGFloat = 12

    fileprivate let itemTagBase: Int = 250

    fileprivate let sliderViewH: CGFloat = 2
    fileprivate let sliderViewW: CGFloat = 28
    /// 当前选中按钮
    fileprivate var currentSelectedBtn: UIButton?


    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    /// 通用初始化：UI、配置、数据等
    fileprivate func commonInit() -> Void {
        self.initialUI()
    }
}

// MARK: - Internal Function
extension AsssetDetailCateView {
    class func loadXib() -> AsssetDetailCateView? {
        return Bundle.main.loadNibNamed("AsssetDetailCateView", owner: nil, options: nil)?.first as? AsssetDetailCateView
    }

    /// 设置当前选中索引
    func setupSelectedIndex(_ selectedIndex: Int) -> Void {
        if selectedIndex == self.selectedIndex {
            return
        }
        guard let button = self.mainView.viewWithTag(self.itemTagBase + selectedIndex) as? UIButton else {
            return
        }
        self.processScrollView(button)
        let index: Int = button.tag - self.itemTagBase
        self.currentSelectedBtn?.isSelected = false
        //self.currentSelectedBtn?.set(font: UIFont.pingFangSCFont(size: 16, weight: .regular))
        button.isSelected = true
        self.currentSelectedBtn = button
        //self.currentSelectedBtn?.set(font: UIFont.pingFangSCFont(size: 20, weight: .medium))
        self.selectedIndex = index
        self.sliderView.snp.remakeConstraints { (make) in
            make.width.equalTo(self.sliderViewW)
            make.height.equalTo(self.sliderViewH)
            make.bottom.equalToSuperview().offset(-5)
            make.centerX.equalTo(button)
        }
        self.layoutIfNeeded()
    }

}

// MARK: - LifeCircle Function
extension AsssetDetailCateView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }

    /// 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()

    }

}
// MARK: - Private UI 手动布局
extension AsssetDetailCateView {
    /// 界面布局
    fileprivate func initialUI() -> Void {
        //
        self.addSubview(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            
        }
        //
        self.mainView.addSubview(self.scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.snp.makeConstraints { (make) in
            //make.top.bottom.height.leading.trailing.equalToSuperview()
            make.edges.height.equalToSuperview()
        }
        //
        self.scrollView.addSubview(self.itemContainer)
        self.itemContainer.snp.makeConstraints { (make) in
            make.edges.height.equalToSuperview()
        }
    }

    fileprivate func setupItemContainer(with models: [EquipmentAssetType]) -> Void {
//        self.itemContainer.removeAllSubView()
        for(_, subview) in self.itemContainer.subviews.enumerated() {
                subview.snp.removeConstraints()
                subview.removeFromSuperview()
        }
        // items
        var leftView: UIView = self.itemContainer
        var contentWidth: CGFloat = 0
        for (index, model) in models.enumerated() {
            let button: UIButton = UIButton.init(type: .custom)
            self.itemContainer.addSubview(button)
            button.set(title: model.title, titleColor: AppColor.minorText, bgImage: UIImage.imageWithColor(UIColor.white), for: .normal)
            button.set(title: model.title, titleColor: AppColor.theme, bgImage: UIImage.imageWithColor(AppColor.theme.withAlphaComponent(0.1)), for: .selected)
            button.set(font: UIFont.pingFangSCFont(size: 15, weight: .regular))
            button.tag = self.itemTagBase + index
            button.set(cornerRadius: 6)
            button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
            let btnWidth: CGFloat = model.title.size(maxSize: CGSize.max, font: UIFont.pingFangSCFont(size: 15, weight: .regular)).width + 40.0
            var itemWidth: CGFloat = max(btnWidth, self.itemMinWidth)
            itemWidth = CGFloat(ceil(Double(itemWidth)))
            button.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.height.equalTo(self.itemHeight)
                make.width.equalTo(itemWidth)
                if 0 == index {
                    make.leading.equalToSuperview().offset(self.itemLrMargin)
                } else {
                    make.leading.equalTo(leftView.snp.trailing).offset(self.itemHorMargin)
                }
                if index == models.count - 1 {
                    make.trailing.equalToSuperview().offset(-self.itemLrMargin)
                    //make.trailing.lessThanOrEqualToSuperview().offset(-self.itemLrMargin)
                }
            }
            leftView = button
        }
        // slider
        mainView.addSubview(self.sliderView)
        self.sliderView.isHidden = true
        self.sliderView.backgroundColor = AppColor.theme
        self.sliderView.set(cornerRadius: self.sliderViewH * 0.5)
        // 默认选中
        guard let selectedBtn = mainView.viewWithTag(self.itemTagBase + self.selectedIndex) as? UIButton else {
            return
        }
        selectedBtn.isSelected = true
        self.currentSelectedBtn = selectedBtn
        //self.currentSelectedBtn?.set(font: UIFont.pingFangSCFont(size: 20, weight: .medium))
        self.sliderView.snp.remakeConstraints { (make) in
            make.width.equalTo(self.sliderViewW)
            make.height.equalTo(self.sliderViewH)
            make.bottom.equalToSuperview().offset(-5)
            make.centerX.equalTo(selectedBtn)
        }
        self.layoutIfNeeded()
    }

}
// MARK: - Private UI Xib加载后处理
extension AsssetDetailCateView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension AsssetDetailCateView {
    fileprivate func setupWithModels(_ models: [EquipmentAssetType]?) -> Void {
        guard let models = models else {
            return
        }
        self.setupItemContainer(with: models)
    }
}

// MARK: - Event Function
extension AsssetDetailCateView {
    /// 按钮点击
    @objc fileprivate func buttonClick(_ button: UIButton) -> Void {
        if button.isSelected {
            return
        }
        self.processScrollView(button)

        let index: Int = button.tag - self.itemTagBase
        self.currentSelectedBtn?.isSelected = false
        //self.currentSelectedBtn?.set(font: UIFont.pingFangSCFont(size: 16, weight: .regular))
        button.isSelected = true
        self.currentSelectedBtn = button
        //self.currentSelectedBtn?.set(font: UIFont.pingFangSCFont(size: 20, weight: .medium))
        self.selectedIndex = index
        self.sliderView.snp.remakeConstraints { (make) in
            make.width.equalTo(self.sliderViewW)
            make.height.equalTo(self.sliderViewH)
            make.bottom.equalToSuperview()
            make.centerX.equalTo(button)
        }
        UIView.animate(withDuration: 0.25) {
            self.mainView.layoutIfNeeded()
        }
        self.delegate?.titleView(self, didClickedAt: index, with: self.models[index])
        self.titleClickAction?(self, index, self.models[index])
    }
}

// MARK: - Extension Function
extension AsssetDetailCateView {
    /// 处理scroll跟着滚动
    func processScrollView(_ button: UIButton) {
        let scrollWidth: CGFloat = kScreenWidth //- 2 * self.itemLrMargin
        if self.scrollView.contentSize.width <= scrollWidth {
            return
        }

        // 初始默认设置时，视图布局并未完成，此时设置显示效果的问题
        ////方案1：index方案，限制了按钮宽度必须一致；
        //let btnCenteX: CGFloat = self.btnMaxW * (CGFloat(button.tag - self.itemTagBase) + 0.5)
        ////方案2：frame方案，限制了必须添加frame
        //let btnCenteX: CGFloat = button.frame.origin.x + button.frame.size.width * 0.5

        // 默认居中，左侧不足则靠左，右侧不足则靠右；优先考虑靠左和靠右的特殊情况
        if button.frame.origin.x + button.frame.size.width * 0.5 < scrollWidth * 0.5 {
            self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        } else if self.scrollView.contentSize.width - button.frame.origin.x - button.frame.size.width * 0.5 < scrollWidth * 0.5 {
            self.scrollView.setContentOffset(CGPoint.init(x: self.scrollView.contentSize.width - scrollWidth, y: 0), animated: true)
        } else {
            self.scrollView.setContentOffset(CGPoint.init(x: button.frame.origin.x + button.frame.size.width * 0.5 - scrollWidth * 0.5, y: 0), animated: true)
        }
    }

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension AsssetDetailCateView {

}
