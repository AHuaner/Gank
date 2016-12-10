//
//  AHTurnChannelViewController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/10.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHTurnChannelViewController: BaseViewController {
    var turnChannelClouse: (() -> Void)?
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        let btnW: CGFloat = 40.0
        let btnH: CGFloat = 35.0
        let margin: CGFloat = 0.0
        let btnF = CGRect(x: kScreen_W - btnW - margin, y: 30, width: btnW, height: btnH)
        closeBtn.setImage(UIImage(named: "add_button_high"), for: .normal)
        closeBtn.frame = btnF
        closeBtn.addTarget(self, action: #selector(AHTurnChannelViewController.close), for: .touchUpInside)
        return closeBtn
    }()
    
    lazy var listView: AHListView = {
        // 福利 | Android | iOS | 休息视频 | 拓展资源 | 前端
        let listView = AHListView(frame: CGRect(x: 0, y: 80, width: kScreen_W, height: 0))
        listView.addTags(titles: ["福利", "Android", "iOS", "休息视频", "拓展资源", "前端"])
        listView.backgroundColor = UIColor.red
        return listView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "频道"
        view.backgroundColor = UIColor.orange
        view.addSubview(closeBtn)
        
        view.addSubview(listView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func close() {
        if turnChannelClouse != nil {
            turnChannelClouse!()
        }
        
        self.dismiss(animated: true, completion: {
            
        })
    }
}
