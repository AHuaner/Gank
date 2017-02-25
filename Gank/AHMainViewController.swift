//
//  AHMainViewController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/7.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHMainViewController: BaseViewController {
    
    lazy var tabBarVC: TabBarController = {
        let tabBarVC = TabBarController()
        tabBarVC.delegate = self
        return tabBarVC
    }()
    
    lazy var LaunchVC: AHLaunchViewController = {
        let LaunchVC = AHLaunchViewController(showTime: 3)
        LaunchVC.launchComplete = { [unowned self] in
            self.view.addSubview(self.tabBarVC.view)
            self.addChildViewController(self.tabBarVC)
        }
        return LaunchVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLaunchVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupLaunchVC() {
        addChildViewController(LaunchVC)
        view.addSubview(LaunchVC.view)
    }
}

extension AHMainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        NotificationCenter.default.post(name: NSNotification.Name.AHTabBarDidSelectNotification, object: nil)
    }
}
