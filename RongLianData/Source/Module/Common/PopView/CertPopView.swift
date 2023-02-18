//
//  CertPopView.swift
//  MTProject
//
//  Created by zhaowei on 2021/3/1.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import UIKit

protocol CertPopViewProtocol: class {
    /// 遮罩点击回调 - 可选
    func popView(_ popView: CertPopView, didClickedCover cover: UIButton) -> Void
    /// 取消按钮点击回调 - 可选
    func popView(_ popView: CertPopView, didClickedCancel cancelView: UIButton) -> Void
    /// 确定按钮点击回调
    func popView(_ popView: CertPopView, didClickedDone doneView: UIButton) -> Void
}
extension CertPopViewProtocol {
    func popView(_ popView: CertPopView, didClickedCover cover: UIButton) -> Void {}
    func popView(_ popView: CertPopView, didClickedCancel cancelView: UIButton) -> Void {}
}

enum CertPopType: Int {
    /// 自己未实名
    case mine = 1
    /// 别人未实名
    case other

    ///
    var title: String {
        var content: String = ""
        switch self {
        case .mine:
            content = "您还未实名认证"
        case .other:
            content = "对方未实名认证"
        }
        return content
    }

    ///
    var message: String {
        var content: String = ""
        switch self {
        case .mine:
            content = "请先实名认证，才可继续操作"
        case .other:
            content = "各自实名认证后，才可继续操作"
        }
        return content
    }
}

class CertPopView: UIView {

    // MARK: - Internal Property

    weak var delegate: CertPopViewProtocol?
    
    let type: CertPopType

    // MARK: - Private Property

    
    let coverBtn: UIButton = UIButton.init(type: .custom)
    
    fileprivate let mainView: UIView = UIView()
    fileprivate let iconView: UIImageView = UIImageView()   // 图标不受mainView限制
    fileprivate let titleView: UIView = UIView.init()       // 标题，左右有横线
    fileprivate let titleLabel: UILabel = UILabel()
    fileprivate let titleLeftLine: UILabel = UILabel()
    fileprivate let titleRightLine: UILabel = UILabel()
    fileprivate let tipsLabel: UILabel = UILabel.init()     // 提示文案
    fileprivate let cancelBtn: GradientLayerButton = GradientLayerButton.init(type: .custom)    // 知道了
    fileprivate let doneBtn: GradientLayerButton = GradientLayerButton.init(type: .custom)      // 确定按钮

    fileprivate let mainViewHeight: CGFloat = 190
    fileprivate let mainLrMargin: CGFloat = 50
    fileprivate let iconSize: CGSize = CGSize.init(width: 113, height: 82)
    fileprivate let iconTopMargin: CGFloat = -36    // mainView.top
    fileprivate let titleTopMargin: CGFloat = 12    // icon.bottom
    fileprivate let tipsTopMargin: CGFloat = 12     // title.bottom
    fileprivate let itemBtnSize: CGSize = CGSize.init(width: 80, height: 32)
    fileprivate let itemBtnTopMargin: CGFloat = 15
    fileprivate let itemBtnBottomMargin: CGFloat = 15
    fileprivate let itemBtnHorMargin: CGFloat = 30
    

    // MARK: - Initialize Function
    init(type: CertPopType) {
        self.type = type
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        //self.commonInit()
        fatalError("init(coder:) has not been implemented")
    }

    /// 通用初始化：UI、配置、数据等
    func commonInit() -> Void {
        self.initialUI()
        self.initialDS()
    }


}

// MARK: - Internal Function
extension CertPopView {

}

// MARK: - LifeCircle Function
extension CertPopView {

}
// MARK: - Private UI 手动布局
extension CertPopView {

    /// 界面布局 - 子类可重写
    fileprivate func initialUI() -> Void {
        // 1. coverBtn
        self.addSubview(self.coverBtn)
        self.coverBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.coverBtn.addTarget(self, action: #selector(coverBtnClick(_:)), for: .touchUpInside)
        self.coverBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 2. mainView
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.mainLrMargin)
            make.trailing.equalToSuperview().offset(-self.mainLrMargin)
            make.center.equalToSuperview()
            make.height.equalTo(self.mainViewHeight)
        }
    }
    /// mainView布局 - 子类可重写
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        mainView.backgroundColor = UIColor.white
        mainView.set(cornerRadius: 10)
        // 1. iconView
        self.addSubview(self.iconView)      // 注意父视图与层级关系
        self.iconView.set(cornerRadius: 0)
        self.iconView.image = UIImage.init(named: "IMG_tips_img_smrz")
        //self.iconView.backgroundColor = UIColor.random
        self.iconView.snp.makeConstraints { (make) in
            make.top.equalTo(mainView.snp.top).offset(self.iconTopMargin)
            make.size.equalTo(self.iconSize)
            make.centerX.equalTo(self.mainView)
        }
        // 2. titleView
        mainView.addSubview(self.titleView)
        self.titleView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.iconView.snp.bottom).offset(self.titleTopMargin)
        }
        // 2.1 titleLabel
        self.titleView.addSubview(self.titleLabel)
        self.titleLabel.set(text: "您还未实名认证", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.mainText, alignment: .center)
        self.titleLabel.snp.makeConstraints { (make) in
            make.center.top.bottom.equalToSuperview()
        }
        // 2.2 titleLeftLine
        self.titleView.addSubview(self.titleLeftLine)
        self.titleLeftLine.backgroundColor = AppColor.mainText
        self.titleLeftLine.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(22)
            make.height.equalTo(1.5)
            make.trailing.equalTo(self.titleLabel.snp.leading).offset(-10)
        }
        // 2.3 titleRightLine
        self.titleView.addSubview(self.titleRightLine)
        self.titleRightLine.backgroundColor = AppColor.mainText
        self.titleRightLine.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(22)
            make.height.equalTo(1.5)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(10)
        }
        // 3. tipsLabel
        mainView.addSubview(self.tipsLabel)
        self.tipsLabel.set(text: "请先实名认证，才可继续操作", font: UIFont.pingFangSCFont(size: 14), textColor: AppColor.mainText, alignment: .center)
        self.tipsLabel.numberOfLines = 2
        self.tipsLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.titleView.snp.bottom).offset(self.tipsTopMargin)
        }
        // 4. cancelBtn
        mainView.addSubview(self.cancelBtn)
        self.cancelBtn.set(title: "再看看", titleColor: UIColor.white, for: .normal)
        self.cancelBtn.set(title: "再看看", titleColor: UIColor.white, for: .highlighted)
        self.cancelBtn.set(font: UIFont.pingFangSCFont(size: 14), cornerRadius: self.itemBtnSize.height * 0.5)
        self.cancelBtn.backgroundColor = AppColor.disable
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnClick(_:)), for: .touchUpInside)
        self.cancelBtn.snp.makeConstraints { (make) in
            make.size.equalTo(self.itemBtnSize)
//            make.top.equalTo(self.tipsLabel.snp.bottom).offset(self.itemBtnTopMargin)
            make.bottom.equalToSuperview().offset(-self.itemBtnBottomMargin)
            make.trailing.equalTo(mainView.snp.centerX).offset(-self.itemBtnHorMargin * 0.5)
        }
        // 5. doneBtn
        mainView.addSubview(self.doneBtn)
        self.doneBtn.set(title: "去认证", titleColor: .white, for: .normal)
        self.doneBtn.set(title: "去认证", titleColor: .white, for: .highlighted)
        self.doneBtn.set(font: UIFont.pingFangSCFont(size: 14), cornerRadius: self.itemBtnSize.height * 0.5)
        //self.doneBtn.backgroundColor = AppColor.theme
        self.doneBtn.gradientLayer.frame = CGRect.init(origin: CGPoint.zero, size: self.itemBtnSize)
        self.doneBtn.gradientLayer.colors = [AppColor.theme.cgColor, AppColor.theme.cgColor]
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.snp.makeConstraints { (make) in
            make.size.equalTo(self.itemBtnSize)
            make.centerY.equalTo(self.cancelBtn)
            make.leading.equalTo(mainView.snp.centerX).offset(self.itemBtnHorMargin * 0.5)
        }
    }
    fileprivate func initialDS() -> Void {
        self.titleLabel.text = self.type.title
        self.tipsLabel.text = self.type.message
        if self.type == .other {
            self.cancelBtn.isHidden = true
            self.doneBtn.set(title: "好的", titleColor: .white, for: .normal)
            self.doneBtn.set(title: "好的", titleColor: .white, for: .highlighted)
            self.doneBtn.snp.remakeConstraints { (make) in
                make.size.equalTo(self.itemBtnSize)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-self.itemBtnBottomMargin)
            }
        }
    }
}
// MARK: - Private UI Xib加载后处理
extension CertPopView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension CertPopView {

}

// MARK: - Event Function
extension CertPopView {
    /// 遮罩点击
    @objc func coverBtnClick(_ button: UIButton) -> Void {
        self.delegate?.popView(self, didClickedCover: button)
        self.removeFromSuperview()
    }
    /// 点击
    @objc func cancelBtnClick(_ button: UIButton) -> Void {
        print("CertPopView cancelBtnClick")
        self.delegate?.popView(self, didClickedCancel: button)
        self.removeFromSuperview()
    }
    /// 点击
    @objc func doneBtnClick(_ button: UIButton) -> Void {
        print("CertPopView doneBtnClick")
        self.delegate?.popView(self, didClickedDone: button)
        self.removeFromSuperview()
    }

}

// MARK: - Extension Function
extension CertPopView {

}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension CertPopView {

}
