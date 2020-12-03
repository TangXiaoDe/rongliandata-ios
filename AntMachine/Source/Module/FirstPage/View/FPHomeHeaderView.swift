//
//  FPHomeHeaderView.swift
//  HZProject
//
//  Created by 小唐 on 2020/11/13.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  首页顶部视图

import UIKit

protocol FPHomeHeaderViewProtocol: class {
    /// 通知内容点击回调
    func headerView(_ headerView: FPHomeHeaderView, didClickedNoticeContent contentView: UIView, with model: MessageListModel) -> Void
    /// 通知右侧全部按钮点击回调
    func headerView(_ headerView: FPHomeHeaderView, didClickedNoticeAll allView: UIView) -> Void
}

class FPHomeHeaderView: UIView
{
    
    // MARK: - Internal Property
    
    var model: FirstPageHomeModel? {
        didSet {
            self.setupWithModel(model)
        }
    }
    
    weak var delegate: FPHomeHeaderViewProtocol?

    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView()
    
    fileprivate let bannerView: AdvertBannerView = AdvertBannerView()
    
    fileprivate let noticeView: UIView = UIView.init()
    fileprivate let noticeIconView: UIImageView = UIImageView.init()    // 通知图标
    //fileprivate let noticeContentView: UILabel = UILabel.init()         // 自动横向滚动
    fileprivate let noticeContentView: XDMarqueeView = XDMarqueeView.init()
    fileprivate let noticeMenuView: UIButton = UIButton.init(type: .custom) // 全部通知
    
    fileprivate let ipfsView: UIView = UIView.init()
    fileprivate let totalPowerItemView: TitleValueView = TitleValueView.init()    // 全网总算力
    fileprivate let tipsetHeightItemView: TitleValueView = TitleValueView.init()  // 最新区块高度
    
    
    fileprivate let bannerHeight: CGFloat = CGSize(width: 351, height: 140).scaleAspectForWidth(kScreenWidth - 24.0).height
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let bannerTopMargin: CGFloat = 12
    
    fileprivate let noticeTopMargin: CGFloat = 16
    fileprivate let noticeViewHeight: CGFloat = 36
    fileprivate let noticeIconWH: CGFloat = 20
    fileprivate let noticeIconLeftMargin: CGFloat = 8
    fileprivate let noticeMenuWidth: CGFloat = 36   //  noticeViewHeight
    fileprivate let noticeContentLrMargin: CGFloat = 15

    fileprivate let itemColCount: Int = 2
    fileprivate let itemTopMargin: CGFloat = 15
    fileprivate let itemBottomMargin: CGFloat = 0
    fileprivate let itemHorMargin: CGFloat = 8
    fileprivate let itemVerMargin: CGFloat = 8
    fileprivate lazy var itemWidth: CGFloat = {
        let width: CGFloat = (kScreenWidth - self.lrMargin * 2.0 - self.itemHorMargin * CGFloat(self.itemColCount - 1)) / CGFloat(self.itemColCount)
        return width
    }()
    fileprivate lazy var itemHeight: CGFloat = {
        let size: CGSize = CGSize.init(width: 171, height: 58).scaleAspectForWidth(self.itemWidth)
        return size.height
    }()

    // MARK: - Initialize Function
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        //fatalError("init(coder:) has not been implemented")
    }
    
    /// 通用初始化：UI、配置、数据等
    func commonInit() -> Void {
        self.initialUI()
    }
    
}

// MARK: - Internal Function
extension FPHomeHeaderView {
    class func loadXib() -> FPHomeHeaderView? {
        return Bundle.main.loadNibNamed("FPHomeHeaderView", owner: nil, options: nil)?.first as? FPHomeHeaderView
    }

}

// MARK: - LifeCircle Function
extension FPHomeHeaderView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
    
    /// 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
// MARK: - Private UI 手动布局
extension FPHomeHeaderView {
    
    /// 界面布局
    fileprivate func initialUI() -> Void {
        //
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    ///
    fileprivate func initialMainView(_ mainView: UIView) -> Void {
        // 1. bannerView
        mainView.addSubview(self.bannerView)
        self.bannerView.delegate = self
        self.bannerView.itemHeight = self.bannerHeight
        self.bannerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(self.bannerTopMargin)
            make.height.equalTo(self.bannerHeight)
        }
        // 2. noticeView
        mainView.addSubview(self.noticeView)
        self.initialNoticeView(self.noticeView)
        self.noticeView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(self.lrMargin)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalTo(self.bannerView.snp.bottom).offset(self.noticeTopMargin)
            make.height.equalTo(self.noticeViewHeight)
        }
        // 3. ipfsView
        mainView.addSubview(self.ipfsView)
        self.initialIpfsView(self.ipfsView)
        self.ipfsView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.noticeView.snp.bottom).offset(0)
            make.bottom.equalToSuperview().offset(0)
        }
    }
    //
    fileprivate func initialNoticeView(_ noticeView: UIView) -> Void {
        noticeView.set(cornerRadius: 5)
        noticeView.backgroundColor = UIColor.white
        // 1. noticeIconView
        noticeView.addSubview(self.noticeIconView)
        self.noticeIconView.set(cornerRadius: 0)
        self.noticeIconView.image = UIImage.init(named: "IMG_home_icom_tongzhi")
        self.noticeIconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(self.noticeIconWH)
            make.leading.equalToSuperview().offset(self.noticeIconLeftMargin)
        }
        // 2. noticeMenuView
        noticeView.addSubview(self.noticeMenuView)
        self.noticeMenuView.setImage(UIImage.init(named: "IMG_home_icon_notice_more"), for: .normal)
        self.noticeMenuView.setImage(UIImage.init(named: "IMG_home_icon_notice_more"), for: .highlighted)
        self.noticeMenuView.addTarget(self, action: #selector(noticeMenuBtnClick(_:)), for: .touchUpInside)
        self.noticeMenuView.snp.makeConstraints { (make) in
            make.width.equalTo(self.noticeMenuWidth)
            make.top.bottom.trailing.centerY.equalToSuperview()
        }
        // 3. noticeContentView
        noticeView.addSubview(self.noticeContentView)
        //self.noticeContentView.set(text: nil, font: UIFont.pingFangSCFont(size: 14), textColor: UIColor.init(hex: 0x666666))
        self.noticeContentView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.noticeIconView.snp.trailing).offset(self.noticeContentLrMargin)
            make.trailing.equalTo(self.noticeMenuView.snp.leading).offset(-self.noticeContentLrMargin)
        }
    }
    ///
    fileprivate func initialIpfsView(_ ipfsView: UIView) -> Void {
        let titleLrMargin: CGFloat = 20
        let titleCenterYBottomMargin: CGFloat = 18  // super.bottom
        let valueCenterYTopMargin: CGFloat = 18     // super.top
        //
        ipfsView.removeAllSubviews()
        let itemViews: [TitleValueView] = [self.totalPowerItemView, self.tipsetHeightItemView]
        let titles: [String] = ["全网总算力(PIB)", "最新区块高度"]
        let bgImgNames: [String] = ["IMG_img_home_bg_pib", "IMG_img_home_bg_qkgd"]
        for (index, itemView) in itemViews.enumerated() {
            let row: Int = index / self.itemColCount
            let col: Int = index % self.itemColCount
            ipfsView.addSubview(itemView)
            itemView.set(cornerRadius: 5)
            itemView.snp.makeConstraints { (make) in
                make.height.equalTo(self.itemHeight)
                make.width.equalTo(self.itemWidth)
                let leftMargin: CGFloat = self.lrMargin + (self.itemWidth + self.itemHorMargin) * CGFloat(col)
                let topMargin: CGFloat = self.itemTopMargin + (self.itemHeight + self.itemVerMargin) * CGFloat(row)
                let rightMargin: CGFloat = kScreenWidth - leftMargin - self.itemWidth
                make.top.equalToSuperview().offset(topMargin)
                make.leading.equalToSuperview().offset(leftMargin)
                if index == itemViews.count - 1 {
                    make.trailing.equalToSuperview().offset(-rightMargin)
                    make.bottom.equalToSuperview().offset(-self.itemBottomMargin)
                }
            }
            // 1. bg
            let bgView: UIImageView = UIImageView.init()
            itemView.addSubview(bgView)
            itemView.sendSubviewToBack(bgView)
            bgView.set(cornerRadius: 0)
            bgView.image = UIImage.init(named: bgImgNames[index])
            bgView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            // 2. title
            itemView.titleLabel.set(text: titles[index], font: UIFont.pingFangSCFont(size: 12), textColor: UIColor.white)
            itemView.titleLabel.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview().offset(titleLrMargin)
                make.trailing.lessThanOrEqualToSuperview()
                make.centerY.equalTo(itemView.snp.bottom).offset(-titleCenterYBottomMargin)
            }
            // 3. value
            itemView.valueLabel.set(text: nil, font: UIFont.pingFangSCFont(size: 16, weight: .medium), textColor: UIColor.white)
            itemView.valueLabel.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview().offset(titleLrMargin)
                make.trailing.lessThanOrEqualToSuperview()
                make.centerY.equalTo(itemView.snp.top).offset(valueCenterYTopMargin)
            }
        }
    }
    
}
// MARK: - Private UI Xib加载后处理
extension FPHomeHeaderView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension FPHomeHeaderView {
    ///
    fileprivate func setupAsDemo() -> Void {
        self.bannerView.backgroundColor = UIColor.random
        self.bannerView.models = []
        self.noticeContentView.text = "合众IPFS合众IPFS合众IPFS合众IPFS合众IPFS合众IPFS合众IPFS合众IPFS"
        self.totalPowerItemView.valueLabel.text = "499200"
        self.tipsetHeightItemView.valueLabel.text = "76251"
    }
    /// 数据加载
    fileprivate func setupWithModel(_ model: FirstPageHomeModel?) -> Void {
        //self.setupAsDemo()
        guard let model = model else {
            return
        }
        // 子控件数据加载
        self.bannerView.models = model.averts
        self.noticeContentView.text = model.newstNotice?.content ?? ""
        self.totalPowerItemView.valueLabel.text = model.ipfs?.total_power
        self.tipsetHeightItemView.valueLabel.text = model.ipfs?.tipset_height
        
        let showAdverts: Bool = !model.averts.isEmpty
        self.bannerView.isHidden = !showAdverts
        self.bannerView.snp.makeConstraints { (make) in
            let topMargin: CGFloat = showAdverts ? self.bannerTopMargin : 0
            let height: CGFloat = showAdverts ? self.bannerHeight : 0
            make.top.equalToSuperview().offset(topMargin)
            make.height.equalTo(height)
        }
        
        let showNotice: Bool = model.newstNotice != nil
        self.noticeView.isHidden = !showNotice
        self.noticeView.snp.updateConstraints { (make) in
            let topMargin: CGFloat = showNotice ? self.noticeTopMargin : 0
            let height: CGFloat = showNotice ? self.noticeViewHeight : 0
            make.top.equalTo(self.bannerView.snp.bottom).offset(topMargin)
            make.height.equalTo(height)
        }
        
        self.mainView.layoutIfNeeded()
    }
    
}

// MARK: - Event Function
extension FPHomeHeaderView {
    ///
    @objc fileprivate func noticeMenuBtnClick(_ button: UIButton) -> Void {
        print("FPHomeHeaderView noticeMenuBtnClick")
        self.delegate?.headerView(self, didClickedNoticeAll: button)
    }

}

// MARK: - Extension Function
extension FPHomeHeaderView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension FPHomeHeaderView {
    
}



// MARK: - <AdvertBannerViewProtocol>
extension FPHomeHeaderView: AdvertBannerViewProtocol {
    func advertBanner(_ bannerView: AdvertBannerView, didSelected advert: AdvertModel, at index: Int) {

    }

}
