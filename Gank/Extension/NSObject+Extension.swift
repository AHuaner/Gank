//
//  NSObject+Extension.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/7.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

extension NSObject {
    
    class func getClassName() -> String {
        let name =  Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let reaName = name + "."
        return NSStringFromClass(self).substring(from: reaName.endIndex)
    }
    
}

func RGBColor(_ r:CGFloat, g:CGFloat, b:CGFloat, alpha:CGFloat) -> UIColor{
    return UIColor(red:r/255.0, green:g/255.0, blue:b/255.0, alpha:alpha)
}

func UIColorFromRGB(_ hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in:.whitespaces).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substring(from: 1)
    }
    let rString = (cString as NSString).substring(to: 2)
    let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
    let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}


func FontSize(size: CGFloat) -> UIFont {
    let font = UIFont(name: UILabel().font.fontName, size: size)
    return font!
}

func AHLog<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){
    #if DEBUG
        var fileN = (fileName as NSString).lastPathComponent as NSString
        fileN = fileN.substring(with: NSMakeRange(0, fileN.length - 6)) as NSString
        print("\(fileN)--\(methodName)--[\(lineNumber)]: \(message)")
    #endif
}

//class SwiftTimer {
//    
//    private let internalTimer: DispatchSourceTimer
//    
//    init(interval: DispatchTimeInterval, repeats: Bool = false, queue: DispatchQueue = .main , handler: () -> Void) {
//        
//        internalTimer = DispatchSource.makeTimerSource(queue: queue)
//        internalTimer.setEventHandler(handler: handler)
//        if repeats {
//            internalTimer.scheduleRepeating(deadline: .now() + interval, interval: interval)
//        } else {
//            internalTimer.scheduleOneshot(deadline: .now() + interval)
//        }
//    }
//    
//    deinit {
//        //事实上，不需要手动cancel. DispatchSourceTimer在销毁时也会自动cancel。
//        internalTimer.cancel()
//    }
//    
//    func rescheduleRepeating(interval: DispatchTimeInterval) {
//        internalTimer.scheduleRepeating(deadline: .now() + interval, interval: interval)
//    }
//    
//}

