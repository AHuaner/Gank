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
        SVProgressHUD.setDefaultMaskType(maskType)
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
    
    // MARK: - 获取网络类型
    static func getNetWorkType() -> String {
        let application = UIApplication.shared
        let subviews = ((application.value(forKey: "statusBar") as AnyObject).value(forKey: "foregroundView") as AnyObject).subviews
        var dataNetWorkItemView: UIView?
        
        for sub in subviews! {
            if sub.isKind(of: NSClassFromString("UIStatusBarDataNetworkItemView")!) {
                dataNetWorkItemView = sub
                break
            }
        }
        
        var NetWorkType: String = ""
        
        guard let NetworkTypeNum = dataNetWorkItemView?.value(forKey: "dataNetworkType") as? Int else {
            return "Airplane mode"
        }
        
        switch NetworkTypeNum {
        case 0:
            NetWorkType = "No wifi or cellular"
        case 1:
            NetWorkType = "2G"
        case 2:
            NetWorkType = "3G"
        case 3:
            NetWorkType = "4G"
        default:
            NetWorkType = "Wifi"
        }
        return NetWorkType
    }
 
    // MARK: - 获取设备型号
    /** 获取设备型号 */
    static func getCurrentDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}
