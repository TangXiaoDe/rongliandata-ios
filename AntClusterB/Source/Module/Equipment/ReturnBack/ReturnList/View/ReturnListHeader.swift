//
//  ReturnListHeader.swift
//  SassProject
//
//  Created by 小唐 on 2021/7/27.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  归还明细列表头部视图

import UIKit

protocol ReturnListHeaderProtocol: class {
    
    ///
    func headerView(_ headerView: ReturnListHeader, didClickedStart startView: UIView) -> Void
    ///
    func headerView(_ headerView: ReturnListHeader, didClickedEnd endView: UIView) -> Void
    
}

///
class ReturnListHeader: UIView {
    
    static let viewHeight: CGFloat = 44
    
    // MARK: - Internal Property
    
    var startDate: Date? {
        didSet {
            self.startView.value = startDate?.string(format: "yyyy-MM-dd", timeZone: .current)
        }
    }
    var endDate: Date? {
        didSet {
            self.endView.value = endDate?.string(format: "yyyy-MM-dd", timeZone: .current)
        }
    }

    /// 回调处理
    weak var delegate: ReturnListHeaderProtocol?
    
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView.init()
    
    fileprivate let startView: ReturnListHeaderDayView = ReturnListHeaderDayView.init()   // 开始时间
    fileprivate let endView: ReturnListHeaderDayView = ReturnListHeaderDayView.init()     // 结束时间
    fileprivate let centerLabel: UILabel = UILabel.init()   // 至
    
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let centerLabelWidth: CGFloat = 44
    fileprivate let itemHeight: CGFloat = 32
    
    
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
extension ReturnListHeader {

    class func loadXib() -> ReturnListHeader? {
        return Bundle.main.loadNibNamed("ReturnListHeader", owner: nil, options: nil)?.first as? ReturnListHeader
    }

}

// MARK: - LifeCircle/Override Function
extension ReturnListHeader {

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
extension ReturnListHeader {
    
    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.backgroundColor = UIColor.white
        //
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    /// mainView布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        //let itemWidth: CGFloat = (kScreenWidth - self.lrMargin * 2.0 - self.centerLabelWidth) * 0.5
        //let itemSize: CGSize = CGSize.init(width: itemWidth, height: self.itemHeight)
        // 1. startView
        mainView.addSubview(self.startView)
        self.startView.set(cornerRadius: 5, borderWidth: 0.5, borderColor: AppColor.dividing)
        self.startView.title = "开始:"
        self.startView.addTarget(self, action: #selector(startViewClick(_:)), for: .touchUpInside)
        self.startView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalTo(mainView.snp.centerX).offset(-self.centerLabelWidth * 0.5)
            make.centerY.equalToSuperview()
            make.height.equalTo(self.itemHeight)
        }
        // 2. centerLabel
        mainView.addSubview(self.centerLabel)
        self.centerLabel.set(text: "至", font: UIFont.pingFangSCFont(size: 13), textColor: AppColor.minorText, alignment: .center)
        self.centerLabel.snp.makeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
        }
        // 3. endView
        mainView.addSubview(self.endView)
        self.endView.set(cornerRadius: 5, borderWidth: 0.5, borderColor: AppColor.dividing)
        self.endView.title = "结束:"
        self.endView.addTarget(self, action: #selector(endViewClick(_:)), for: .touchUpInside)
        self.endView.snp.makeConstraints { (make) in
            make.leading.equalTo(mainView.snp.centerX).offset(self.centerLabelWidth * 0.5)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.centerY.equalToSuperview()
            make.height.equalTo(self.itemHeight)
        }
    }
    
}
// MARK: - UI Xib加载后处理
extension ReturnListHeader {

    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension ReturnListHeader {

    ///
    fileprivate func setupAsDemo() -> Void {
        self.startView.value = "2021-02-01"
        self.endView.value = "2021-02-21"
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
extension ReturnListHeader {

    ///
    @objc fileprivate func startViewClick(_ startView: ReturnListHeaderDayView) -> Void {
        print("ReturnListHeader doneBtnClick")
//        guard let model = self.model else {
//            return
//        }
        self.delegate?.headerView(self, didClickedStart: startView)
    }
    ///
    @objc fileprivate func endViewClick(_ endView: ReturnListHeaderDayView) -> Void {
        print("ReturnListHeader doneBtnClick")
//        guard let model = self.model else {
//            return
//        }
        self.delegate?.headerView(self, didClickedEnd: endView)
    }

}

// MARK: - Notification Function
extension ReturnListHeader {
    
}

// MARK: - Extension Function
extension ReturnListHeader {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension ReturnListHeader {
    
}

