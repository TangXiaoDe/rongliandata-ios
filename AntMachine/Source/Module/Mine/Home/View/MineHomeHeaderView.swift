//
//  MineHomeHeaderView.swift
//  CCMall
//
//  Created by 小唐 on 2019/1/17.
//  Copyright © 2019 COMC. All rights reserved.
//
//  MineHome页的顶部视图
//  [注] 动画既可能固定再顶部视图，也可能固定悬浮在屏幕上，所以HeaderView和MineController里都有动画，根据需要选择加载即可；

import UIKit

protocol MineHomeHeaderViewProtocol: class {
    /// 通知点击回调
    func headerView(_ headerView: MineHomeHeaderView, didClickedNotice noticeBtn: UIButton) -> Void
    /// 用户点击回调
    func didClickedUserInfo(in headerView: MineHomeHeaderView) -> Void
    /// vip点击回调
    func didClickedUserInfo(in headerView: MineHomeHeaderView, didClickVipImageView imageView: UIImageView) -> Void
}

class MineHomeHeaderView: UIView {

    // MARK: - Internal Property

    static var viewHeight: CGFloat = 192 + kStatusBarHeight // 6s下267

    static let iconTopMargin: CGFloat = UIDevice.current.isiPhoneXSeries() ? 86 : 66

    /// 回调
    weak var delegate: MineHomeHeaderViewProtocol?

    var userModel: CurrentUserModel? {
        didSet {
            self.setupUserModel(userModel)
        }
    }
    var assetModel: AssetInfoModel? {
        didSet {
            self.setupAssetModel(assetModel)
        }
    }
    var unReadNum: Int? {
        didSet {
            self.setupunReadNum(unReadNum)
        }
    }
    // MARK: - Private Property

    fileprivate let mainView: UIView = UIView()

    fileprivate let bgImgView: UIImageView = UIImageView()

    let noticeBtn: UIButton = UIButton(type: .custom)
    fileprivate let unReadView: UIView = UIView()
    fileprivate let unReadNumLabel: UILabel = UILabel()

    /// 用户信息视图
    fileprivate let infoView: UIView = UIView()
    fileprivate let iconContainer: UIView = UIView()
    fileprivate let iconView: UIImageView = UIImageView()
    fileprivate let nameLabel: UILabel = UILabel()
    fileprivate let vipImgView: UIImageView = UIImageView()

    fileprivate let titleValueView: UIView = UIView()
    /// COMC
    fileprivate let comcItemView = TopTitleBottomTitleControl()
    /// 矿石
    fileprivate let oreItemView = TopTitleBottomTitleControl()
    /// 矿力
    fileprivate let powerItemView = TopTitleBottomTitleControl()

    fileprivate let animaViewTopMargin: CGFloat = 50 + kStatusBarHeight
    
    fileprivate let infoTopMargin: CGFloat = UIDevice.current.isiPhoneXSeries() ? 88 : 64
    fileprivate let iconWH: CGFloat = 50
    fileprivate let nameLeftMargin: CGFloat = 17
    fileprivate let nameDescVerMargin: CGFloat = 4
    
    fileprivate let incomeTopMargin: CGFloat = 25
    fileprivate let incomeBtnHeight: CGFloat = 28
    fileprivate let incomeBtnWidth: CGFloat = 80
    
    fileprivate let soonMoneyViewLeftMargin: CGFloat = 29 // super
    fileprivate let totalMoneyViewLeftMargin: CGFloat = 147 // super
    fileprivate let incomeBtnRightMargin: CGFloat = 12

    fileprivate let titleValueTopMargin: CGFloat = 36

    fileprivate let titleValueItemTagBase: Int = 250
    
    fileprivate let unreadViewHeight: CGFloat = 15

    fileprivate let lrMargin: CGFloat = 22
    fileprivate let titleValueBottomMargin: CGFloat = 60
    fileprivate let vipIconSize: CGSize = CGSize.init(width: 73, height: 22)

    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
        self.initialUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension MineHomeHeaderView {
    
}

// MARK: - LifeCircle Function
extension MineHomeHeaderView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension MineHomeHeaderView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. bgView
        mainView.addSubview(self.bgImgView)
        self.bgImgView.set(cornerRadius: 0)
        self.bgImgView.image = UIImage.init(named: "IMG_mine_top_bg")
        self.bgImgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 3. infoView
        mainView.addSubview(self.infoView)
        self.initialInfoView(self.infoView)
        self.infoView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(lrMargin)
            make.trailing.equalToSuperview().offset(-lrMargin)
            make.top.equalToSuperview().offset(infoTopMargin)
        }
        // 2. noticeBtn
        mainView.addSubview(self.noticeBtn)
        self.noticeBtn.setImage(UIImage.init(named: "IMG_mine_message"), for: .normal)
        self.noticeBtn.setImage(UIImage.init(named: "IMG_mine_message"), for: .selected)
        self.noticeBtn.addTarget(self, action: #selector(noticeBtnClick(_:)), for: .touchUpInside)
        self.noticeBtn.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        self.noticeBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(kStatusBarHeight)
        }
        // 3. unReadView
        mainView.addSubview(self.unReadView)
        self.unReadView.backgroundColor = AppColor.themeYellow
        self.unReadView.set(cornerRadius: self.unreadViewHeight/2)
        self.unReadView.snp.makeConstraints { (make) in
            make.left.equalTo(self.noticeBtn.snp.right).offset(-self.unreadViewHeight/2 - 10)
            make.bottom.equalTo(self.noticeBtn.snp.centerY).offset(0)
            make.height.equalTo(self.unreadViewHeight)
            make.width.greaterThanOrEqualTo(self.unreadViewHeight)
        }
        self.unReadView.isHidden = true
        self.unReadView.addSubview(self.unReadNumLabel)
        self.unReadNumLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 10), textColor: AppColor.title, alignment: .center)
        self.unReadNumLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
    }

    fileprivate func initialInfoView(_ infoView: UIView) -> Void {
        // 0. click
        let singleTapGR = UITapGestureRecognizer(target: self, action: #selector(infoViewSingleTap(_:)))
        infoView.addGestureRecognizer(singleTapGR)
        infoView.isUserInteractionEnabled = true
        // 2.x iconContainer
        infoView.addSubview(iconContainer)
        iconContainer.set(cornerRadius: (self.iconWH + 5.0) * 0.5, borderWidth: 5 * 0.5, borderColor: UIColor.init(hex: 0xf6f6f6).withAlphaComponent(0.5))
        iconContainer.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.iconWH + 5.0)
            make.top.bottom.leading.equalToSuperview()
        }
        // 2. iconView
        iconContainer.addSubview(self.iconView)
        self.iconView.set(cornerRadius: self.iconWH * 0.5)
        self.iconView.image = UIImage.init(named: "IMG_user_avatar_default")
        self.iconView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.iconWH)
            make.center.equalToSuperview()
        }
        // 3. nameLabel
        infoView.addSubview(self.nameLabel)
        self.nameLabel.set(text: nil, font: UIFont(name: "PingFangSC-Medium", size: 15), textColor: UIColor.white)
        self.nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(iconContainer.snp.trailing).offset(nameLeftMargin)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(iconContainer.snp.centerY).offset(-self.nameDescVerMargin * 0.5)
        }
        // 4. vipImgView
        infoView.addSubview(self.vipImgView)
        self.vipImgView.set(cornerRadius: 0)
        self.vipImgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(vipImgViewTap(_:))))
        self.vipImgView.isUserInteractionEnabled = true
        self.vipImgView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.nameLabel)
            make.top.equalTo(iconContainer.snp.centerY).offset(self.nameDescVerMargin * 0.5)
            make.size.equalTo(self.vipIconSize)
        }

        self.iconView.backgroundColor = UIColor.random
        self.nameLabel.text = "昵称"
    }

}
// MARK: - Private UI Xib加载后处理
extension MineHomeHeaderView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension MineHomeHeaderView {
    /// 数据加载
    fileprivate func setupUserModel(_ model: CurrentUserModel?) -> Void {
        guard let model = model else {
            return
        }
        self.nameLabel.text = model.name
        self.iconView.kf.setImage(with: model.avatarUrl, placeholder: kPlaceHolderAvatar, options: nil, progressBlock: nil, completionHandler: nil)
        self.vipImgView.isHidden = true
        self.nameLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(iconContainer.snp.trailing).offset(nameLeftMargin)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(iconContainer.snp.centerY).offset(0)
        }
    }
    fileprivate func setupAssetModel(_ model: AssetInfoModel?) -> Void {
        guard let model = model else {
            return
        }
//        self.powerItemView.topLabel.text = model.power.amount.decimalProcess(digits: 0)
//        self.oreItemView.topLabel.text = model.ore.amount.decimalProcess(digits: 4)
//        self.comcItemView.topLabel.text = model.comc.amount.decimalProcess(digits: 4)
        self.layoutIfNeeded()
    }
    
    fileprivate func setupunReadNum(_ num: Int?) -> Void {
        guard let unReadCount = num else {
            return
        }
        if unReadCount != 0 {
            self.unReadView.isHidden = false
            if unReadCount > 99 {
                self.unReadNumLabel.text = "99+"
            } else {
                self.unReadNumLabel.text = "\(unReadCount)"
            }
        } else {
            self.unReadView.isHidden = true
        }
    }
}

// MARK: - Event Function
extension MineHomeHeaderView {

    /// 通知按钮点击响应
    @objc fileprivate func noticeBtnClick(_ button: UIButton) -> Void {
        self.delegate?.headerView(self, didClickedNotice: button)
    }
    
    @objc fileprivate func vipImgViewTap(_ tagGR: UITapGestureRecognizer) -> Void {
        if let tagView = tagGR.view as? UIImageView {
            self.delegate?.didClickedUserInfo(in: self, didClickVipImageView: tagView)
        }
    }
}

// MARK: - Tap Gesture
extension MineHomeHeaderView {
    
    /// 个人信息点击事件
    @objc fileprivate func infoViewSingleTap(_ tapGR: UITapGestureRecognizer) -> Void {
        if tapGR.state == .ended {
            self.delegate?.didClickedUserInfo(in: self)
        }
    }
    
}
