//
//  CommonKeyboardInputAccessoryView.swift
//  OneMateProject
//
//  Created by 小唐 on 2022/2/28.
//  Copyright © 2022 ChainOne. All rights reserved.
//
//  通用的键盘输入辅助视图

import UIKit
import ChainOneKit

protocol CommonKeyboardInputAccessoryViewProtocol: class {
    
    /// 图片按钮点击回调
    func accessoryView(_ accessoryView: CommonKeyboardInputAccessoryView, didClickedPic picBtn: UIButton) -> Void
    /// 关闭键盘按钮点击回调
    func accessoryView(_ accessoryView: CommonKeyboardInputAccessoryView, didClickedDone doneBtn: UIButton) -> Void
    
}
extension CommonKeyboardInputAccessoryViewProtocol {
    
    /// 
    func accessoryView(_ accessoryView: CommonKeyboardInputAccessoryView, didClickedPic picBtn: UIButton) -> Void {}
    
}

class CommonKeyboardInputAccessoryView: UIView {

    // MARK: - Internal Property
    
    static let viewHeight: CGFloat = 50
    
    // 回调处理
    weak var delegate: CommonKeyboardInputAccessoryViewProtocol?
    var picBtnClickAction: ((_ accessoryView: CommonKeyboardInputAccessoryView, _ picBtn: UIButton) -> Void)?
    var doneBtnClickAction: ((_ accessoryView: CommonKeyboardInputAccessoryView, _ doneBtn: UIButton) -> Void)?
    
    
    ///
    var showPicBtn: Bool = false {
        didSet {
            self.picBtn.isHidden = !showPicBtn
        }
    }
    
    // MARK: - Private Property
    
    let picBtn: UIButton  = UIButton(type: .custom)
    let doneBtn: UIButton = UIButton(type: .custom)
    
    let defaultH: CGFloat = 40

    // MARK: - Internal Function

    // MARK: - Initialize Function
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialUI()
    }
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: defaultH))
        self.initialUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.bounds = CGRect(x: 0, y: 0, width: kScreenWidth, height: defaultH)
        self.initialUI()
    }

    // MARK: - Private  UI

    // 界面布局
    private func initialUI() -> Void {
        self.backgroundColor = UIColor.white
        let lrMargin: Float = 15
        let picSize: CGSize = CGSize.init(width: 30, height: 25)
        // 1. left picBtn
        self.addSubview(self.picBtn)
        self.picBtn.setImage(UIImage(named: "IMG_icon_picture_grey"), for: .normal)
        self.picBtn.setImage(UIImage(named: "IMG_icon_picture_grey"), for: .highlighted)
        self.picBtn.addTarget(self, action: #selector(picBtnClick(_:)), for: .touchUpInside)
        self.picBtn.clipsToBounds = true
        self.picBtn.isHidden = true  // 默认隐藏
        self.picBtn.snp.makeConstraints { (make) in
            make.size.equalTo(picSize)
            make.leading.equalToSuperview().offset(lrMargin)
            make.centerY.equalTo(self)
        }
        // 2. right doneBtn
        self.addSubview(self.doneBtn)
        self.doneBtn.set(title: "common.done".localized, titleColor: AppColor.theme, for: .normal)
        self.doneBtn.set(title: "common.done".localized, titleColor: AppColor.theme, for: .highlighted)
        self.doneBtn.set(font: UIFont.pingFangSCFont(size: 18, weight: .medium))
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.centerY.equalTo(self)
        }
        // 3. topLine
        self.addLineWithSide(.inTop, color: UIColor.lightGray, thickness: 0.5, margin1: 0, margin2: 0)
        // 4. bottomLine
        self.addLineWithSide(.inBottom, color: UIColor.black, thickness: 0.5, margin1: 0, margin2: 0)
    }

    // MARK: - Private  数据加载

    // MARK: - Private  事件响应

    // 关闭键盘按钮点击响应
    @objc private func doneBtnClick(_ button: UIButton) -> Void {
        self.delegate?.accessoryView(self, didClickedDone: button)
        self.doneBtnClickAction?(self, button)
    }
    // 图片按钮点击响应
    @objc private func picBtnClick(_ button: UIButton) -> Void {
        self.delegate?.accessoryView(self, didClickedPic: button)
        self.picBtnClickAction?(self, button)
    }

}



