//
//  ReturnListTipsController.swift
//  RongLianData
//
//  Created by 小唐 on 2021/10/12.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  归还流水说明界面，由弹窗改为界面，文案写死

import UIKit

class ReturnListTipsController: BaseViewController
{

    // MARK: - Internal Property
    
    // MARK: - Private Property
    
    fileprivate let scrollView: UIScrollView = UIScrollView.init()
    fileprivate let tipsContainer: UIView = UIView.init()
    fileprivate let tipsLabel: UILabel = UILabel.init()
    
    fileprivate let lrMargin: CGFloat = 20
    fileprivate let tbMargin: CGFloat = 20
    
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
extension ReturnListTipsController {
    
}

// MARK: - LifeCircle/Override Function
extension ReturnListTipsController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }
    
    /// 控制器的view将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    /// 控制器的view即将消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

// MARK: - UI Function
extension ReturnListTipsController {

    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.white
        // navBar
        self.navigationItem.title = "归还流水说明"
        // scrollView
        self.view.addSubview(self.scrollView)
        self.initialScrollView(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //
        // 顶部位置 的版本适配
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else if #available(iOS 9.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    ///
    fileprivate func initialScrollView(_ scrollView: UIScrollView) -> Void {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        // tipsContainer
        scrollView.addSubview(self.tipsContainer)
        self.tipsContainer.snp.makeConstraints { make in
            make.leading.trailing.width.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-kBottomHeight)
        }
        // tips
        self.tipsContainer.addSubview(self.tipsLabel)
        self.tipsLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14), textColor: AppColor.detailText)
        self.tipsLabel.numberOfLines = 0
        self.tipsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalToSuperview().offset(self.tbMargin)
            make.bottom.equalToSuperview().offset(-self.tbMargin)
        }
    }

}

// MARK: - Data Function
extension ReturnListTipsController {

    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        //self.setupAsDemo()
        
        let tips: String = """
        利息算法为待归还借贷本金*日利率，每日进行统计一次，每月月初结算一次 当日应还利息=待归还借贷本金*日利率*X% 当日累计欠款利息=待归还借贷本金*日利率*Y% 其中X%+Y%=100% 当日归还金额=当日分发冻结数量+当日线性释放冻结数量
        
        当日归还金额≥待归还借贷本金*日利率时，则当日归还金额归还所有当日应还利息+当日累计欠款利息，如归还之后当日归还金额有剩余，则归还借贷本金
        
        待归还借贷本金*日利率＞当日归还金额≥当日应还利息时，则当日归还金额归还当日应还利息，如归还之后当日归还金额有剩余，则归还借贷本金，当日累计欠款利息直接做累计
        
        当日归还金额＜当日应还利息时，没有还完的应还利息作为累计欠款利息与当日累计欠款利息直接做累计
        """
        self.tipsLabel.text = tips
    }
    ///
    fileprivate func setupAsDemo() -> Void {
        
    }

}

// MARK: - Event Function
extension ReturnListTipsController {


}

// MARK: - Request Function
extension ReturnListTipsController {
    
}

// MARK: - Enter Page
extension ReturnListTipsController {
    
}

// MARK: - Notification Function
extension ReturnListTipsController {
    
}

// MARK: - Extension Function
extension ReturnListTipsController {
    
}

// MARK: - Delegate Function

// MARK: - <>
extension ReturnListTipsController {
    
}

