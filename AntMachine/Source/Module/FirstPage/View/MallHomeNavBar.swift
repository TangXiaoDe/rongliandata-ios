//
//  MallHomeStatusNavBar.swift
//  HZProject
//
//  Created by 小唐 on 2020/5/8.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  商城主页导航栏

import UIKit


protocol MallHomeStatusNavBarProtocol: class {
    /// 导航栏左侧按钮点击回调
    func homeBar(_ navBar: MallHomeStatusNavBar, didClickedLeftItem itemView: UIView) -> Void
    /// 导航栏右侧按钮点击回调
    func homeBar(_ navBar: MallHomeStatusNavBar, didClickedRightItem itemView: UIView) -> Void
}
extension MallHomeStatusNavBarProtocol {
    func homeBar(_ navBar: MallHomeStatusNavBar, didClickedLeftItem itemView: UIView) -> Void {}
}

/// 商城主页导航栏状态栏视图
class MallHomeStatusNavBar: UIView {
    
    static let barHeight: CGFloat = kNavigationStatusBarHeight

    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    var msgcount: Int = 0 {
        didSet {
            self.rightItem.titleLabel.text = "\(msgcount)"
            self.rightItem.titleLabel.isHidden = msgcount <= 0
        }
    }
    var showBottomLine: Bool = true {
        didSet {
            self.bottomLine.isHidden = !showBottomLine
        }
    }

    weak var delegate: MallHomeStatusNavBarProtocol?

    let statusBar: UIView = UIView()

    let navBar: UIView = UIView()
    var leftItem: UIButton = UIButton.init(type: .custom)
    var rightItem: TitleIconControl = TitleIconControl.init()
    let titleView: UIView = UIView()
    let titleLabel: UILabel = UILabel()
    let bottomLine: UIView = UIView.init()

    fileprivate let statusHeight: CGFloat = kStatusBarHeight
    fileprivate let navbarHeight: CGFloat = kNavigationBarHeight
    fileprivate let titleLrMargin: CGFloat = 80
    fileprivate let leftItemLeftMargin: CGFloat = 15
    fileprivate let leftItemSize: CGSize = CGSize.init(width: 111, height: 24)
    fileprivate let rightItemRightMargin: CGFloat = 6
    fileprivate let rightItemIconWH: CGFloat = 20
    fileprivate let rightItemTitleWH: CGFloat = 15
    fileprivate let rightItemTitleIconVerTopMargin: CGFloat = 5
    fileprivate let rightItemTitleIconHorRightMargin: CGFloat = 9


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 默认加载控件
    func commonInit() -> Void {
        // statusBar
        self.addSubview(self.statusBar)
        self.statusBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.statusHeight)
        }
        // navBar
        self.addSubview(self.navBar)
        self.initialNavBar(self.navBar)
        self.navBar.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(self.navbarHeight)
        }
        // bottomLine
        self.addSubview(self.bottomLine)
        self.bottomLine.backgroundColor = AppColor.navShadow
        self.bottomLine.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        // data
        self.msgcount = 0
    }

    fileprivate func initialNavBar(_ barView: UIView) -> Void {
        // titleView
        barView.addSubview(self.titleView)
        self.titleView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(self.titleLrMargin)
            make.trailing.equalToSuperview().offset(-self.titleLrMargin)
        }
        self.titleView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: UIColor.white, alignment: .center)  // default align center
        self.titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // leftItem
        barView.addSubview(self.leftItem)
        self.leftItem.addTarget(self, action: #selector(leftItemClick(_:)), for: .touchUpInside)
        self.leftItem.setBackgroundImage(UIImage.init(named: "IMG_mall_logo"), for: .normal)
        self.leftItem.setBackgroundImage(UIImage.init(named: "IMG_mall_logo"), for: .highlighted)
        self.leftItem.isUserInteractionEnabled = false
        self.leftItem.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.leftItemLeftMargin)
            make.centerY.equalToSuperview()
            make.size.equalTo(self.leftItemSize)
        }
        // rightItem
        barView.addSubview(self.rightItem)
        self.rightItem.addTarget(self, action: #selector(rightItemClick(_:)), for: .touchUpInside)
        self.rightItem.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.rightItemRightMargin)
            make.centerY.equalToSuperview()
        }
        self.rightItem.bringSubviewToFront(self.rightItem.titleLabel)
        self.rightItem.titleLabel.backgroundColor = AppColor.themeYellow
        self.rightItem.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 10), textColor: UIColor.white, alignment: .center)
//        self.rightItem.titleLabel.set(cornerRadius: self.rightItemTitleWH * 0.5, borderWidth: 1, borderColor: UIColor.white)
        self.rightItem.titleLabel.set(cornerRadius: self.rightItemTitleWH * 0.5)
        self.rightItem.titleLabel.snp.remakeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.width.height.equalTo(self.rightItemTitleWH)
        }
        self.rightItem.iconView.image = UIImage.init(named: "IMG_mall_nav_msg")
        self.rightItem.iconView.set(cornerRadius: 0)
        self.rightItem.iconView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.rightItem.titleLabel).offset(self.rightItemTitleIconVerTopMargin)
            make.trailing.equalTo(self.rightItem.titleLabel).offset(-self.rightItemTitleIconHorRightMargin)
            make.width.height.equalTo(self.rightItemIconWH)
            make.leading.bottom.equalToSuperview()
        }
    }

    @objc fileprivate func leftItemClick(_ button: UIButton) -> Void {
        self.delegate?.homeBar(self, didClickedLeftItem: button)
    }
    @objc fileprivate func rightItemClick(_ rightItem: TitleIconControl) -> Void {
        self.delegate?.homeBar(self, didClickedRightItem: rightItem)
    }

}

