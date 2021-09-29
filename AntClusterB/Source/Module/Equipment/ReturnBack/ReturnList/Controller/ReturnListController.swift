//
//  ReturnListController.swift
//  SassProject
//
//  Created by 小唐 on 2021/7/27.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  归还明细页面

import UIKit

class ReturnListController: BaseViewController
{
    
    /// 日期选择类型
    enum DateType {
        case start
        case end
    }
    
    // MARK: - Internal Property

    // MARK: - Private Property
    
    fileprivate let headerView: ReturnListHeader = ReturnListHeader.init()
    fileprivate let tableView: BaseTableView = BaseTableView(frame: CGRect.zero, style: .plain)
    
    fileprivate var sourceList: [String] = []
    fileprivate var offset: Int = 0
    fileprivate let limit: Int = 20
    
    fileprivate let headerHeight: CGFloat = 52
    
    fileprivate var dateType: DateType? = nil
    fileprivate var selectedStartDate: Date? = nil
    fileprivate var selectedEndDate: Date? = nil
    
    
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

// MARK: - LifeCircle/Override Function
extension ReturnListController {

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
extension ReturnListController {
    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.pageBg
        // 1. navBar
        self.navigationItem.title = "归还流水"
        let explainItem = UIBarButtonItem.init(title: "说明", style: .plain, target: self, action: #selector(navBarRightItemClick))
        AppUtil.setupCommonNavTitleItem(explainItem, font: UIFont.pingFangSCFont(size: 13), normalColor: AppColor.mainText, disableColor: AppColor.disable)
        self.navigationItem.rightBarButtonItem = explainItem
        // header
        self.view.addSubview(self.headerView)
        self.headerView.backgroundColor = UIColor.white
        self.headerView.delegate = self
        self.headerView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.headerHeight)
        }
        // 2. tableView
        self.view.addSubview(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 250
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.backgroundColor = AppColor.pageBg
        self.tableView.mj_header = XDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        self.tableView.mj_footer = XDRefreshFooter(refreshingTarget: self, refreshingAction: #selector(footerLoadMore))
        self.tableView.mj_header.isHidden = false
        self.tableView.mj_footer.isHidden = true
        self.tableView.frame = self.view.bounds
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp_bottom)
        }
        // 顶部位置 的版本适配
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else if #available(iOS 9.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

}

// MARK: - Data Function
extension ReturnListController {

    // MARK: - Private  数据处理与加载
    fileprivate func initialDataSource() -> Void {
        //self.tableView.mj_header.beginRefreshing()
        self.setupAsDemo()
    }
    ///
    fileprivate func setupAsDemo() -> Void {
        for i in 0...25 {
            self.sourceList.append("\(i)")
        }
        self.tableView.reloadData()
    }
    
    ///
    fileprivate func setupDate(_ date: Date, for type: DateType?) -> Void {
        guard let type = type else {
            return
        }
        switch type {
        case .start:
            self.selectedStartDate = date
            self.headerView.startDate = date
        case .end:
            self.selectedEndDate = date
            self.headerView.endDate = date
        }
        //self.tableView.mj_header.beginRefreshing()
    }

}

// MARK: - Event Function
extension ReturnListController {

    /// 导航栏 左侧按钮点击响应
    @objc fileprivate func navBarLeftItemClick() -> Void {
        print("TemplateUIViewController navBarLeftItemClick")
        self.navigationController?.popViewController(animated: true)
    }
    /// 导航栏 右侧侧按钮点击响应
    @objc fileprivate func navBarRightItemClick() -> Void {
        print("TemplateUIViewController navBarRightItemClick")
        
        let popView = ReturnListTipsPopVew.init()
        popView.content = "利息算法为待归还借贷本金*日利率，每日进行统计一次，一半放到累计欠款利息，一半直接进行统计等待月初进行归还，当归还金额低于应归还利息时，剩余未归还金额放至累计欠款利息中等待借贷本金还完进行二次归还，归还借贷本金可点击提前归还按钮进行提前归还借贷本金，本金减少后利息也会适当下降。"
        PopViewUtil.showPopView(popView)
        
    }

    /// 顶部刷新
    @objc fileprivate func headerRefresh() -> Void {
        self.refreshRequest()
    }
    /// 底部记载更多
    @objc fileprivate func footerLoadMore() -> Void {
        self.loadMoreRequest()
    }
    
}

// MARK: - Request Function
extension ReturnListController {

    /// 下拉刷新请求
    fileprivate func refreshRequest() -> Void {
//        MessageNetworkManager.getMessageList(offset: 0, limit: self.limit) { [weak self](status, msg, models) in
//            guard let `self` = self else {
//                return
//            }
//            self.tableView.mj_header.endRefreshing()
//            self.tableView.mj_footer.state = .idle
//            guard status, let models = models else {
//                ToastUtil.showToast(title: msg)
//                self.tableView.showDefaultEmpty = self.sourceList.isEmpty
//                return
//            }
//            self.sourceList = models
//            self.offset = self.sourceList.count
//            self.tableView.mj_footer.isHidden = models.count < self.limit
//            self.tableView.showDefaultEmpty = self.sourceList.isEmpty
//            self.tableView.reloadData()
//        }
    }
    
    /// 上拉加载更多请求
    fileprivate func loadMoreRequest() -> Void {
//        MessageNetworkManager.getMessageList(offset: self.offset, limit: self.limit) { [weak self](status, msg, models) in
//            guard let `self` = self else {
//                return
//            }
//            self.tableView.mj_footer.endRefreshing()
//            guard status, let models = models else {
//                self.tableView.mj_footer.endRefreshingWithWeakNetwork()
//                return
//            }
//            if models.count < self.limit {
//                self.tableView.mj_footer.endRefreshingWithNoMoreData()
//            }
//            self.sourceList += models
//            self.offset = self.sourceList.count
//            self.tableView.reloadData()
//        }
    }

}

// MARK: - Enter Page
extension ReturnListController {
    
    ///
    fileprivate func showDatePicker(selectedDate: Date? = nil) -> Void {
        print("ReturnListController showDatePicker")
        
        let datePicker: UIDatePicker = UIDatePicker.init()
        // 设置地区: zh-中国
        datePicker.locale = Locale.init(identifier: "zh_CN")
        // 设置当前显示时间
        datePicker.setDate(Date.init(), animated: false)
        // 设置日期范围：最大显示时间、最小显示时间
        datePicker.minimumDate = Date.dateWithString("2021-06-01 00:00:00")    // yyyy-MM-dd HH:mm:ss
        datePicker.maximumDate = Date.dateWithString("2022-01-01 00:00:00")    // yyyy-MM-dd HH:mm:ss
        // 设置日期模式(time、date、dateAndTime、countDownTimer)
        datePicker.datePickerMode = UIDatePicker.Mode.date
        // 版本兼容处理，13.4之后默认需加载到UIController中，点击弹出新的非UIPickerView样式的日期选择控件
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        //
        let pickerView = PickerPopView.init()
        pickerView.showDatePicker(picker: datePicker)
        pickerView.datePickerDoneBtnClickAction = { (_ picker: UIDatePicker) -> Void in
            print(picker.date)
            DispatchQueue.main.async {
                self.setupDate(picker.date, for: self.dateType)
            }
        }
        PickerUtil.showPickerPopView(pickerView)
    }
    
}

// MARK: - Notification Function
extension ReturnListController {
    
}

// MARK: - Extension Function
extension ReturnListController {
    
}

// MARK: - Delegate Function

// MARK: - <UITableViewDataSource>
extension ReturnListController: ReturnListHeaderProtocol {

    ///
    func headerView(_ headerView: ReturnListHeader, didClickedStart startView: UIView) -> Void {
        self.dateType = .start
        self.showDatePicker(selectedDate:self.selectedStartDate)
    }
    ///
    func headerView(_ headerView: ReturnListHeader, didClickedEnd endView: UIView) -> Void {
        self.dateType = .end
        self.showDatePicker(selectedDate:self.selectedEndDate)
    }
    
}

// MARK: - <UITableViewDataSource>
extension ReturnListController: UITableViewDataSource {

    ///
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceList.count
    }

    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ReturnListCell.cellInTableView(tableView, at: indexPath)
        cell.model = self.sourceList[indexPath.row]
        cell.showTopMargin = indexPath.row == 0
        return cell
    }
    
}

// MARK: - <UITableViewDelegate>
extension ReturnListController: UITableViewDelegate {

    ///
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //return 44
    }

    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt\(indexPath.row)")
    }
    
}

