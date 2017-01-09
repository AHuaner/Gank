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
        layer.cornerRadius = 3
        let tap = UITapGestureRecognizer(target: self, action: #selector(AHSearchView.showSearchVC))
        self.addGestureRecognizer(tap)
    }
    
    func showSearchVC() {
        let searchVC = AHSearchViewController()
        
        // 自定义转场动画
        searchVC.transitioningDelegate = transitionManager
        searchVC.modalPresentationStyle = UIModalPresentationStyle.custom
        locationVC?.present(searchVC, animated: true, completion: nil)
    }
}
