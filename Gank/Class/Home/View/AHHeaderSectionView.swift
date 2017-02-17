//
//  AHHeaderSectionView.swift
//  Gank
//
//  Created by AHuaner on 2016/12/22.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHHeaderSectionView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    var groupModel: AHHomeGroupModel! {
        didSet {
            titleLabel.text = groupModel.groupTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = UIColorTextLightGray
        backgroundColor = RGBColor(248, g: 248, b: 248, alpha: 1.0)
    }
    
    class func headerSectionView() -> AHHeaderSectionView {
        return AHHeaderSectionView.viewFromNib() as! AHHeaderSectionView
    }
}
