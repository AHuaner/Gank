//
//  AHUpdateNickViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/2/16.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AHUpdateNickViewController: BaseViewController {

    @IBOutlet weak var textField: UITextField!

    fileprivate var lastNickName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        IQKeyboardManager.sharedManager().enable = true
    }
    
    fileprivate func setupUI() {
        title = "昵称"
        setNavigationBarStyle(BarColor: UIColor.white, backItemColor: .blue)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(self.saveAction))
        
        textField.text = User.info?.object(forKey: "nickName") as? String
        lastNickName = User.info?.object(forKey: "nickName") as? String
        
        IQKeyboardManager.sharedManager().enable = false
    }
    
    func saveAction() {
        if textField.text?.characters.count == 0 {
            ToolKit.showInfo(withStatus: "昵称不能为空")
            return
        }
        
        ToolKit.show(withStatus: "正在保存")
        view.endEditing(true)
        
        User.info?.setObject(textField.text, forKey: "nickName")
        User.info?.updateInBackground { (isSuccessful, error) in
            if isSuccessful {
                ToolKit.showSuccess(withStatus: "保存成功")
            } else {
                ToolKit.showError(withStatus: "保存失败")
                User.info?.setObject(self.lastNickName, forKey: "nickName")
                AHLog(error!)
            }
        }
    }
}
