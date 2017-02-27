//
//  UIView+Extension.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/7.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

extension UIView {
    
    var X: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newX) {
            self.frame.origin.x = newX
        }
    }
    
    var Y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newY) {
            self.frame.origin.y = newY
        }
    }
    
    var Height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newHeight) {
            self.frame.size.height = newHeight
        }
    }
    
    var Width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newWidth) {
            self.frame.size.width = newWidth
        }
    }
    
    var CenterX: CGFloat {
        get {
            return self.center.x
        }
        set(newCenterX) {
            self.center.x = newCenterX
        }
    }
    
    var CenterY: CGFloat {
        get {
            return self.center.y
        }
        set(newCenterY) {
            self.center.y = newCenterY
        }
    }
    
    var MaxX: CGFloat {
        get {
            return self.frame.maxX
        }
    }
    
    var MaxY: CGFloat {
        get {
            return self.frame.maxY
        }
    }
    
    class func viewFromNib() -> Any? {
        return Bundle.main.loadNibNamed(self.className, owner: nil, options: nil)?.last as Any?
    }
    
    class func nib() -> UINib {
        return UINib(nibName: self.className, bundle: nil)
    }
    
    // 判断一个控件是否真正显示在主窗口
    func isShowingOnKeyWindow() -> Bool {
        
        // 以主窗口左上角为坐标原点, 计算self的矩形框
        let newFrame = kWindow!.convert(self.frame, from: self.superview)
        let winBounds = kWindow!.bounds
        
        // 主窗口的bounds 和 self的矩形框 是否有重叠
        let intersects = newFrame.intersects(winBounds)
        return !self.isHidden && self.alpha > 0.01 && self.window == kWindow && intersects
    }
}
