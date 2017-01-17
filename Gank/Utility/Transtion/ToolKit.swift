//
//  ToolKit.swift
//  Gank
//
//  Created by AHuaner on 2017/1/13.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit
import SVProgressHUD

class ToolKit: NSObject {
    
}

extension ToolKit {
    class func show(withStatus status: String!, style: SVProgressHUDStyle = .light) {
        SVProgressHUD.setDefaultStyle(style)
        SVProgressHUD.show(withStatus: status)
    }
    
    class func showInfo(withStatus status: String!, style: SVProgressHUDStyle = .light) {
        SVProgressHUD.setDefaultStyle(style)
        SVProgressHUD.showInfo(withStatus: status)
    }
    
    class func showSuccess(withStatus status: String!, style: SVProgressHUDStyle = .light) {
        SVProgressHUD.setDefaultStyle(style)
        SVProgressHUD.showSuccess(withStatus: status)
    }
    
    class func showError(withStatus status: String!, style: SVProgressHUDStyle = .light) {
        SVProgressHUD.setDefaultStyle(style)
        SVProgressHUD.showError(withStatus: status)
    }
    
    class func dismissHUD() {
        SVProgressHUD.dismiss()
    }
}
