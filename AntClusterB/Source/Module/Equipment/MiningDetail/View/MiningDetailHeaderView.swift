//
//  MiningDetailHeaderView.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/1/12.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  挖矿明细界面头视图

import UIKit

class MiningDetailHeaderView: UIView
{
    
    // MARK: - Internal Property
    
    static let viewHeight: CGFloat = 14 + 125 + 0
    
    var model: EquipmentListModel? {
        didSet {
            self.itemView.model = model
        }
    }
    
    
    // MARK: - Private Property

    fileprivate let mainView: UIView = UIView.init()
    fileprivate let itemView: EquipmentHomeItemView = EquipmentHomeItemView.init()

    fileprivate let lrMargin: CGFloat = 12
    fileprivate let topMargin: CGFloat = 14
    fileprivate let itemHeight: CGFloat = 125
    
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
extension MiningDetailHeaderView {

    class func loadXib() -> MiningDetailHeaderView? {
        return Bundle.main.loadNibNamed("MiningDetailHeaderView", owner: nil, options: nil)?.first as? MiningDetailHeaderView
    }

}

// MARK: - LifeCircle/Override Function
extension MiningDetailHeaderView {

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
extension MiningDetailHeaderView {
    
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
        // itemView
        mainView.addSubview(self.itemView)
        self.itemView.backgroundColor = UIColor.white
        self.itemView.set(cornerRadius: 10)
        self.itemView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalToSuperview().offset(self.topMargin)
            make.height.equalTo(self.itemHeight)
            make.bottom.equalToSuperview()
        }
    }
    
}
// MARK: - UI Xib加载后处理
extension MiningDetailHeaderView {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension MiningDetailHeaderView {

    ///
    fileprivate func setupAsDemo() -> Void {

    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: String?) -> Void {
        //self.setupAsDemo()
        guard let _ = model else {
            return
        }
        // 子控件数据加载
    }
    
}

// MARK: - Event Function
extension MiningDetailHeaderView {

}

// MARK: - Notification Function
extension MiningDetailHeaderView {
    
}

// MARK: - Extension Function
extension MiningDetailHeaderView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension MiningDetailHeaderView {
    
}

