//
//  MineHomeIncomeInfoView.swift
//  LianYouPin
//
//  Created by zhaowei on 2020/1/8.
//  Copyright © 2020 COMC. All rights reserved.
//
// 我的主页收益view

import Foundation
import UIKit

protocol MineHomeIncomeInfoViewProtocol: class {
    //点击全部
    func incomeInfoView(_ view: MineHomeIncomeInfoView, didTapPageAt index: Int) -> Void
}

class MineHomeIncomeInfoView: UIControl {

    static var viewHeight: CGFloat {
        return CGSize.init(width: 351, height: 140).scaleAspectForWidth(kScreenWidth - 2 * 12).height
    }
    // MARK: - Internal Property
    let viewWidth: CGFloat
    
    var models: [WalletAllInfoModel]? {
        didSet {
            self.setupModels(models)
        }
    }
    weak var delegate: MineHomeIncomeInfoViewProtocol?

    fileprivate let mainView: UIView = UIView()
    fileprivate let bgImgView: UIImageView = UIImageView()
    /// 累计收益
    fileprivate var totalMoneyView: TopTitleBottomTitleControl = TopTitleBottomTitleControl()
    /// 可提现
    fileprivate var soonMoneyView: TopTitleBottomTitleControl = TopTitleBottomTitleControl()
    /// 资产余额
    fileprivate var balanceMoneyView: TopTitleBottomTitleControl = TopTitleBottomTitleControl()
    
    fileprivate let moreIconView = UIImageView()
    let pagedView: PagedFlowView = PagedFlowView()
    
    fileprivate let bottomMargin: CGFloat = 15
    
    fileprivate let lrMargin: CGFloat = 12
    
    fileprivate let bgViewSize: CGSize = CGSize.init(width: 351, height: 140).scaleAspectForWidth(kScreenWidth - 2 * 12)

    fileprivate var itemMaxWidth: CGFloat {
        return (kScreenWidth - 2 * self.lrMargin) / 3
    }

    // MARK: - Private Property

    // MARK: - Initialize Function
    init(viewWidth: CGFloat) {
        self.viewWidth = viewWidth
        super.init(frame: CGRect.zero)
        self.initialUI()
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal Function
extension MineHomeIncomeInfoView {

}

// MARK: - LifeCircle Function
extension MineHomeIncomeInfoView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
}
// MARK: - Private UI 手动布局
extension MineHomeIncomeInfoView {

    /// 界面布局
    fileprivate func initialUI() -> Void {
        self.addSubview(self.mainView)
        self.initialMainView(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func initialMainView(_ mainView: UIView) {
        mainView.addSubview(self.pagedView)
        self.pagedView.dataSource = self
        self.pagedView.delegate = self
        self.pagedView.minimumPageAlpha = 0.95
        self.pagedView.minimumPageScale = 0.85
        self.pagedView.orientation = PagedFlowViewOrientationHorizontal
        self.pagedView.snp.makeConstraints { (make) in
            //make.edges.equalToSuperview()
            // edges约束总会让左侧看到一点左侧的图片，故左右减少1的间距
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(1)
            make.trailing.equalToSuperview().offset(-1)
        }
    }
}
// MARK: - Private UI Xib加载后处理
extension MineHomeIncomeInfoView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {

    }
}

// MARK: - Data Function
extension MineHomeIncomeInfoView {
    fileprivate func setupModels(_ models: [WalletAllInfoModel]?) -> Void {
        guard let models = models else {
            return
        }
        self.pagedView.reloadData()
    }
}

// MARK: - Event Function
//extension MineHomeIncomeInfoView {
//    /// 全部收入按钮点击
//    @objc fileprivate func allIncomeBtnClick(_ tapGR: UITapGestureRecognizer) -> Void {
//        guard  let view = tapGR.view else {
//            return
//        }
//        self.delegate?.incomeInfoView(self, clickAllIncomeControl: view)
//    }
//}
// MARK: - <HQFlowViewDataSource>
extension MineHomeIncomeInfoView: PagedFlowViewDataSource {
    func numberOfPages(in flowView: PagedFlowView!) -> Int {
        return self.models?.count ?? 0
    }

    func flowView(_ flowView: PagedFlowView!, cellForPageAt index: Int) -> UIView! {
        var itemView = flowView.dequeueReusableCell() as? MineHomeIncomeInfoItemView
        if itemView == nil {
            itemView = MineHomeIncomeInfoItemView()
            itemView?.layer.cornerRadius = 10
        }
        var model: WalletAllInfoModel?
        for i in 0..<self.models!.count {
            let item = self.models?[i]
            if item?.currency == "fil" && index == 0 {
                model = item
            } else if item?.currency == "xch" && index == 1 {
                model = item
            }
        }
        itemView?.model = model
        return itemView
    }
}

// MARK: - <HQFlowViewDelegate>
extension MineHomeIncomeInfoView: PagedFlowViewDelegate {
    func flowView(_ flowView: PagedFlowView!, didTapPageAt index: Int) {
        self.delegate?.incomeInfoView(self, didTapPageAt: index)
    }

    func sizeForPage(in flowView: PagedFlowView!) -> CGSize {
        let height = CGSize.init(width: 280, height: 140).scaleAspectForWidth(kScreenWidth - 95).height
        let size = CGSize.init(width: kScreenWidth - 95, height: height)
        return size
    }
}
