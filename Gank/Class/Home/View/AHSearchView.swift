//
//  AHSearchView.swift
//  Gank
//
//  Created by AHuaner on 2017/1/9.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHSearchView: UIView {
    
    weak var locationVC: AHHomeViewController?
    
    /// 转场代理
    fileprivate lazy var transitionManager: AHTurnVCTransitionManager = {
        let manager = AHTurnVCTransitionManager()
        manager.presentFrame = kScreen_BOUNDS
        return manager
    }()
    
    class func searchView() -> AHSearchView {
        return self.viewFromNib() as! AHSearchView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(AHSearchView.showSearchVC))
        self.addGestureRecognizer(tap)
    }
    
    func showSearchVC() {
        let searchVC = AHSearchViewController()
        let nav = UINavigationController(rootViewController: searchVC)
        
        // 自定义转场动画
        nav.transitioningDelegate = transitionManager
        nav.modalPresentationStyle = UIModalPresentationStyle.custom
        locationVC?.present(nav, animated: true, completion: nil)
    }
}
