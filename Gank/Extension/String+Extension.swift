//
//  String+Extension.swift
//  SubApp
//
//  Created by GuYi on 16/8/8.
//  Copyright © 2016年 aicai. All rights reserved.
//

import Foundation

extension String {

    /// 长度
    var length: Int {
        return self.characters.count
    }
    
    // MARK: - 快速生成缓存路径
    func cachesDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        
        // 生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath
    }
    
    // MARK: - 快速生成文档路径
    func docDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath
    }
    
    // MARK: - 快速生成临时路径
    func tmpDir() -> String {
        let path = NSTemporaryDirectory()
        
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath
    }
    
    // MARK: - 快速生成富文本
    func getAttributedString(_ fontNum: CGFloat, color: UIColor, loc: Int, len: Int) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: fontNum)
        let attString =  NSMutableAttributedString(string: self)
        
        attString.addAttributes([ NSFontAttributeName : font,
                                  NSForegroundColorAttributeName : color  ], range: NSMakeRange(loc, len))
        return attString
    }
    
    // MARK: - 快速生成年收益文本
    func getRateSting(_ smallFont: CGFloat) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: smallFont)
        let attString =  NSMutableAttributedString(string: self)
        
        attString.addAttributes([ NSFontAttributeName : font ], range: NSMakeRange((self as NSString).length - 1, 1))
        return attString
    }
    
    // MARK: - 毫秒转化时间
    static func get1970Date(_ time: NSNumber, formater: String) -> String {
        let date =  Date(timeIntervalSince1970: time.doubleValue / 1000.0)
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = formater
        return formatter.string(from: date)
    }
    
    // MARK: - 获得千分位分隔符字符串
    static func getBigDecimalString(_ string: String) -> String {
        
        guard var numString: NSString = string as NSString? else { return "" }
        
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
