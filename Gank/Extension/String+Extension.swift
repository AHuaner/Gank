//
//  String+Extension.swift
//  SubApp
//
//  Created by GuYi on 16/8/8.
//  Copyright © 2016年 aicai. All rights reserved.
//

import Foundation

extension String {
    
    static func getUUID() -> String{
     
        let UUID = Foundation.UUID().uuidString
        
        return UUID
    }
    
    // MARK: - 快速生成缓存路径
    /** 快速生成缓存路径 */
    func cachesDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        
        // 生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath
    }
    
    // MARK: - 快速生成文档路径
    /** 快速生成文档路径 */
    func docDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath
    }
    
    // MARK: - 快速生成临时路径
    /** 快速生成临时路径 */
    func tmpDir() -> String {
        let path = NSTemporaryDirectory()
        
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath
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
    
    // MARK: - 快速生成富文本
    /** 快速生成富文本 */
    func getAttributedString(_ fontNum: CGFloat, color: UIColor, loc: Int, len: Int) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: fontNum)
        let attString =  NSMutableAttributedString(string: self)
        
        attString.addAttributes([ NSFontAttributeName : font,
                                  NSForegroundColorAttributeName : color  ], range: NSMakeRange(loc, len))
        return attString
    }
    
    // MARK: - 快速生成年收益文本
    /** 快速年收益文本 */
    func getRateSting(_ smallFont: CGFloat) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: smallFont)
        let attString =  NSMutableAttributedString(string: self)
        
        attString.addAttributes([ NSFontAttributeName : font ], range: NSMakeRange((self as NSString).length - 1, 1))
        return attString
    }
    
    // MARK: - 获取网络类型
    /** 获取网络类型 */
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
        
        let NetWorkType: String?
        switch dataNetWorkItemView?.value(forKey: "dataNetworkType")! as! Int {
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
        return NetWorkType!
    }
    
    // MARK: - 毫秒转化时间
    /** 毫秒转化时间 */
    static func get1970Date(_ time: NSNumber, formater: String) -> String {
        let date =  Date(timeIntervalSince1970: time.doubleValue / 1000.0)
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = formater
        return formatter.string(from: date)
    }
    
    // MARK: - 获得千分位分隔符字符串
    /** 获得千分位分隔符字符串 */
    static func getBigDecimalString(_ string: String) -> String {
        
        guard var numString: NSString = string as NSString? else {
            return ""
        }
        
        if numString.doubleValue < 1000.0 {
            return numString as String
        }
        let defultFormatter = NumberFormatter()
        defultFormatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
        defultFormatter.numberStyle = NumberFormatter.Style.decimal
        //需要限定位数，否则double型小数点后为0时会被省略
        if numString.range(of: ".").location != NSNotFound {
            defultFormatter.maximumFractionDigits = 2
            defultFormatter.minimumFractionDigits = 2
            numString = defultFormatter.string(from: NSNumber(value: numString.doubleValue as Double))! as NSString
        } else {
            defultFormatter.maximumFractionDigits = 0
            numString = defultFormatter.string(from: NSNumber(value: numString.intValue as Int32))! as NSString
        }
        return numString as String
    }
}
