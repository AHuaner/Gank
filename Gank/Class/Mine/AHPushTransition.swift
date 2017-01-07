//
//  AHPushTransition.swift
//  Gank
//
//  Created by AHuaner on 2017/1/6.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHPushTransition: NSObject {
    
}

extension AHPushTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! AHGankViewController
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let tempView = UIView(frame: fromVC.popRect)
        tempView.backgroundColor = RGBColor(234, g: 234, b: 234, alpha: 1)
        
        guard let snapShotView = fromVC.tabBarController?.view.snapshotView(afterScreenUpdates: false) else { return }
        snapShotView.frame = containerView.frame
        snapShotView.tag = 3333
        
        let maskView = UIView(frame: containerView.frame)
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        maskView.tag = 4444
    
        fromVC.view.alpha = 0
        toVC.view.alpha = 0
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapShotView)
        containerView.addSubview(maskView)
        containerView.addSubview(tempView)
        
        // 计算缩放比例
        let tempViewYScale = max(2.5 * tempView.frame.minY / tempView.Height, 2.5 * (containerView.Height - tempView.frame.minY) / tempView.Height)
        
        UIView.animate(withDuration: 0.2, animations: {
            snapShotView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);
        }) { (finished) in
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext) - 0.2, animations: { 
                tempView.transform = CGAffineTransform(scaleX: 1, y: tempViewYScale);
            }, completion: { (finished) in
                tempView.removeFromSuperview()
                snapShotView.removeFromSuperview()
                maskView.removeFromSuperview()
                
                toVC.view.alpha = 1.0
                fromVC.view.alpha = 1.0
                
                toVC.navigationController?.view.superview?.insertSubview(snapShotView, at: 0)
                toVC.navigationController?.view.superview?.insertSubview(maskView, aboveSubview: snapShotView)
                toVC.navigationController?.delegate = nil
                //告诉系统动画结束
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
