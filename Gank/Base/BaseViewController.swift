//
//  BaseViewController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/7.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - property
    var popClosure: (() -> Void)?
    
    enum navBarBackItem {
        case blue
        case white
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColorMainBG
        
        setupNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        else {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        AHLog("---dealloc---\(type(of: self))")
    }
    
    // MARK: - event && methods
    fileprivate func setupNav() {
        if navigationController?.viewControllers.count > 1 {
            navigationController?.interactivePopGestureRecognizer?.delegate = self
            
            popClosure = { [unowned self] in
                guard let navigationController = self.navigationController else { return }
                navigationController.popViewController(animated: true)
            }
        }
        setNavigationBarStyle()
    }
    
    func back() {
        if popClosure != nil {
            popClosure!()
        }
    }
    
    func setNavigationBarStyle(BarColor: UIColor = UIColorMainBlue, backItemColor: navBarBackItem = .white) {
        self.navigationController?.navigationBar.barTintColor = BarColor
        
        var titleColor = UIColor.white
        
        if BarColor.isEqual(UIColor.white) {
            titleColor = UIColor.black
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: titleColor,
                                                                        NSFontAttributeName : UIFont.systemFont(ofSize: 19)]
        
        if navigationController?.viewControllers.count > 1 {
            switch backItemColor {
            case .blue:
                navigationController?.navigationBar.tintColor = UIColorMainBlue
                let oriImage = UIImage(named: "nav_back_blue")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: oriImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.back))
            default: // white
                let oriImage = UIImage(named: "nav_back")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: oriImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.back))
            }
        }
    }
    
}
