//
//  AHGankViewController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/8.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHGankViewController: AHDisplayViewController {
    
    fileprivate var childVCtitles: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupChildVcs()
        
        addTitleButton.addTarget(self, action: #selector(AHGankViewController.addTitleButtonClick(_:)), for: .touchUpInside)
    }
    
    func addTitleButtonClick(_ btn: UIButton) {
//        self.childViewControllers[0].removeFromParentViewController()
        let turnVC = AHTurnChannelViewController()
        turnVC.tagsTitleArray = childVCtitles

//        turnVC.turnChannelClouse = { [unowned self] in
//            let vc7 = Text1ViewController()
//            vc7.title = "新增"
//            self.addChildViewController(vc7);
//            self.setupTitleWidth()
//            self.setupAllTitle()
//            self.contentScrollView.reloadData()
//        }
        
        self.present(turnVC, animated: true, completion: {
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupChildVcs() {
        //  福利 | Android | iOS | 休息视频 | 拓展资源 | 前端
        let vc1 = Text1ViewController()
        vc1.title = "福利"
        addChildViewController(vc1);
        childVCtitles.append(vc1.title!)
        
        let vc2 = Text1ViewController()
        vc2.title = "Android"
        addChildViewController(vc2);
        childVCtitles.append(vc2.title!)

        let vc3 = Text1ViewController()
        vc3.title = "iOS"
        addChildViewController(vc3);
        childVCtitles.append(vc3.title!)

        let vc4 = Text1ViewController()
        vc4.title = "休息视频"
        addChildViewController(vc4);
        childVCtitles.append(vc4.title!)

        let vc5 = Text1ViewController()
        vc5.title = "拓展资源"
        addChildViewController(vc5);
        childVCtitles.append(vc5.title!)

        let vc6 = Text1ViewController()
        vc6.title = "前端"
        addChildViewController(vc6);
        childVCtitles.append(vc6.title!)
    }
}
