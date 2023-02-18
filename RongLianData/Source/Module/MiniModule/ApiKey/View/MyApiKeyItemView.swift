//
//  MyApiKeyItemView.swift
//  RongLianData
//
//  Created by 小唐 on 2021/9/23.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  MyApiKeyItemView

import UIKit

protocol MyApiKeyItemViewProtocol: class {
    
    /// 复制按钮点击回调
    func itemView(_ itemView: MyApiKeyItemView, didClickedCopy copyView: UIView) -> Void
    
}

///
class MyApiKeyItemView: UIView {
    
    // MARK: - Internal Property
    
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    var value: String? {
        didSet {
            self.valueLabel.text = value
        }
    }

    /// 回调处理
    weak var delegate: MyApiKeyItemViewProtocol?
    var copyClickAction: ((_ itemView: MyApiKeyItemView, _ copyView: UIView) -> Void)?
    
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    fileprivate let titleLabel: UILabel = UILabel.init()
    fileprivate let valueLabel: UILabel = UILabel.init()
    fileprivate let copyView: TitleIconControl = TitleIconControl.init()
    
    fileprivate let lrMargin: CGFloat = 20
    fileprivate let titleTopMargin: CGFloat = 0
    fileprivate let valueTopMargin: CGFloat = 12    // title.bottom
    fileprivate let valueBottomMargin: CGFloat = 0
    fileprivate let copyIconWH: CGFloat = 12
    fileprivate let valueCopyHorMargin: CGFloat = 20
    
    
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
extension MyApiKeyItemView {

    class func loadXib() -> MyApiKeyItemView? {
        return Bundle.main.loadNibNamed("MyApiKeyItemView", owner: nil, options: nil)?.first as? MyApiKeyItemView
    }

}

// MARK: - LifeCircle/Override Function
extension MyApiKeyItemView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
    
    /// 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
// MARK: - UI Function
extension MyApiKeyItemView {
    
    /// 界面布局
    fileprivate func initialUI() -> Void {
        //
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    /// mainView布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        let copyIconTitleMargin: CGFloat = 5
        let copyTitleW: CGFloat = "复制".size(maxSize: CGSize.max, font: UIFont.pingFangSCFont(size: 12, weight: .medium)).width + 2
        let valueRightMinMargin: CGFloat = self.lrMargin + copyTitleW + copyIconTitleMargin + self.copyIconWH + 20
        // 1. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 15, weight: .medium), textColor: AppColor.subMainText)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.titleTopMargin)
            make.leading.equalToSuperview().offset(self.lrMargin)
        }
        // 2. valueLabel
        mainView.addSubview(self.valueLabel)
        self.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 15, weight: .medium), textColor: AppColor.grayText)
        self.valueLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(self.valueTopMargin)
            make.bottom.equalToSuperview().offset(-self.valueBottomMargin)
            make.trailing.lessThanOrEqualToSuperview().offset(-valueRightMinMargin)
        }
        // 3. copyView
        mainView.addSubview(self.copyView)
        self.copyView.addTarget(self, action: #selector(copyViewClick(_:)), for: .touchUpInside)
        self.copyView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.centerY.equalTo(self.valueLabel)
        }
        self.copyView.titleLabel.set(text: "复制", font: UIFont.pingFangSCFont(size: 12, weight: .medium), textColor: UIColor.init(hex: 0xEBB844), alignment: .right)
        self.copyView.titleLabel.snp.remakeConstraints { (make) in
            make.trailing.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        self.copyView.iconView.set(cornerRadius: 0)
        self.copyView.iconView.image = UIImage.init(named: "IMG_icon_tc_copy")
        self.copyView.iconView.snp.remakeConstraints { (make) in
            make.width.height.equalTo(self.copyIconWH)
            make.leading.centerY.equalToSuperview()
            make.trailing.equalTo(self.copyView.titleLabel.snp.leading).offset(-5)
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
}
// MARK: - UI Xib加载后处理
extension MyApiKeyItemView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension MyApiKeyItemView {

    ///
    fileprivate func setupAsDemo() -> Void {
        self.titleLabel.text = "我是标题"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: String?) -> Void {
//        self.setupAsDemo()
        guard let _ = model else {
            return
        }
        // 子控件数据加载
    }
    
}

// MARK: - Event Function
extension MyApiKeyItemView {

    //
    @objc fileprivate func copyViewClick(_ copyView: TitleIconControl) -> Void {
//        print("MyApiKeyItemView doneBtnClick")
//        guard let _ = self.title, let _ = self.value  else {
//            return
//        }
        self.delegate?.itemView(self, didClickedCopy: copyView)
        self.copyClickAction?(self, copyView)
    }

}

// MARK: - Notification Function
extension MyApiKeyItemView {
    
}

// MARK: - Extension Function
extension MyApiKeyItemView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension MyApiKeyItemView {
    
}

