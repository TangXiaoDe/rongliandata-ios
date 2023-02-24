//
//  LoginTypeView.swift
//  OneMateProject
//
//  Created by 小唐 on 2022/8/29.
//  Copyright © 2022 ChainOne. All rights reserved.
//
//  登录方式选择视图

import UIKit

protocol LoginTypeViewProtocol: class {
    
    ///
    func typeView(_ typeView: LoginTypeView, didClickedAt index: Int, type: LoginType, title: String?) -> Void
    
}


class LoginTypeView: UIView {

    // MARK: - Internal Property

    static let viewHeight: CGFloat = 44
    
    //var defaultSelectedIndex: Int = 0

    weak var delegate: LoginTypeViewProtocol?
    var titleClickAction: ((_ titleView: LoginTypeView, _ index: Int, _ type: LoginType, _ title: String?) -> Void)?

    private(set) var selectedIndex: Int = 0
    //    var selectedIndex: Int = 0 {
    //        didSet {
    //            if oldValue == selectedIndex {
    //                return
    //            }
    //            self.didSetupSelectedIndex(selectedIndex)
    //        }
    //    }
    
    var types: [LoginType] = [] {
        didSet {
            self.setupWithTypes(types)
        }
    }
    
    ///
    var showPwdLogin: Bool = true {
        didSet {
            self.setupShowPwdLogin(showPwdLogin)
        }
    }

    // MARK: - Private Property


    fileprivate let mainView: UIView = UIView()
    fileprivate let mainScrollView: UIScrollView = UIScrollView.init()
    fileprivate let itemContainer: UIView = UIView.init()
    fileprivate let sliderView: UIImageView = UIImageView()


    fileprivate let containerViewHeight: CGFloat = 44
    fileprivate let containerTopMargin: CGFloat = 0
    fileprivate let containerBottomMargin: CGFloat = 0
    
    fileprivate let sliderViewH: CGFloat = 3
    fileprivate let sliderViewW: CGFloat = 40
    fileprivate let sliderBottomMargin: CGFloat = 4

    
    fileprivate let normalFont: UIFont = UIFont.pingFangSCFont(size: 16, weight: .medium)
    fileprivate let selectedFont: UIFont = UIFont.pingFangSCFont(size: 16, weight: .medium)
    fileprivate let normalColor: UIColor = AppColor.grayText
    fileprivate let selectedColor: UIColor = AppColor.theme
    
    fileprivate let itemViewTagBase: Int = 250

    /// 当前选中按钮
    fileprivate var currentSelectedView: UIButton?


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
extension LoginTypeView {
    
    ///
    class func loadXib() -> LoginTypeView? {
        return Bundle.main.loadNibNamed("LoginTypeView", owner: nil, options: nil)?.first as? LoginTypeView
    }

    /// 设置当前选中索引
    func setupSelectedIndex(_ selectedIndex: Int) -> Void {
        if selectedIndex == self.selectedIndex {
            return
        }
        guard let selectedView = self.mainView.viewWithTag(self.itemViewTagBase + selectedIndex) as? UIButton else {
            return
        }
        //self.processScrollView(selectedView)
        let index: Int = selectedView.tag - self.itemViewTagBase
        self.currentSelectedView?.isSelected = false
        //self.currentSelectedView?.titleLabel?.textColor = self.normalColor
        self.currentSelectedView?.set(font: self.normalFont)
        selectedView.isSelected = true
        //selectedView.titleLabel?.textColor = self.selectedColor
        selectedView.set(font: self.selectedFont)
        self.currentSelectedView = selectedView
        self.selectedIndex = index
        self.sliderView.snp.remakeConstraints { (make) in
            make.width.equalTo(self.sliderViewW)
            make.height.equalTo(self.sliderViewH)
            make.bottom.equalToSuperview().offset(-self.sliderBottomMargin)
            make.centerX.equalTo(selectedView)
        }
    }

}

// MARK: - LifeCircle Function
extension LoginTypeView {
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
extension LoginTypeView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        //self.backgroundColor = AppColor.mainViewBg
        //
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    ///
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. container
        mainView.addSubview(self.itemContainer)
        self.itemContainer.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(self.containerTopMargin)
            make.bottom.equalToSuperview().offset(-self.containerBottomMargin)
        }
        // 2. sliderView
        mainView.addSubview(self.sliderView)
        self.sliderView.set(cornerRadius: self.sliderViewH * 0.5)
        //self.sliderView.image = UIImage.init(named: "IMG_login_img_arrowhead")
        self.sliderView.snp.makeConstraints { (make) in
            make.width.equalTo(self.sliderViewW)
            make.height.equalTo(self.sliderViewH)
            make.bottom.equalToSuperview().offset(-self.sliderBottomMargin)
            make.leading.equalToSuperview()
        }
        let sliderLayer = AppUtil.commonGradientLayer()
        self.sliderView.layer.insertSublayer(sliderLayer, below: nil)
        sliderLayer.frame = CGRect.init(x: 0, y: 0, width: self.sliderViewW, height: self.sliderViewH)
    }

}
// MARK: - Private UI Xib加载后处理
extension LoginTypeView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension LoginTypeView {
    
    ///
    fileprivate func setupWithTypes(_ types: [LoginType]) -> Void {
        self.itemContainer.removeAllSubviews()
        // 等分方案
        let itemWidth: CGFloat = kScreenWidth / CGFloat(types.count)
        for (index, type) in types.enumerated() {
            let itemView: UIButton = UIButton.init(type: .custom)
            self.itemContainer.addSubview(itemView)
            itemView.tag = self.itemViewTagBase + index
            itemView.set(title: type.title, titleColor: self.normalColor, image: nil, bgImage: nil, for: .normal)
            itemView.set(title: type.title, titleColor: self.selectedColor, image: nil, bgImage: nil, for: .selected)
            itemView.set(font: self.normalFont)
            itemView.addTarget(self, action: #selector(itemViewClick(_:)), for: .touchUpInside)
            itemView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.width.equalTo(itemWidth)
                let leftMargin: CGFloat = CGFloat(index) * itemWidth
                make.leading.equalToSuperview().offset(leftMargin)
                if index == types.count - 1 {
                    make.trailing.equalToSuperview()
                }
            }
        }
        // 默认选中
        guard let selectedView = self.itemContainer.viewWithTag(self.itemViewTagBase + self.selectedIndex) as? UIButton else {
            return
        }
        self.currentSelectedView?.isSelected = false
        //self.currentSelectedView?.titleLabel?.textColor = self.normalColor
        self.currentSelectedView?.set(font: self.normalFont)
        selectedView.isSelected = true
        //selectedView.titleLabel?.textColor = self.selectedColor
        selectedView.set(font: self.selectedFont)
        self.currentSelectedView = selectedView
        self.sliderView.snp.remakeConstraints { (make) in
            make.width.equalTo(self.sliderViewW)
            make.height.equalTo(self.sliderViewH)
            make.bottom.equalToSuperview().offset(-self.sliderBottomMargin)
            make.centerX.equalTo(selectedView)
        }
    }
    
    ///
    fileprivate func setupShowPwdLogin(_ showPwdLogin: Bool) -> Void {
        if !showPwdLogin {
            var showTypes: [LoginType] = []
            for type in self.types {
                if type != .password {
                    showTypes.append(type)
                }
            }
            self.types = showTypes
        }
    }
    
}

// MARK: - Event Function
extension LoginTypeView {
    /// 按钮点击
    @objc fileprivate func itemViewClick(_ itemView: UIButton) -> Void {
        if itemView.isSelected || self.types.isEmpty {
            return
        }
        let index: Int = itemView.tag - self.itemViewTagBase
        let type: LoginType = self.types[index]
        self.delegate?.typeView(self, didClickedAt: index, type: type, title: self.types[index].title)
        self.titleClickAction?(self, index, type, self.types[index].title)
    }

}

// MARK: - Extension Function
extension LoginTypeView {
    /// 处理scroll跟着滚动
    func processScrollView(_ selectedView: UIControl) {
        // 初始默认设置时，视图布局并未完成，此时设置显示效果的问题
        ////方案1：index方案，限制了按钮宽度必须一致；
        //let btnCenteX: CGFloat = self.btnMaxW * (CGFloat(button.tag - self.itemViewTagBase) + 0.5)
        ////方案2：frame方案，限制了必须添加frame
        //let btnCenteX: CGFloat = button.frame.origin.x + button.frame.size.width * 0.5

        // 宽度不足时不予滑动处理
        if self.mainScrollView.contentSize.width <= kScreenWidth {
            return
        }

        // 默认居中，左侧不足则靠左，右侧不足则靠右；优先考虑靠左和靠右的特殊情况
        if selectedView.frame.origin.x + selectedView.frame.size.width * 0.5 < kScreenWidth * 0.5 {
            self.mainScrollView.setContentOffset(CGPoint.zero, animated: true)
        } else if self.mainScrollView.contentSize.width - selectedView.frame.origin.x - selectedView.frame.size.width * 0.5 < kScreenWidth * 0.5 {
            self.mainScrollView.setContentOffset(CGPoint.init(x: self.mainScrollView.contentSize.width - kScreenWidth, y: 0), animated: true)
        } else {
            self.mainScrollView.setContentOffset(CGPoint.init(x: selectedView.frame.origin.x + selectedView.frame.size.width * 0.5 - kScreenWidth * 0.5, y: 0), animated: true)
        }
    }

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension LoginTypeView {

}
