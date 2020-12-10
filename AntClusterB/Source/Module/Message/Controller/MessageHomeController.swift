//
//  MessageHomeController.swift
//  CCMall
//
//  Created by 小唐 on 2019/2/22.
//  Copyright © 2019 COMC. All rights reserved.
//
//  消息主页
//
import UIKit
import MJRefresh

typealias MessageCenterController = MessageHomeController
class MessageHomeController: BaseViewController {

    // MARK: - Internal Property
    // MARK: - Private Property
    fileprivate let tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)

    fileprivate var sourceList: [UnreadItemModel] = []

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
extension MessageHomeController {
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }
    ///
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

// MARK: - UI
extension MessageHomeController {
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.white
        // 1. navigationbar
        self.navigationItem.title = "消息中心"
        // 2. tableView
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 250
        tableView.showsVerticalScrollIndicator = false
        tableView.mj_header = XDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshRequest))
        tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp_bottomMargin)
        }
    }
}

// MARK: - Data(数据处理与加载)
extension MessageHomeController {
    // MARK: - Private  数据处理与加载
    fileprivate func initialDataSource() -> Void {
        let orderItem = UnreadItemModel()
        orderItem.type = .order
        let systemItem = UnreadItemModel()
        systemItem.type = .system
        self.sourceList = [orderItem, systemItem]
        self.tableView.reloadData()
        self.tableView.mj_header?.beginRefreshing()
    }
}

// MARK: - Event(事件响应)
extension MessageHomeController {
    @objc fileprivate func refreshRequest() -> Void {
        MessageNetworkManager.getUnreadMessage { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            self.tableView.mj_header?.endRefreshing()
            guard status, let model = model else {
                return
            }
            self.sourceList = [model.order, model.system]
            self.tableView.reloadData()
        }
    }

}

// MARK: - Notification
extension MessageHomeController {

}

// MARK: - Delegate Function

// MARK: - <UITableViewDataSource>
extension MessageHomeController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageHomeListCell.cellInTableView(tableView)
        cell.model = self.sourceList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

}

// MARK: - <UITableViewDelegate>
extension MessageHomeController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableView.automaticDimension
        return MessageHomeListCell.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.sourceList[indexPath.row]
        model.unreadCount = 0
        self.enterMessageListPage(model.type)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
            self.tableView.reloadData()
        }
    }

}

// MARK: - Extension
extension MessageHomeController {
    fileprivate func enterMessageListPage(_ type: MessageType) -> Void {
        let listVC = MessageListController.init(type: type)
        self.navigationController?.pushViewController(listVC, animated: true)
    }
}
