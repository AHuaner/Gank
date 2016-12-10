//
//  AHTagBtn.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/10.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHTagBtn: UIButton {
    
    let margin: CGFloat = 10
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let btnW = self.frame.size.width
        let btnH = self.frame.size.height
        titleLabel?.frame = CGRect(x: margin, y: margin, width: btnW - 2 * margin, height: btnH - margin * 2)
        
        imageView?.frame = CGRect(x: 2, y: 2, width: 12, height: 12)
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
        backgroundColor = UIColor.white
        adjustsImageWhenHighlighted = false
        setTitleColor(UIColor.gray, for: .normal)
        setTitleColor(UIColor.blue, for: .selected)
        titleLabel?.textAlignment = .center
        titleLabel?.font = FontSize(size: 13)
        titleLabel?.adjustsFontSizeToFitWidth = true
        imageView?.isHighlighted = true
        setImage(UIImage(named: "add_button_high"), for: .normal)
    }
    
    func longPanAction() {
        
    }
    
}
