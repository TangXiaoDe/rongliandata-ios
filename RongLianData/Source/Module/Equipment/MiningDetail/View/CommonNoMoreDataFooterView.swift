//
//  CommonNoMoreDataFooterView.swift
//  RongLianData
//
//  Created by 小唐 on 2021/1/12.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  没有更多数据的底部视图

import UIKit

class CommonNoMoreDataFooterView: UITableViewHeaderFooterView
{
    
    // MARK: - Internal Property

    static let viewHeight: CGFloat = 40
    static let identifier: String = "CommonNoMoreDataFooterViewReuseIdentifier"
    
    var title: String? = nil {
        didSet {
            self.titleLabel.text = title
        }
    }


    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    fileprivate let titleLabel: UILabel = UILabel.init()
    fileprivate let leftLine: UIView = UIView.init()
    fileprivate let rightLine: UIView = UIView.init()

    fileprivate let lrMargin: CGFloat = 26
    fileprivate let titleLrMargin: CGFloat = 10
    
    // MARK: - Initialize Function
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    /// 通用初始化：UI、配置、数据等
    fileprivate func commonInit() -> Void {
        self.initialUI()
    }

}

// MARK: - Internal Function
extension CommonNoMoreDataFooterView {

    /// 便利构造
    class func footerInTableView(_ tableView: UITableView) -> CommonNoMoreDataFooterView {
        let identifier = self.identifier
        var headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
        if nil == headerFooterView {
            headerFooterView = CommonNoMoreDataFooterView.init(reuseIdentifier: identifier)
        }
        // 状态重置
        if let headerFooterView = headerFooterView as? CommonNoMoreDataFooterView {
            headerFooterView.resetSelf()
        }
        return headerFooterView as! CommonNoMoreDataFooterView
    }

}

// MARK: - LifeCycle/Override Function
extension CommonNoMoreDataFooterView {

}

// MARK: - UI Function
extension CommonNoMoreDataFooterView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        //self.contentView.backgroundColor = AppColor.pageBg
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        // iOS14会出现线条或背景的处理
        if #available(iOS 14.0, *) {
            self.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        //
        self.contentView.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    /// mainView布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12), textColor: UIColor.init(hex: 0xC7CED8), alignment: .center)
        self.titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        // 2. leftLine
        mainView.addSubview(self.leftLine)
        self.leftLine.backgroundColor = UIColor.init(hex: 0xC7CED8)
        self.leftLine.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalTo(self.titleLabel.snp.leading).offset(-self.titleLrMargin)
            make.height.equalTo(0.5)
            make.centerY.equalToSuperview()
        }
        // 3. rightLine
        mainView.addSubview(self.rightLine)
        self.rightLine.backgroundColor = UIColor.init(hex: 0xC7CED8)
        self.rightLine.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(self.titleLrMargin)
            make.height.equalTo(0.5)
            make.centerY.equalToSuperview()
        }

    }

}

// MARK: - Data Function
extension CommonNoMoreDataFooterView {

    /// 重置
    fileprivate func resetSelf() -> Void {
        self.titleLabel.text = nil
    }

}

// MARK: - Event Function
extension CommonNoMoreDataFooterView {


}

// MARK: - Notification Function

// MARK: - Extension Function

// MARK: - Delegate Function

