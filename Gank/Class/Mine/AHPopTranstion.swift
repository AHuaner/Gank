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
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! AHClassWebViewController
        
        fromVC.view.isHidden = true
       
        guard let snapShotView = fromVC.view.snapshotView(afterScreenUpdates: false) else { return }
        snapShotView.frame = fromVC.view.frame
        snapShotView.Y += 44
        
        let maskView = UIView(frame: containerView.frame)
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        containerView.addSubview(toVC.view)
        containerView.addSubview(maskView)
        containerView.addSubview(snapShotView)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext) - 0.1, animations: {
            snapShotView.transform = CGAffineTransform(translationX: 0, y: -snapShotView.Height)
        }) { (finish) in
            snapShotView.removeFromSuperview()
            maskView.removeFromSuperview()
            toVC.tabBarController?.tabBar.isHidden = false
            
            UIView.animate(withDuration: 0.1, animations: {
                toVC.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: { (finish) in

                transitionContext.completeTransition(true)
            })
        }
    }
}
