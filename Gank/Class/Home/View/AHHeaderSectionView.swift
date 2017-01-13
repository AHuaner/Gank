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

    @IBOutlet weak var imageView: UIImageView!
    
    var groupModel: AHHomeGroupModel! {
        didSet {
            titleLabel.text = groupModel.groupTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = UIColorTextBlue
        backgroundColor = UIColorMainBG
    }
    
    class func headerSectionView() -> AHHeaderSectionView {
        return AHHeaderSectionView.viewFromNib() as! AHHeaderSectionView
    }
}
