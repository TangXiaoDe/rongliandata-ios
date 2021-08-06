//
//  PreReturnHomeController.swift
//  SassProject
//
//  Created by 小唐 on 2021/7/27.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  提前还币主页

import UIKit

/// 提前还币类型
enum PreReturnType: String {
    /// 归还全部
    case all
    /// GAS小号
    case gas
    /// 质押
    case mortgage = "pledge"
    /// 累计欠款利息
    case interest = "arrears"
    
    var title: String {
        var value: String = ""
        switch self {
        case .all:
            value = "归还全部"
        case .gas:
            value = "归还GAS消耗"
        case .mortgage:
            value = "归还质押币"
        case .interest:
            value = "归还累计欠款利息"
        }
        return value
    }
    
}

class PreReturnHomeController: BaseViewController
{

    // MARK: - Internal Property
    
    let model: EquipmentDetailModel
    
    // MARK: - Private Property
    
    fileprivate let topBgView: UIImageView = UIImageView.init()
    fileprivate let navBar: AppHomeNavStatusView = AppHomeNavStatusView.init()
    
    fileprivate let scrollView: UIScrollView = UIScrollView.init()
    
    fileprivate let topView: UIView = UIView.init()
    fileprivate let totalWaitReturnView: TitleValueView = TitleValueView.init() // 总计待归还
    fileprivate let returnAllBtn: UIButton = UIButton.init(type: .custom)       // 归还全部
    
    
    fileprivate let centerView: UIView = UIView.init()
    fileprivate let returnTitleLabel: UILabel = UILabel.init()  // 选择归还类型
    fileprivate let returnContainer: UIView = UIView.init()     //
    fileprivate let gasItemView: PRWaitReturnItemView = PRWaitReturnItemView.init()         // Gas消耗数量(FIL)
    fileprivate let mortgageItemView: PRWaitReturnItemView = PRWaitReturnItemView.init()    // 质押币数量(FIL)
    fileprivate let interestItemView: PRWaitReturnItemView = PRWaitReturnItemView.init()    // 累计欠款利息(FIL)
    
    
    fileprivate let bottomView: UIView = UIView.init()
    fileprivate let tipsLabel: UILabel = UILabel.init() // 温馨提示

    fileprivate let topBgViewHeight: CGFloat = CGSize.init(width: 375, height: 194).scaleAspectForWidth(kScreenWidth).height
    fileprivate let lrMargin: CGFloat = 15
    
    fileprivate let topViewTopMargin: CGFloat = 15
    fileprivate let totalWaitReturnViewHeight: CGFloat = 132
    fileprivate let returnAllBtnSize: CGSize = CGSize.init(width: 180, height: 40)
    
    fileprivate let centerViewTopMargin: CGFloat = 5
    fileprivate let centerTitleHeight: CGFloat = 45
    
    fileprivate let itemTbMargin: CGFloat = 0
    fileprivate let itemVerMargin: CGFloat = 12
    fileprivate let itemHeight: CGFloat = PRWaitReturnItemView.viewHeight
    
    fileprivate let tipsTbMargin: CGFloat = 25
    
    
    // MARK: - Initialize Function
    
    init(model: EquipmentDetailModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension PreReturnHomeController {
    
}

// MARK: - LifeCircle/Override Function
extension PreReturnHomeController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }
    
    /// 控制器的view将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    /// 控制器的view即将消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

// MARK: - UI Function
extension PreReturnHomeController {

    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.pageBg
        // topBg
        self.view.addSubview(self.topBgView)
        self.topBgView.image = UIImage.init(named: "IMG_sb_top_bg")
        //self.topBgView.backgroundColor = UIColor.init(hex: 0x282E42)
        //self.topBgView.setupCorners(UIRectCorner.init([UIRectCorner.bottomLeft, UIRectCorner.bottomRight]), selfSize: CGSize.init(width: kScreenWidth, height: self.topBgViewHeight), cornerRadius: 50)
        self.topBgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.topBgViewHeight)
        }
        // navBar
        self.view.addSubview(self.navBar)
        self.navBar.titleLabel.set(text: "提前还币", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.mainText, alignment: .center)
        self.navBar.leftItem.isHidden = false
        self.navBar.leftItem.setImage(UIImage.init(named: "IMG_navbar_back"), for: .normal)
        self.navBar.leftItem.setImage(UIImage.init(named: "IMG_navbar_back"), for: .highlighted)
        self.navBar.rightItem.isHidden = true
        self.navBar.delegate = self
        self.navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(kNavigationStatusBarHeight)
        }
        // scrollView
        self.view.addSubview(self.scrollView)
        self.initialScrollView(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.navBar.snp.bottom)
        }
    }
    ///
    fileprivate func initialScrollView(_ scrollView: UIScrollView) -> Void {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.mj_header = XDRefreshHeader.init(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        scrollView.mj_footer = XDRefreshFooter.init(refreshingTarget: self, refreshingAction: #selector(footerLoadMore))
        scrollView.mj_header.isHidden = false
        scrollView.mj_footer.isHidden = true
        // 顶部位置 的版本适配
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else if #available(iOS 9.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        // 1. topView
        scrollView.addSubview(self.topView)
        self.initialTopView(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.leading.trailing.width.equalToSuperview()
            make.top.equalToSuperview().offset(self.topViewTopMargin)
        }
        // 2. centerView
        scrollView.addSubview(self.centerView)
        self.initialCenterView(self.centerView)
        self.centerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom).offset(self.centerViewTopMargin)
        }
        // 3. bottomView
        scrollView.addSubview(self.bottomView)
        self.initialBottomView(self.bottomView)
        self.bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.centerView.snp.bottom)
            make.bottom.lessThanOrEqualToSuperview().offset(-kBottomHeight)
        }
    }
    ///
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        // totalWaitReturnView
        topView.addSubview(self.totalWaitReturnView)
        self.totalWaitReturnView.backgroundColor = UIColor.white
        self.totalWaitReturnView.set(cornerRadius: 10)
        self.totalWaitReturnView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalToSuperview()
            make.height.equalTo(self.totalWaitReturnViewHeight)
        }
        self.totalWaitReturnView.titleLabel.set(text: "总计待归还(FIL)", font: UIFont.pingFangSCFont(size: 13), textColor: AppColor.minorText, alignment: .center)
        self.totalWaitReturnView.titleLabel.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerY.equalTo(self.totalWaitReturnView.snp.bottom).offset(-55)
        }
        self.totalWaitReturnView.valueLabel.set(text: "0", font: UIFont.pingFangSCFont(size: 32, weight: .medium), textColor: AppColor.mainText, alignment: .center)
        self.totalWaitReturnView.valueLabel.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerY.equalTo(self.totalWaitReturnView.snp.top).offset(44)
        }
        // 2. returnAllBtn
        topView.addSubview(self.returnAllBtn)
        self.returnAllBtn.set(title: "归还全部", titleColor: UIColor.white, for: .normal)
        self.returnAllBtn.set(title: "归还全部", titleColor: UIColor.white, for: .highlighted)
        self.returnAllBtn.set(font: UIFont.systemFont(ofSize: 16), cornerRadius: self.returnAllBtnSize.height * 0.5)
        self.returnAllBtn.addTarget(self, action: #selector(returnAllBtnClick(_:)), for: .touchUpInside)
        self.returnAllBtn.backgroundColor = AppColor.theme
        self.returnAllBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.totalWaitReturnView.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.returnAllBtnSize)
            make.bottom.equalToSuperview()
        }
    }
    ///
    fileprivate func initialCenterView(_ centerView: UIView) -> Void {
        // 1. returnTitleLabel
        centerView.addSubview(self.returnTitleLabel)
        self.returnTitleLabel.set(text: "选择归还类型", font: UIFont.pingFangSCFont(size: 16), textColor: AppColor.mainText, alignment: .left)
        self.returnTitleLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalToSuperview()
            make.height.equalTo(self.centerTitleHeight)
        }
        // 2. returnContainer
        centerView.addSubview(self.returnContainer)
        self.initialReturnContainer(self.returnContainer)
        self.returnContainer.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.returnTitleLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    ///
    fileprivate func initialReturnContainer(_ container: UIView) -> Void {
        //
        let itemViews: [PRWaitReturnItemView] = [self.gasItemView, self.mortgageItemView, self.interestItemView]
        let itemTitles: [String] = ["Gas消耗数量(FIL)", "质押币数量(FIL)", "累计欠款利息(FIL)"]
        var lastView: UIView = container
        for (index, itemView) in itemViews.enumerated() {
            container.addSubview(itemView)
            itemView.title = itemTitles[index]
            itemView.delegate = self
            itemView.backgroundColor = UIColor.white
            itemView.set(cornerRadius: 5)
            itemView.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(self.lrMargin)
                make.trailing.equalToSuperview().offset(-self.lrMargin)
                make.height.equalTo(self.itemHeight)
                if 0 == index {
                    make.top.equalToSuperview().offset(self.itemTbMargin)
                } else {
                    make.top.equalTo(lastView.snp.bottom).offset(self.itemVerMargin)
                }
                if index == itemViews.count - 1 {
                    make.bottom.equalToSuperview().offset(-self.itemTbMargin)
                }
            }
            lastView = itemView
        }
    }

    ///
    fileprivate func initialBottomView(_ bottomView: UIView) -> Void {
        let tips: String = "温馨提示： \n当设备封装比例达到72%时可选择部分借贷金额进行还款，选择总计待归还时只能进行归还全部借贷。"
        //
        bottomView.addSubview(self.tipsLabel)
        self.tipsLabel.set(text: tips, font: UIFont.pingFangSCFont(size: 12), textColor: AppColor.grayText, alignment: .left)
        self.tipsLabel.numberOfLines = 0
        self.tipsLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalToSuperview().offset(self.tipsTbMargin)
            make.bottom.equalToSuperview().offset(-self.tipsTbMargin)
        }
    }
    
}

// MARK: - Data Function
extension PreReturnHomeController {

    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        //self.setupAsDemo()
        guard let asset = self.model.assets else {
            return
        }
        self.gasItemView.value = asset.wait_gas
        self.mortgageItemView.value = asset.wait_pledge
        self.interestItemView.value = asset.interest
        //
        self.totalWaitReturnView.valueLabel.text = asset.wait_total.decimalValidDigitsProcess(digits: 8)
        self.returnAllBtn.isEnabled = asset.wait_total > 0
        self.returnAllBtn.backgroundColor = self.returnAllBtn.isEnabled ? AppColor.theme : AppColor.disable
    }
    ///
    fileprivate func setupAsDemo() -> Void {
        self.totalWaitReturnView.valueLabel.text = "2.0000"
        self.gasItemView.value = 52.000015
        self.mortgageItemView.value = 12.0000
        self.interestItemView.value = 2.0000
    }

}

// MARK: - Event Function
extension PreReturnHomeController {

    /// 导航栏 左侧按钮点击响应
    @objc fileprivate func navBarLeftItemClick() -> Void {
        print("PreReturnHomeController navBarLeftItemClick")
        self.navigationController?.popViewController(animated: true)
    }
    /// 导航栏 右侧侧按钮点击响应
    @objc fileprivate func navBarRightItemClick() -> Void {
        print("PreReturnHomeController navBarRightItemClick")
    }
    
    ///
    @objc fileprivate func headerRefresh() -> Void {
        self.scrollView.mj_header.endRefreshing()
    }
    ///
    @objc fileprivate func footerLoadMore() -> Void {
        self.scrollView.mj_footer.endRefreshing()
    }
    
    ///
    @objc fileprivate func returnAllBtnClick(_ button: UIButton) -> Void {
        self.enterReturnInputPage(type: .all, model: self.model)
    }

}

// MARK: - Request Function
extension PreReturnHomeController {
    
}

// MARK: - Enter Page
extension PreReturnHomeController {
    
    /// 进入还款输入界面
    fileprivate func enterReturnInputPage(type: PreReturnType, model: EquipmentDetailModel) -> Void {
        let inputVC = PreReturnInputController.init(type: type, model: model)
        self.enterPageVC(inputVC)
    }
    
}

// MARK: - Notification Function
extension PreReturnHomeController {
    
}

// MARK: - Extension Function
extension PreReturnHomeController {
    
}

// MARK: - Delegate Function

// MARK: - <AppHomeNavStatusViewProtocol>
extension PreReturnHomeController: AppHomeNavStatusViewProtocol {
    
    /// 导航栏左侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedLeftItem itemView: UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    /// 导航栏右侧按钮点击回调
    func homeBar(_ navBar: AppHomeNavStatusView, didClickedRightItem itemView: UIButton) -> Void {

    }

}


// MARK: - <PRWaitReturnItemViewProtocol>
extension PreReturnHomeController: PRWaitReturnItemViewProtocol {
    
    /// 去还款按钮点击回调
    func itemView(_ itemView: PRWaitReturnItemView, didClickedGoReturn returnView: UIButton) -> Void {
        print("PreReturnHomeController itemView didClickedGoReturn")

        switch itemView {
        case self.gasItemView:
            self.enterReturnInputPage(type: .gas, model: self.model)
        case self.mortgageItemView:
            self.enterReturnInputPage(type: .mortgage, model: self.model)
        case self.interestItemView:
            self.enterReturnInputPage(type: .interest, model: self.model)
        default:
            break
        }
    }
    
}


