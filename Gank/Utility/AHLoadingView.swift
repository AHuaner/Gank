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
        animView.frame.size = CGSize(width: 150, height: 150)
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
    
    func setupUI() {
        var images = [UIImage]()
        for i in 1...5 {
            let image = UIImage(named: "loading\(i)")
            images.append(image!)
        }
        animView.animationDuration = 1
        animView.animationRepeatCount = Int(MAXINTERP)
        animView.animationImages = images
        animView.startAnimating()
        animView.CenterX = self.CenterX
        animView.CenterY = self.CenterY - 100
        
//        backgroundColor = UIColorMainBG
//        let label = UILabel()
//        label.text = "一大波干货正在来袭......."
//        label.sizeToFit()
//        label.center = self.center
//        self.addSubview(label)
    }
}
