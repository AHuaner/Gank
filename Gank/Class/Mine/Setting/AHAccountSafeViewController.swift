//
//  AHAccountSafeViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/2/17.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHAccountSafeViewController: BaseViewController {
    
    // MARK: - control
    @IBOutlet weak var currentPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - event && methods
    fileprivate func setupUI() {
        title = "修改密码"
        view.backgroundColor = UIColor.white
        setNavigationBarStyle(BarColor: UIColor.white, backItemColor: .blue)
    }
    
    @IBAction func showSecureTextEvent(_ btn: UIButton) {
        if btn.tag == 1 {
            currentPasswordTF.isSecureTextEntry = !currentPasswordTF.isSecureTextEntry
            
            if currentPasswordTF.isSecureTextEntry {
                btn.setImage(UIImage(named: "icon_show"), for: .normal)
            } else {
                btn.setImage(UIImage(named: "icon_show_blue"), for: .normal)
            }
        } else if btn.tag == 2 {
            newPasswordTF.isSecureTextEntry = !newPasswordTF.isSecureTextEntry
            
            if newPasswordTF.isSecureTextEntry {
                btn.setImage(UIImage(named: "icon_show"), for: .normal)
            } else {
                btn.setImage(UIImage(named: "icon_show_blue"), for: .normal)
            }
        } else {
            confirmPasswordTF.isSecureTextEntry = !confirmPasswordTF.isSecureTextEntry
            
            if confirmPasswordTF.isSecureTextEntry {
                btn.setImage(UIImage(named: "icon_show"), for: .normal)
            } else {
                btn.setImage(UIImage(named: "icon_show_blue"), for: .normal)
            }
        }
    }
    
    @IBAction func updatePasswordEvent() {
        view.endEditing(true)
        
        if currentPasswordTF.text?.length == 0 {
            ToolKit.showInfo(withStatus: "请填写当前密码")
        } else {
            if newPasswordTF.text?.length == 0 {
                ToolKit.showInfo(withStatus: "请填写新密码")
            } else {
                if Validate.checkPassword(newPasswordTF.text!) {
                    if confirmPasswordTF.text! != newPasswordTF.text! {
                        ToolKit.showInfo(withStatus: "两次密码输入不一致")
                    } else {
                        sendUpdatePasswordRequest()
                    }
                } else {
                    ToolKit.showInfo(withStatus: "密码为6-18位字母和数字组合")
                }
            }
        }
    }
    
    fileprivate func sendUpdatePasswordRequest() {
        ToolKit.show(withStatus: "正在修改中", style: .dark, maskType: .clear)
        
        let user = User.info
        let oldPassword = currentPasswordTF.text!
        let newPassword = newPasswordTF.text!
        
        user?.updateCurrentUserPassword(withOldPassword: oldPassword, newPassword: newPassword, block: { (isSuccessful, error) in
            if isSuccessful {
                ToolKit.showSuccess(withStatus: "密码修改成功\n 请重新登录")
                User.logout()
                self.navigationController!.popToRootViewController(animated: true)
            } else {
                AHLog(error)
                let nserror = error as! NSError
                switch nserror.code {
                case 210:
                    ToolKit.showError(withStatus: "当前密码不正确")
                default:
                    ToolKit.showError(withStatus: "密码修改失败, 请稍后重试")
                }
            }
        })
    }
    
}
