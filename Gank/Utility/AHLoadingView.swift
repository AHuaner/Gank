//
//  AHLoadingView.swift
//  Gank
//
//  Created by AHuaner on 2016/12/12.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHLoadingView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColorMainBG
        let label = UILabel()
        label.text = "一大波干货正在来袭......."
        label.sizeToFit()
        label.center = self.center
        self.addSubview(label)
    }
}
