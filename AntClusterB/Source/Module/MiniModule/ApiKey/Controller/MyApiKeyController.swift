//
//  MyApiKeyController.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/9/23.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  我的APIKEY界面

import UIKit

class MyApiKeyController: BaseViewController
{

    // MARK: - Internal Property
    
    fileprivate var model: MyApiKeyModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    // MARK: - Private Property
    
    fileprivate let coverView: UIButton = UIButton.init(type: .custom)
    
    fileprivate let mainView: UIView = UIView.init()
    
    fileprivate let titleView: UIView = UIView.init()
    fileprivate let titleLabel: UILabel = UILabel.init()                // 标题
    fileprivate let closeBtn: UIButton = UIButton.init(type: .custom)   // 关闭按钮
    
    fileprivate let itemContainer: UIView = UIView.init()
    fileprivate let apiKeyItemView: MyApiKeyItemView = MyApiKeyItemView.init()
    fileprivate let apiSecretItemView: MyApiKeyItemView = MyApiKeyItemView.init()

    fileprivate let titleViewHeight: CGFloat = 44
    fileprivate let itemTopMargin: CGFloat = 20
    fileprivate let itemVerMargin: CGFloat = 15
    fileprivate let itemBottomMargin: CGFloat = 55 + kBottomHeight
    
    
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
extension MyApiKeyController {
    
}

// MARK: - LifeCircle/Override Function
extension MyApiKeyController {

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
extension MyApiKeyController {

    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.clear
        // 1. coverView
        self.view.addSubview(self.coverView)
        self.coverView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.coverView.addTarget(self, action: #selector(coverBtnClick(_:)), for: .touchUpInside)
        self.coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 2. mainVIew
        self.view.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    ///
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. titleView
        mainView.addSubview(self.titleView)
        self.initialTitleView(self.titleView)
        self.titleView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.titleViewHeight)
        }
        // 2. itemContainer
        mainView.addSubview(self.itemContainer)
        self.initialItemContainer(self.itemContainer)
        self.itemContainer.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.titleView.snp.bottom)
        }
    }
    ///
    fileprivate func initialTitleView(_ titleView: UIView) -> Void {
        // 0.
        titleView.backgroundColor = UIColor.white
        titleView.setupCorners(UIRectCorner.init([UIRectCorner.topLeft, UIRectCorner.topRight]), selfSize: CGSize.init(width: kScreenWidth, height: self.titleViewHeight), cornerRadius: 10)
        // 1. title
        titleView.addSubview(self.titleLabel)
        self.titleLabel.set(text: "我的APIKEY", font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: AppColor.subMainText, alignment: .center)
        self.titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        // 2. closeBtn
        titleView.addSubview(self.closeBtn)
        self.closeBtn.addTarget(self, action: #selector(closeBtnClick(_:)), for: .touchUpInside)
        self.closeBtn.setImage(UIImage.init(named: "IMG_icon_tc_close"), for: .normal)
        self.closeBtn.setImage(UIImage.init(named: "IMG_icon_tc_close"), for: .highlighted)
        self.closeBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15 + 20 * 0.5)
            make.width.height.equalTo(12 + 20)
        }
        // 3. bottomLine
        titleView.addLineWithSide(.inBottom, color: AppColor.dividing, thickness: 0.5, margin1: 0, margin2: 0)
    }
    ///
    fileprivate func initialItemContainer(_ container: UIView) -> Void {
        container.backgroundColor = UIColor.white
        container.removeAllSubviews()
        //
        let itemViews: [MyApiKeyItemView] = [self.apiKeyItemView, self.apiSecretItemView]
        let titles: [String] = ["API KEY:", "API SECRET:"]
        var topView: UIView = container
        for (index, itemView) in itemViews.enumerated() {
            container.addSubview(itemView)
            itemView.title = titles[index]
            itemView.delegate = self
            itemView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                if 0 == index {
                    make.top.equalToSuperview().offset(self.itemTopMargin)
                } else {
                    make.top.equalTo(topView.snp.bottom).offset(self.itemVerMargin)
                }
                if index == itemViews.count - 1 {
                    make.bottom.equalToSuperview().offset(-self.itemBottomMargin)
                }
            }
            topView = itemView
        }
    }

}

// MARK: - Data Function
extension MyApiKeyController {

    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        if let model = AppConfig.share.apiKey {
            self.model = model
        } else {
            MineNetworkManager.getMyApiKey { [weak self]status, msg, model in
                guard let `self` = self else {
                    return
                }
                guard status, let model = model else {
                    Toast.showToast(title: msg)
                    return
                }
                self.model = model
            }
        }
    }
    ///
    fileprivate func setupWithModel(_ model: MyApiKeyModel?) -> Void {
        guard let model = model else {
            return
        }
        self.apiKeyItemView.value = model.api_key
        self.apiSecretItemView.value = model.api_secret
    }

}

// MARK: - Event Function
extension MyApiKeyController {
    
    ///
    @objc fileprivate func coverBtnClick(_ coverBtn: UIButton) -> Void {
        //print("MyApiKeyController coverBtnClick")
        self.dismiss(animated: false, completion: nil)
    }
    ///
    @objc fileprivate func closeBtnClick(_ closeBtn: UIButton) -> Void {
        //print("MyApiKeyController closeBtnClick")
        self.dismiss(animated: false, completion: nil)
    }
    
}

// MARK: - Request Function
extension MyApiKeyController {
    
}

// MARK: - Enter Page
extension MyApiKeyController {
    
}

// MARK: - Notification Function
extension MyApiKeyController {
    
}

// MARK: - Extension Function
extension MyApiKeyController {
    
}

// MARK: - Delegate Function

// MARK: - <MyApiKeyItemViewProtocol>
extension MyApiKeyController: MyApiKeyItemViewProtocol {
    
    /// 复制按钮点击回调
    func itemView(_ itemView: MyApiKeyItemView, didClickedCopy copyView: UIView) -> Void {
        guard let model = self.model else {
            return
        }
        switch itemView {
        case self.apiKeyItemView:
            AppUtil.copyToPasteProcess(model.api_key, indicatorMsg: "API KEY 已复制")
        case self.apiSecretItemView:
            AppUtil.copyToPasteProcess(model.api_secret, indicatorMsg: "API SECRET 已复制")
        default:
            break
        }
    }
    
}

