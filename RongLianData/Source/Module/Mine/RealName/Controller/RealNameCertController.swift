//
//  RealNameCertController.swift
//  iMeet
//
//  Created by 小唐 on 2019/5/29.
//  Copyright © 2019 iMeet. All rights reserved.
//
//  实名认证界面

import UIKit
import TZImagePickerController
import ChainOneKit

enum CertificationImagePickerType {
    case front
    case back
    case hand
}

enum CertificationHomeType {
    case apply
    case update
    case success
    case wait
}

typealias PersonalCertificationController = RealNameCertController
typealias RealNameCertificateController = RealNameCertController
/// 实名界面
class RealNameCertController: BaseViewController {
    // MARK: - Internal Property

    // MARK: - Private Property

    fileprivate let scrollView: UIScrollView = UIScrollView()
    fileprivate let certView: RealNameCertView = RealNameCertView()

    fileprivate let bottomView: UIView = UIView()
    fileprivate let bottomBtn: UIButton = UIButton(type: .custom)
    fileprivate let bottomBtnGradientLayer: CAGradientLayer = AppUtil.commonGradientLayer()

    fileprivate let bottomViewHeight: CGFloat = 50
    fileprivate let bottomBtnH: CGFloat = 40
    fileprivate let bottomBtnLrMargin: CGFloat = 12

    fileprivate var model: RealNameCertModel?

    fileprivate var frontImgModel: ImageUploadModel?
    fileprivate var backImgModel: ImageUploadModel?
    fileprivate var handImgModel: ImageUploadModel?

    fileprivate var imgPickerType: CertificationImagePickerType = .front

    /// 认证主页类型，默认为申请认证
    fileprivate var type: CertificationHomeType = .apply

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

// MARK: - LifeCircle Function
extension RealNameCertController {
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
extension RealNameCertController {
    /// 页面布局
    fileprivate func initialUI() -> Void {
        // navigation
        self.navigationItem.title = "实名认证"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "IMG_navbar_back"), style: .plain, target: self, action: #selector(backItemClick))
        self.view.addSubview(self.bottomView)
        self.bottomView.backgroundColor = AppColor.pageBg
        self.bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.bottomViewHeight)
            make.bottom.equalTo(self.view.snp_bottomMargin)
        }
        // 3. bottomBtn
        self.bottomView.addSubview(self.bottomBtn)
        self.bottomBtn.set(title: "确认提交", titleColor: UIColor.white, image: nil, bgImage: UIImage.imageWithColor(AppColor.theme), for: .normal)
        self.bottomBtn.set(title: "确认提交", titleColor: UIColor.white, image: nil, bgImage: UIImage.imageWithColor(AppColor.disable), for: .disabled)
        // [注] 此种状态下应不可响应
        self.bottomBtn.set(title: "资料审核中，请耐心等待", titleColor: UIColor.white, image: nil, bgImage: UIImage.imageWithColor(AppColor.disable), for: .selected)
        self.bottomBtn.set(font: UIFont.pingFangSCFont(size: 18))
        self.bottomBtn.set(cornerRadius: self.bottomBtnH * 0.5)
        self.bottomBtn.addTarget(self, action: #selector(submitBtnClick(_:)), for: .touchUpInside)
        self.bottomBtn.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.bottomBtnLrMargin)
            make.trailing.equalToSuperview().offset(-self.bottomBtnLrMargin)
            make.height.equalTo(self.bottomBtnH)
            make.centerY.equalToSuperview()
        }
        self.bottomBtn.layer.insertSublayer(self.bottomBtnGradientLayer, below: nil)
        self.bottomBtnGradientLayer.isHidden = true
        self.bottomBtnGradientLayer.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.bottomBtnH)
        // scrollView
        self.view.addSubview(self.scrollView)
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self
        self.scrollView.bounces = false
        self.scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(self.bottomView.snp.top)
        }
        let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(tapGRProcess(_:)))
        self.scrollView.addGestureRecognizer(tapGR)
        // certView
        self.scrollView.addSubview(self.certView)
        self.certView.delegate = self
        self.certView.nameField.addTarget(self, action: #selector(nameFieldValueChanged(_:)), for: .editingChanged)
        self.certView.idNumField.addTarget(self, action: #selector(idnumFieldValueChanged(_:)), for: .editingChanged)
        self.certView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(kScreenWidth)
        }
    }
}

// MARK: - Data(数据处理与加载)
extension RealNameCertController {
    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        self.couldDoneProcess()
        self.startLoading()
        // 获取认证请求
        CertificationNetworkManager.getRealNameCertDetail { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            self.stopLoading()
            guard status, let model = model else {
                //Toast.showToast(title: msg)
                return
            }
            // [注] 这里objectmapper解析时有默认值导致
            if let _ = model.statusValue {
                self.model = model
                if let userInfo = AccountManager.share.currentAccountInfo?.userInfo {
                    userInfo.certStatusValue = model.userCertStatus.rawValue
                    AccountManager.share.updateCurrentAccount(userInfo: userInfo)
                }
            }
            self.setupWithModel(model)
        }
    }

    /// 判断当前操作按钮(确定、登录、下一步...)是否可用
    fileprivate func couldDone() -> Bool {
        var flag: Bool = false
        guard let name = self.certView.nameField.text, let idnum = self.certView.idNumField.text, let _ = self.frontImgModel, let _ = self.backImgModel, let _ = self.handImgModel else {
            return flag
        }
        flag = (!name.isEmpty && !idnum.isEmpty)
        return flag
    }
    /// 操作按钮(确定、登录、下一步...)的可用性判断
    fileprivate func couldDoneProcess() -> Void {
        self.bottomBtn.isEnabled = self.couldDone()
        self.bottomBtnGradientLayer.isHidden = !self.couldDone()
    }

    /// 数据加载
    fileprivate func setupWithModel(_ model: RealNameCertModel?) -> Void {
        self.bottomBtn.isEnabled = false
        self.bottomBtnGradientLayer.isHidden = true
        guard let model = model else {
            return
        }
        self.certView.model = model
        switch model.status {
        case .wait:
            self.type = .wait
            self.certView.isUserInteractionEnabled = false
            self.bottomBtn.isEnabled = true
            self.bottomBtnGradientLayer.isHidden = true
            self.bottomBtn.isSelected = true
            self.bottomBtn.isUserInteractionEnabled = false
        case .success:
            self.type = .success
            self.certView.isUserInteractionEnabled = false
            self.bottomBtn.set(title: "认证成功", titleColor: UIColor.init(hex: 0x27BF4E), bgImage: UIImage.init(color: UIColor(hex: 0x27BF4E).withAlphaComponent(0.1)), for: .normal)
            self.bottomBtn.isEnabled = true
            self.bottomBtn.isUserInteractionEnabled = false
            self.bottomBtnGradientLayer.isHidden = true
            self.bottomBtn.set(cornerRadius: 0)
            self.bottomBtn.snp.remakeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        case .failure:
            self.type = .update
            self.bottomBtn.isEnabled = false
            self.bottomBtnGradientLayer.isHidden = true
            self.frontImgModel = nil //ImageUploadModel.init(filename: model.strFront)
            self.backImgModel = nil //ImageUploadModel.init(filename: model.strBack)
            self.handImgModel = nil //ImageUploadModel.init(filename: model.strHand)
        }
    }
}

// MARK: - Event(事件响应)
extension RealNameCertController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    /// 导航栏返回处理
    @objc fileprivate func backItemClick() -> Void {
        self.navigationController?.popViewController(animated: true)
    }

    /// 点击手势处理
    @objc fileprivate func tapGRProcess(_ tapGR: UITapGestureRecognizer) -> Void {
        if tapGR.state == .ended {
            self.view.endEditing(true)
        }
    }

    /// 提交按钮点击
    @objc fileprivate func submitBtnClick(_ button: UIButton) -> Void {
        self.view.endEditing(true)
        guard let name = self.certView.nameField.text, let idnum = self.certView.idNumField.text, let frontModel = self.frontImgModel, let backModel = self.backImgModel, let handModel = self.handImgModel else {
            return
        }
        self.submitCertification(name: name, idnum: idnum, front: frontModel, back: backModel, hand: handModel)
    }

    @objc fileprivate func nameFieldValueChanged(_ textField: UITextField) -> Void {
        guard let _ = textField.text else {
            return
        }
        TextFieldHelper.limitTextField(textField, withMaxLen: Int.max)
        self.couldDoneProcess()
    }
    @objc fileprivate func idnumFieldValueChanged(_ textField: UITextField) -> Void {
        guard let _ = textField.text else {
            return
        }
        TextFieldHelper.limitTextField(textField, withMaxLen: Int.max)
        self.couldDoneProcess()
    }

}

// MARK: - Notification
extension RealNameCertController {

}

// MARK: - Extension Function
extension RealNameCertController {
    /// 显示图片选择弹窗
    fileprivate func showImagePickerVC(for type: CertificationImagePickerType) {
        self.imgPickerType = type
        guard let picker = TZImagePickerHelper.getImagePicker(count: 1, delegate: self) else {
            return
        }
        RootManager.share.showRootVC.present(picker, animated: true, completion: nil)
    }

    fileprivate func uploadImage(_ image: UIImage) -> Void {
        let indicator = AppLoadingView.init(title: "上传中")
        indicator.show()
        self.view.isUserInteractionEnabled = false
        UploadManager.share.uploadImages([image], ModuleName: "") { [weak self](status, msg, models) in
            guard let `self` = self else {
                return
            }
            indicator.dismiss()
            self.view.isUserInteractionEnabled = true
            let message: String? = status ? "上传成功" : msg
            Toast.showToast(title: message)
            guard status, let model = models?.first else {
                switch self.imgPickerType {
                case .front:
                    self.certView.idCardFrontBtn.setBackgroundImage(UIImage.init(named: "IMG_icon_certification_front"), for: .normal)
                case .back:
                    self.certView.idCardFrontBtn.setBackgroundImage(UIImage.init(named: "IMG_icon_certification_verso"), for: .normal)
                case .hand:
                    self.certView.handHoldBtn.setBackgroundImage(UIImage.init(named: "IMG_icon_certification_other"), for: .normal)
                }
                return
            }
            switch self.imgPickerType {
            case .front:
                self.frontImgModel = model
            case .back:
                self.backImgModel = model
            case .hand:
                self.handImgModel = model
            }
            self.couldDoneProcess()
        }
    }

    /// 提交认证
    fileprivate func submitCertification(name: String, idnum: String, front: ImageUploadModel, back: ImageUploadModel, hand: ImageUploadModel) -> Void {
        let complete: ((_ status: Bool, _ msg: String?, _ model: RealNameCertModel?) -> Void) = { [weak self](status, msg, model) in
            guard let `self` = self else {
                return
            }
            guard status, let model = model else {
                Toast.showToast(title: msg)
                return
            }
            self.model = model
            self.setupWithModel(model)
            // 认证提交通知
            NotificationCenter.default.post(name: NSNotification.Name.User.certSubmit, object: nil, userInfo: nil)
        }
        // TODO: - 具体请求部分待完成
        switch self.type {
        case .apply:
            CertificationNetworkManager.applyRealNameCert(frontImg: front.filename, backImg: back.filename, handImg: hand.filename, name: name, idNo: idnum, complete: complete)
        case .update:
            CertificationNetworkManager.updateRealNameCert(frontImg: front.filename, backImg: back.filename, handImg: hand.filename, name: name, idNo: idnum, complete: complete)
        default:
            break
        }
        if let userInfo = AccountManager.share.currentAccountInfo?.userInfo {
            userInfo.certStatusValue = UserCertificationStatus.waiting.rawValue
            AccountManager.share.updateCurrentAccount(userInfo: userInfo)
        }
    }

}

// MARK: - Delegate Function

// MARK: - <UIScrollViewDelegate>
extension RealNameCertController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

// MARK: - <CertificationViewProtocol>
extension RealNameCertController: RealNameCertViewProtocol {
    func certView(_ certView: RealNameCertView, didClickedIdCardFont frontBtn: UIButton) -> Void {
        if let model = self.model, model.status == .wait || model.status == .success {
            return
        }
        self.showImagePickerVC(for: .front)
    }
    func certView(_ certView: RealNameCertView, didClickedIdCardBack backBtn: UIButton) -> Void {
        if let model = self.model, model.status == .wait || model.status == .success {
            return
        }
        self.showImagePickerVC(for: .back)
    }
    /// 手持照
    func certView(_ certView: RealNameCertView, didClickedHandHold holdBtn: UIButton) -> Void {
        if let model = self.model, model.status == .wait || model.status == .success {
            return
        }
        self.showImagePickerVC(for: .hand)
    }
}

// MARK: - <TZImagePickerControllerDelegate>
extension RealNameCertController: TZImagePickerControllerDelegate {

    /// 选中图片回调
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        guard let selectedImage = photos.first else {
            return
        }
        switch self.imgPickerType {
        case .front:
            self.certView.idCardFrontBtn.setBackgroundImage(selectedImage, for: .normal)
        case .back:
            self.certView.idCardBackBtn.setBackgroundImage(selectedImage, for: .normal)
        case .hand:
            self.certView.handHoldBtn.setBackgroundImage(selectedImage, for: .normal)
        }
        self.uploadImage(selectedImage)
    }

}
