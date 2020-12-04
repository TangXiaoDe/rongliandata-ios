//
//  WalletDetailHomeController.swift
//  JXProject
//
//  Created by zhaowei on 2020/10/21.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  Fil明细

import UIKit
import ChainOneKit

class WalletDetailHomeController: BaseViewController {
    // MARK: - Internal Property

    // MARK: - Private Property

    fileprivate let titleView = AssetActionTitleView()
    fileprivate let scrollView: UIScrollView = UIScrollView()

    fileprivate let titleViewH: CGFloat = AssetActionTitleView.viewHeight
    
    fileprivate let scrollTopMargin: CGFloat = 12

    fileprivate(set) var selectedIndex: Int = 0 {
        didSet {
            if oldValue == selectedIndex {
                return
            }
            self.titleView.selectedIndex = selectedIndex
            self.scrollView.setContentOffset(CGPoint.init(x: CGFloat(selectedIndex) * kScreenWidth, y: 0), animated: false)
        }
    }

    // MARK: - Initialize Function

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle Function
extension WalletDetailHomeController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - UI
extension WalletDetailHomeController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.pageBg
        // navigation
        self.navigationItem.title = "FIL明细"
        // 1. titleView
        self.view.addSubview(self.titleView)
        self.titleView.delegate = self
        self.titleView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.titleViewH)
        }
        // 2. scrollView
        self.view.addSubview(self.scrollView)
        self.initialScrollView(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.titleView.snp.bottom).offset(scrollTopMargin)
            make.bottom.equalToSuperview().offset(-kBottomHeight)
        }
    }
    /// scrollView 布局
    fileprivate func initialScrollView(_ scrollView: UIScrollView) -> Void {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        let scrollViewH: CGFloat = kScreenHeight - kBottomHeight - kNavigationStatusBarHeight - self.titleViewH - scrollTopMargin
        let childVCList: [WalletListController] = [WalletListController.init(type: .all),
                                             WalletListController.init(type: .income),
                                             WalletListController.init(type: .outcome)]
        for (index, childVC) in childVCList.enumerated() {
            self.addChild(childVC)
            scrollView.addSubview(childVC.view)
            childVC.view.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(kScreenWidth)
                make.height.equalTo(scrollViewH)
                make.leading.equalToSuperview().offset(CGFloat(index) * kScreenWidth)
                if index == childVCList.count - 1 {
                    make.trailing.equalToSuperview()
                }
            }
        }
        // contentOffset
        scrollView.contentSize = CGSize.init(width: kScreenWidth * CGFloat(childVCList.count), height: scrollViewH)
        self.scrollView.contentOffset = CGPoint.init(x: kScreenWidth * CGFloat(self.selectedIndex), y: 0)
    }

}

// MARK: - Data(数据处理与加载)
extension WalletDetailHomeController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {

    }
}

// MARK: - Event(事件响应)
extension WalletDetailHomeController {

}

// MARK: - Notification
extension WalletDetailHomeController {

}

// MARK: - Extension Function
extension WalletDetailHomeController {

}

// MARK: - Delegate Function

// MARK: - <AssetActionTitleViewProtocol>
extension WalletDetailHomeController: AssetActionTitleViewProtocol {
    func titleView(_ titleView: AssetActionTitleView, didClickedAt index: Int, with title: String) {
        self.selectedIndex = index
    }
}

// MARK: - <MyOrderTitleSelectViewProtocol>
extension WalletDetailHomeController: UIScrollViewDelegate {
    /// 滑动结束 回调
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollIndex: Int = Int(scrollView.contentOffset.x / kScreenWidth)
        self.selectedIndex = scrollIndex
    }
}

