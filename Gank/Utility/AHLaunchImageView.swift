//
//  AHLaunchImageView.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/8.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit



class AHLaunchImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        backgroundColor = MainBGColor
        image = UIImage(named: "adver.png")
        isUserInteractionEnabled = true
    }
    deinit {
        AHLog("---dealloc---\(type(of: self))")
    }
}
