//
//  KefuContactController.swift
//  SassProject
//
//  Created by 小唐 on 2020/11/23.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  客服联系方式界面
//  注1：该界面是一个弹窗界面；
//  注2：该界面用于取代'申请代理升级 保存二维码'的界面；
//  注3：联系方式来自服务器配置，若没有，可该界面请求；


import UIKit

class KefuContactController: UIViewController {
    // MARK: - Internal Property

    // MARK: - Private Property

    fileprivate var model: BusinessContactModel?
    fileprivate var sourceList: [ContactItemModel] = []

    fileprivate let coverBtn: UIButton = UIButton.init(type: .custom)
    fileprivate let mainView: UIView = UIView.init()

    fileprivate let titleView: UIView = UIView.init()
    fileprivate let titleLabel: UILabel = UILabel.init()
    fileprivate let closeBtn: UIButton = UIButton.init(type: .custom)

    fileprivate let centerView: UIView = UIView.init()
    fileprivate let itemContainer: UIView = UIView.init()

    fileprivate let titleViewHeight: CGFloat = 44
    fileprivate let bottomSafeHeight: CGFloat = kBottomHeight
    fileprivate let itemHeight: CGFloat = ContactItemView.viewHeight
    fileprivate let itemVerMargin: CGFloat = 12
    fileprivate let itemTopMargin: CGFloat = 15
    fileprivate let itemBottomMargin: CGFloat = 20


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

// MARK: - LifeCircle Function
extension KefuContactController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

// MARK: - UI
extension KefuContactController {
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
            make.leading.trailing.equalToSuperview() // 内部处理安全距离
            make.bottom.equalToSuperview()
        }
    }
    /// 
    @objc fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. titleView
        mainView.addSubview(self.titleView)
        self.initialTopView(self.titleView)
        self.titleView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.titleViewHeight)
        }
        // 2. centerView
        mainView.addSubview(self.centerView)
        self.initialCenterView(self.centerView)
        self.centerView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.titleView.snp.bottom)
        }
    }
    ///
    fileprivate func initialTopView(_ topView: UIView) -> Void {
        topView.backgroundColor = .white
        topView.setupCorners(UIRectCorner.init([UIRectCorner.topLeft, UIRectCorner.topRight]), selfSize: CGSize.init(width: kScreenWidth, height: self.titleViewHeight), cornerRadius: 10)
        // 1. titleLabel  "客服联系方式"    "如需客服请添加"
        topView.addSubview(self.titleLabel)
        self.titleLabel.set(text: "如需客服请添加", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.mainText, alignment: .center)
        self.titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        topView.addSubview(self.closeBtn)
        self.closeBtn.setImage(UIImage(named: "IMG_common_icon_close"), for: .normal)
        self.closeBtn.addTarget(self, action: #selector(closeBtnClick(_:)), for: .touchUpInside)
        self.closeBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(24)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
        // 2. separateLine
        topView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: 0, margin2: 0)
    }
    ///
    fileprivate func initialCenterView(_ centerView: UIView) -> Void {
        centerView.backgroundColor = .white
        // contaienrView
        centerView.addSubview(self.itemContainer)
        self.itemContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }


    ///
    fileprivate func setupContainer(with itemList: [ContactItemModel]) -> Void {
        self.itemContainer.removeAllSubView()
        var topView: UIView = self.itemContainer
        for (index, itemModel) in itemList.enumerated() {
            let itemView: ContactItemView = ContactItemView.init()
            self.itemContainer.addSubview(itemView)
            itemView.model = itemModel
            itemView.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(self.itemHeight)
                if 0 == index {
                    make.top.equalToSuperview().offset(self.itemTopMargin)
                } else {
                    make.top.equalTo(topView.snp.bottom).offset(self.itemVerMargin)
                }
                if index == itemList.count - 1 {
                    make.bottom.equalToSuperview().offset(-self.itemBottomMargin)
                }
            }
            topView = itemView
        }
    }

}

// MARK: - Data(数据处理与加载)
extension KefuContactController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        guard let business = AppConfig.share.server?.business else {
            self.dataRequest()
            return
        }
        self.model = business
        self.dataSourceProcess(business)
    }
    /// 数据请求
    fileprivate func dataRequest() -> Void {
        SystemNetworkManager.appServerConfig { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            guard status, let model = model?.business else {
                Toast.showToast(title: msg)
                return
            }
            self.model = model
            self.dataSourceProcess(model)
        }
    }
    /// 数据源处理
    fileprivate func dataSourceProcess(_ model: BusinessContactModel) -> Void {
        self.sourceList.removeAll()
        let wechatItem = ContactItemModel.init(title: "微信", account: model.wechat)
        let qqItem = ContactItemModel.init(title: "QQ", account: model.qq)
        self.sourceList = [wechatItem, qqItem]
        self.setupContainer(with: self.sourceList)
    }

}

// MARK: - Event(事件响应)
extension KefuContactController {
    /// 遮罩点击
    @objc fileprivate func coverBtnClick(_ button: UIButton) -> Void {
        self.dismiss(animated: false, completion: nil)
    }
    /// 取消点击
    @objc fileprivate func closeBtnClick(_ button: UIButton) -> Void {
        self.dismiss(animated: false, completion: nil)
    }

}

// MARK: - Notification
extension KefuContactController {

}

// MARK: - Extension Function
extension KefuContactController {

}

// MARK: - Delegate Function

// MARK: - <>
extension KefuContactController {

}
