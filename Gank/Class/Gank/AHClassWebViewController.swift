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
    
    var currentCompleted: CGFloat = 0.0
    
    var animatedTransition: Bool = false
    
    var classModel: AHClassModel?
    var homeGankModel: AHHomeGankModel?
    
    lazy var toolView: AHWebToolView = {
        let toolView = AHWebToolView.webToolView()
        toolView.frame = CGRect(x: 0, y: kScreen_H - kBottomBarHeight, width: kScreen_W, height: kBottomBarHeight)
        toolView.backBtn.addTarget(self, action: #selector(AHClassWebViewController.backAciton), for: .touchUpInside)
        toolView.forwardBtn.addTarget(self, action: #selector(AHClassWebViewController.forwardAction), for: .touchUpInside)
        toolView.reloadBtn.addTarget(self, action:#selector(AHClassWebViewController.reloadAction), for: .touchUpInside)
        toolView.likeBtn.addTarget(self, action: #selector(AHClassWebViewController.likeAction), for: .touchUpInside)
        toolView.backBtn.isEnabled = false
        toolView.forwardBtn.isEnabled = false
        return toolView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !animatedTransition { return }
        self.navigationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !animatedTransition { return }
        self.navigationController?.delegate = nil
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
        view.autoresizesSubviews = false
        // view.addSubview(toolView)
    }

    func setToolViewHidden(_ hidden: Bool) {
        if hidden { //隐藏
            UIView.animate(withDuration: 0.5, animations: {
                self.toolView.transform = CGAffineTransform(translationX: 0, y: kBottomBarHeight)
            })
        } else { // 显示
            UIView.animate(withDuration: 0.5, animations: {
                self.toolView.transform = CGAffineTransform.identity
            })
        }
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
    
    override func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        super.webView(webView, didCommit: navigation)
        toolView.backBtn.isEnabled = webView.canGoBack
        toolView.forwardBtn.isEnabled = webView.canGoForward
    }
}

extension AHClassWebViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        contentOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        newContentOffsetY = scrollView.contentOffset.y
        if newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY {
            setToolViewHidden(true)
        } else if newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY {
            setToolViewHidden(false)
        }
        
        if !animatedTransition { return }
        
        let begainY = scrollView.contentSize.height - scrollView.Height
        let offsetY = min(0, begainY - scrollView.contentOffset.y)
        view.Y = offsetY
        
        // 拖拽比例
        self.currentCompleted = min(max(0, fabs(offsetY) / 200), 1);
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        oldContentOffsetY = scrollView.contentOffset.y
        
        if !animatedTransition { return }
        
        if currentCompleted > 0.35 {
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            }
        }
    }
}

extension AHClassWebViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AHPopTranstion()
    }
}
