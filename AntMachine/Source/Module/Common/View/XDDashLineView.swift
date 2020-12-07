//
//  XDDashLineView.swift
//  AntMachine
//
//  Created by 小唐 on 2019/7/26.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  虚线视图

import UIKit

/// 虚线视图
class XDDashLineView: UIView {

    // 实线虚线占比
    var lengths: [CGFloat] = [3.0, 1.5]
    var lineColor: UIColor = UIColor(hex: 0xbfbfbf)
    var lineWidth: CGFloat = 1.0
    var phase: CGFloat = 0

    init(lineColor: UIColor, lengths: [CGFloat], lineWidth: CGFloat = 1.0, phase: CGFloat = 0) {
        self.lineColor = lineColor
        self.lengths = lengths
        self.lineWidth = lineWidth
        self.phase = phase
        super.init(frame: CGRect.zero)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

//        let context = UIGraphicsGetCurrentContext()!
//
//        let point1: CGPoint = CGPoint.init(x: rect.minX, y: rect.midY)
//        let point2: CGPoint = CGPoint.init(x: rect.maxX, y: rect.midY)
//        context.setLineWidth(lineWidth)
//        context.setFillColor(UIColor.clear.cgColor)
//        context.setStrokeColor(self.lineColor.cgColor)
//
//        context.move(to: point1)
//        context.setLineDash(phase: self.phase, lengths: self.lengths)     // 虚线绘制起点
//        context.addLine(to: point2)
//        context.strokePath()
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = self.lineColor.cgColor
        
        shapeLayer.lineWidth = self.lineWidth
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPhase = self.phase
        shapeLayer.lineDashPattern = [NSNumber(value: 3.0), NSNumber(value: 1.5)]
        
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }

}
