//
//  AHSeatchTagBtn.swift
//  Gank
//
//  Created by AHuaner on 2017/1/12.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHSeatchTagBtn: UIButton {
    let margin: CGFloat = 8
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let btnW = self.frame.size.width
        let btnH = self.frame.size.height
        titleLabel?.frame = CGRect(x: margin, y: margin, width: btnW - 2 * margin, height: btnH - margin * 2)
        
        imageView?.frame = CGRect(x: -3, y: -3, width: 10, height: 10)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        layer.cornerRadius = 3
        backgroundColor = RGBColor(246, g: 246, b: 246, alpha: 1)
        adjustsImageWhenHighlighted = false
        setTitleColor(UIColor.black, for: .normal)
        titleLabel?.textAlignment = .center
        titleLabel?.font = FontSize(size: 12)
        imageView?.isHighlighted = true
    }
}
