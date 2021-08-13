//
//  ReturnListTipsPopVew.swift
//  SassProject
//
//  Created by 小唐 on 2021/7/27.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  归还流水说明弹窗

import UIKit

@objc protocol ReturnListTipsPopVewProtocol: class {
    func popView(_ popView: ReturnListTipsPopVew, didClickedCover cover: UIButton) -> Void
}
extension ReturnListTipsPopVewProtocol {
    func popView(_ popView: ReturnListTipsPopVew, didClickedCover cover: UIButton) -> Void {}
}

class ReturnListTipsPopVew: UIView {

    // MARK: - Internal Property

    var content: String? {
        didSet {
            self.contentLabel.text = content
        }
    }
    
    ///
    weak var delegate: ReturnListTipsPopVewProtocol?

    // MARK: - Private Property

    fileprivate let coverBtn: UIButton = UIButton.init(type: .custom)
    fileprivate let mainView: UIView = UIView()
    
    fileprivate let titleLabel: UILabel = UILabel()
    fileprivate let doneBtn: UIButton = UIButton.init(type: .custom)
    
    fileprivate let scrollView: UIScrollView = UIScrollView.init()
    fileprivate let contentContainer: UIView = UIView.init()
    fileprivate let contentLabel: UILabel = UILabel.init()
    

    fileprivate let mainOutLrMargin: CGFloat = 45
    fileprivate let mainInLrMargin: CGFloat = 15
    fileprivate let titleTopMargin: CGFloat = 22
    fileprivate let doneBtnSize: CGSize = CGSize.init(width: 76, height: 28)
    fileprivate let doneBtnBottomMargin: CGFloat = 24
    
    fileprivate let contentMaxHeight: CGFloat = 200
    fileprivate let contentLrMargin: CGFloat = 15
    fileprivate let contentTopMargin: CGFloat = 15
    fileprivate let contentBottomMargin: CGFloat = 24

    
    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        //fatalError("init(coder:) has not been implemented")
    }

    /// 通用初始化：UI、配置、数据等
    func commonInit() -> Void {
        self.initialUI()
    }

}

// MARK: - Internal Function
extension ReturnListTipsPopVew {

}

// MARK: - LifeCircle Function
extension ReturnListTipsPopVew {

}
// MARK: - Private UI 手动布局
extension ReturnListTipsPopVew {

    /// 界面布局 - 子类可重写
    fileprivate func initialUI() -> Void {
        // 1. coverBtn
        self.addSubview(self.coverBtn)
        self.coverBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.coverBtn.addTarget(self, action: #selector(coverBtnClick(_:)), for: .touchUpInside)
        self.coverBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 2. mainView
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.mainOutLrMargin)
            make.trailing.equalToSuperview().offset(-self.mainOutLrMargin)
            make.center.equalToSuperview()
        }
    }
    /// mainView布局 - 子类可重写
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = UIColor.white
        mainView.set(cornerRadius: 10)
        // 1. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: "说明", font: UIFont.pingFangSCFont(size: 18, weight: .medium), textColor: AppColor.mainText, alignment: .center)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(self.titleTopMargin)
        }
        // 2. doneBtn
        mainView.addSubview(self.doneBtn)
        self.doneBtn.set(title: "关闭", titleColor: AppColor.theme, for: .normal)
        self.doneBtn.set(title: "关闭", titleColor: AppColor.theme, for: .highlighted)
        self.doneBtn.set(font: UIFont.systemFont(ofSize: 13), cornerRadius: self.doneBtnSize.height * 0.5)
        self.doneBtn.backgroundColor = AppColor.theme.withAlphaComponent(0.1)
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(self.doneBtnSize)
            make.bottom.equalToSuperview().offset(-self.doneBtnBottomMargin)
        }
        // 3. content
        mainView.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.contentLrMargin)
            make.trailing.equalToSuperview().offset(-self.contentLrMargin)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(self.contentTopMargin)
            make.bottom.equalTo(self.doneBtn.snp.top).offset(-self.contentBottomMargin)
            make.height.equalTo(self.contentMaxHeight)
        }
        self.scrollView.addSubview(self.contentContainer)
        self.contentContainer.snp.makeConstraints { (make) in
            make.leading.trailing.width.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        self.contentContainer.addSubview(self.contentLabel)
        self.contentLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 14), textColor: AppColor.minorText)
        self.contentLabel.numberOfLines = 0
        self.contentLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}
// MARK: - Private UI Xib加载后处理
extension ReturnListTipsPopVew {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension ReturnListTipsPopVew {

}

// MARK: - Event Function
extension ReturnListTipsPopVew {
    
    /// 遮罩点击
    @objc fileprivate  func coverBtnClick(_ button: UIButton) -> Void {
        self.delegate?.popView(self, didClickedCover: button)
        self.removeFromSuperview()
    }
    /// 确定按钮点击
    @objc fileprivate func doneBtnClick(_ button: UIButton) -> Void {
        self.removeFromSuperview()
    }

}

// MARK: - Extension Function
extension ReturnListTipsPopVew {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension ReturnListTipsPopVew {

}
