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
    // MARK: - HUD相关
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
    
    // MARK: - 存储、获取、删除用户信息
    class func saveUserInfoObject(object: Any, key: String) {
        let defaults = UserDefaults.standard
        defaults.set(object, forKey: key)
        defaults.synchronize()
    }
    
    class func getUserInfoObjectForKey(key: String) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key)
    }
    
    class func removeUserInfoObjectForKey(key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
}
