//
//  AHPresentationController.swift
//  Gank
//
//  Created by AHuaner on 2017/1/8.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHPresentationController: UIPresentationController {
    var presentFrame = CGRect.zero
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = presentFrame
    }
}
