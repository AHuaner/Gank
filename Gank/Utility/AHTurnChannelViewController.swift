//
//  AHTurnChannelViewController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/10.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHTurnChannelViewController: BaseViewController {

    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        let btnW: CGFloat = 40.0
        let btnH: CGFloat = 35.0
        let margin: CGFloat = 0.0
        let btnF = CGRect(x: kScreen_W - btnW - margin, y: 50, width: btnW, height: btnH)
        closeBtn.setImage(UIImage(named: "add_button_high"), for: .normal)
        closeBtn.frame = btnF
        closeBtn.addTarget(self, action: #selector(AHTurnChannelViewController.close), for: .touchUpInside)
        return closeBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "频道"
        view.backgroundColor = UIColor.orange
        view.addSubview(closeBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func close() {
        self.dismiss(animated: true, completion: {
            
        })
    }
}
