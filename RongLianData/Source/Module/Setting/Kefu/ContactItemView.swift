//
//  ContactItemView.swift
//  SassProject
//
//  Created by 小唐 on 2020/11/23.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  

import UIKit

///
class ContactItemView: UIView {

    // MARK: - Internal Property

    static let viewHeight: CGFloat = 40

    var model: ContactItemModel? {
        didSet {
            self.setupWithModel(model)
        }
    }


    // MARK: - Private Property

    fileprivate let mainView: UIView = UIView()

    fileprivate let titleLabel: UILabel = UILabel.init()
    fileprivate let accountLabel: UILabel = UILabel.init()
    fileprivate let copyView: TitleIconControl = TitleIconControl.init()

    fileprivate let leftMargin: CGFloat = 20
    fileprivate let rightMargin: CGFloat = 15
    fileprivate let accountLeftMargin: CGFloat = 84


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
extension ContactItemView {
    class func loadXib() -> ContactItemView? {
        return Bundle.main.loadNibNamed("ContactItemView", owner: nil, options: nil)?.first as? ContactItemView
    }
}

// MARK: - LifeCircle Function
extension ContactItemView {
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
extension ContactItemView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    ///
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        let copyIconSize: CGSize = CGSize.init(width: 12, height: 12)
        // 1. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 15), textColor: AppColor.mainText)
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.leftMargin)
            make.centerY.equalToSuperview()
            //make.trailing.lessThanOrEqualTo(mainView.snp.leading).offset(-self.accountLeftMargin)
        }
        // 2. copyView
        mainView.addSubview(self.copyView)
        self.copyView.addTarget(self, action: #selector(copyViewClick(_:)), for: .touchUpInside)
//        self.copyView.set(cornerRadius: 8)
//        self.copyView.backgroundColor = AppColor.pageBg
        self.copyView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.rightMargin)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        self.copyView.titleLabel.set(text: "复制", font: UIFont.pingFangSCFont(size: 15), textColor: UIColor(hex: 0x3FC6DB), alignment: .center)
        self.copyView.titleLabel.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
//        self.copyView.iconView.image = UIImage(named: "IMG_icon_copy")
//        self.copyView.iconView.snp.remakeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        // 3. accountLabel
        mainView.addSubview(self.accountLabel)
        self.accountLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 15, weight: .medium), textColor: AppColor.mainText)
        self.accountLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.accountLeftMargin)
            make.trailing.equalTo(self.copyView.snp.leading).offset(-self.rightMargin)
            make.centerY.equalToSuperview()
        }
    }

}
// MARK: - Private UI Xib加载后处理
extension ContactItemView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }

}

// MARK: - Data Function
extension ContactItemView {
    ///
    fileprivate func setupAsDemo() -> Void {
        self.titleLabel.text = "QQ号"
        self.accountLabel.text = "1234567890"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: ContactItemModel?) -> Void {
        //self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 子控件数据加载
        self.titleLabel.text = model.title + "号:"
        self.accountLabel.text = model.account
    }

}

// MARK: - Event Function
extension ContactItemView {
    /// 复制点击
    @objc fileprivate func copyViewClick(_ copyView: TitleIconControl) -> Void {
        guard let model = self.model else {
            return
        }
        AppUtil.copyToPasteProcess(model.account, indicatorMsg: "账号已复制到粘贴板")
    }

}

// MARK: - Extension Function
extension ContactItemView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension ContactItemView {

}
