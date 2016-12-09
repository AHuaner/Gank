//
//  AHGankViewController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/8.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHGankViewController: AHDisplayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置下滑指示线样式
        setupUnderLineEffect { (isShowUnderLine, underLineColor, underLineH) in
            isShowUnderLine = false
        }
        
        // 设置蒙版样式
        setupCoverViewEffect { (isShowCoverView, coverViewColor, coverViewCornerRadius) in
            isShowCoverView = true
        }
        
//        addTitleButton.isHidden = true
        setupChildVcs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupChildVcs() {
        //  福利 | Android | iOS | 休息视频 | 拓展资源 | 前端
        let vc1 = Text1ViewController()
        vc1.title = "福利"
        addChildViewController(vc1);
        
        let vc2 = Text1ViewController()
        vc2.title = "Android"
        addChildViewController(vc2);
        
        let vc3 = Text1ViewController()
        vc3.title = "iOS"
        addChildViewController(vc3);
        
        let vc4 = Text1ViewController()
        vc4.title = "休息视频"
        addChildViewController(vc4);
        
        let vc5 = Text1ViewController()
        vc5.title = "拓展资源"
        addChildViewController(vc5);
        
        let vc6 = Text1ViewController()
        vc6.title = "前端"
        addChildViewController(vc6);
        
        let vc7 = Text1ViewController()
        vc7.title = "拓展资源"
        addChildViewController(vc7);
        
        let vc8 = Text1ViewController()
        vc8.title = "前端"
        addChildViewController(vc8);
    }
}
