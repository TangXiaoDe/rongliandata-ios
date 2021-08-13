//
//  ReturnListHeaderDayView.swift
//  SassProject
//
//  Created by 小唐 on 2021/7/27.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  日期选择响应控件

import UIKit

class ReturnListHeaderDayView: UIControl {
    
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
    
    
    // MARK: - Private Property
    
    fileprivate let titleLabel: UILabel = UILabel.init()    // 标题：开始/结束
    fileprivate let valueLabel: UILabel = UILabel.init()    // 值：具体日期
    fileprivate let updownView: UIImageView = UIImageView.init()    // 上下图标
    
    fileprivate let lrMargin: CGFloat = 8
    fileprivate let updownIconSize: CGSize = CGSize.init(width: 8, height: 12)
    fileprivate let valueTitleHorMargin: CGFloat = 8
    
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
extension ReturnListHeaderDayView {

    class func loadXib() -> ReturnListHeaderDayView? {
        return Bundle.main.loadNibNamed("ReturnListHeaderDayView", owner: nil, options: nil)?.first as? ReturnListHeaderDayView
    }

}

// MARK: - LifeCircle/Override Function
extension ReturnListHeaderDayView {

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
extension ReturnListHeaderDayView {
    
    /// 界面布局
    fileprivate func initialUI() -> Void {
        
        // 1. titleLabel
        self.addSubview(self.titleLabel)
        self.titleLabel.set(text: "", font: UIFont.pingFangSCFont(size: 13), textColor: AppColor.minorText)
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.centerY.equalToSuperview()
        }
        // 2. valueLabel
        self.addSubview(self.valueLabel)
        self.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 13), textColor: AppColor.grayText, alignment: .center)
        self.valueLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(self.valueTitleHorMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin - self.updownIconSize.width - 2)
            make.centerY.equalToSuperview()
        }
        // 3. updownView
        self.addSubview(self.updownView)
        self.updownView.set(cornerRadius: 0)
        self.updownView.image = UIImage.init(named: "")
        self.updownView.backgroundColor = UIColor.random
        self.updownView.snp.makeConstraints { (make) in
            make.size.equalTo(self.updownIconSize)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-self.lrMargin)
        }
    }
    
}
// MARK: - UI Xib加载后处理
extension ReturnListHeaderDayView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension ReturnListHeaderDayView {

    ///
    fileprivate func setupAsDemo() -> Void {
        self.titleLabel.text = "开始:"
        self.valueLabel.text = "2021-02-01"
        self.updownView.backgroundColor = UIColor.red
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
extension ReturnListHeaderDayView {


}

// MARK: - Notification Function
extension ReturnListHeaderDayView {
    
}

// MARK: - Extension Function
extension ReturnListHeaderDayView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension ReturnListHeaderDayView {
    
}

