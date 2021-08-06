//
//  PRWaitReturnItemView.swift
//  SassProject
//
//  Created by 小唐 on 2021/7/28.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  提前还币主页中待归还类型下的子视图

import UIKit

protocol PRWaitReturnItemViewProtocol: class {
    
    /// 去还款按钮点击回调
    func itemView(_ itemView: PRWaitReturnItemView, didClickedGoReturn returnView: UIButton) -> Void
    
}

///
class PRWaitReturnItemView: UIView {
    
    // MARK: - Internal Property
    
    static let viewHeight: CGFloat = 70
    
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    var value: Double = 0 {
        didSet {
            self.valueLabel.text = value.decimalValidDigitsProcess(digits: 8)
            //self.doneBtn.isEnabled = value > 0
            //self.doneBtn.backgroundColor = self.doneBtn.isEnabled ? AppColor.theme : AppColor.disable
        }
    }

    /// 回调处理
    weak var delegate: PRWaitReturnItemViewProtocol?
    
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    fileprivate let doneBtn: UIButton = UIButton.init(type: .custom)    // 去还款
    fileprivate let titleLabel: UILabel = UILabel.init()    // 标题
    fileprivate let valueLabel: UILabel = UILabel.init()    // 值
    
    fileprivate let rightMargin: CGFloat = 12
    fileprivate let leftMargin: CGFloat = 15
    fileprivate let doneBtnSize: CGSize = CGSize.init(width: 76, height: 28)
    fileprivate let titleCenterYMargin: CGFloat = 13    // super.centery
    fileprivate let valueCenterYMargin: CGFloat = 11    // super.centery
    
    
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
extension PRWaitReturnItemView {

    class func loadXib() -> PRWaitReturnItemView? {
        return Bundle.main.loadNibNamed("PRWaitReturnItemView", owner: nil, options: nil)?.first as? PRWaitReturnItemView
    }

}

// MARK: - LifeCircle/Override Function
extension PRWaitReturnItemView {

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
extension PRWaitReturnItemView {
    
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
        // 1. doneBtn
        mainView.addSubview(self.doneBtn)
        self.doneBtn.set(title: "去还款", titleColor: UIColor.white, for: .normal)
        self.doneBtn.set(title: "去还款", titleColor: UIColor.white, for: .highlighted)
        self.doneBtn.set(title: "去还款", titleColor: UIColor.white, for: .disabled)
        self.doneBtn.set(font: UIFont.systemFont(ofSize: 13), cornerRadius: self.doneBtnSize.height * 0.5)
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.backgroundColor = AppColor.theme
        self.doneBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.rightMargin)
            make.centerY.equalToSuperview()
            make.size.equalTo(self.doneBtnSize)
        }
        // 2. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.systemFont(ofSize: 13), textColor: AppColor.minorText)
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.leftMargin)
            make.trailing.lessThanOrEqualTo(self.doneBtn.snp.trailing)
            make.centerY.equalToSuperview().offset(-self.titleCenterYMargin)
        }
        // 3. valueLabel
        mainView.addSubview(self.valueLabel)
        self.valueLabel.set(text: nil, font: UIFont.systemFont(ofSize: 20, weight: .medium), textColor: AppColor.mainText)
        self.valueLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.leftMargin)
            make.trailing.lessThanOrEqualTo(self.doneBtn.snp.trailing)
            make.centerY.equalToSuperview().offset(self.valueCenterYMargin)
        }
    }
    
}
// MARK: - UI Xib加载后处理
extension PRWaitReturnItemView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension PRWaitReturnItemView {

    ///
    fileprivate func setupAsDemo() -> Void {
        //self.titleLabel.text = "我是标题"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: String?) -> Void {
        self.setupAsDemo()
        guard let _ = model else {
            return
        }
        // 子控件数据加载
    }
    
}

// MARK: - Event Function
extension PRWaitReturnItemView {

    //
    @objc fileprivate func doneBtnClick(_ doneBtn: UIButton) -> Void {
        print("PRWaitReturnItemView doneBtnClick")
        self.delegate?.itemView(self, didClickedGoReturn: doneBtn)
    }

}

// MARK: - Notification Function
extension PRWaitReturnItemView {
    
}

// MARK: - Extension Function
extension PRWaitReturnItemView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension PRWaitReturnItemView {
    
}
