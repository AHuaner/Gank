//
//  AHTagBtn.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/10.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHTagBtn: UIButton {
    
    fileprivate let margin: CGFloat = 10
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let btnW = self.frame.size.width
        let btnH = self.frame.size.height
        titleLabel?.frame = CGRect(x: margin, y: margin, width: btnW - 2 * margin, height: btnH - margin * 2)
        
        imageView?.frame = CGRect(x: 2, y: 2, width: 10, height: 10)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = RGBColor(230.0, g: 230.0, b: 230.0, alpha: 1).cgColor
        backgroundColor = RGBColor(250.0, g: 250.0, b: 250.0, alpha: 1)
        adjustsImageWhenHighlighted = false
        setTitleColor(UIColorTextLightGray, for: .normal)
        setTitleColor(UIColorTextBlue, for: .selected)
        titleLabel?.textAlignment = .center
        titleLabel?.font = FontSize(size: 13)
        titleLabel?.adjustsFontSizeToFitWidth = true
        imageView?.isHighlighted = true
    }
}
