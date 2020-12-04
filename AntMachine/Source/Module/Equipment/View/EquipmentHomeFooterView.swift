//
//  EquipmentHomeFooterView.swift
//  AntMachine
//
//  Created by 小唐 on 2020/12/3.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  

import UIKit

class EquipmentHomeFooterView: UIView {
    
    // MARK: - Internal Property
    
    var model: String? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    fileprivate let titleLabel: UILabel = UILabel.init()
    fileprivate let leftLine: UIView = UIView.init()
    fileprivate let rightLine: UIView = UIView.init()
    
    fileprivate let lrMargin: CGFloat = 26
    fileprivate let titleLrMargin: CGFloat = 10

    
    
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
extension EquipmentHomeFooterView {

    class func loadXib() -> EquipmentHomeFooterView? {
        return Bundle.main.loadNibNamed("EquipmentHomeFooterView", owner: nil, options: nil)?.first as? EquipmentHomeFooterView
    }

}

// MARK: - LifeCircle/Override Function
extension EquipmentHomeFooterView {

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
extension EquipmentHomeFooterView {
    
    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    /// mainView布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. titleLabel
        mainView.addSubview(self.titleLabel)
        self.titleLabel.set(text: nil, font: UIFont.systemFont(ofSize: 12), textColor: UIColor.init(hex: 0xC7CED8), alignment: .center)
        self.titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        // 2. leftLine
        mainView.addSubview(self.leftLine)
        self.leftLine.backgroundColor = UIColor.init(hex: 0xC7CED8)
        self.leftLine.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalTo(self.titleLabel.snp.leading).offset(-self.titleLrMargin)
            make.height.equalTo(0.5)
            make.centerY.equalToSuperview()
        }
        // 3. rightLine
        mainView.addSubview(self.rightLine)
        self.rightLine.backgroundColor = UIColor.init(hex: 0xC7CED8)
        self.rightLine.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(self.titleLrMargin)
            make.height.equalTo(0.5)
            make.centerY.equalToSuperview()
        }
    }
    
}
// MARK: - UI Xib加载后处理
extension EquipmentHomeFooterView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension EquipmentHomeFooterView {

    ///
    fileprivate func setupAsDemo() -> Void {
        self.titleLabel.text = "没有更多数据"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: String?) -> Void {
        //self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 子控件数据加载
        self.titleLabel.text = model
    }
    
}

// MARK: - Event Function
extension EquipmentHomeFooterView {

    //
    @objc fileprivate func doneBtnClick(_ doneBtn: UIButton) -> Void {
        print("EquipmentHomeFooterView doneBtnClick")
    }

}

// MARK: - Notification Function
extension EquipmentHomeFooterView {
    
}

// MARK: - Extension Function
extension EquipmentHomeFooterView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension EquipmentHomeFooterView {
    
}

