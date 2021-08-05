//
//  PreReturnTypeSelectController.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/8/5.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  还币类型选择界面

import UIKit

protocol PreReturnTypeSelectControllerProtocol: class {
    
    ///
    func returnTypeSelectVC(_ selectVC: PreReturnTypeSelectController, didSelected type: PreReturnType) -> Void
    
}

class PreReturnTypeSelectController: BaseViewController
{

    // MARK: - Internal Property
    
    weak var delegate: PreReturnTypeSelectControllerProtocol?
    
    
    // MARK: - Private Property
    
    fileprivate let coverBtn: UIButton = UIButton.init(type: .custom)
    
    fileprivate let mainView: UIView = UIView.init()
    
    fileprivate let titleView: TitleContainer = TitleContainer.init()
    
    fileprivate let typeContainer: UIView = UIView.init()
    fileprivate let allItemView: TitleIconControl = TitleIconControl.init()
    fileprivate let gasItemView: TitleIconControl = TitleIconControl.init()
    fileprivate let pledgeItemView: TitleIconControl = TitleIconControl.init()
    fileprivate let interestItemView: TitleIconControl = TitleIconControl.init()
    
    fileprivate let bottomView: UIView = UIView.init()
    fileprivate let cancelBtn: UIButton = UIButton.init(type: .custom)
    
    fileprivate let titleViewHeight: CGFloat = 50
    
    fileprivate let itemViewHeight: CGFloat = 45
    fileprivate let itemViewTopMargin: CGFloat = 0
    fileprivate let itemViewVerMargin: CGFloat = 12
    fileprivate let itemViewBottomMargin: CGFloat = 16
    
    fileprivate let bottomViewTopMargin: CGFloat = 5
    fileprivate let cancelBtnHeight: CGFloat = 50
    
    fileprivate let leftMargin: CGFloat = 15
    fileprivate let rightMargin: CGFloat = 12
    
    
    // MARK: - Initialize Function
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // present后的透明展示
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // present后的透明展示
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension PreReturnTypeSelectController {
    
}

// MARK: - LifeCircle/Override Function
extension PreReturnTypeSelectController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }
    
}

// MARK: - UI Function
extension PreReturnTypeSelectController {

    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.clear
        // 1. coverBtn
        self.view.addSubview(self.coverBtn)
        //self.coverBtn.isUserInteractionEnabled = false
        self.coverBtn.addTarget(self, action: #selector(coverBtnClick(_:)), for: .touchUpInside)
        self.coverBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.coverBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 2. mainView
        self.view.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    ///
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. titleView
        mainView.addSubview(self.titleView)
        self.titleView.backgroundColor = UIColor.white
        self.titleView.setupCorners(UIRectCorner.init([UIRectCorner.topLeft, UIRectCorner.topRight]), selfSize: CGSize.init(width: kScreenWidth, height: self.titleViewHeight), cornerRadius: 15)
        self.titleView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.titleViewHeight)
        }
        self.titleView.label.set(text: "选择还币类型", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.mainText, alignment: .center)
        self.titleView.label.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
        }
        // 2. typeContainer
        mainView.addSubview(self.typeContainer)
        self.initialTypeContainer(self.typeContainer)
        self.typeContainer.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.titleView.snp.bottom)
        }
        // 3. bottomView
        mainView.addSubview(self.bottomView)
        self.bottomView.backgroundColor = UIColor.white
        self.bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.typeContainer.snp.bottom)
        }
        self.bottomView.addSubview(self.cancelBtn)
        self.cancelBtn.set(title: "取消", titleColor: AppColor.grayText, for: .normal)
        self.cancelBtn.set(title: "取消", titleColor: AppColor.grayText, for: .highlighted)
        self.cancelBtn.set(font: UIFont.pingFangSCFont(size: 16, weight: .medium))
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnClick(_:)), for: .touchUpInside)
        self.cancelBtn.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.cancelBtnHeight)
            make.bottom.equalToSuperview().offset(-kBottomHeight)
        }
    }
    ///
    fileprivate func initialTypeContainer(_ containerView: UIView) -> Void {
        containerView.backgroundColor = UIColor.white
        containerView.removeAllSubviews()
        //
        let itemViews: [TitleIconControl] = [self.allItemView, self.gasItemView, self.pledgeItemView, self.interestItemView]
        let itemTitles: [String] = ["归还全部", "归还质押币", "归还GAS消耗", "归还累计欠款利息"]
        var lastView: UIView = containerView
        for (index, itemView) in itemViews.enumerated() {
            containerView.addSubview(itemView)
            itemView.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(self.itemViewHeight)
                if 0 == index {
                    make.top.equalToSuperview().offset(self.itemViewTopMargin)
                } else {
                    make.top.equalTo(lastView.snp.bottom).offset(self.itemViewVerMargin)
                }
                if index == itemViews.count - 1 {
                    make.bottom.equalToSuperview().offset(-self.itemViewBottomMargin)
                }
            }
            lastView = itemView
            //
            itemView.titleLabel.set(text: itemTitles[index], font: UIFont.pingFangSCFont(size: 14), textColor: AppColor.mainText)
            itemView.titleLabel.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview().offset(self.leftMargin)
                make.centerY.equalToSuperview()
            }
            itemView.iconView.image = UIImage.init(named: "IMG_equip_next_black")
            itemView.iconView.set(cornerRadius: 0)
            itemView.iconView.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 5, height: 10))
                make.trailing.equalToSuperview().offset(-self.rightMargin)
                make.centerY.equalToSuperview()
            }
        }
    }

}

// MARK: - Data Function
extension PreReturnTypeSelectController {

    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        self.setupAsDemo()
    }
    ///
    fileprivate func setupAsDemo() -> Void {
        
    }

}

// MARK: - Event Function
extension PreReturnTypeSelectController {
    
    ///
    @objc fileprivate func coverBtnClick(_ button: UIButton) -> Void {
        self.dismiss(animated: false, completion: nil)
    }
    
    ///
    @objc fileprivate func cancelBtnClick(_ button: UIButton) -> Void {
        self.dismiss(animated: false, completion: nil)
    }
    
    ///
    @objc fileprivate func itemViewClick(_ itemView: UIView) -> Void {
        var type: PreReturnType?
        switch itemView {
        case self.allItemView:
            type = PreReturnType.all
        case self.gasItemView:
            type = PreReturnType.gas
        case self.pledgeItemView:
            type = PreReturnType.mortgage
        case self.interestItemView:
            type = PreReturnType.interest
        default:
            break
        }
        guard let selectedType = type else {
            self.dismiss(animated: false, completion: nil)
            return
        }
        //
        self.dismiss(animated: false) {
            self.delegate?.returnTypeSelectVC(self, didSelected: selectedType)
        }
    }

}

// MARK: - Request Function
extension PreReturnTypeSelectController {
    
}

// MARK: - Enter Page
extension PreReturnTypeSelectController {
    
}

// MARK: - Notification Function
extension PreReturnTypeSelectController {
    
}

// MARK: - Extension Function
extension PreReturnTypeSelectController {
    
}

// MARK: - Delegate Function

// MARK: - <>
extension PreReturnTypeSelectController {
    
}

