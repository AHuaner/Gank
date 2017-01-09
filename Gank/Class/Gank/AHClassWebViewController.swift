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
    
    fileprivate var contentOffsetY: CGFloat = 0.0
    fileprivate var oldContentOffsetY: CGFloat = 0.0
    fileprivate var newContentOffsetY: CGFloat = 0.0
    fileprivate var isDismissAnimation: Bool = true
    
    fileprivate var isCustomTranstion: Bool = false
    
    var currentCompleted: CGFloat = 0.0
    
    var classModel: AHClassModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
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
    
    fileprivate func setupUI() {
        self.title = "详细内容"
        webView.scrollView.delegate = self
        let oriImage = UIImage(named: "icon_more")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: oriImage, style: .plain, target: self, action: #selector(AHClassWebViewController.moreClick))
        // view.addSubview(toolView)
    }
    
    func moreClick() {
        
    }
    
    func backAciton() {
        webView.goBack()
    }
    
    func forwardAction() {
        webView.goForward()
    }
    
    func reloadAction() {
        webView.reload()
    }
    
    func likeAction() {
        AHLog("喜欢")
    }
}

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
        } else if newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY {
            // setToolViewHidden(false)
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
