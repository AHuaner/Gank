//
//  AHRegisterViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/2/8.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHRegisterViewController: BaseViewController {
    
    // MARK: - control
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authcodeTextField: UITextField!
    
    @IBOutlet weak var autocodeBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    // MARK: - property
    var registerClouse: (() -> Void)?
    
    var timer: Timer?
    var time: Int = 60
    // 用户是否获取短信验证码
    var isGetAutoCode: Bool = false
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - event && methods
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        
        accountTextField.addTarget(self, action: #selector(chectRegisterCanClick), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(chectRegisterCanClick), for: .editingChanged)
        authcodeTextField.addTarget(self, action: #selector(chectRegisterCanClick), for: .editingChanged)
    }
    
    func chectRegisterCanClick() {
        if accountTextField.text != "" && passwordTextField.text != "" && authcodeTextField.text != "" {
            registerBtn.backgroundColor = UIColorMainBlue
            registerBtn.isEnabled = true
        } else {
            registerBtn.backgroundColor = UIColor.lightGray
            registerBtn.isEnabled = false
        }
    }
    
    @IBAction func registerAction() {
        if Validate.checkMobile(accountTextField.text!) {
            if Validate.checkPassword(passwordTextField.text!) {
                if isGetAutoCode {
                    requestRegister()
                } else {
                    ToolKit.showInfo(withStatus: "请获取短信验证码", style: .dark)
                }
            } else {
                ToolKit.showInfo(withStatus: "密码为6-18位字母数字组合", style: .dark)
            }
        } else {
            ToolKit.showInfo(withStatus: "请输入正确的手机号码", style: .dark)
        }
     }
    
    @IBAction func popAction() {
        timer?.invalidate()
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func showSecureTextAction(_ btn: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        
        if passwordTextField.isSecureTextEntry {
            btn.setImage(UIImage(named: "icon_show"), for: .normal)
        } else {
            btn.setImage(UIImage(named: "icon_show_blue"), for: .normal)
        }
    }
    
    @IBAction func autocodeAction() {
        if accountTextField.text?.characters.count == 0 {
            ToolKit.showInfo(withStatus: "请输入手机号码", style: .dark)
        } else {
            if Validate.checkMobile(accountTextField.text!) {
                if passwordTextField.text?.characters.count == 0 {
                    ToolKit.showInfo(withStatus: "请输入密码", style: .dark)
                } else {
                    if Validate.checkPassword(passwordTextField.text!) {
                        checkRegistered()
                    } else {
                        ToolKit.showInfo(withStatus: "密码为6-18位字母数字组合", style: .dark)
                    }
                }
            } else {
                ToolKit.showInfo(withStatus: "请输入正确的手机号码", style: .dark)
            }
        }

    }
    
    // 检验账号是否已注册
    fileprivate func checkRegistered() {
        self.view.endEditing(true)
        ToolKit.show(withStatus: "正在获取验证码", style: .dark, maskType: .clear)
        
        let query = BmobUser.query()!
        query.whereKey("username", equalTo: accountTextField.text)
        query.findObjectsInBackground { (array, error) in
            AHLog(array!)
            if array!.count > 0 { // 该账号已注册
                ToolKit.dismissHUD()
                self.showAlertController(locationVC: self, title: "该账号已注册, 要去登陆吗?", message: "", cancelTitle: "取消", confirmTitle: "好的", confrimClouse: { (_) in
                    self.navigationController!.popViewController(animated: true)
                }, cancelClouse: { (_) in })
            } else { // 该账号未注册
                // 重置时间
                self.time = 60
                
                self.autocodeBtn.isUserInteractionEnabled = false
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AHRegisterViewController.timeRun), userInfo: nil, repeats: true)
                RunLoop.current.add(self.timer!, forMode: .commonModes)
                
                self.requestSMSCode()
            }
        }
    }
    
    // 获取短信验证码
    func requestSMSCode() {
        isGetAutoCode = true
        BmobSMS.requestCodeInBackground(withPhoneNumber: accountTextField.text, andTemplate: "干货") { (SMSID, error) in
            if error != nil {
                let nserror = error as! NSError
                ToolKit.showError(withStatus: "获取失败")
                AHLog(nserror.code)
            } else {
                ToolKit.showSuccess(withStatus: "获取成功")
                AHLog("SMSID --\(SMSID)")
            }
        }
    }
    
    // 验证码倒计时
    func timeRun() {
        autocodeBtn.setTitleColor(UIColor.lightGray, for: .normal)
        autocodeBtn.setTitle("重新获取(\(self.time))", for: .normal)
        time = time - 1
        if time <= 0 {
            autocodeBtn.isUserInteractionEnabled = true
            autocodeBtn.setTitleColor(UIColorMainBlue, for: .normal)
            autocodeBtn.setTitle("获取验证码", for: .normal)
            timer?.invalidate()
        }
    }
    
    // 发送注册请求
    func requestRegister() {
        self.view.endEditing(true)
        ToolKit.show(withStatus: "正在注册中", style: .dark, maskType: .clear)
        let user = BmobUser()
        user.username = accountTextField.text
        user.mobilePhoneNumber = accountTextField.text
        user.password = passwordTextField.text
        user.setObject("\(Bundle.appName)用户", forKey: "nickName")
        user.setObject(UIDevice.getUUID(), forKey: "uuid")
        user.signUpOrLoginInbackground(withSMSCode: authcodeTextField.text) { (isSuccessful, error) in
            if error == nil {
                User.update()
                AHLog("注册成功---\(User.info)")
                ToolKit.showSuccess(withStatus: "注册成功")
                ToolKit.saveUserInfoObject(object: user.mobilePhoneNumber, key: AHConfig.UserDefault.mobilePhoneNumber)
                DispatchQueue.main.asyncAfter(deadline: 1, execute: {
                    if self.registerClouse != nil { self.registerClouse!() }
                })
            }else{
                AHLog("\(error)")
                let nserror = error as! NSError
                switch nserror.code {
                case 207:
                    ToolKit.showError(withStatus: "验证码错误")
                default:
                    ToolKit.showError(withStatus: "注册失败, 请稍后重试")
                }
            }
        }
    }

}
