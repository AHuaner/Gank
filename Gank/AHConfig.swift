//
//  AHConfig.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/7.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import Foundation

let kScreen_BOUNDS = UIScreen.main.bounds
let kScreen_W = UIScreen.main.bounds.size.width
let kScreen_H = UIScreen.main.bounds.size.height
let kScreen_Scale = UIScreen.main.scale

let kWindow = UIApplication.shared.delegate!.window

let kStatusBarHeight: CGFloat = 20.0
let kTopBarHeight: CGFloat = 44.0
let kNavBarHeight: CGFloat = 64.0
let kBottomBarHeight: CGFloat = 49.0

let iPhone4_Width = 320.0
let iPhone4_Height = 480.0
let iPhone5_Width = 320.0
let iPhone5_Height = 568.0
let iPhone6_Width = 375.0
let iPhone6_Height = 667.0
let iPhone6Plus_Width = 414.0
let iPhone6Plus_Height = 736.0

let UIColorMainBG = RGBColor(240.0, g: 240.0, b: 240.0, alpha: 1.0)
let UIColorTextGray = RGBColor(153.0, g: 153.0, b: 153.0, alpha: 1.0)
let UIColorTextBlue = RGBColor(21.0, g: 126.0, b: 251.0, alpha: 1.0)
let UIColorMainBlue = RGBColor(93.0, g: 160.0, b: 245.0, alpha: 1.0)
let UIColorLine = RGBColor(217.0, g: 217.0, b: 217.0, alpha: 1.0)

class AHConfig {
    
    // MARK: 服务器地址
    static let Http_ = "http://gank.io/api/"
    
    // MARK: 通知通用字段
    struct Notification {
        
    }
    
    // MARK: UserDefault通用字段
    struct UserDefault {
        
    }
}
