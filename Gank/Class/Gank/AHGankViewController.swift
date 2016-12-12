//
//  AHGankViewController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/8.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

let ConfigDict: [AnyHashable: Any] = ["福利" : "福利",
                                "Android": "Android",
                                "iOS" : "iOS",
                                "视频" : "休息视频",
                                "拓展资源" : "拓展资源",
                                "前端" : "前端",
                                "干货" : "all"]
enum ClassType: String {
    case welfare = "福利"
    case Android = "Android"
    case iOS = "iOS"
    case video = "休息视频"
    case resource = "拓展资源"
    case fontEnd = "前端"
    case gank = "all"
}

class AHGankViewController: AHDisplayViewController {
    
    fileprivate var childVCtitles: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titles = ["干货", "福利", "Android", "iOS", "视频", "拓展资源", "前端"]
        setupChildVCs(titles: titles)
        addTitleButton.addTarget(self, action: #selector(AHGankViewController.addTitleButtonClick(_:)), for: .touchUpInside)
    }
    
    func addTitleButtonClick(_ btn: UIButton) {
        let turnVC = AHTurnChannelViewController()
        turnVC.tagsTitleArray = childVCtitles

        turnVC.turnChannelClouse = { [unowned self]  titleArray in
            if titleArray.count <= 0 {
                return
            }
            AHLog(titleArray)
            for childVC in self.childViewControllers {
                childVC.removeFromParentViewController()
            }
            self.setupChildVCs(titles: titleArray)
            self.setupTitleWidth()
            self.setupAllTitle()
            self.contentScrollView.reloadData()
        }
        
        self.present(turnVC, animated: true, completion: {})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupChildVCs(titles: [String]) {
        childVCtitles.removeAll()
        for title in titles {
            let classVC = AHClassViewController()
            classVC.title = title
            classVC.type = ClassType(rawValue: "\(ConfigDict[title]!)")
            addChildViewController(classVC);
            childVCtitles.append(title)
        }
    }
}
