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
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var pictureViewClickClouse: ((_ index: IndexPath) -> Void)?
    
    lazy var pictureView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let pictureView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        pictureView.dataSource = self
        pictureView.delegate = self
        pictureView.backgroundColor = UIColor.white
        pictureView.isScrollEnabled = false
        pictureView.register(UINib(nibName: AHImageCell.getClassName(), bundle: nil), forCellWithReuseIdentifier: "collectionID")
        self.contentView.addSubview(pictureView)
        return pictureView
    }()
    
    var classModel: AHClassModel! {
        didSet {
            self.contentLabel.text = classModel.desc
            self.userLabel.text = classModel.user
            self.timeLabel.text = classModel.publishedAt
            self.pictureView.frame = classModel.imageContainFrame
            self.pictureView.isHidden = true
            
            // 只有一张图片
            if classModel.imageType == AHImageType.oneImage {
                self.pictureView.isHidden = false

                let layout = UICollectionViewFlowLayout()
                layout.itemSize = CGSize(width: classModel.imageContainFrame.width, height: classModel.imageContainFrame.height)
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
                self.pictureView.setCollectionViewLayout(layout, animated: false)
            }
            
            // 有多张图片
            if classModel.imageType == AHImageType.moreImage {
                self.pictureView.isHidden = false
                
                let layout = UICollectionViewFlowLayout()
                let collectMargin = cellMargin / 2
                layout.minimumInteritemSpacing = collectMargin
                layout.minimumLineSpacing = collectMargin
                let itemWidth = (cellMaxWidth - collectMargin * 2) / 3
                layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
                self.pictureView.setCollectionViewLayout(layout, animated: false)
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

extension AHClassCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = classModel.images?.count else {
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionID", for: indexPath) as! AHImageCell
        cell.index = indexPath.item
        cell.classModel = classModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let browser = AHPhotoBrowser()
        browser.currentImageIndex = indexPath.item
        browser.imageCount = classModel.images?.count
        browser.sourceImagesContainerView = collectionView
        
        browser.placeholderImageForIndexClouse = { (index) in
            let newIndexPath = IndexPath(item: index, section: 0)
            let cell = collectionView.cellForItem(at: newIndexPath) as! AHImageCell
            let placeholderImage = cell.imageView.image
            return placeholderImage!
        }
        
        browser.highQualityImageURLForIndexClouse = { [unowned self] (index) in
            let urlString = self.classModel.images?[index]
            let url = URL(string: urlString!)
            return url!
        }

        browser.show()
    }
}
