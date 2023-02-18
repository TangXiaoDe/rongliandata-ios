//
//  CurrentUserInfoController.swift
//  CCMall
//
//  Created by 小唐 on 2019/1/19.
//  Copyright © 2019 COMC. All rights reserved.
//
//  当前用户资料界面/个人资料界面

import UIKit
import TZImagePickerController

class CurrentUserInfoController: BaseViewController {
    // MARK: - Internal Property

    // MARK: - Private Property

    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var phoneDetailLabel: UILabel!
    @IBOutlet weak var headIcon: UIImageView!
    @IBOutlet weak var headBtn: UIButton!
    
    fileprivate let iconWH: CGFloat = 100

    fileprivate var model: CurrentUserModel? {
        didSet {
            self.setupModel(model)
        }
    }

    // MARK: - Initialize Function

    init() {
        super.init(nibName: "CurrentUserInfoController", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function

// MARK: - LifeCircle Function
extension CurrentUserInfoController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - UI
extension CurrentUserInfoController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        // navigationbar
        self.navigationItem.title = "个人资料"
        // icon
        self.headIcon.set(cornerRadius: self.iconWH * 0.5)
        self.headBtn.setTitle("", for: .normal)
        self.headBtn.setTitle("", for: .highlighted)
        // detailLabel
        self.phoneDetailLabel.font = UIFont.pingFangSCFont(size: 14, weight: .regular)
        self.phoneDetailLabel.text = nil
        self.nickLabel.font = UIFont.pingFangSCFont(size: 14, weight: .regular)
        self.nickLabel.text = nil
    }
}

// MARK: - Data(数据处理与加载)
extension CurrentUserInfoController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        guard let userInfo = AccountManager.share.currentAccountInfo?.userInfo else {
            return
        }
        self.model = userInfo
    }

    /// 数据模型加载
    fileprivate func setupModel(_ model: CurrentUserModel?) -> Void {
        guard let model = model else {
            return
        }
        self.headIcon.kf.setImage(with: model.avatarUrl, placeholder: kPlaceHolderAvatar, options: nil, progressBlock: nil, completionHandler: nil)
        self.phoneDetailLabel.text = model.phone
        self.nickLabel.text = model.name
    }
}

// MARK: - Event(事件响应)
extension CurrentUserInfoController {
    // 头像点击
    @IBAction func headBtnClick(_ sender: UIButton) {
        self.showAvatarPicker()
    }
    /// 昵称点击
    @IBAction func nameBtnClick(_ sender: UIButton) {
        guard let model = self.model else {
            return
        }
        let nameUpdateVC = UserNameUpdateController(user: model)
        nameUpdateVC.updateSuccessAction = { () in
            self.initialDataSource()
        }
        self.navigationController?.pushViewController(nameUpdateVC, animated: true)
    }
    
    @IBAction func phoneOnClicked(_ sender: UIButton) {
    }
}

// MARK: - Notification
extension CurrentUserInfoController {

}

// MARK: - Extension Function
extension CurrentUserInfoController {
    /// 显示头像选择弹窗
    fileprivate func showAvatarPicker() -> Void {
        guard let imagePickerVC = TZImagePickerController(maxImagesCount: 1, columnNumber: 4, delegate: self)
            else {
                return
        }
        //设置默认为中文，不跟随系统
        imagePickerVC.preferredLanguage = "zh-Hans"
        imagePickerVC.maxImagesCount = 1
        imagePickerVC.isSelectOriginalPhoto = false
        imagePickerVC.allowTakePicture = true
        imagePickerVC.allowPickingVideo = false
        imagePickerVC.allowPickingImage = true
        imagePickerVC.allowPickingGif = true
        imagePickerVC.allowPickingMultipleVideo = false
        imagePickerVC.allowPickingOriginalPhoto = false
        imagePickerVC.sortAscendingByModificationDate = false
        imagePickerVC.barItemTextColor = UIColor(hex: 0x333333)
        imagePickerVC.statusBarStyle = .default
        imagePickerVC.naviTitleColor = UIColor.black
        // 裁剪 单选模式,maxImagesCount为1时才生效
        imagePickerVC.showSelectBtn = false
        imagePickerVC.allowCrop = true  // 允许裁剪,默认为YES，showSelectBtn为NO才生效
        let cropWH: CGFloat = kScreenWidth
        imagePickerVC.cropRect = CGRect.init(x: (kScreenWidth - cropWH) * 0.5, y: (kScreenHeight - cropWH) * 0.5, width: cropWH, height: cropWH)
        imagePickerVC.notScaleImage = false
        imagePickerVC.modalPresentationStyle = .overCurrentContext
        self.present(imagePickerVC, animated: true)
    }
    /// 修改头像
    fileprivate func updateAvatarRequest(_ avatar: UIImage) -> Void {
        self.headIcon.image = avatar
        self.view.isUserInteractionEnabled = false
        let indicator = AppLoadingView.init()
        indicator.show()
        UserNetworkManager.updateCurrentUser(icon: avatar) { [weak self](status, msg, mdoel) in
            guard let `self` = self else {
                return
            }
            self.view.isUserInteractionEnabled = true
            indicator.dismiss()
            let message: String? = status ? "修改头像成功" : msg
            Toast.showToast(title: message)
            guard status, let model = mdoel else {
                return
            }
            AccountManager.share.updateCurrentAccount(userInfo: model)
        }
    }
}

// MARK: - Delegate Function

// MARK: - <TZImagePickerControllerDelegate>
extension CurrentUserInfoController: TZImagePickerControllerDelegate {

    /// 选中图片回调
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        guard let image = photos.first else {
            return
        }
        self.updateAvatarRequest(image)
    }

}
