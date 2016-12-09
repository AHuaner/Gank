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
        return tabBarVC
    }()
    
    lazy var LaunchVC: AHLaunchViewController = {
        let LaunchVC = AHLaunchViewController()
//        let LaunchVC = AHLaunchViewController(launchClouse: { [unowned self] in
//            AHLog("回调")
//            self.view.addSubview(self.tabBarVC.view)
//            self.addChildViewController(self.tabBarVC)
//        })
        LaunchVC.launchComplete = { [unowned self] in
            AHLog("回调")
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
