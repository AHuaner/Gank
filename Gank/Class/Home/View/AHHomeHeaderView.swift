//
//  AHHomeHeaderView.swift
//  Gank
//
//  Created by AHuaner on 2016/12/22.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHHomeHeaderView: UIView {
    
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    
    class func headerView() -> AHHomeHeaderView {
        return AHHomeHeaderView.viewFromNib() as! AHHomeHeaderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
