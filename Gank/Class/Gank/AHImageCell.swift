//
//  AHImageCell.swift
//  Gank
//
//  Created by AHuaner on 2016/12/14.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import YYWebImage

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
                        // 先从缓存中查找对应的高清图
                        let image = imageFromCache(urlString: urlString)
                        
                        if image != nil { // 缓存中有高清图, 直接加载
                            imageView.image = image
                        } else {
                            let small_url = urlString + "?imageView2/1/w/\(Int(classModel.imageContainFrame.width))/h/\(Int(classModel.imageContainFrame.height))/interlace/1"
                            
                            // 当前网络不是wifi, 而且仅允许wifi网络下载图片
                            if ToolKit.getNetWorkType() != "Wifi" && onlyWifiDownPic == true {
                                // 缓存中有缩略图,直接加载
                                imageView.image = imageFromCache(urlString: small_url) ?? UIImage(named: "loading1")
                                return
                            }
                            
                            imageView.yy_imageURL = URL(string: small_url)
                        }
                    // 获取不到图片的高度宽度
                    } else {
                        if ToolKit.getNetWorkType() != "Wifi" && onlyWifiDownPic == true {
                            imageView.image = imageFromCache(urlString: urlString) ?? UIImage(named: "loading1")
                            return
                        }
                        
                        imageView.yy_imageURL = URL(string: urlString)
                    }
                // 有多张图片
                } else if count > 1 {
                    // 先从缓存中查找对应的高清图
                    let image = imageFromCache(urlString: urlString)
                    
                    if image != nil { // 缓存中有高清图, 直接加载
                        imageView.image = image
                    } else {
                        let small_url = urlString + "?imageView2/0/w/\(Int(cellMaxWidth))"
                        
                        if ToolKit.getNetWorkType() != "Wifi" && onlyWifiDownPic == true {
                            imageView.image = imageFromCache(urlString: small_url) ?? UIImage(named: "loading1")
                            return
                        }
                        
                        imageView.yy_imageURL = URL(string: small_url)
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var imageView: YYAnimatedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColorMainBG
    }
    
    fileprivate func imageFromCache(urlString: String) -> UIImage? {
        let url = URL(string: urlString)
        let cacheKey = YYWebImageManager.shared().cacheKey(for: url!)
        let image = YYWebImageManager.shared().cache?.getImageForKey(cacheKey)
        
        return image
    }
}
