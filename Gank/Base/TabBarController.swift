//
//  TabBarController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/8.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    lazy var gankVC: UINavigationController = {
        let gankVC = AHGankViewController()
        let nav = self.setupNav(viewController: gankVC, title: "干货", barItemTitle: "干货", image: "find", selectedImage: "find_select")
        return nav
    }()
    
    lazy var mineVC: UINavigationController = {
        let mineVC = AHMineViewController()
        let nav = self.setupNav(viewController: mineVC, title: "我的", barItemTitle: "我的", image: "property", selectedImage: "property_select")
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        AHLog("---dealloc---\(type(of: self))")
    }
    
    fileprivate func setupNav(viewController: BaseViewController, title: String, barItemTitle: String, image:String, selectedImage: String) -> UINavigationController {
        viewController.title = title
        viewController.tabBarItem.title = barItemTitle
        viewController.tabBarItem.selectedImage = UIImage(named: selectedImage)
        viewController.tabBarItem.image = UIImage(named: image)
        let nav = UINavigationController(rootViewController: viewController)
        return nav
    }
    
    fileprivate func setupTabBar() {
        viewControllers = [gankVC, mineVC]
        tabBar.shadowImage = UIImage()
        tabBar.selectionIndicatorImage = UIImage()
        tabBar.backgroundImage = UIImage(named: "tabBar_bgwhiteColor")
    }
}
