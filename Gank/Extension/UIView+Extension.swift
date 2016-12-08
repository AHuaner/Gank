//
//  UIView+Extension.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/7.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

extension UIView {
    
    var X:CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newX) {
            self.frame.origin.x = newX
        }
    }
    
    var Y:CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newY) {
            self.frame.origin.y = newY
        }
    }
    
    var Height:CGFloat {
        get {
            return self.frame.size.height
        }
        set(newHeight) {
            self.frame.size.height = newHeight
        }
    }
    
    var Width:CGFloat {
        get {
            return self.frame.size.width
        }
        set(newWidth) {
            self.frame.size.width = newWidth
        }
    }
    
    var CenterX:CGFloat {
        get {
            return self.center.x
        }
        set(newCenterX) {
            self.center.x = newCenterX
        }
    }
    
    var CenterY:CGFloat {
        get {
            return self.center.y
        }
        set(newCenterY) {
            self.center.y = newCenterY
        }
    }
    
    class func viewFromNib() -> Any? {
        return Bundle.main.loadNibNamed(self.getClassName(), owner: nil, options: nil)?.last as Any?
    }
}
