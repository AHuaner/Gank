//
//  AHImageCell.swift
//  Gank
//
//  Created by AHuaner on 2016/12/14.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHImageCell: UICollectionViewCell {
    
    var urlString: String! {
        didSet {
            let url = URL(string: urlString)
            imageView.yy_imageURL = url
        }
    }
    
    @IBOutlet weak var imageView: YYAnimatedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
