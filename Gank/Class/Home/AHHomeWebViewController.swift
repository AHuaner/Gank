//
//  AHHomeWebViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/1/7.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHHomeWebViewController: BaseWebViewController {
    
    var homeGankModel: AHHomeGankModel?
    
    // 弹窗
    fileprivate lazy var moreView: AHMoreView = {
        let moreView = AHMoreView.moreView()
        let W = kScreen_W / 2
        let H = CGFloat(moreView.titles.count * 44 + 15)
        moreView.alpha = 0.01
        moreView.frame = CGRect(x: kScreen_W - W - 3, y: 50, width: W, height: H)
        return moreView
    }()
    
    // 蒙版
    fileprivate var maskBtnView: UIButton = {
        let maskBtnView = UIButton()
        maskBtnView.frame = kScreen_BOUNDS
        maskBtnView.backgroundColor = UIColor.clear
        return maskBtnView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUI() {
        self.title = "加载中..."
        
        let oriImage = UIImage(named: "icon_more")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: oriImage, style: .plain, target: self, action: #selector(AHClassWebViewController.moreClick))
        
        maskBtnView.addTarget(self, action: #selector(AHClassWebViewController.dismissMoreView), for: .touchUpInside)
        
        moreView.tableViewdidSelectClouse = { [unowned self] (indexPath) in
            self.dismissMoreView()
            switch indexPath.row {
            case 0: // 收藏
                self.collectGankAction()
            case 1: // 分享
                ToolKit.showSuccess(withStatus: "收藏成功")
            case 2: // 复制链接
                let pasteboard = UIPasteboard.general
                pasteboard.string = self.urlString!
                ToolKit.showSuccess(withStatus: "复制成功")
            case 3: // Safari打开
                guard let urlString = self.urlString else { return }
                guard let url = URL(string: urlString) else { return }
                UIApplication.shared.openURL(url)
            default: break
            }
        }
    }
    
    func moreClick() {
        kWindow?.addSubview(maskBtnView)
        kWindow?.addSubview(moreView)
        UIView.animate(withDuration: 0.25) {
            self.moreView.alpha = 1
        }
    }
    
    func dismissMoreView() {
        maskBtnView.removeFromSuperview()
        UIView.animate(withDuration: 0.25, animations: {
            self.moreView.alpha = 0.01
        }) { (_) in
            self.moreView.removeFromSuperview()
        }
    }
    
    func collectGankAction() {
        if userInfo == nil { // 未登录
            let loginVC = AHLoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            present(nav, animated: true, completion: nil)
            return
        }
        
        // 登录
        ToolKit.showSuccess(withStatus: "收藏成功")
    }
}
