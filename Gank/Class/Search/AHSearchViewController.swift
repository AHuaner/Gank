//
//  AHSearchViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/1/9.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHSearchViewController: BaseViewController {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        closeBtn.addTarget(self, action: #selector(AHSearchViewController.popViewController), for: .touchUpInside)
    }
    
    func popViewController() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
