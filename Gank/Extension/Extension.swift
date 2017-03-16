//
//  Extension.swift
//  Gank
//
//  Created by AHuaner on 2017/2/26.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

// MARK: - Bundle - Extension
extension Bundle {
    static var releaseVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static var buildVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    static var appName: String {
        return Bundle.main.infoDictionary?["CFBundleName"] as! String
    }
}

// MARK: - UIDevice - Extension
extension UIDevice {
    static func getUUID() -> String {
        // let UUID = Foundation.UUID().uuidString
        return UIDevice.current.identifierForVendor!.uuidString
    }
}

// MARK: - DispatchTime - Extension
extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}

extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}

// MARK: - NSObject - Extension
extension NSObject {
    static var className: String {
        let name =  Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let reaName = name + "."
        return NSStringFromClass(self).substring(from: reaName.endIndex)
    }
}

// MARK: - CGFloat - Extension
extension CGFloat {
    func format(f: Int) -> String {
        return NSString(format:"%.\(f)f" as NSString, self) as String
    }
}

// MARK: - Date - Extension
extension Date {
    func toString(WithFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

// MARK: - CALayer - Extension
extension CALayer {
    var XibBorderColor: UIColor? {
        get {
            return UIColor(cgColor: self.borderColor!)
        }
        set(boderColor) {
            self.borderColor = boderColor?.cgColor
        }
    }
}
