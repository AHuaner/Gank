//
//  AHImageCell.swift
//  Gank
//
//  Created by AHuaner on 2016/12/14.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHImageCell: UICollectionViewCell {
    
    var index: Int!
    
    var classModel: AHClassModel! {
        didSet {
            if let count = classModel.images?.count {
                let urlString = classModel.images![index]
                
                // 只有一张图片
                if count == 1 {
                    // 可以得到图片的高度宽度, 根据宽高比缩放图片
                    if classModel.imageW != 0 && classModel.imageH != 0 {
                        let small_url = urlString + "?imageView2/1/w/\(Int(classModel.imageContainFrame.width) * 2)/h/\(Int(classModel.imageContainFrame.height) * 2)/interlace/1"
                        imageView.yy_imageURL = URL(string: small_url)
                    
                    //
                    } else {
                        imageView.yy_imageURL = URL(string: urlString)
                    }
                // 有多张图片
                } else if count > 1 {
                    imageView.yy_imageURL = URL(string: urlString)
                }
            }
        }
    }
    
    @IBOutlet weak var imageView: YYAnimatedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
