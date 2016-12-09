//
//  AHTitleListView.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/9.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHTitleListView: UIView {
    
    var closeClouse: (() -> Void)?
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        let btnW: CGFloat = 40.0
        let btnH: CGFloat = 35.0
        let margin: CGFloat = 0.0
        let btnF = CGRect(x: kScreen_W - btnW - margin, y: margin, width: btnW, height: btnH)
        closeBtn.setImage(UIImage(named: "add_button_high"), for: .normal)
        closeBtn.frame = btnF
        closeBtn.addTarget(self, action: #selector(AHTitleListView.close), for: .touchUpInside)
        return closeBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(closeBtn)
        
        let subview = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        subview.backgroundColor = UIColor.white
        self.addSubview(subview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func close() {
        UIView.animate(withDuration: 0.5, animations: {
            self.Y = -(kScreen_H - kNavBarHeight)
            if self.closeClouse != nil {
                self.closeClouse!()
            }
        }, completion: { (_) in
            self.removeFromSuperview()
        })
    }
}
