////
////  MessageListController.swift
////  CCMall
////
////  Created by 小唐 on 2019/2/22.
////  Copyright © 2019 COMC. All rights reserved.
////
////  消息列表界面
//
//import UIKit
//import MJRefresh
//
/// 消息类型
enum MessageType: String {
    case order
    case system
}

class MessageListController: BaseViewController {

    // MARK: - Internal Property

    let type: MessageType

    // MARK: - Private Property
    fileprivate let tableView: BaseTableView = BaseTableView(frame: CGRect.zero, style: .plain)

    fileprivate var sourceList: [MessageListModel] = []

    fileprivate let limit: Int = 15
    fileprivate var offset: Int = 0

    // MARK: - Initialize Function
    init(type: MessageType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle Function
extension MessageListController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }
}

// MARK: - UI
extension MessageListController {
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.init(hex: 0xf6f6f6)
        // 1. navigationbar
        let title: String = (self.type == .order) ? "订单通知" : "系统通知"
        self.navigationItem.title = title
        // 2. tableView
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 250
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.init(hex: 0xf6f6f6)
        tableView.mj_header = XDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshRequest))
        tableView.mj_footer = XDRefreshFooter(refreshingTarget: self, refreshingAction: #selector(loadmoreRequest))
        tableView.mj_footer?.isHidden = true
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(self.view.snp_bottomMargin)
        }
        // 顶部位置 的版本适配
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else if #available(iOS 9.0, *) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
}

// MARK: - Data(数据处理与加载)
extension MessageListController {
    // MARK: - Private  数据处理与加载
    fileprivate func initialDataSource() -> Void {
        self.tableView.mj_header?.beginRefreshing()
    }
}

// MARK: - Event(事件响应)
extension MessageListController {
    @objc fileprivate func refreshRequest() -> Void {
        MessageNetworkManager.getMessagList(type: self.type, offset: 0, limit: self.limit) { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.state = .idle  // 网络错误、没有更多数据时重置
            guard status, let models = models else {
                Toast.showToast(title: msg)
                self.tableView.showDefaultEmpty = self.sourceList.isEmpty
                return
            }
            self.sourceList = models
            self.offset = models.count
            self.tableView.mj_footer?.isHidden = models.count < self.limit
            self.tableView.showDefaultEmpty = self.sourceList.isEmpty
            self.tableView.reloadData()
            NotificationCenter.default.post(name: AppNotificationName.Message.refresh, object: nil)
        }
    }
    @objc fileprivate func loadmoreRequest() -> Void {
        MessageNetworkManager.getMessagList(type: self.type, offset: self.offset, limit: self.limit) { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            self.tableView.mj_footer?.endRefreshing()
            guard status, let models = models else {
                return
            }
            self.sourceList.append(contentsOf: models)
            self.offset = self.sourceList.count
            if models.count < self.limit {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            self.tableView.reloadData()
        }
    }
}

// MARK: - Notification
extension MessageListController {

}

// MARK: - Delegate Function

// MARK: - <UITableViewDataSource>
extension MessageListController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageListCell.cellInTableView(tableView)
        cell.model = self.sourceList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

}

// MARK: - <UITableViewDelegate>
extension MessageListController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt\(indexPath.row)")
    }

}
