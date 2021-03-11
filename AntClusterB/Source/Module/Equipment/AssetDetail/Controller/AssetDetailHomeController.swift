//
//  AssetDetailHomeController.swift
//  RenRenProject
//
//  Created by zhaowei on 2020/11/3.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  资产明细

import UIKit
import ChainOneKit

class AssetDetailHomeController: BaseViewController {
    // MARK: - Internal Property
    fileprivate var model: EquipmentDetailModel
    // MARK: - Private Property
    fileprivate let popView = AssetDetailFilterPopView.init()
    fileprivate let filterBtn = UIButton.init(type: .custom)
    fileprivate let titleView = AssetDetailTitleView.init(themeColor: AppColor.theme)
    fileprivate let scrollView: UIScrollView = UIScrollView()
    fileprivate var cateList: [EquipmentAssetType] = [EquipmentAssetType.all, EquipmentAssetType.fil_pawn, EquipmentAssetType.fil_lock, EquipmentAssetType.fil_available]
    fileprivate let titleViewH: CGFloat = AssetDetailTitleView.viewHeight
    fileprivate let topMargin: CGFloat = 10
    
    fileprivate var selectType: EquipmentAssetType = .all
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

    init(model: EquipmentDetailModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Internal Function

// MARK: - LifeCircle Function
extension AssetDetailHomeController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.hiddenNavBarShadow()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.showNavBarShadow(color: AppColor.navShadow)
    }
}

// MARK: - UI
extension AssetDetailHomeController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.white
        // navigation
        self.navigationItem.title = "资产明细"
        self.filterBtn.set(title: "筛选", titleColor: AppColor.mainText, image: UIImage.init(named: "IMG_home_icom_select"), bgImage: nil, for: .normal)
        self.filterBtn.set(font: UIFont.pingFangSCFont(size: 13, weight: .regular))
        self.filterBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -2, bottom: 0, right: 2)
        self.filterBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 2, bottom: 0, right: -2)
        self.filterBtn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 2, bottom: 0, right: 2)
        self.filterBtn.addTarget(self, action: #selector(filterBtnClick(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.filterBtn)
        // 1. titleView
        self.view.addSubview(self.titleView)
        self.titleView.delegate = self
        self.titleView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.titleViewH)
        }
        self.titleView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: 0, margin2: 0)
        // 2. scrollView
        self.view.addSubview(self.scrollView)
        self.initialScrollView(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.titleView.snp.bottom).offset(self.topMargin)
            make.bottom.equalToSuperview().offset(-kBottomHeight)
        }
    }
    /// scrollView 布局
    fileprivate func initialScrollView(_ scrollView: UIScrollView) -> Void {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        let scrollViewH: CGFloat = kScreenHeight - kBottomHeight - kNavigationStatusBarHeight - self.titleViewH - self.topMargin
        let childVCList: [AssetDetailHomeListController] = [AssetDetailHomeListController.init(type: .all, model: self.model),
                                                            AssetDetailHomeListController.init(type: .income, model: self.model),
                                                            AssetDetailHomeListController.init(type: .outcome, model: self.model)]
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
extension AssetDetailHomeController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {

    }
}

// MARK: - Event(事件响应)
extension AssetDetailHomeController {
    @objc func filterBtnClick(_ btn: UIButton) {
        //  跳转资产明细分类选择
        self.enterCategorySelectPage(model: nil)
    }
}

// MARK: - EnterPage
extension AssetDetailHomeController {
    //  分类选择界面
    fileprivate func enterCategorySelectPage(model: String?) -> Void {
        popView.selectType = self.selectType
        popView.models = self.cateList
        popView.delegate = self
        PopViewUtil.showPopView(popView, on: self.view, duration: nil)
    }
}

// MARK: - Notification
extension AssetDetailHomeController {

}

// MARK: - Extension Function
extension AssetDetailHomeController {

}

// MARK: - Delegate Function

// MARK: - <AssetDetailTitleViewProtocol>
extension AssetDetailHomeController: AssetDetailTitleViewProtocol {
    func titleView(_ titleView: AssetDetailTitleView, didClickedAt index: Int, with title: String) {
        self.selectedIndex = index
    }
}

// MARK: - <MyOrderTitleSelectViewProtocol>
extension AssetDetailHomeController: UIScrollViewDelegate {
    /// 滑动结束 回调
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollIndex: Int = Int(scrollView.contentOffset.x / kScreenWidth)
        self.selectedIndex = scrollIndex
    }
}
extension AssetDetailHomeController: AssetDetailFilterPopViewProtocol {
    func popView(_ popView: AssetDetailFilterPopView, didClickedCate cateBtn: UIButton, index: Int) {
        self.selectType = self.cateList[index]
        NotificationCenter.default.post(name: AppNotificationName.Equipment.assetTypeChange, object: selectType)
    }
}
