//
//  PreReturnGuideController.swift
//  AntClusterB
//
//  Created by 小唐 on 2021/8/5.
//  Copyright © 2021 ChainOne. All rights reserved.
//
//  (设备模块中)提前归还界面

import UIKit

protocol PreReturnGuideControllerProtocol: class {
    
    /// skip / close
    func guideVC(_ guideVC: PreReturnGuideController, didClickedSkip skipView: UIButton) -> Void
    /// done
    func guideVC(_ guideVC: PreReturnGuideController, didClickedDone doneView: UIButton) -> Void
    
}

typealias EquipPreReturnGuideController = PreReturnGuideController
class PreReturnGuideController: BaseViewController
{

    // MARK: - Internal Property
    
    weak var delegate: PreReturnGuideControllerProtocol?
    
    fileprivate var selectedIndex: Int = 0 {
        didSet {
            if oldValue == selectedIndex {
                return
            }
            let bgImgName: String = selectedIndex < self.itemCount - 1 ? "IMG_shebei_button_zhiyin_tiaoguo" : "IMG_shebei_button_zhiyin_close"
            self.skipBtn.setBackgroundImage(UIImage.init(named: bgImgName), for: .normal)
            self.skipBtn.setBackgroundImage(UIImage.init(named: bgImgName), for: .normal)
            self.pageControl.image = UIImage.init(named: "IMG_shebei_icon_zhiyin_step\(selectedIndex + 1)")
            self.doneBtn.isHidden = selectedIndex < self.itemCount - 1
        }
    }
    
    // MARK: - Private Property
    
    fileprivate let scrollView: UIScrollView = UIScrollView.init()
    
    fileprivate let skipBtn: UIButton = UIButton.init(type: .custom)    // 跳过、关闭
    fileprivate let pageControl: UIImageView = UIImageView.init()       //
    fileprivate let doneBtn: UIButton = UIButton.init(type: .custom)    // 立即体验
    
    fileprivate let itemCount: Int = 3
    fileprivate let itemTagBase: Int = 250
    
    
    fileprivate let skipBtnSize: CGSize = CGSize.init(width: 60, height: 24)
    fileprivate let pageViewSize: CGSize = CGSize.init(width: 72, height: 3)
    fileprivate let doneBtnSize: CGSize = CGSize.init(width: 108, height: 50)
    
    fileprivate let lrMargin: CGFloat = 12
    fileprivate let skipBtnTopMargin: CGFloat = 54
    fileprivate let pageViewCenterYMultiply: CGFloat = (517.0 / 812.0)
    fileprivate let doneBtnTopMargin: CGFloat = 25
    
    
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
extension PreReturnGuideController {
    
}

// MARK: - LifeCircle/Override Function
extension PreReturnGuideController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUI()
        self.initialDataSource()
    }
    
}

// MARK: - UI Function
extension PreReturnGuideController {

    /// 页面布局
    fileprivate func initialUI() -> Void {
        self.view.backgroundColor = AppColor.pageBg
        //
        // scrollView
        self.view.addSubview(self.scrollView)
        self.initialScrollView(self.scrollView)
        self.scrollView.frame = self.view.bounds
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// scrollView 布局
    fileprivate func initialScrollView(_ scrollView: UIScrollView) -> Void {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        //
        let scrollViewH: CGFloat = kScreenHeight
        for index in 0..<self.itemCount {
            let itemView: IconContainer = IconContainer.init()
            scrollView.addSubview(itemView)
            itemView.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(kScreenWidth)
                make.height.equalTo(scrollViewH)
                make.leading.equalToSuperview().offset(CGFloat(index) * kScreenWidth)
                if index == self.itemCount - 1 {
                    make.trailing.equalToSuperview()
                }
            }
            //
            itemView.iconView.image = UIImage.init(named: "IMG_shebei_img_zhiyin_step\(index + 1)")
            itemView.iconView.contentMode = .scaleToFill
            itemView.iconView.snp.remakeConstraints { (make) in
                make.leading.trailing.width.top.equalToSuperview()
            }
        }
        scrollView.contentSize = CGSize.init(width: kScreenWidth * CGFloat(self.itemCount), height: scrollViewH)
        // skipBtn
        self.view.addSubview(self.skipBtn)
        self.skipBtn.setBackgroundImage(UIImage.init(named: "IMG_shebei_button_zhiyin_tiaoguo"), for: .normal)
        self.skipBtn.setBackgroundImage(UIImage.init(named: "IMG_shebei_button_zhiyin_tiaoguo"), for: .highlighted)
        self.skipBtn.addTarget(self, action: #selector(skipBtnClick(_:)), for: .touchUpInside)
        self.skipBtn.snp.makeConstraints { (make) in
            make.size.equalTo(self.skipBtnSize)
            make.trailing.equalToSuperview().offset(-self.lrMargin)
            make.top.equalToSuperview().offset(self.skipBtnTopMargin)
        }
        // pageControl
        self.view.addSubview(self.pageControl)
        self.pageControl.set(cornerRadius: 0)
        self.pageControl.image = UIImage.init(named: "IMG_shebei_icon_zhiyin_step1")
        self.pageControl.snp.makeConstraints { (make) in
            make.size.equalTo(self.pageViewSize)
            make.centerX.equalToSuperview()
            let topMargin: CGFloat = kScreenHeight * self.pageViewCenterYMultiply + 45
            make.centerY.equalTo(self.view.snp.top).offset(topMargin)
        }
        // doneBtn
        self.view.addSubview(self.doneBtn)
        self.doneBtn.setBackgroundImage(UIImage.init(named: "IMG_shebei_button_zhiyin_go"), for: .normal)
        self.doneBtn.setBackgroundImage(UIImage.init(named: "IMG_shebei_button_zhiyin_go"), for: .highlighted)
        self.doneBtn.addTarget(self, action: #selector(doneBtnClick(_:)), for: .touchUpInside)
        self.doneBtn.isHidden = true        // 默认隐藏
        self.doneBtn.snp.makeConstraints { (make) in
            make.size.equalTo(self.doneBtnSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.pageControl.snp.bottom).offset(self.doneBtnTopMargin)
        }
    }

}

// MARK: - Data Function
extension PreReturnGuideController {

    /// 默认数据加载
    fileprivate func initialDataSource() -> Void {
        self.setupAsDemo()
    }
    ///
    fileprivate func setupAsDemo() -> Void {
        
    }

}

// MARK: - Event Function
extension PreReturnGuideController {

    /// 跳过/关闭
    @objc fileprivate func skipBtnClick(_ button: UIButton) -> Void {
        NoviceGuideManager.share.setGuideCompleteState(true, for: .equipPreReturn)
        print("PreReturnGuideController navBarLeftItemClick")
        self.dismiss(animated: false, completion: nil)
        self.dismiss(animated: false) {
            DispatchQueue.main.async {
                self.delegate?.guideVC(self, didClickedSkip: button)
            }
        }
    }
    /// 完成/确定/马上体验
    @objc fileprivate func doneBtnClick(_ button: UIButton) -> Void {
        NoviceGuideManager.share.setGuideCompleteState(true, for: .equipPreReturn)
        print("PreReturnGuideController navBarRightItemClick")
        self.dismiss(animated: false) {
            DispatchQueue.main.async {
                self.delegate?.guideVC(self, didClickedDone: button)
            }
        }
    }

}

// MARK: - Request Function
extension PreReturnGuideController {
    
}

// MARK: - Enter Page
extension PreReturnGuideController {
    
}

// MARK: - Notification Function
extension PreReturnGuideController {
    
}

// MARK: - Extension Function
extension PreReturnGuideController {
    
}

// MARK: - Delegate Function

// MARK: - <UIScrollViewDelegate>
extension PreReturnGuideController: UIScrollViewDelegate {

    /// 滑动结束 回调
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollIndex: Int = Int(scrollView.contentOffset.x / kScreenWidth)
        self.selectedIndex = scrollIndex
    }

}

