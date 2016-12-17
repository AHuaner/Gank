//
//  AHPhotoBrowser.swift
//  Gank
//
//  Created by AHuaner on 2016/12/16.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

let AHPhotoBrowserImageViewMargin: CGFloat = 5

class AHPhotoBrowser: UIView {
    var currentImageIndex: Int!
    var imageCount: Int!
    var sourceImagesContainerView: UIView!
    
    var placeholderImageForIndexClouse: ((_ index: Int) -> UIImage)?
    
    var highQualityImageURLForIndexClouse: ((_ index: Int) -> URL)?
    
    fileprivate var isShowedFistView: Bool = false
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        
        for i in 0..<self.imageCount {
            let imageView = AHBrowserImageView()
            imageView.tag = i
            imageView.isUserInteractionEnabled = true
            imageView.contentMode = .scaleAspectFit
            let tap = UITapGestureRecognizer(target: self, action: #selector(AHPhotoBrowser.phonoClick(tap:)))
            imageView.addGestureRecognizer(tap)
            scrollView.addSubview(imageView)
        }
        return scrollView
    }()
    
    func phonoClick(tap: UITapGestureRecognizer) {
        scrollView.isHidden = true
        let currentImageView = tap.view as! AHBrowserImageView
        let currentIndex = currentImageView.tag
        
        let sourceViewContain: UICollectionView = sourceImagesContainerView as! UICollectionView
        let indexPath = IndexPath(item: currentIndex, section: 0)
        let sourceView = sourceViewContain.cellForItem(at: indexPath) as! AHImageCell
        let targetTemp = sourceImagesContainerView.convert(sourceView.frame, to: self)
        
        let tempView = UIImageView()
        tempView.contentMode = sourceView.imageView.contentMode
        tempView.clipsToBounds = true
        tempView.image = currentImageView.image
        
        var h = (self.Width / (currentImageView.image?.size.width)!) * (currentImageView.image?.size.height)!
        
        if currentImageView.image == nil {
            h = self.Height
        }
        tempView.bounds = CGRect(x: 0, y: 0, width: self.Width, height: h)
        tempView.center = self.center
        
        addSubview(tempView)
        
        UIView.animate(withDuration: 0.5, animations: {
            tempView.frame = targetTemp
            self.backgroundColor = UIColor.clear
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(scrollView)
        setupImageOfImageViewForIndex(index: currentImageIndex)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RGBColor(0, g: 0, b: 0, alpha: 0.95)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = self.bounds
        rect.size.width += AHPhotoBrowserImageViewMargin * 2
        scrollView.bounds = rect
        scrollView.center = self.center
        
        let y: CGFloat = 0
        let w = scrollView.Width - 2 * AHPhotoBrowserImageViewMargin
        let h = scrollView.Height
        
        for i in 0..<scrollView.subviews.count {
            let x = AHPhotoBrowserImageViewMargin + CGFloat(i) * (AHPhotoBrowserImageViewMargin * 2 + w)
            scrollView.subviews[i].frame = CGRect(x: x, y: y, width: w, height: h)
        }
        scrollView.contentSize = CGSize(width: CGFloat(scrollView.subviews.count) * scrollView.Width, height: 0)
        scrollView.contentOffset = CGPoint(x: CGFloat(currentImageIndex) * scrollView.Width, y: 0)
        
        if !isShowedFistView {
            showFirstImage()
        }
    }
    
    
    func show() {
        let window = UIApplication.shared.keyWindow!
        self.frame = window.bounds
        window.addSubview(self)
    }
    
    fileprivate func showFirstImage() {
        let sourceViewContain: UICollectionView = sourceImagesContainerView as! UICollectionView
        let indexPath = IndexPath(item: currentImageIndex, section: 0)
        let sourceView = sourceViewContain.cellForItem(at: indexPath)
        let rect = sourceViewContain.convert(sourceView!.frame, to: self)
        
        let tempImageView = UIImageView()
        tempImageView.image = placeholderImageForIndex(index: currentImageIndex)
        self.addSubview(tempImageView)
        
        let targetTemp = scrollView.subviews[currentImageIndex].bounds
        tempImageView.frame = rect
        tempImageView.contentMode = scrollView.subviews[currentImageIndex].contentMode
        scrollView.isHidden = true
        
        UIView.animate(withDuration: 0.5, animations: {
            tempImageView.center = self.center
            tempImageView.bounds = CGRect(x: 0, y: 0, width: targetTemp.width, height: targetTemp.height)
        }) { (_) in
            self.isShowedFistView = true
            tempImageView.removeFromSuperview()
            self.scrollView.isHidden = false
        }
    }
    
    fileprivate func placeholderImageForIndex(index: Int) -> UIImage? {
        if placeholderImageForIndexClouse != nil {
            return placeholderImageForIndexClouse!(index)
        }
        return nil
    }
    
    fileprivate func highQualityImageURLForIndex(index: Int) -> URL? {
        if highQualityImageURLForIndexClouse != nil {
            return highQualityImageURLForIndexClouse!(index)
        }
        return nil
    }
    
    // 加载图片
    fileprivate func setupImageOfImageViewForIndex(index: Int) {
        let imageView = scrollView.subviews[index] as! AHBrowserImageView
        currentImageIndex = index
        if highQualityImageURLForIndex(index: index) != nil {
            imageView.yy_imageURL = highQualityImageURLForIndex(index: index)!
        } else {
            imageView.image = placeholderImageForIndex(index: index)
        }
    }
}

extension AHPhotoBrowser: UIScrollViewDelegate {
    
}
