//
//  NSObject+alertController.swift
//  Gank
//
//  Created by AHuaner on 2017/1/13.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

typealias ConfirmsHandlerClouse = ((_ action: UIAlertAction) -> Void)
typealias CancelClouse = ((_ action: UIAlertAction) -> Void)

extension NSObject {
    
    /**
     *  @param title        标题
     *  @param message      信息
     *  @param cancelTitle  取消标题, 默认文字是 "取消"
     *  @param confirmTitle 确定标题, 默认文字是 "确定"
     *  @param confirm      确定Clouse
     *  @param cancel       取消Clouse
     */
    func showAlertController(locationVC: UIViewController, title: String, message: String, cancelTitle: String = "取消", confirmTitle: String = "确定", confrimClouse: @escaping ConfirmsHandlerClouse, cancelClouse: @escaping CancelClouse) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (alertAction) in
            cancelClouse(alertAction)
                // locationVC.dismiss(animated: true, completion: nil)
        }
        
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { (alertAction) in
            confrimClouse(alertAction)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        locationVC.present(alertController, animated: true, completion: nil)
    }

    /**
     *  @param title        标题
     *  @param message      信息
     *  @param confirmTitle 确定标题
     *  @param confirm      确定Clouse
     */
    func showAlertController(locationVC: UIViewController, title: String, message: String, confirmTitle: String, confrimClouse : @escaping ConfirmsHandlerClouse) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { (alertAction) in
            confrimClouse(alertAction)
        }
        
        alertController.addAction(confirmAction)
        locationVC.present(alertController, animated: true, completion: nil)
    }
    
    /**
     *  @param title        标题
     *  @param message      信息
     *  @param cancelTitle  取消标题
     *  @param cancel       取消Clouse
     */
    func showAlertController(locationVC: UIViewController, title: String, message: String, cancelTitle: String, cancelClouse: @escaping CancelClouse) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (alertAction) in
            cancelClouse(alertAction)
                // locationVC.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        locationVC.present(alertController, animated: true, completion: nil)
    }
}
