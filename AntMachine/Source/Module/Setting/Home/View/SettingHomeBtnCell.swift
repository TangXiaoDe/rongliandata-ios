//
//  SettingHomeBtnCell.swift
//  CCMall
//
//  Created by 小唐 on 2019/3/14.
//  Copyright © 2019 COMC. All rights reserved.
//
//  设置主页按钮类Cell，如退出登录Cell

import UIKit

protocol SettingHomeBtnCellProtocol: class {
    /// 按钮点击响应回调
    func btnCell(_ cell: SettingHomeBtnCell, didClickedBtn btn: UIButton) -> Void
}

class SettingHomeBtnCell: UITableViewCell
{
    
    // MARK: - Internal Property
    static let cellHeight: CGFloat = 44
    /// 重用标识符
    static let identifier: String = "SettingHomeBtnCellReuseIdentifier"
    
    var model: SettingItemModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    var showBottomLine: Bool = true {
        didSet {
            self.bottomLine.isHidden = !showBottomLine
        }
    }
    
    /// 回调
    weak var delegate: SettingHomeBtnCellProtocol?
    var btnClickAction: ((_ cell: SettingHomeBtnCell, _ btn: UIButton) -> Void)?
    
    // MARK: - fileprivate Property
    
    fileprivate let mainView = UIView()
    fileprivate let button: UIButton = UIButton.init(type: .custom)
    fileprivate weak var bottomLine: UIView!
    
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let btnH: CGFloat = 44
    
    // MARK: - Initialize Function
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialUI()
    }
    
    
}

// MARK: - Internal Function
extension SettingHomeBtnCell {
    /// 便利构造方法
    class func cellInTableView(_ tableView: UITableView) -> SettingHomeBtnCell {
        let identifier = SettingHomeBtnCell.identifier
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if nil == cell {
            cell = SettingHomeBtnCell.init(style: .default, reuseIdentifier: identifier)
        }
        // 状态重置
        if let cell = cell as? SettingHomeBtnCell {
            cell.resetSelf()
        }
        return cell as! SettingHomeBtnCell
    }
}

// MARK: - Override Function
extension SettingHomeBtnCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

// MARK: - UI 界面布局
extension SettingHomeBtnCell {
    // 界面布局
    fileprivate func initialUI() -> Void {
        // mainView - 整体布局，便于扩展，特别是针对分割、背景色、四周间距
        self.contentView.addSubview(mainView)
        self.initialMainView(self.mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    // 主视图布局
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = UIColor.white
        // button
        mainView.addSubview(self.button)
        self.button.backgroundColor = AppColor.theme
        self.button.set(font: UIFont.pingFangSCFont(size: 18), cornerRadius: 5, borderWidth: 0, borderColor: .clear)
        self.button.setTitleColor(AppColor.title, for: .normal)
        self.button.setTitleColor(AppColor.title, for: .highlighted)
        self.button.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        self.button.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(self.btnH)
            make.leading.equalToSuperview().offset(lrMargin)
            make.trailing.equalToSuperview().offset(-lrMargin)
        }
        // bottomline
        self.bottomLine = mainView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: lrMargin, margin2: lrMargin)
    }
}

// MARK: - Data 数据加载
extension SettingHomeBtnCell {
    /// 重置
    fileprivate func resetSelf() -> Void {
        self.selectionStyle = .none
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: SettingItemModel?) -> Void {
        guard let model = model else {
            return
        }
        self.button.setTitle(model.title, for: .normal)
        self.button.setTitle(model.title, for: .highlighted)
    }
}

// MARK: - Event  事件响应
extension SettingHomeBtnCell {
    /// 按钮点击
    @objc fileprivate func btnClick(_ button: UIButton) -> Void {
        self.delegate?.btnCell(self, didClickedBtn: button)
        self.btnClickAction?(self, button)
    }
}

