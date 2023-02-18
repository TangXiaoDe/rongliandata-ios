//
//  MessageSystemTabCell.swift
//  HuoTuiVideo
//
//  Created by zhaowei on 2020/6/5.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  系统消息cell

import UIKit

protocol MessageSystemTabCellDelegate: AnyObject {
    func messageSystemTabCell(_ cell: MessageSystemTabCell, didClickedDelete model: MessageListModel)
}

class MessageSystemTabCell: UITableViewCell {

    // MARK: - Internal Property
    static let cellHeight: CGFloat = 75
    /// 重用标识符
    static let identifier: String = "MessageSystemTabCellReuseIdentifier"

    weak var delegate: MessageSystemTabCellDelegate?
    var model: MessageListModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    fileprivate var isShowDelete: Bool = false
//    var type: MessageType = .system {
//        didSet {
//            self.messageTopTypeLabel.text = type.title
//        }
//    }
    // MARK: - fileprivate Property

    fileprivate let mainView = UIView()

    fileprivate let dateLabel: UILabel = UILabel()

    fileprivate let messageView: UIView = UIView()
    fileprivate let messageTopView: UIView = UIView()
    fileprivate let typeIcon: UIImageView = UIImageView()
//    fileprivate let messageTopTypeLabel: UILabel = UILabel()
    fileprivate let moreControl: TitleIconControl = TitleIconControl()
    fileprivate let titleLabel: UILabel = UILabel()
//    fileprivate let contentLabel: UILabel = UILabel()
    fileprivate let deleteBtn: UIButton = UIButton()

    fileprivate let dateViewTopMargin: CGFloat = 16
    fileprivate let dateLrMargin: CGFloat = 20

    fileprivate let messageViewLrMargin: CGFloat = 16.5
    fileprivate let messageViewTopMargin: CGFloat = 10
    fileprivate let messageViewBottomMargin: CGFloat = 0
    fileprivate let messageViewOffset: CGFloat = 60
    fileprivate let messageTopViewHeight: CGFloat = 62

    fileprivate let messageLrMargin: CGFloat = 12
    fileprivate let titleTopMargin: CGFloat = 23
    fileprivate let messageTopMargin: CGFloat = 5
    fileprivate let messageBottomMargin: CGFloat = 18

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
extension MessageSystemTabCell {
    /// 便利构造方法
    class func cellInTableView(_ tableView: UITableView) -> MessageSystemTabCell {
        let identifier = MessageSystemTabCell.identifier
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if nil == cell {
            cell = MessageSystemTabCell.init(style: .default, reuseIdentifier: identifier)
        }
        // 状态重置
        if let cell = cell as? MessageSystemTabCell {
            cell.resetSelf()
        }
        return cell as! MessageSystemTabCell
    }
}

// MARK: - Override Function
extension MessageSystemTabCell {
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
extension MessageSystemTabCell {
    // 界面布局
    fileprivate func initialUI() -> Void {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        // mainView - 整体布局，便于扩展，特别是针对分割、背景色、四周间距
        self.contentView.addSubview(mainView)
        self.initialMainView(self.mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }
    }
    // 主视图布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = .white
        mainView.set(cornerRadius: 4)
        //
        mainView.addSubview(self.typeIcon)
        self.typeIcon.image = UIImage(named: "IMG_mine_icon_news")
        self.typeIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(self.messageLrMargin)
            make.size.equalTo(CGSize.init(width: 34, height: 34))
            make.top.equalToSuperview().offset(9)
        }
        //
        let titleLabel = UILabel()
        titleLabel.set(text: "系统消息", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.mainText)
        mainView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.typeIcon.snp.trailing).offset(9)
            make.centerY.equalTo(self.typeIcon)
        }
        // 1. dateView
        mainView.addSubview(self.dateLabel)
        self.dateLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: AppColor.minorText, alignment: .center)
        self.dateLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalTo(self.typeIcon)
        }
        // 2. messageView
        mainView.addSubview(self.messageView)
//        self.messageView.backgroundColor = .white
        self.initialMessageView(self.messageView)
        self.messageView.set(cornerRadius: 10)
        self.messageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.typeIcon.snp.bottom).offset(messageViewTopMargin)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-messageViewBottomMargin)
        }
        // 滑动手势
//        let swipeRight = UISwipeGestureRecognizer.init(target: self, action: #selector(messageViewSwipe(_:)))
//        self.messageView.addGestureRecognizer(swipeRight)
//        let swipeLeft = UISwipeGestureRecognizer.init(target: self, action: #selector(messageViewSwipe(_:)))
//        swipeLeft.direction = .left
//        self.messageView.addGestureRecognizer(swipeLeft)
        // deleteBtn
//        mainView.insertSubview(self.deleteBtn, belowSubview: self.messageView)
//        self.deleteBtn.setImage(UIImage(named: "IMG_message_icon_shanchu"), for: .normal)
//        self.deleteBtn.addTarget(self, action: #selector(deleteBtnOnClicked(_:)), for: .touchUpInside)
//        self.deleteBtn.snp.makeConstraints { make in
//            make.centerY.equalTo(self.messageView)
//            make.trailing.equalToSuperview().offset(-20)
//        }
    }
    fileprivate func initialMessageView(_ messageView: UIView) -> Void {
        messageView.addSubview(self.messageTopView)
        self.initialMessageTopView(self.messageTopView)
        self.messageTopView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.messageTopViewHeight)
        }
        //
        messageView.addSubview(self.moreControl)
        self.moreControl.isUserInteractionEnabled = false
        self.moreControl.titleLabel.set(text: "查看详情", font: UIFont.pingFangSCFont(size: 14, weight: .regular), textColor: UIColor(hex: 0x666666), alignment: .left)
        self.moreControl.iconView.image = UIImage.init(named: "IMG_equip_next_black")
        self.moreControl.snp.makeConstraints { (make) in
            make.top.equalTo(self.messageTopView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        self.moreControl.titleLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(self.messageLrMargin)
            make.centerY.equalToSuperview()
        }
        self.moreControl.iconView.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
//        // 2. textView
//        messageView.addSubview(self.contentLabel)
//        self.contentLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14, weight: .regular), textColor: AppColor.grayText)
//        self.contentLabel.numberOfLines = 2
//        self.contentLabel.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview().offset(messageLrMargin)
//            make.trailing.equalToSuperview().offset(-messageLrMargin)
//            make.top.equalTo(self.titleLabel.snp.bottom).offset(messageTopMargin)
//            make.bottom.equalToSuperview().offset(-messageBottomMargin)
//        }
    }
    fileprivate func initialMessageTopView(_ messageTopView: UIView) -> Void {
//        messageTopView.addSubview(self.messageTopTypeLabel)
//        self.messageTopTypeLabel.set(text: "系统公告", font: UIFont.pingFangSCFont(size: 15, weight: .regular), textColor: AppColor.mainText)
//        self.messageTopTypeLabel.snp.makeConstraints { make in
//            make.leading.equalTo(self.typeIcon.snp.trailing).offset(9)
//            make.centerY.equalToSuperview()
//        }
        // 1. titleLabel
        messageTopView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .regular), textColor: AppColor.grayText)
        self.titleLabel.numberOfLines = 2
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(messageLrMargin)
            make.trailing.equalToSuperview().offset(-messageLrMargin)
            make.centerY.equalToSuperview()
        }
        messageTopView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: 12, margin2: 12)
    }
    
}

// MARK: - Data 数据加载
extension MessageSystemTabCell {
    /// 重置
    fileprivate func resetSelf() -> Void {
        self.selectionStyle = .none
        self.dateLabel.text = nil
        self.titleLabel.text = nil
//        self.contentLabel.text = nil
    }
    
    fileprivate func setupAsDemo() {
        self.dateLabel.text = "2023.03.11"
        self.titleLabel.text = "model.title"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: MessageListModel?) -> Void {
        self.setupAsDemo()
        guard let model = model else {
            return
        }
        self.dateLabel.text = model.createDate.string(format: "yyyy-MM-dd HH:mm", timeZone: TimeZone.current)
        self.titleLabel.text = model.title
//        self.contentLabel.text = model.intro

        self.deleteBtn.isHidden = !self.isShowDelete
        self.messageView.snp.remakeConstraints { make in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(self.messageViewTopMargin)
            make.leading.equalTo(self.typeIcon.snp.trailing).offset(self.isShowDelete ? -self.messageViewOffset : self.messageLrMargin)
            make.trailing.equalToSuperview().offset(self.isShowDelete ? (-self.messageViewLrMargin - self.messageViewOffset) : -self.messageViewLrMargin)
            make.bottom.equalToSuperview().offset(-self.messageViewBottomMargin)
        }
    }
}

// MARK: - Event  事件响应
extension MessageSystemTabCell {
    @objc fileprivate func deleteBtnOnClicked(_ btn: UIButton) {
        guard let model = self.model else {
            return
        }
        self.delegate?.messageSystemTabCell(self, didClickedDelete: model)
    }
    @objc fileprivate func messageViewSwipe(_ swipe: UISwipeGestureRecognizer) {
        guard let model = self.model else {
            return
        }
        if swipe.direction == .left {
            self.isShowDelete = true
            self.deleteBtn.isHidden = false
            self.messageView.snp.remakeConstraints { make in
                make.top.equalTo(self.dateLabel.snp.bottom).offset(self.messageViewTopMargin)
                make.leading.equalTo(self.typeIcon.snp.trailing).offset(self.messageLrMargin)
                make.trailing.equalToSuperview().offset(-self.messageViewLrMargin - self.messageViewOffset)
                make.bottom.equalToSuperview().offset(-self.messageViewBottomMargin)
            }
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        } else if swipe.direction == .right {
            self.isShowDelete = false
            self.deleteBtn.isHidden = true
            self.messageView.snp.remakeConstraints { make in
                make.top.equalTo(self.dateLabel.snp.bottom).offset(self.messageViewTopMargin)
                make.leading.equalTo(self.typeIcon.snp.trailing).offset(self.messageLrMargin)
                make.trailing.equalToSuperview().offset(-self.messageViewLrMargin)
                make.bottom.equalToSuperview().offset(-self.messageViewBottomMargin)
            }
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }
}
