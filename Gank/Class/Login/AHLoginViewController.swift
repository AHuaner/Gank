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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        if (self.navigationController?.viewControllers.count)! > 1 {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        
//        let user = BmobUser()
//        user.username = "15539183979"
//        user.password = "123456"
//        user.signUpInBackground { (_ isSuccess, error) in
//            if isSuccess {
//                AHLog("登录成功")
//            } else {
//                AHLog(error)
//            }
//        }
    }

    @IBAction func closeAction() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginAction() {
        view.endEditing(true)
        
        if accountTextField.text?.characters.count == 0 {
            ToolKit.showInfo(withStatus: "请输入手机号码", style: .dark)
        } else {
            if Validate.checkMobile(accountTextField.text!) {
                if passwordTextField.text?.characters.count == 0 {
                    ToolKit.showInfo(withStatus: "请输入登录密码", style: .dark)
                }
            } else {
                ToolKit.showInfo(withStatus: "请输入正确的手机号码", style: .dark)
            }
        }
    }
    
    @IBAction func registerAction() {
        self.view.endEditing(true)
        
        let registerVC = AHRegisterViewController()
        registerVC.completeRegisterClouse = {
            self.dismiss(animated: true, completion: nil)
        }
        
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func forgetAction() {
        
    }
    
    @IBAction func showSecureTextAction(_ btn: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        
        if passwordTextField.isSecureTextEntry {
            btn.setImage(UIImage(named: "icon_show"), for: .normal)
        } else {
            btn.setImage(UIImage(named: "icon_show_blue"), for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
