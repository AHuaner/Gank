//
//  AHFeedbackViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/2/15.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AHFeedbackViewController: BaseViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        IQKeyboardManager.sharedManager().enable = true
    }
    
    fileprivate func setupUI() {
        title = "反馈"
        setNavigationBarStyle(BarColor: UIColor.white, backItemColor: .blue)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(submitAction))
        
        IQKeyboardManager.sharedManager().enable = false
    }
    
    func submitAction() {
        if textView.text!.characters.count == 0 {
            ToolKit.showInfo(withStatus: "内容不能为空")
            return
        }
        
        self.view.endEditing(true)
        ToolKit.show(withStatus: " 正在提交 ")
        
        let feedbackInfo = BmobObject(className: "UserFeedback")
        feedbackInfo?.setObject(User.info?.objectId, forKey: "userId")
        feedbackInfo?.setObject(textView.text!, forKey: "content")
        
        feedbackInfo?.saveInBackground(resultBlock: { (isSuccessful, error) in
            if error != nil { // 提交失败
                AHLog(error!)
                ToolKit.showError(withStatus: " 提交失败 ")
            } else { // 提交成功
                ToolKit.showSuccess(withStatus: " 提交成功 ")
            }
        })
    }
    
}
