//
//  AHLaunchViewController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/8.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

typealias AHLaunchComplete = () -> (Void)

class AHLaunchViewController: BaseViewController {

    var launchComplete: AHLaunchComplete?
    
    lazy var skipBtn: AHTimeButton = {
        let btnW: CGFloat = 50.0
        let btnH: CGFloat = 30.0
        let margin: CGFloat = 20.0
        let btnF = CGRect(x: kScreen_W - btnW - margin, y: margin, width: btnW, height: btnH)
        let skipBtn = AHTimeButton(frame: btnF, time: 3, clickAction: { 
            self.skipAction()
        })
        return skipBtn
    }()
    
    lazy var LaunchImageView: AHLaunchImageView = {
        let LaunchImageView = AHLaunchImageView(frame: kScreen_BOUNDS)
        return LaunchImageView
    }()
    
//    init(launchClouse: @escaping AHLaunchComplete) {
//        self.launchComplete = launchClouse
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUI() {
        view.addSubview(skipBtn)
        view.insertSubview(LaunchImageView, belowSubview: skipBtn)
    }
    
    func skipAction() {
        if launchComplete != nil {
            launchComplete!()
        }
        launchComplete = nil
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}
