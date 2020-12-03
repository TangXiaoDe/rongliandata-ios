//
//  AuthViewController.swift
//  iMeet
//
//  Created by 小唐 on 2019/5/29.
//  Copyright © 2019 iMeet. All rights reserved.
//
//  授权界面/授权主页

import UIKit

typealias AuthHomeController = AuthViewController
/// 授权界面/授权主页
class AuthViewController: BaseViewController {
    // MARK: - Internal Property

    // MARK: - Private Property

    // MARK: - Initialize Function

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle & Override Function
extension AuthViewController {
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
extension AuthViewController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = UIColor.white
    }
}

// MARK: - Data(数据处理与加载)
extension AuthViewController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {

    }
}

// MARK: - Event(事件响应)
extension AuthViewController {

}

// MARK: - Enter Page
extension AuthViewController {

}

// MARK: - Notification
extension AuthViewController {

}

// MARK: - Extension Function
extension AuthViewController {

}

// MARK: - Delegate Function

// MARK: - <>
extension AuthViewController {

}
