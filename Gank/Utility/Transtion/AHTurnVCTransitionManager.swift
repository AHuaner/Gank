//
//  AHTurnVCTransitionManager.swift
//  Gank
//
//  Created by AHuaner on 2017/1/8.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHTurnVCTransitionManager: NSObject {
    var presentFrame = CGRect.zero
    fileprivate var isPresent = false
}

extension AHTurnVCTransitionManager: UIViewControllerTransitioningDelegate {
    
    // 该方法用于返回一个负责转场动画的对象
    // 可以在该对象中控制弹出视图的尺寸等
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?{
        
        let presentController = AHPresentationController(presentedViewController: presented, presenting: presenting)
        
        presentController.presentFrame = presentFrame
        
        return presentController
    }
    
    // 该方法用于返回一个负责转场如何出现的对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = true
        return self
    }
    
    // 该方法用于返回一个负责转场如何消失的对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = false
        return self
    }
}

extension AHTurnVCTransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // 专门用于管理modal如何展现和消失的, 无论是展现还是消失都会调用该方法
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            popoverViewWillShow(transitionContext)
        } else {
            popoverViewWillHide(transitionContext)
        }
    }
    
    fileprivate func popoverViewWillShow(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        transitionContext.containerView.addSubview(toView)
        toView.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.alpha = 1
        }, completion: { (_) in
            transitionContext.completeTransition(true)
        })
    }
    
    fileprivate func popoverViewWillHide(_ transitionContext: UIViewControllerContextTransitioning?) {
        
        guard let fromView = transitionContext?.view(forKey: UITransitionContextViewKey.from) else { return }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.alpha = 0
        }, completion: { (_) in
            transitionContext?.completeTransition(true)
        })
    }
}
