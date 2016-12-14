//
//  AHClassCell.swift
//  Gank
//
//  Created by AHuaner on 2016/12/14.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHClassCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    lazy var pictureView: YYAnimatedImageView = {
        let pictureView = YYAnimatedImageView()
        self.contentView.addSubview(pictureView)
        return pictureView
    }()
    
    lazy var morePicturesView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let morePicturesView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        morePicturesView.collectionViewLayout = UICollectionViewLayout()
        self.contentView.addSubview(morePicturesView)
        return morePicturesView
    }()
    
    var classModel: AHClassModel! {
        didSet {
            self.contentLabel.text = classModel.desc
            
            // 只有一张图片
            if classModel.imageType == AHImageType.oneImage {
                self.pictureView.isHidden = false
                self.morePicturesView.isHidden = true
                self.pictureView.frame = classModel.imageFrame
                if let urlString = classModel.images?[0] {
                    let small_url = urlString + "?imageView2/1/w/\(Int(classModel.imageFrame.width))/h/\(Int(classModel.imageFrame.height))"
                    self.pictureView.yy_imageURL = URL(string: small_url)
                }
            }
            
            // 有多张图片
            if classModel.imageType == AHImageType.moreImage {
                AHLog(classModel.images?.count)
                self.pictureView.isHidden = true
                self.morePicturesView.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func cellWithTableView(_ tableview: UITableView) -> AHClassCell {
        
        var cell = tableview.dequeueReusableCell(withIdentifier: "AHClassCell")
        if cell == nil {
            cell = self.viewFromNib() as! AHClassCell
        }
        return cell as! AHClassCell
    }
}
