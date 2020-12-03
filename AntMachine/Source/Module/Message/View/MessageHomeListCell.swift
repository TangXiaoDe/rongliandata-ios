//
//  MessageHomeListCell.swift
//  CCMall
//
//  Created by 小唐 on 2019/2/22.
//  Copyright © 2019 COMC. All rights reserved.
//
//  消息主页列表的Cell

import UIKit

class MessageHomeListCell: UITableViewCell {

    // MARK: - Internal Property
    static let cellHeight: CGFloat = 72
    /// 重用标识符
    static let identifier: String = "MessageHomeListCellReuseIdentifier"

    var model: UnreadItemModel? {
        didSet {
            self.setupWithModel(model)
        }
    }

    var showBottomLine: Bool = true {
        didSet {
            self.bottomLine.isHidden = !showBottomLine
        }
    }

    // MARK: - fileprivate Property

    fileprivate let mainView = UIView()

    fileprivate let unreadCountLabel: UILabel = UILabel()
    fileprivate let newMessageLabel: UILabel = UILabel()
    fileprivate let titleLabel: UILabel = UILabel()
    fileprivate let iconView: UIImageView = UIImageView()
    fileprivate let bottomLine: UIView = UIView()

    fileprivate let lrMargin: CGFloat = 12
    fileprivate let topMargin: CGFloat = 16
    fileprivate let iconWH: CGFloat = 40
    fileprivate let unreadWH: CGFloat = 15
    fileprivate let titleLeftMargin: CGFloat = 12
    fileprivate let lineLeftMargin: CGFloat = 60

    // MARK: - Initialize Function

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialUI()
    }

}

// MARK: - Internal Function
extension MessageHomeListCell {
    /// 便利构造方法
    class func cellInTableView(_ tableView: UITableView) -> MessageHomeListCell {
        let identifier = MessageHomeListCell.identifier
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if nil == cell {
            cell = MessageHomeListCell.init(style: .default, reuseIdentifier: identifier)
        }
        // 状态重置
        if let cell = cell as? MessageHomeListCell {
            cell.resetSelf()
        }
        return cell as! MessageHomeListCell
    }
}

// MARK: - Override Function
extension MessageHomeListCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - UI 界面布局
extension MessageHomeListCell {
    // 界面布局
    fileprivate func initialUI() -> Void {
        // mainView - 整体布局，便于扩展，特别是针对分割、背景色、四周间距
        self.contentView.addSubview(mainView)
        self.initialMainView(self.mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    // 主视图布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = UIColor.white
        // 1. iconView
        mainView.addSubview(self.iconView)
        self.iconView.set(cornerRadius: 5)
        //self.iconView.contentMode = .center
        self.iconView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.iconWH)
            make.leading.equalToSuperview().offset(lrMargin)
            make.top.equalToSuperview().offset(topMargin)
        }
        // 2. unreadCount
        mainView.addSubview(self.unreadCountLabel)
        self.unreadCountLabel.set(text: nil, font: UIFont.systemFont(ofSize: 10), textColor: UIColor.white, alignment: .center)
        self.unreadCountLabel.backgroundColor = AppColor.themeYellow
        self.unreadCountLabel.set(cornerRadius: self.unreadWH * 0.5)
        self.unreadCountLabel.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.unreadWH)
            make.centerX.equalTo(self.iconView.snp.trailing)
            make.centerY.equalTo(self.iconView.snp.top)
        }
        // 3. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.systemFont(ofSize: 15), textColor: UIColor(hex: 0x333333))
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.iconView.snp.trailing).offset(titleLeftMargin)
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.top.equalTo(self.iconView)
        }
        // 4. newMessage
        mainView.addSubview(self.newMessageLabel)
        self.newMessageLabel.set(text: nil, font: UIFont.systemFont(ofSize: 12), textColor: UIColor(hex: 0x999999))
        self.newMessageLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.titleLabel)
            make.bottom.equalTo(self.iconView)
        }
        // 5. bottomLine
        mainView.addSubview(self.bottomLine)
        self.bottomLine.backgroundColor = AppColor.dividing
        self.bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.leading.equalToSuperview().offset(lineLeftMargin)
            make.trailing.equalToSuperview().offset(-lrMargin)
        }
    }
}

// MARK: - Data 数据加载
extension MessageHomeListCell {
    /// 重置
    fileprivate func resetSelf() -> Void {
        self.selectionStyle = .none
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: UnreadItemModel?) -> Void {
        guard let model = model else {
            return
        }
        // TODO: - 根据type选择image
        switch model.type {
        case .order:
            self.iconView.backgroundColor = AppColor.themeYellow
            self.iconView.image = UIImage.init(named: "IMG_message_dingdan")
            self.titleLabel.text = "订单通知"
        case .system:
            self.iconView.backgroundColor = AppColor.themeYellow
            self.iconView.image = UIImage.init(named: "IMG_message_xitong")
            self.titleLabel.text = "系统通知"
        }
        self.unreadCountLabel.text = "\(model.unreadCount)"
        self.unreadCountLabel.isHidden = model.unreadCount <= 0
        var newMsg: String = model.newest
        if model.newest.isEmpty {
            newMsg = (model.type == .order) ? "暂无通知" : "暂无通知"
        }
        self.newMessageLabel.text = newMsg
    }
}

// MARK: - Event  事件响应
extension MessageHomeListCell {

}
