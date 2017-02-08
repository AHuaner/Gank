//
//  AHRegisterViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/2/8.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHRegisterViewController: BaseViewController {
    
    var completeRegisterClouse: (() -> Void)?
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        self.title = "注册"
    }
    
    @IBAction func completeAction() {
        if completeRegisterClouse != nil {
            completeRegisterClouse!()
        }
     }
    @IBAction func showSecureTextAction(_ btn: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        
        if passwordTextField.isSecureTextEntry {
            btn.setImage(UIImage(named: "icon_show"), for: .normal)
        } else {
            btn.setImage(UIImage(named: "icon_show_blue"), for: .normal)
        }
    }
}
