//
//  AHTestViewController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/8.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHTestViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMainVc() {
        navigationController?.pushViewController(AHMainViewController(), animated: true)
    }

}
