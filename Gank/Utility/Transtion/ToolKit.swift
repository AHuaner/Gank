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
    class func show(withStatus status: String!, style: SVProgressHUDStyle = .dark, maskType: SVProgressHUDMaskType = .none) {
        SVProgressHUD.setDefaultStyle(style)
        // SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show(withStatus: status)
    }
    
    class func showInfo(withStatus status: String!, style: SVProgressHUDStyle = .dark) {
        SVProgressHUD.setDefaultStyle(style)
        // SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        SVProgressHUD.showInfo(withStatus: status)
    }
    
    class func showSuccess(withStatus status: String!, style: SVProgressHUDStyle = .dark) {
        SVProgressHUD.setDefaultStyle(style)
        // SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        SVProgressHUD.showSuccess(withStatus: status)
    }
    
    class func showError(withStatus status: String!, style: SVProgressHUDStyle = .dark) {
        SVProgressHUD.setDefaultStyle(style)
        // SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        SVProgressHUD.showError(withStatus: status)
    }
    
    class func dismissHUD() {
        SVProgressHUD.dismiss()
    }
}
