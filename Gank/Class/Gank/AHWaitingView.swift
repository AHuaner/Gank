//
//  AHWaitingView.swift
//  Gank
//
//  Created by AHuaner on 2016/12/17.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

enum AHWaitingViewType {
    case AHDWaitingViewTypeLoop
    case AHDWaitingViewTypePie
}

class AHWaitingView: UIView {
    
    // 模式
    var tpye: AHWaitingViewType!
    
    // 进度
    var progresses: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
            if progresses >= 1 {
                removeFromSuperview()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RGBColor(0, g: 0, b: 0, alpha: 0.7)
        layer.cornerRadius = 5;
        clipsToBounds = true
        tpye = AHWaitingViewType.AHDWaitingViewTypeLoop
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let centenX = rect.size.width * 0.5
        let centenY = rect.size.height * 0.5
        UIColor.white.set()
        
        if self.tpye == AHWaitingViewType.AHDWaitingViewTypePie {
            let radius = min(centenX, centenY) - 10
            let w = radius * 2 + 10
            let h = w
            let x = (rect.size.width - w) * 0.5
            let y = (rect.size.height - h) * 0.5
            ctx.addEllipse(in: CGRect(x: x, y: y, width: w, height: h))
            ctx.fillPath()
            
            RGBColor(0, g: 0, b: 0, alpha: 0.7).set()
            ctx.move(to: CGPoint(x: centenX, y: centenY))
            ctx.addLine(to: CGPoint(x: centenX, y: 0))
            
            let to = CGFloat(-M_PI) * 0.5 + progresses * CGFloat(M_PI) * 2.0 + 0.001 // 初始值
            ctx.addArc(center: CGPoint(x: centenX, y: centenY), radius: radius, startAngle: CGFloat(-M_PI) * 0.5, endAngle: to, clockwise: false)
            ctx.closePath()
            ctx.fillPath()
        } else {
            ctx.setLineWidth(15)
            ctx.setLineCap(CGLineCap.round)
            let to = CGFloat(-M_PI) * 0.5 + progresses * CGFloat(M_PI) * 2.0 + 0.05; // 初始值0.05
            let radius = min(rect.size.width, rect.size.height) * 0.5 - 10.0;
            ctx.addArc(center: CGPoint(x: centenX, y: centenY), radius: radius, startAngle: CGFloat(-M_PI) * 0.5, endAngle: to, clockwise: false)
            ctx.strokePath()
        }
    }

}
