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
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        passwordTextField.delegate = self
        
        // 获取上次登录的账号
        if let lastPhoneNumber =  ToolKit.getUserInfoObjectForKey(key: "mobilePhoneNumber") as? String {
            accountTextField.text = lastPhoneNumber
        }
    }

    @IBAction func closeAction() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginAction() {
        view.endEditing(true)
        
        if accountTextField.text?.characters.count == 0 {
            ToolKit.showInfo(withStatus: "请输入手机号码")
        } else {
            if Validate.checkMobile(accountTextField.text!) {
                if passwordTextField.text?.characters.count == 0 {
                    ToolKit.showInfo(withStatus: "请输入登录密码")
                } else {
                    logining()
                }
            } else {
                ToolKit.showInfo(withStatus: "请输入正确的手机号码")
            }
        }
    }
    
    @IBAction func registerAction() {
        self.view.endEditing(true)
        let registerVC = AHRegisterViewController()
        registerVC.registerClouse = {
            self.dismiss(animated: true, completion: nil)
        }
        
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func forgetAction() {
        self.view.endEditing(true)
        let resetVC = AHResetPasswordController()
        resetVC.resetClouse = {
            self.dismiss(animated: true, completion: nil)
        }
        
        self.navigationController?.pushViewController(resetVC, animated: true)
    }
    
    @IBAction func showSecureTextAction(_ btn: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        
        if passwordTextField.isSecureTextEntry {
            btn.setImage(UIImage(named: "icon_show"), for: .normal)
        } else {
            btn.setImage(UIImage(named: "icon_show_blue"), for: .normal)
        }
    }
    
    func logining() {
        let userName = accountTextField.text!
        let passWord = passwordTextField.text!
        
        ToolKit.show(withStatus: "正在获取用户信息", style: .dark, maskType: .clear)
        BmobUser.loginWithUsername(inBackground: userName, password: passWord) { (BmobUser, error) in
            if let user = BmobUser {
                AHLog("登录成功---\(user)")
                ToolKit.dismissHUD()
                ToolKit.saveUserInfoObject(object: user.mobilePhoneNumber, key: "mobilePhoneNumber")
                self.dismiss(animated: true, completion: nil)
            } else {
                guard let nserror = error as? NSError else {
                    ToolKit.showError(withStatus: "登录失败")
                    return
                }
                switch nserror.code {
                case 101:
                    ToolKit.showError(withStatus: "手机号和密码不匹配")
                case 20002:
                    ToolKit.showError(withStatus: "请检查网络设置")
                default:
                    ToolKit.showError(withStatus: "请检查网络设置")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension AHLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginAction()
        return true
    }
}
