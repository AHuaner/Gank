//
//  AHPopTranstion.swift
//  Gank
//
//  Created by AHuaner on 2017/1/7.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHPopTranstion: NSObject {

}

extension AHPopTranstion: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        toVC.view.alpha = 0
        fromVC.view.isHidden = true
       
        guard let snapShotView = fromVC.view.snapshotView(afterScreenUpdates: false) else { return }
        snapShotView.frame = fromVC.view.frame
    
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapShotView)
        
        let snapView = fromVC.navigationController?.view.superview?.viewWithTag(3333)
        let maskView = fromVC.navigationController?.view.superview?.viewWithTag(4444)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            snapShotView.transform = CGAffineTransform(translationX: 0, y: -snapShotView.Height)
            snapView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            maskView?.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { (finish) in
            snapShotView.removeFromSuperview()
            snapView?.removeFromSuperview()
            maskView?.removeFromSuperview()
            
            toVC.tabBarController?.tabBar.isHidden = false
            toVC.view.alpha = 1.0
            // toVC.navigationController?.delegate = nil
            
            transitionContext.completeTransition(true)
        }
    }
}
