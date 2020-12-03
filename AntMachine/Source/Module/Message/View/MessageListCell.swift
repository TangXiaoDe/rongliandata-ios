//
//  MessageListCell.swift
//  CCMall
//
//  Created by 小唐 on 2019/2/22.
//  Copyright © 2019 COMC. All rights reserved.
//
//  消息列表的Cell

import UIKit

class MessageListCell: UITableViewCell {

    // MARK: - Internal Property
    static let cellHeight: CGFloat = 75
    /// 重用标识符
    static let identifier: String = "MessageListCellReuseIdentifier"

    var model: MessageListModel? {
        didSet {
            self.setupWithModel(model)
        }
    }

    // MARK: - fileprivate Property

    fileprivate let mainView = UIView()

    fileprivate let dateView: UIView = UIView()
    fileprivate let dateLabel: UILabel = UILabel()

    fileprivate let messageView: UIView = UIView()
    fileprivate let titleLabel: UILabel = UILabel()
    fileprivate let messageLabel: UILabel = UILabel()

    fileprivate let dateViewH: CGFloat = 15
    fileprivate let dateViewTopMargin: CGFloat = 13
    fileprivate let dateLrMargin: CGFloat = 7

    fileprivate let messageViewLrMargin: CGFloat = 12
    fileprivate let messageViewTopMargin: CGFloat = 12
    fileprivate let messageViewBottomMargin: CGFloat = 0

    fileprivate let messageLrMargin: CGFloat =  12
    fileprivate let titleTopMargin: CGFloat = 12
    fileprivate let messageTopMargin: CGFloat = 13
    fileprivate let messageBottomMargin: CGFloat = 11

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
extension MessageListCell {
    /// 便利构造方法
    class func cellInTableView(_ tableView: UITableView) -> MessageListCell {
        let identifier = MessageListCell.identifier
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if nil == cell {
            cell = MessageListCell.init(style: .default, reuseIdentifier: identifier)
        }
        // 状态重置
        if let cell = cell as? MessageListCell {
            cell.resetSelf()
        }
        return cell as! MessageListCell
    }
}

// MARK: - Override Function
extension MessageListCell {
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
extension MessageListCell {
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
        mainView.backgroundColor = UIColor.init(hex: 0xf6f6f6)
        // 1. dateView
        mainView.addSubview(self.dateView)
        self.dateView.backgroundColor = UIColor.init(hex: 0xe2e2e2)
        self.dateView.set(cornerRadius: self.dateViewH * 0.5)
        self.dateView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(self.dateViewH)
            make.top.equalToSuperview().offset(dateViewTopMargin)
        }
        self.dateView.addSubview(self.dateLabel)
        self.dateLabel.set(text: nil, font: UIFont.systemFont(ofSize: 10), textColor: UIColor.white, alignment: .center)
        self.dateLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(dateLrMargin)
            make.trailing.equalToSuperview().offset(-dateLrMargin)
        }
        // 2. messageView
        mainView.addSubview(self.messageView)
        self.messageView.backgroundColor = UIColor.white
        self.initialMessageView(self.messageView)
        self.messageView.set(cornerRadius: 10)
        self.messageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.dateView.snp.bottom).offset(messageViewTopMargin)
            make.leading.equalToSuperview().offset(messageViewLrMargin)
            make.trailing.equalToSuperview().offset(-messageViewLrMargin)
            make.bottom.equalToSuperview().offset(-messageViewBottomMargin)
        }
    }
    fileprivate func initialMessageView(_ messageView: UIView) -> Void {
        // 1. titleLabel
        messageView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.systemFont(ofSize: 15), textColor: UIColor.init(hex: 0x333333))
        self.titleLabel.numberOfLines = 0
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(messageLrMargin)
            make.trailing.equalToSuperview().offset(-messageLrMargin)
            make.top.equalToSuperview().offset(titleTopMargin)
        }
        // 2. messageLabel
        messageView.addSubview(self.messageLabel)
        self.messageLabel.set(text: nil, font: UIFont.systemFont(ofSize: 12), textColor: UIColor(hex: 0x999999))
        self.messageLabel.numberOfLines = 0
        self.messageLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(messageLrMargin)
            make.trailing.equalToSuperview().offset(-messageLrMargin)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(messageTopMargin)
            make.bottom.equalToSuperview().offset(-messageBottomMargin)
        }
    }
}

// MARK: - Data 数据加载
extension MessageListCell {
    /// 重置
    fileprivate func resetSelf() -> Void {
        self.selectionStyle = .none
        self.dateLabel.text = nil
        self.titleLabel.text = nil
        self.messageLabel.text = nil
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: MessageListModel?) -> Void {
        guard let model = model else {
            return
        }
        self.dateLabel.text = model.createDate.string(format: "yyyy年 MM月dd日 HH:mm", timeZone: TimeZone.current)
        self.titleLabel.text = model.title
        self.messageLabel.text = model.content
    }
}

// MARK: - Event  事件响应
extension MessageListCell {

}
