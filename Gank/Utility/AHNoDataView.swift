//
//  AHNoDataView.swift
//  Gank
//
//  Created by AHuaner on 2017/3/2.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHNoDataView: UIView {
    
    /// 跳转到干货界面的闭包
    var goGankClouse: (() -> Void)? {
        didSet {
            goGankBtn.isHidden = false
        }
    }
    
    fileprivate lazy var describeLabel: UILabel = {
        let label = UILabel()
        label.text = "还没有收藏的干货"
        label.textColor = UIColorTextGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        label.CenterX = self.CenterX
        label.CenterY = self.CenterY - 50
        return label
    }()
    
    fileprivate lazy var goGankBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 130, height: 35))
        btn.setTitle("去读干货", for: .normal)
        btn.setTitleColor(UIColorTextBlue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.layer.borderColor = UIColorTextBlue.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 17.5
        btn.CenterX = self.describeLabel.CenterX
        btn.CenterY = self.describeLabel.CenterY + 50
        btn.isHidden = true
        btn.addTarget(self, action: #selector(goGankAction), for: .touchUpInside)
        return btn
    }()
    
    init(describeText: String, frame: CGRect) {
        super.init(frame: frame)
        
        describeLabel.text = describeText
        
        self.addSubview(describeLabel)
        self.addSubview(goGankBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func goGankAction() {
        if goGankClouse != nil {
            goGankClouse!()
        }
    }
    
}
