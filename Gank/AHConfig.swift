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

let kWindow = UIApplication.shared.delegate!.window!

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

let UIColorMainBG = RGBColor(239, g: 239, b: 245, alpha: 1)
let UIColorTextLightGray = RGBColor(153, g: 153, b: 153, alpha: 1)
let UIColorTextGray = RGBColor(99, g: 99, b: 99, alpha: 1)
let UIColorTextBlock = RGBColor(47, g: 47, b: 47, alpha: 1)
let UIColorTextBlue = RGBColor(40, g: 154, b: 236, alpha: 1)
let UIColorMainBlue = RGBColor(30, g: 130, b: 210, alpha: 1)
let UIColorLine = RGBColor(217, g: 217, b: 217, alpha: 1)

typealias JSONObject = [String: Any]

class AHConfig {
    // MARK: - 服务器地址
    static let Http_ = "http://gank.io/api/"
}

// MARK: - 通知通用字段
extension NSNotification.Name {
    // 点击TabBar item 发出的通知
    static let AHTabBarDidSelectNotification = NSNotification.Name(rawValue: "AHTabBarDidSelectNotification")
    // 隐藏或显示statusBar发出的通知
    static let AHChangeStatusBarNotification = NSNotification.Name(rawValue: "AHChangeStatusBarNotification")
}

// MARK: - UserDefaults通用字段
typealias UserDefaultsSettable = StringDefaultSettable & BoolDefaultSettable

struct UserConfig: UserDefaultsSettable {
    enum StringKey: String {
        case mobilePhoneNumber                  /// 上一次登录的手机号
        case lastDate                           /// 首页缓存数据的日期
    }
    
    enum BoolKey: String {
        case isOnlyWifiDownPic                  /// 仅在WiFi下载图片开关的状态
    }
}
