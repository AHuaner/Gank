//
//  AHClassCell.swift
//  Gank
//
//  Created by AHuaner on 2016/12/14.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHClassCell: UITableViewCell {
    
    // MARK: - control
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var editorBtn: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    lazy var pictureView: UICollectionView = {
        let pictureView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        
        pictureView.dataSource = self
        pictureView.delegate = self
        pictureView.backgroundColor = UIColor.white
        pictureView.isScrollEnabled = false
        pictureView.register(UINib(nibName: AHImageCell.getClassName(), bundle: nil), forCellWithReuseIdentifier: "collectionID")
        self.contentView.addSubview(pictureView)
        return pictureView
    }()
    
    lazy var moreBrn: UIButton = {
        let moreBrn = UIButton()
        moreBrn.setTitle("全文", for: .normal)
        moreBrn.setTitle("收起", for: .selected)
        moreBrn.titleLabel?.font = FontSize(size: 15)
        moreBrn.titleLabel?.textAlignment = .left
        moreBrn.setTitleColor(UIColorMainBlue, for: .normal)
        self.contentView.addSubview(moreBrn)
        moreBrn.addTarget(self, action: #selector(AHClassCell.moreBtnClicked), for: .touchUpInside)
        return moreBrn
    }()
    
    // MARK: - property
    var indexPath: IndexPath!
    
    var moreButtonClickedClouse: ((_ indexPath: IndexPath) -> Void)?
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
    
    var classModel: AHClassModel! {
        didSet {
            self.contentLabel.text = classModel.desc
            self.contentLabel.numberOfLines = 0
            
            self.editorBtn.setTitle(classModel.user, for: .normal)
            self.editorBtn.isHidden = (classModel.user == nil) ? true : false
            
            self.timeBtn.setTitle(classModel.publishedAt, for: .normal)
            
            self.moreBrn.frame = classModel.moreBtnFrame
            self.moreBrn.isHidden = !classModel.isShouldShowMoreButton
            
            // cell是否展开
            if classModel.isOpen {
                self.contentLabel.numberOfLines = 0
                self.moreBrn.setTitle("收起", for: .normal)
            } else {
                self.contentLabel.numberOfLines = 3
                self.moreBrn.setTitle("全文", for: .normal)
            }
            
            self.pictureView.isHidden = true
            
            if classModel.imageType == AHImageType.noImage {
                return
            }
            
            // 只有一张图片
            if classModel.imageType == AHImageType.oneImage {
                
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
                layout.itemSize = CGSize(width: classModel.imageContainFrame.width, height: classModel.imageContainFrame.height)
                
                self.pictureView.isHidden = false
                self.pictureView.setCollectionViewLayout(layout, animated: false)
                self.pictureView.frame = classModel.imageContainFrame
                self.pictureView.reloadData()
            } else if classModel.imageType == AHImageType.moreImage { // 多张图片
                
                layout.minimumInteritemSpacing = collectMargin
                layout.minimumLineSpacing = collectMargin
                let itemWidth = (cellMaxWidth - collectMargin * 2) / 3
                layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
                
                self.pictureView.isHidden = false
                self.pictureView.setCollectionViewLayout(layout, animated: false)
                self.pictureView.frame = classModel.imageContainFrame
                self.pictureView.reloadData()
            }
        }
    }
    
    // MARK: - event && methods
    func moreBtnClicked () {
        self.classModel._cellH = nil
    
        if moreButtonClickedClouse != nil {
            moreButtonClickedClouse!(self.indexPath)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        editorBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
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
        // 隐藏状态栏
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeStatusBarNotifica"), object: nil)
        
        let browser = AHPhotoBrowser()
        browser.currentImageIndex = indexPath.item
        browser.imageCount = classModel.images?.count
        browser.sourceImagesContainerView = collectionView
        
        browser.placeholderImageForIndexClouse = { (index: Int) in
            let newIndexPath = IndexPath(item: index, section: 0)
            guard let cell = collectionView.cellForItem(at: newIndexPath) as? AHImageCell else {
                return nil
            }
            let placeholderImage = cell.imageView.image
            return placeholderImage
        }
        
        browser.highQualityImageURLForIndexClouse = { (index: Int) in
            let urlString = self.classModel.images?[index]
            let url = URL(string: urlString!)
            return url
        }
        
        browser.show()
    }
}
