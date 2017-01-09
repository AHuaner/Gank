//
//  AHClosePopTranstion.swift
//  Gank
//
//  Created by AHuaner on 2017/1/7.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHClosePopTranstion: NSObject {
    
}

extension AHClosePopTranstion: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        let snapView = fromVC.navigationController?.view.superview?.viewWithTag(3333)
        let maskView = fromVC.navigationController?.view.superview?.viewWithTag(4444)
        
        toVC.tabBarController?.tabBar.isHidden = false
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            fromVC.view.transform = CGAffineTransform(translationX: 0, y: fromVC.view.Height)
        }) { (finish) in

            snapView?.removeFromSuperview()
            maskView?.removeFromSuperview()
            // toVC.navigationController?.delegate = nil
            
            transitionContext.completeTransition(true)
        }
    }
}

