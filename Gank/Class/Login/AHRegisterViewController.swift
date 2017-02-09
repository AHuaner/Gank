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
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authcodeTextField: UITextField!
    @IBOutlet weak var autocodeBtn: UIButton!
    
    var timer: Timer?
    
    var time: Int = 60

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
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        self.title = "注册"
    }
    
    @IBAction func completeAction() {
        if completeRegisterClouse != nil {
            completeRegisterClouse!()
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
//        BmobSMS.requestCodeInBackground(withPhoneNumber: "15993901771", andTemplate: "干货") { (SMSID, error) in
//            if error != nil {
//                let nserror = error as! NSError
//                AHLog(nserror.code)
//            } else {
//                AHLog(SMSID)
//            }
//        }
        // 重置时间
        time = 60
        
        autocodeBtn.isUserInteractionEnabled = false
        autocodeBtn.setTitle("(\(time)s) 后可重发", for: .normal)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeRun), userInfo: nil, repeats: true)
    }
    
    func timeRun() {
        time = time - 1
        autocodeBtn.setTitle("(\(time)s) 后可重发", for: .normal)
        if time <= 0 {
            autocodeBtn.isUserInteractionEnabled = true
            autocodeBtn.setTitle("重发验证码", for: .normal)
            timer?.invalidate()
        }
    }
}
