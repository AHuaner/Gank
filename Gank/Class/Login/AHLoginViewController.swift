//
//  AHLoginViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/2/7.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHLoginViewController: BaseViewController {    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var forgetBtn: UIButton!
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
    }

    @IBAction func closeAction() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func loginAction() {
        view.endEditing(true)
        
        if accountTextField.text?.characters.count == 0 {
            ToolKit.showInfo(withStatus: "请输入11位手机号码", style: .dark)
        } else {
            if Validate.checkMobile(accountTextField.text!) {
                if passwordTextField.text?.characters.count == 0 {
                    ToolKit.showInfo(withStatus: "请输入登录密码", style: .dark)
                }
            } else {
                ToolKit.showInfo(withStatus: "请输入正确的11位手机号码", style: .dark)
            }
        }
    }
    
    @IBAction func registerAction() {
        
    }
    
    @IBAction func forgetAction() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
