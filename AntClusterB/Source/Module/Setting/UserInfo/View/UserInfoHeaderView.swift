//
//  UserInfoHeaderView.swift
//  iMeet
//
//  Created by 小唐 on 2019/7/6.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  个人资料页顶部视图 - 头像修改

import UIKit

protocol UserInfoHeaderViewProtocol: class {
    /// 头像点击
    func headerView(_ headerView: UserInfoHeaderView, didClickedAvatar avatarView: UIButton) -> Void
}
extension UserInfoHeaderViewProtocol {
    func headerView(_ headerView: UserInfoHeaderView, didClickedAvatar avatarView: UIButton) -> Void {}
}

class UserInfoHeaderView: UIView {

    // MARK: - Internal Property

    static let viewHeight: CGFloat = 140

    var model: String? {
        didSet {
            self.setupWithModel(model)
        }
    }

    /// 回调
    weak var delegate: UserInfoHeaderViewProtocol?
    var avatarClickAction: ((_ header: UserInfoHeaderView, _ avatarView: UIButton) -> Void)?


    // MARK: - Private Property

    let mainView: UIView = UIView()
    let titleLabel: UILabel = UILabel()
    let iconView: UIButton = UIButton.init(type: .custom)
    let iconPromptLabel: UILabel = UILabel()
    fileprivate(set) weak var bottomLine: UIView!

    fileprivate let titleLeftMargin: CGFloat = 16
    fileprivate let titleTopMargin: CGFloat = 24
    fileprivate let iconWH: CGFloat = 64
    fileprivate let iconBottomMargin: CGFloat = 25
    fileprivate let iconPromptHeight: CGFloat = 24
    fileprivate let lineLeftMargin: CGFloat = 12


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
extension UserInfoHeaderView {
    class func loadXib() -> UserInfoHeaderView? {
        return Bundle.main.loadNibNamed("UserInfoHeaderView", owner: nil, options: nil)?.first as? UserInfoHeaderView
    }
}

// MARK: - LifeCircle Function
extension UserInfoHeaderView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }

    /// 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()

    }

}
// MARK: - Private UI 手动布局
extension UserInfoHeaderView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: "头像", font: UIFont.pingFangSCFont(size: 16), textColor: UIColor.init(hex: 0x8A98AE))
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.titleLeftMargin)
            make.trailing.lessThanOrEqualToSuperview().offset(-self.titleLeftMargin)
            make.top.equalToSuperview().offset(self.titleTopMargin)
        }
        // 2. iconView
        mainView.addSubview(self.iconView)
        self.iconView.set(font: nil, cornerRadius: self.iconWH * 0.5)
        self.iconView.addTarget(self, action: #selector(iconBtnClick(_:)), for: .touchUpInside)
        self.iconView.setBackgroundImage(AppImage.PlaceHolder.avatar, for: .normal)
        self.iconView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.iconWH)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-self.iconBottomMargin)
        }
        // 3. iconPrompt
        self.iconView.addSubview(self.iconPromptLabel)
        self.iconPromptLabel.set(text: "更换", font: UIFont.pingFangSCFont(size: 12), textColor: UIColor.white, alignment: .center)
        self.iconPromptLabel.backgroundColor = UIColor.init(hex: 0x000000).withAlphaComponent(0.5)
        self.iconPromptLabel.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(self.iconPromptHeight)
        }
        // 4. bottomLine
        self.bottomLine = mainView.addLineWithSide(.inBottom, color: UIColor.init(hex: 0x2D385C), thickness: 0.5, margin1: self.lineLeftMargin, margin2: 0)

    }

}
// MARK: - Private UI Xib加载后处理
extension UserInfoHeaderView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension UserInfoHeaderView {
    /// 数据加载
    fileprivate func setupWithModel(_ model: String?) -> Void {
        guard let _ = model else {
            return
        }
        // 子控件数据加载
    }

}

// MARK: - Event Function
extension UserInfoHeaderView {
    /// 头像点击
    @objc fileprivate func iconBtnClick(_ button: UIButton) -> Void {
        self.delegate?.headerView(self, didClickedAvatar: button)
        self.avatarClickAction?(self, button)
    }

}

// MARK: - Extension Function
extension UserInfoHeaderView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension UserInfoHeaderView {

}
