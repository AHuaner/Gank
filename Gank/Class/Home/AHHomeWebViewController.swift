//
//  AHHomeWebViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/1/7.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHHomeWebViewController: BaseWebViewController {
    // MARK: - property
    var gankModel: GankModel?
    
    // 文章是否被收藏
    fileprivate var isCollected: Bool = false
    
    // MARK: - control
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
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    
        cheakIsCollected()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - event && methods
    fileprivate func setupUI() {
        self.title = "加载中..."
        
        let oriImage = UIImage(named: "icon_more")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: oriImage, style: .plain, target: self, action: #selector(AHClassWebViewController.moreClick))
        
        maskBtnView.addTarget(self, action: #selector(self.dismissMoreView), for: .touchUpInside)
        
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
    
    // 检验文章是否已被收藏
    fileprivate func cheakIsCollected() {
        let query: BmobQuery = BmobQuery(className: "Collect")
        
        let array = [["userId": User.info?.objectId], ["gankId": gankModel?.id]]
        query.addTheConstraintByAndOperation(with: array)
        
        query.findObjectsInBackground { (array, error) in
            // 加载失败
            if error != nil { return }
            guard let ganksArr = array else { return }
            if ganksArr.count == 1 { // 以收藏
                self.moreView.gankBe(collected: true)
                self.isCollected = true
                self.gankModel?.objectId = (ganksArr.first as! BmobObject).objectId
            } else { // 未收藏
                self.moreView.gankBe(collected: false)
                self.isCollected = false
                self.gankModel?.objectId = nil
            }
        }
    }
    
    func moreClick() {
        cheakIsCollected()
        
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
    
    // 点击收藏
    func collectGankAction() {
        if User.info == nil { // 未登录
            let loginVC = AHLoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            present(nav, animated: true, completion: nil)
            return
        }
        // 检验用户是否在其他设备登录
        ToolKit.checkUserLoginedWithOtherDevice(noLogin: {
            
            // 登录状态
            // 取消收藏
            if self.isCollected {
                ToolKit.show(withStatus: "正在取消收藏")
                guard let objectId = self.gankModel?.objectId else { return }
                let gank: BmobObject = BmobObject(outDataWithClassName: "Collect", objectId: objectId)
                gank.deleteInBackground { (isSuccessful, error) in
                    if isSuccessful { // 删除成功
                        ToolKit.showSuccess(withStatus: "已取消收藏")
                        self.isCollected = false
                        self.moreView.gankBe(collected: false)
                    } else {
                        AHLog(error!)
                        ToolKit.showError(withStatus: "取消收藏失败")
                    }
                }
                return
            }
            
            // 收藏
            let gankInfo = BmobObject(className: "Collect")
            gankInfo?.setObject(User.info!.objectId, forKey: "userId")
            gankInfo?.setObject(User.info!.mobilePhoneNumber, forKey: "userPhone")
            if let gankModel = self.gankModel {
                gankInfo?.setObject(gankModel.id, forKey: "gankId")
                gankInfo?.setObject(gankModel.desc, forKey: "gankDesc")
                gankInfo?.setObject(gankModel.type, forKey: "gankType")
                gankInfo?.setObject(gankModel.user, forKey: "gankUser")
                gankInfo?.setObject(gankModel.publishedAt, forKey: "gankPublishAt")
                gankInfo?.setObject(gankModel.url, forKey: "gankUrl")
            }
            
            gankInfo?.saveInBackground(resultBlock: { (isSuccessful, error) in
                if error != nil { // 收藏失败
                    AHLog(error!)
                    ToolKit.showError(withStatus: "收藏失败")
                } else { // 收藏成功
                    ToolKit.showSuccess(withStatus: "收藏成功")
                    self.isCollected = true
                    self.moreView.gankBe(collected: true)
                }
            })
        })
    }
    
}
