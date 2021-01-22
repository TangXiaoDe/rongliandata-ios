//
//  XDMarqueeView.swift
//  HZProject
//
//  Created by 小唐 on 2020/11/16.
//  Copyright © 2020 ChainOne. All rights reserved.
//
//  

import UIKit

class XDMarqueeView: UIView
{
    
    // MARK: - Internal Property
    
    public var text: String = "" {
        didSet {
            text = text.replacingOccurrences(of: "\n", with: "")
            self.textLabel.text = text
            self.setNeedsLayout()
        }
    }

    public var textColor: UIColor = .init(hex: 0x666666) {
        didSet {
            self.textLabel.textColor = textColor
        }
    }


    public var textFont: UIFont = UIFont.pingFangSCFont(size: 14) {
        didSet {
            self.textLabel.font = textFont
        }
    }
    
    // MARK: - Private Property
    
    fileprivate let mainView: UIView = UIView()
    fileprivate let scrollView: UIScrollView = UIScrollView.init()
    fileprivate let textLabel: UILabel = UILabel.init()
    
    private weak var displayLink: CADisplayLink?
    private var duration: TimeInterval = 0
    /// 是否向左滚动标记
    private var isLeft: Bool = false
    /// 是否需要滚动标记
    private var isCanRun: Bool = true


    
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
    
    deinit {
        self.displayLink?.invalidate()
        self.displayLink = nil
    }
    
    /// 通用初始化：UI、配置、数据等
    func commonInit() -> Void {
        self.initialUI()
    }
    
}

// MARK: - Internal Function
extension XDMarqueeView {
    class func loadXib() -> XDMarqueeView? {
        return Bundle.main.loadNibNamed("XDMarqueeView", owner: nil, options: nil)?.first as? XDMarqueeView
    }

}

// MARK: - LifeCircle Function
extension XDMarqueeView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInAwakeNib()
    }
    
    /// 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        let textSize = self.text.size(maxSize: CGSize.init(width: CGFloat.max, height: 20), font: self.textFont)
        let margin: CGFloat = 30
        let textWith = textSize.width + margin * 2
        self.scrollView.contentSize = CGSize.init(width: 0, height: textWith)
        self.textLabel.frame = CGRect.init(x: 0, y: 0, width: textWith, height: textSize.height)
        self.duration = -min(TimeInterval(self.text.size(maxSize: CGSize.init(width: CGFloat.max, height: 20), font: self.textFont).width), Double(self.width))
        self.isCanRun = textWith > self.width
        self.displayLink?.isPaused = self.width >= textWith
    }
    
}
// MARK: - Private UI 手动布局
extension XDMarqueeView {
    
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
        // 1. scrollView
        mainView.addSubview(self.scrollView)
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.height.equalToSuperview()
        }
        // 2. textLabel
        self.scrollView.addSubview(self.textLabel)
        self.textLabel.set(text: nil, font: self.textFont, textColor: self.textColor)
        self.textLabel.snp.makeConstraints { (make) in
            make.leading.top.bottom.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        // 3.
        let displayLink = CADisplayLink.init(target: self, selector: #selector(timerEvent))
        displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        displayLink.isPaused = true
        self.displayLink = displayLink
    }
    
}
// MARK: - Private UI Xib加载后处理
extension XDMarqueeView {
    /// awakeNib时的处理
    fileprivate func initialInAwakeNib() -> Void {
        
    }

}

// MARK: - Data Function
extension XDMarqueeView {
    /// 数据加载
    fileprivate func setupWithModel(_ model: String?) -> Void {
        guard let _ = model else {
            return
        }
        // 子控件数据加载
    }
    
}

// MARK: - Event Function
extension XDMarqueeView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.displayLink?.isPaused = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isCanRun {
            self.displayLink?.isPaused = false
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isCanRun {
            self.displayLink?.isPaused = false
        }
    }
    
    /// 定时器事件
    @objc private func timerEvent() {
        let maxWidth: CGFloat = self.text.size(maxSize: CGSize.init(width: CGFloat.max, height: 20), font: self.textFont).width
        let scale: TimeInterval = 0.5
        if self.duration < 0 {
            self.isLeft = false
            self.duration += scale
        }
        else if (self.duration >= 0 && self.duration <= TimeInterval(maxWidth)) {
            if self.isLeft {
                self.duration -= scale
            }
            else {
                self.duration += scale
            }
        }
        else {
            self.duration = -min(TimeInterval(self.text.size(maxSize: CGSize.init(width: CGFloat.max, height: 20), font: self.textFont).width), Double(self.width))
//            self.isLeft = false
//            self.duration -= scale
        }
        self.scrollView.setContentOffset(CGPoint.init(x: self.duration, y: 0), animated: false)
    }

}

// MARK: - Extension Function
extension XDMarqueeView {
    
}

// MARK: - Delegate Function

// MARK: - <XXXDelegate>
extension XDMarqueeView {
    
}

