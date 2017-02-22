//
//  AHLoadingView.swift
//  Gank
//
//  Created by AHuaner on 2016/12/12.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHLoadingView: UIView {
    
    lazy var animView: UIImageView = {
        let animView = UIImageView()
        animView.frame.size = CGSize(width: 300, height: 225)
        self.addSubview(animView)
        return animView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        var images = [UIImage]()
        for i in 1...8 {
            let image = UIImage(named: "loading\(i)")
            images.append(image!)
        }
        animView.animationDuration = 1
        animView.animationRepeatCount = Int(MAXINTERP)
        animView.animationImages = images
        animView.startAnimating()
        animView.center = self.center

       
//        let label = UILabel()
//        label.text = "正在加载"
//        label.sizeToFit()
//        label.center = self.center
//
//        self.addSubview(label)
    }
}
