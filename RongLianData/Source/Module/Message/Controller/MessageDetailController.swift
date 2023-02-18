//
//  MessageDetailController.swift
//  OneMateProject
//
//  Created by zhaowei on 2022/5/6.
//  Copyright © 2022 ChainOne. All rights reserved.
//
//  消息详情

import Foundation
import UIKit
import MarkdownView

class MessageDetailController: BaseViewController {
    fileprivate let model: MessageListModel
    fileprivate let scrollView: UIScrollView = UIScrollView()
    fileprivate let titleView: TitleContainer = TitleContainer()
    fileprivate let dateLabel: UILabel = UILabel()
    fileprivate let detailTextView: UITextView = UITextView.init()
    fileprivate let detailWebView: MarkdownView = MarkdownView.init()
    
    fileprivate let mainOurLrMargin: CGFloat = 19
    fileprivate let mainInLrMargin: CGFloat = 12
    fileprivate let detailTopMargin: CGFloat = 12
    
    // MARK: - Initialize Function
    init(model: MessageListModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCircle/Override Function
extension MessageDetailController {
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
// MARK: - UI Function
extension MessageDetailController {
    fileprivate func initialUI() {
        self.title = "消息详情"
        // scrollView
        self.view.backgroundColor = AppColor.pageBg
        self.view.addSubview(self.scrollView)
        self.initialScrollView(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(mainOurLrMargin)
            make.trailing.equalToSuperview().offset(-mainOurLrMargin)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-kBottomHeight - 16)
        }
    }
    fileprivate func initialScrollView(_ scrollView: UIScrollView) {
//        scrollView.backgroundColor = AppColor.white
//        scrollView.set(cornerRadius: 12)
        scrollView.showsVerticalScrollIndicator = false
        // centerView
        scrollView.addSubview(self.titleView)
//        self.titleView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: mainInLrMargin, margin2: mainInLrMargin)
        //
        self.titleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.trailing.equalToSuperview()
            make.width.equalTo(kScreenWidth - 2 * self.mainOurLrMargin)
            //make.height.equalTo(58)
        }
        self.titleView.label.set(text: nil, font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.mainText, alignment: .left)
        self.titleView.label.numberOfLines = 0
        self.titleView.label.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-self.mainInLrMargin)
            make.leading.equalToSuperview().offset(self.mainInLrMargin)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
        //
        let lineView = UIView()
        lineView.backgroundColor = AppColor.theme
        scrollView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(self.titleView)
            make.size.equalTo(CGSize(width: 2, height: 13.5))
        }
        // dateLabel
        scrollView.addSubview(self.dateLabel)
        self.dateLabel.isHidden = true
        self.dateLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 12, weight: .regular), textColor: AppColor.grayText, alignment: .left)
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleView.snp.bottom).offset(0)
            make.leading.equalToSuperview().offset(self.mainInLrMargin)
            make.height.equalTo(0)
        }
        // bottomView
        scrollView.addSubview(self.detailTextView)
        self.detailTextView.font = UIFont.pingFangSCFont(size: 14)
        self.detailTextView.backgroundColor = AppColor.pageBg
        self.detailTextView.textColor = UIColor(hex: 0x666666)
        self.detailTextView.isEditable = false
        self.detailTextView.isScrollEnabled = false
        self.detailTextView.snp.makeConstraints { make in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(self.detailTopMargin)
            make.width.equalTo(scrollView)
            make.trailing.equalToSuperview() // .offset(-self.mainInLrMargin)
            make.leading.equalToSuperview() // .offset(self.mainInLrMargin)
            make.bottom.equalToSuperview()
        }
        scrollView.addSubview(self.detailWebView)
//        self.detailWebView.custom_bgColor = "#" + (AppColor.mainViewBg.hexString() ?? "")
//        self.detailWebView.custom_textColor = "#" + (AppColor.mainText.hexString() ?? "")
        self.detailWebView.isHidden = true
        self.detailWebView.isScrollEnabled = false
        self.detailWebView.onTouchLink = { [weak self] (request) in
            guard let url = request.url, let _ = self else {
                return false
            }
            if url.scheme == "file" {
                return false
            } else if url.scheme == "http" || url.scheme == "https" {
                return false
            } else {
                return false
            }
        }
        self.detailWebView.snp.makeConstraints { make in
            make.width.equalTo(self.scrollView)
            make.trailing.equalToSuperview() // .offset(-self.mainInLrMargin)
            make.leading.equalToSuperview() // .offset(self.mainInLrMargin)
            make.top.equalTo(self.dateLabel.snp.bottom).offset(self.detailTopMargin)
            make.height.equalTo(0)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Data Function
extension MessageDetailController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        self.titleView.label.text = self.model.title
        self.detailTextView.text = self.model.content
        self.dateLabel.text = self.model.createDate.string(format: "yyyy-MM-dd HH:mm", timeZone: TimeZone.current)
        self.setupIsRichText(isRich: model.is_rich)
        if model.is_rich {
            //self.markdownView.custom_bgColor = "#" + (AppColor.mainViewBg.hexString() ?? "")
            self.detailWebView.load(markdown: self.model.content, enableImage: true)
            self.detailWebView.onRendered = { [unowned self] (height) in
                self.detailWebView.snp.updateConstraints({ (make) in
                    make.height.equalTo(height)
                })
                self.view.setNeedsLayout()
            }
        }
    }
    ///
    fileprivate func setupIsRichText(isRich: Bool) -> Void {
        self.detailTextView.isHidden = isRich
        self.detailWebView.isHidden = !isRich
        self.detailTextView.snp.removeConstraints()
        self.detailWebView.snp.removeConstraints()
        if isRich {
            self.detailWebView.snp.remakeConstraints { make in
                make.width.equalTo(self.scrollView)
                make.trailing.equalToSuperview() // .offset(-self.mainInLrMargin)
                make.leading.equalToSuperview() // .offset(self.mainInLrMargin)
                make.top.equalTo(self.dateLabel.snp.bottom).offset(self.detailTopMargin)
                make.height.equalTo(0)
                make.bottom.equalToSuperview()
            }
        } else {
            self.detailTextView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.dateLabel.snp.bottom).offset(self.detailTopMargin)
                make.width.equalTo(self.scrollView)
                make.trailing.equalToSuperview() // .offset(-self.mainInLrMargin)
                make.leading.equalToSuperview() // .offset(self.mainInLrMargin)
                make.bottom.equalToSuperview()
            }
        }
        self.view.layoutIfNeeded()
    }
}

// MARK: - Event Function
extension MessageDetailController {

}

// MARK: - Request Function
extension MessageDetailController {
    
}

// MARK: - Enter Page

// MARK: - Notification
extension MessageDetailController {

}


// MARK: - Extension Function
extension MessageDetailController {
    
}
