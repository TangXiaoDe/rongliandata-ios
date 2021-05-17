//
//  FPOrePoolTypeSelectController.swift
//  MallProject
//
//  Created by 小唐 on 2021/3/8.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  首页矿池类型选择界面

import UIKit

protocol FPOrePoolTypeSelectControllerProtocol: class {
    ///
    func typeSelectVC(_ selectVC: FPOrePoolTypeSelectController, didClickedClose closeView: UIView, with selectedType: FPOrePoolType) -> Void
    ///
    func typeSelectVC(_ selectVC: FPOrePoolTypeSelectController, didClickedItem itemView: UIView, with selectedType: FPOrePoolType) -> Void
}
extension FPOrePoolTypeSelectControllerProtocol {
    func typeSelectVC(_ selectVC: FPOrePoolTypeSelectController, didClickedClose closeView: UIView, with selectedType: FPOrePoolType) -> Void {}
}

class FPOrePoolTypeSelectController: UIViewController {

    // MARK: - Internal Property

    var defaultType: FPOrePoolType?

    weak var delegate: FPOrePoolTypeSelectControllerProtocol?

    // MARK: - Private Property

    fileprivate let coverBtn: UIButton = UIButton.init(type: .custom)
    fileprivate let mainView: UIView = UIView.init()

    fileprivate let titleView: UIView = UIView.init()
    fileprivate let titleLabel: UILabel = UILabel.init()
    fileprivate let closeBtn: UIButton = UIButton.init(type: .custom)

    fileprivate let bottomView: UIView = UIView.init()
    fileprivate let container: UIView = UIView.init()
    fileprivate let ipfsItemView: FPOrePoolTypeSelectItemView = FPOrePoolTypeSelectItemView.init()
    fileprivate let btcItemView: FPOrePoolTypeSelectItemView = FPOrePoolTypeSelectItemView.init()
    fileprivate let ethItemView: FPOrePoolTypeSelectItemView = FPOrePoolTypeSelectItemView.init()
    fileprivate let chiaItemView: FPOrePoolTypeSelectItemView = FPOrePoolTypeSelectItemView.init()
    
    
    // 备注：字典遍历是无序的，导致显示顺序每次都不一样
    fileprivate lazy var itemViewDicInfo: [FPOrePoolType: FPOrePoolTypeSelectItemView] = {
        return [.ipfs: self.ipfsItemView, .chia: self.chiaItemView]
    }()
    fileprivate let itemTypes: [FPOrePoolType] = [.ipfs, .chia]
    fileprivate lazy var itemViews: [FPOrePoolTypeSelectItemView] = {
        var itemViews: [FPOrePoolTypeSelectItemView] = []
        for type in self.itemTypes {
            if let itemView = self.itemViewDicInfo[type] {
                itemViews.append(itemView)
            }
        }
        return itemViews
    }()


    fileprivate let titleViewHeight: CGFloat = 44


    fileprivate let containerTopMargin: CGFloat = 30
    fileprivate let containerBottomMargin: CGFloat = kTabBarHeight + 40

    fileprivate let itemLrMargin: CGFloat = 15
    fileprivate let itemHorMargin: CGFloat = 12
    fileprivate let itemVerMargin: CGFloat = 12
    fileprivate let itemTbMargin: CGFloat = 0
    fileprivate let itemHeight: CGFloat = 75
    fileprivate let itemColNum: Int = 3
    fileprivate var itemWidth: CGFloat {
        let colnum: Int = self.itemColNum
        let width: CGFloat = (kScreenWidth - self.itemLrMargin * 2.0 - self.itemHorMargin * CGFloat(colnum - 1)) / CGFloat(colnum)
        return width
    }

    fileprivate(set) var selectedType: FPOrePoolType?
    fileprivate var selectedItemView: FPOrePoolTypeSelectItemView?


    // MARK: - Initialize Function

    init() {
        super.init(nibName: nil, bundle: nil)
        // present后的透明展示
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension FPOrePoolTypeSelectController {

}

// MARK: - LifeCircle/Override Function
extension FPOrePoolTypeSelectController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    /// 控制器的view将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    /// 控制器的view即将消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

// MARK: - UI Function
extension FPOrePoolTypeSelectController {

    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.clear
        // 1. coverBtn
        self.view.addSubview(self.coverBtn)
        self.coverBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.coverBtn.addTarget(self, action: #selector(coverBtnClick(_:)), for: .touchUpInside)
        self.coverBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 2. mainView
        self.view.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview() // 内部处理安全距离
        }
    }
    ///
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. topView
        mainView.addSubview(self.titleView)
        self.initialTitleView(self.titleView)
        self.titleView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.titleViewHeight)
        }
        // 2. bottomView
        mainView.addSubview(self.bottomView)
        self.initialBottomView(self.bottomView)
        self.bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.titleView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    ///
    fileprivate func initialTitleView(_ topView: UIView) -> Void {
        topView.backgroundColor = UIColor.white
        topView.setupCorners(UIRectCorner.init([UIRectCorner.topLeft, UIRectCorner.topRight]), selfSize: CGSize.init(width: kScreenWidth, height: self.titleViewHeight), cornerRadius: 10)
        // 1. titleLabel
        topView.addSubview(self.titleLabel)
        self.titleLabel.set(text: "切换矿池数据", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.mainText, alignment: .center)
        self.titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        // 2. closeBtn
        topView.addSubview(self.closeBtn)
        self.closeBtn.setImage(UIImage.init(named: "IMG_icon_btn_close"), for: .normal)
        self.closeBtn.setImage(UIImage.init(named: "IMG_icon_btn_close"), for: .highlighted)
        self.closeBtn.addTarget(self, action: #selector(closeBtnClick(_:)), for: .touchUpInside)
        self.closeBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.trailing.centerY.equalToSuperview()
        }
        // 3. separateLine
        topView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: 0, margin2: 0)
    }
    ///
    fileprivate func initialBottomView(_ bottomView: UIView) -> Void {
        bottomView.backgroundColor = UIColor.white
        // container
        bottomView.addSubview(self.container)
        self.container.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.containerTopMargin)
            make.bottom.equalToSuperview().offset(-self.containerBottomMargin)
            make.leading.trailing.equalToSuperview()
        }
        //
        for (index, type) in self.itemTypes.enumerated() {
            let row: Int = index / self.itemColNum
            let col: Int = index % self.itemColNum
            let itemView = self.itemViews[index]
            container.addSubview(itemView)
            itemView.type = type
            itemView.set(cornerRadius: 3, borderWidth: 0.5, borderColor: UIColor.clear)
            itemView.addTarget(self, action: #selector(itemViewClick(_:)), for: .touchUpInside)
            itemView.snp.makeConstraints { (make) in
                make.width.equalTo(self.itemWidth)
                make.height.equalTo(self.itemHeight)
                let topMargin: CGFloat = self.itemTbMargin + CGFloat(row) * (self.itemHeight + self.itemVerMargin)
                let leftMargin: CGFloat = self.itemLrMargin + CGFloat(col) * (self.itemWidth + self.itemHorMargin)
                make.leading.equalToSuperview().offset(leftMargin)
                make.top.equalToSuperview().offset(topMargin)
                if index == self.itemTypes.count - 1 {
                    let rightMargin: CGFloat = kScreenWidth - leftMargin - self.itemWidth
                    make.trailing.equalToSuperview().offset(-rightMargin)
                    make.bottom.equalToSuperview().offset(-self.itemTbMargin)
                }
            }
        }
    }

}

// MARK: - Data Function
extension FPOrePoolTypeSelectController {

    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        guard let defaultType = self.defaultType else {
            return
        }
        self.selectedType = defaultType
        if let index = self.itemTypes.firstIndex(of: defaultType) {
            self.itemViews[index].isSelected = true
            self.selectedItemView = self.itemViews[index]
        }
    }

}

// MARK: - Event Function
extension FPOrePoolTypeSelectController {
    /// 遮罩点击
    @objc fileprivate func coverBtnClick(_ button: UIButton) -> Void {
        self.dismiss(animated: false, completion: nil)
        //self.delegate?.ensureVC(self, didClickedCover: button)
    }

    ///
    @objc fileprivate func closeBtnClick(_ button: UIButton) -> Void {
        self.dismiss(animated: false, completion: nil)
        //self.delegate?.ensureVC(self, didClickedCover: button)
        guard let selectedType = self.selectedType else {
            return
        }
        self.delegate?.typeSelectVC(self, didClickedClose: button, with: selectedType)
    }

    ///
    @objc fileprivate func itemViewClick(_ itemView: FPOrePoolTypeSelectItemView) -> Void {
        if itemView.isSelected {
            self.dismiss(animated: false, completion: nil)
            return
        }
        self.selectedItemView?.isSelected = false
        itemView.isSelected = true
        self.selectedItemView = itemView
        self.selectedType = itemView.type
        self.dismiss(animated: false, completion: nil)
        if let type = itemView.type {
            self.delegate?.typeSelectVC(self, didClickedItem: itemView, with: type)
        }
    }

}

// MARK: - Request Function
extension FPOrePoolTypeSelectController {

}

// MARK: - Enter Page
extension FPOrePoolTypeSelectController {

}

// MARK: - Notification Function
extension FPOrePoolTypeSelectController {

}

// MARK: - Extension Function
extension FPOrePoolTypeSelectController {

}

// MARK: - Delegate Function

// MARK: - <>
extension FPOrePoolTypeSelectController {

}
