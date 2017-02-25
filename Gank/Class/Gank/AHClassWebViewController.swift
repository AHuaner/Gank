//
//  AHClassWebViewController.swift
//  Gank
//
//  Created by AHuaner on 2016/12/20.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import WebKit

class AHClassWebViewController: BaseWebViewController {
    
    // MARK: - property
    fileprivate var contentOffsetY: CGFloat = 0.0
    fileprivate var oldContentOffsetY: CGFloat = 0.0
    fileprivate var newContentOffsetY: CGFloat = 0.0
    fileprivate var isDismissAnimation: Bool = true
    fileprivate var isCustomTranstion: Bool = false
    
    var currentCompleted: CGFloat = 0.0
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isCustomTranstion = false
        self.navigationController?.delegate = self
        tabBarController?.tabBar.isHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.delegate = nil
        
        if isCustomTranstion { return }
        tabBarController?.tabBar.isHidden = false
        let snapView = navigationController?.view.superview?.viewWithTag(3333)
        let maskView = navigationController?.view.superview?.viewWithTag(4444)
        snapView?.removeFromSuperview()
        maskView?.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        webView.scrollView.delegate = nil
    }
    
    // MARK: - event && methods
    fileprivate func setupUI() {
        self.title = "加载中..."
        webView.scrollView.delegate = self
        
        let oriImage = UIImage(named: "icon_more")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: oriImage, style: .plain, target: self, action: #selector(moreClick))
        
        maskBtnView.addTarget(self, action: #selector(dismissMoreView), for: .touchUpInside)
        
        moreView.tableViewdidSelectClouse = { [unowned self] (indexPath) in
            self.dismissMoreView()
            switch indexPath.row {
            case 0: // 收藏
                self.collectGankAction()
            case 1: // 分享
                self.shareEvent()
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
            if ganksArr.count == 1 { // 已收藏
                self.moreView.gankBe(collected: true)
                self.isCollected = true
                self.gankModel?.objectId = (ganksArr.first as! BmobObject).objectId
            } else { // 未收藏
                self.moreView.gankBe(collected: false)
                self.isCollected = false
                self.gankModel?.objectId = nil
            }
            
            guard let nav = self.navigationController else { return }
            nav.view.insertSubview(self.maskBtnView, aboveSubview: self.webView)
            nav.view.insertSubview(self.moreView, aboveSubview: self.webView)
            UIView.animate(withDuration: 0.25) {
                self.moreView.alpha = 1
            }
        }
    }
    
    func moreClick() {
        cheakIsCollected()
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
        if User.info == nil { // 未登录状态
            //
            isCustomTranstion = true
            let loginVC = AHLoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            present(nav, animated: true, completion: nil)
            return
        }
        
        ToolKit.checkUserLoginedWithOtherDevice { 
            // 登录状态
            // 取消收藏
            if self.isCollected {
                ToolKit.show(withStatus: "正在取消收藏")
                let gank: BmobObject = BmobObject(outDataWithClassName: "Collect", objectId: self.gankModel?.objectId)
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
        }
    }
    
    fileprivate func shareEvent() {
        UMSocialUIManager.showShareMenuViewInWindow { (platformType, userInfo) in
            let messageObject = UMSocialMessageObject()
            
            let shareObject = UMShareWebpageObject.shareObject(withTitle: "Gank", descr: self.gankModel?.desc, thumImage: UIImage(named: "icon108"))
            shareObject?.webpageUrl = self.gankModel?.url
            messageObject.shareObject = shareObject
            
            UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self) { (data, error) in
                if error == nil {
                    AHLog(data)
                } else {
                    AHLog("分享失败\(error!)")
                }
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension AHClassWebViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        contentOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scrollView还在加载的时候系统会自动调用scrollViewDidScroll
        // 我们要的是scrollView加载好以后再执行下面的代码
        if scrollView.contentSize == CGSize.zero { return }
        
        newContentOffsetY = scrollView.contentOffset.y
        if newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY {
            // setToolViewHidden(true)
            // self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else if newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY {
            // setToolViewHidden(false)
            // self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        
        let begainY = scrollView.contentSize.height - scrollView.Height
        let offsetY = min(0, begainY - scrollView.contentOffset.y)
        
        view.Y = offsetY
        // 拖拽比例
        self.currentCompleted = min(max(0, fabs(offsetY) / 200), 1);
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        oldContentOffsetY = scrollView.contentOffset.y
        
        if currentCompleted > 0.35 {
            if let navigationController = self.navigationController {
                isDismissAnimation = false
                navigationController.popViewController(animated: true)
            }
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension AHClassWebViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            isCustomTranstion = true
            
            if isDismissAnimation {
                return AHClosePopTranstion()
            } else {
                return AHPopTranstion()
            }
        default:
            return nil
        }
    }
}
