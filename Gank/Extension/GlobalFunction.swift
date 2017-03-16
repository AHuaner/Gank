//
//  GlobalFunction.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/7.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

func RGBColor(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) -> UIColor{
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
}

func RGBColor(_ hex: String) -> UIColor {
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

func AHLog<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){
    #if DEBUG
        var fileN = (fileName as NSString).lastPathComponent as NSString
        fileN = fileN.substring(with: NSMakeRange(0, fileN.length - 6)) as NSString
        
        let nowDate = Date().toString(WithFormat: "yyyy-MM-dd hh:mm:ss")
        print("--\(nowDate)--\(fileN)--\(methodName)--[\(lineNumber)]: \(message)")
    #endif
}

//获取正确的删除索引
func getRemoveIndex<T: Equatable>(value: T, array: [T]) -> [Int]{
    var indexArray = [Int]()
    var correctArray = [Int]()
    
    //获取指定值在数组中的索引
    for (index,_) in array.enumerated() {
        if array[index] == value {
            indexArray.append(index)
        }
    }
    
    //计算正确的删除索引
    for (index, originIndex) in indexArray.enumerated() {
        //指定值索引减去索引数组的索引
        let correctIndex = originIndex - index
        
        //添加到正确的索引数组中
        correctArray.append(correctIndex)
    }
    return correctArray
}

//从数组中删除指定元素
func removeValueFromArray<T: Equatable>(value: T, array: inout [T]){
    let correctArray = getRemoveIndex(value: value, array: array)
    
    //从原数组中删除指定元素
    for index in correctArray {
        array.remove(at: index)
    }
}

