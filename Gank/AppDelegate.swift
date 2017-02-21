//
//  AppDelegate.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/7.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 初始化根控制器
        setRootVC()
        
        // 腾讯Bugly crash日志配置
        setBugly()
        
        // 初始化IQKeyboardManager
        setIQKeyboardManager()
        
        // 初始化UMeng
        setUMeng()
        
        // 初始化Bmob
        setBmob()
        
        // 初始化全局属性
        setGlobalConfig()
        
        // 创建数据库文件
        SQLiteManager.shareManager().openDB(DBName: "ganks.sqlite")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        if result {
            AHLog("处理成功")
        } else {
            AHLog("处理失败")
        }
        return true
    }
    
    fileprivate func setRootVC() {
        // let rootVC = AHMainViewController()
        let rootVC = TabBarController()
        rootVC.delegate = self
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColorMainBG
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    fileprivate func setBugly() {
        let config = BuglyConfig()
        config.reportLogLevel = .warn
        config.blockMonitorEnable = true
        config.blockMonitorTimeout = 1.5
        config.channel = "AppStore"
        
        Bugly.start(withAppId: "b8f061c283",
                    developmentDevice: false,
                    config: config)
        
        if ToolKit.getCurrentDeviceModel() == "Simulator" {
            Bugly.start(withAppId: "b8f061c283",
                        developmentDevice: true,
                        config: config)
        }

        Bugly.updateAppVersion(Bundle.releaseVersionNumber!)
        Bugly.setUserValue(ProcessInfo.processInfo.processName, forKey: "Process")
        Bugly.setUserIdentifier("\(UIDevice.current.name)")
    }
    
    fileprivate func setIQKeyboardManager() {
        let manager = IQKeyboardManager.sharedManager()
        manager.enable = true
        manager.shouldShowTextFieldPlaceholder = false
        manager.toolbarTintColor = UIColorMainBlue
        manager.toolbarDoneBarButtonItemText = "完成"
    }
    
    fileprivate func setGlobalConfig() {
        UITextField.appearance().tintColor = UIColorMainBlue
        UITextView.appearance().tintColor = UIColorMainBlue
        UITabBar.appearance().tintColor = UIColorMainBlue
    }
    
    fileprivate func setBmob() {
        Bmob.register(withAppKey: "480048add0eb994db572f59796aa9bb7")
    }
    
    fileprivate func setUMeng() {
        UMSocialManager.default().openLog(true)
        UMSocialManager.default().umSocialAppkey = "587ed28d04e20582670008fe"
        
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: "wx63cb6a9a9328f689", appSecret: "389c351724e6b2be9dad31b626afa8e1", redirectURL: "http://mobile.umeng.com/social")
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatTimeLine, appKey: "wx63cb6a9a9328f689", appSecret: "389c351724e6b2be9dad31b626afa8e1", redirectURL: "http://mobile.umeng.com/social")
        UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.wechatFavorite)
        
        // 配置分享界面
        let shareUIConfig = UMSocialShareUIConfig.shareInstance()!
        shareUIConfig.shareTitleViewConfig.isShow = false
        shareUIConfig.shareCancelControlConfig.isShow = false
        shareUIConfig.sharePageGroupViewConfig.sharePageGroupViewPostionType = .bottom;
        shareUIConfig.sharePageScrollViewConfig.shareScrollViewPageMaxRowCountForPortraitAndBottom = 2
        shareUIConfig.sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndBottom = 3
    }
}

extension AppDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TabBarDidSelectNotification"), object: nil)
    }
}

