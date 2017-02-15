//
//  AHPhotoBrowser.swift
//  Gank
//
//  Created by AHuaner on 2016/12/16.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import YYWebImage

let AHPhotoBrowserImageViewMargin: CGFloat = 5
let AHPhotoBrowserShowImageDuration: CGFloat = 0.3

class AHPhotoBrowser: UIView {
    var currentImageIndex: Int!
    var imageCount: Int!
    var sourceImagesContainerView: UIView!
    
    var placeholderImageForIndexClouse: ((_ index: Int) -> UIImage?)?
    var highQualityImageURLForIndexClouse: ((_ index: Int) -> URL?)?
    
    fileprivate var isShowedFistView: Bool = false
    fileprivate var isWillDisappear: Bool = false
    
    lazy var indexLabel: UILabel = {
        let indexLabel = UILabel()
        indexLabel.textAlignment = .center
        indexLabel.textColor = UIColor.white
        indexLabel.font = FontSize(size: 20)
        indexLabel.backgroundColor = UIColor.clear
        indexLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        indexLabel.isHidden = true
        if self.imageCount > 1 {
            indexLabel.text = "1/\(self.imageCount!)"
        }
        return indexLabel
    }()
    
    lazy var saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.setTitle("保存", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.backgroundColor = RGBColor(0, g: 0, b: 0, alpha: 0.9)
        saveButton.layer.cornerRadius = 5
        saveButton.clipsToBounds = true
        saveButton.addTarget(self, action: #selector(AHPhotoBrowser.saveImage), for: .touchUpInside)
        return saveButton
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.activityIndicatorViewStyle = .whiteLarge
        indicatorView.center = self.center
        return indicatorView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isHidden = true
        for i in 0..<self.imageCount {
            let imageView = AHBrowserImageView(frame: CGRect.zero)
            imageView.tag = i
            
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(AHPhotoBrowser.phonoClickAction(tap:)))
            imageView.addGestureRecognizer(singleTap)
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(AHPhotoBrowser.doubleTapAction(tap:)))
            doubleTap.numberOfTapsRequired = 2
            imageView.addGestureRecognizer(doubleTap)
            singleTap.require(toFail: doubleTap)
            
            scrollView.addSubview(imageView)
        }
        return scrollView
    }()
    
    func saveImage() {
        let index = Int(scrollView.contentOffset.x / scrollView.Width)
        let currentImageView = scrollView.subviews[index] as! AHBrowserImageView
        guard let image = currentImageView.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(savedOK(image:didFinishSavingWithError:contextInfo:)), nil)
        
        UIApplication.shared.keyWindow?.addSubview(indicatorView)
        indicatorView.startAnimating()
    }
    
    func savedOK(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        indicatorView.removeFromSuperview()
        let label = UILabel()
        label.textColor = UIColor.white
        label.backgroundColor = RGBColor(0.1, g: 0.1, b: 0.1, alpha: 0.9)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.bounds = CGRect(x: 0, y: 0, width: 150, height: 150)
        label.center = self.center
        label.textAlignment = .center
        label.font = FontSize(size: 17)
        UIApplication.shared.keyWindow?.addSubview(label)
        UIApplication.shared.keyWindow?.bringSubview(toFront: label)
        
        if error != nil {
            label.text = " >_< 保存失败 "
        } else {
            label.text = " ^_^ 保存成功 "
        }
        DispatchQueue.main.asyncAfter(deadline: 1.0) { 
            label.removeFromSuperview()
        }
    }
    
    func phonoClickAction(tap: UITapGestureRecognizer) {
        // 显示状态栏
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeStatusBarNotifica"), object: nil)
        
        scrollView.isHidden = true
        isWillDisappear = true
        
        let currentImageView = tap.view as! AHBrowserImageView
        let currentIndex = currentImageView.tag
        
        let sourceViewContain: UICollectionView = sourceImagesContainerView as! UICollectionView
        let indexPath = IndexPath(item: currentIndex, section: 0)
        guard let sourceView = sourceViewContain.cellForItem(at: indexPath) as? AHImageCell else {
            AHLog("崩溃")
            self.removeFromSuperview()
            return
        }
        
        let targetTemp = sourceImagesContainerView.convert(sourceView.frame, to: self)
        
        let tempView = UIImageView()
        tempView.contentMode = sourceView.imageView.contentMode
        tempView.clipsToBounds = true
        tempView.image = currentImageView.image
        
        var h: CGFloat
        
        if currentImageView.image != nil {
            h = (self.Width / (currentImageView.image?.size.width)!) * (currentImageView.image?.size.height)!
        } else {
            h = self.Height
        }
        
        tempView.bounds = CGRect(x: 0, y: 0, width: self.Width, height: h)
        tempView.center = self.center
        
        addSubview(tempView)
        
        saveButton.isHidden = true
        
        UIView.animate(withDuration: TimeInterval(AHPhotoBrowserShowImageDuration), animations: {
            tempView.frame = targetTemp
            self.backgroundColor = UIColor.clear
            self.indexLabel.alpha = 0.001
        }) { (_) in
            self.removeFromSuperview()
            
            let sourceViewContain: UICollectionView = self.sourceImagesContainerView as! UICollectionView
            let indexPath = IndexPath(item: self.currentImageIndex, section: 0)
            sourceViewContain.reloadItems(at: [indexPath])
        }
    }
    
    func doubleTapAction(tap: UITapGestureRecognizer) {
        let imageView = tap.view as! AHBrowserImageView
        let scale: CGFloat
        if imageView.isScale {
            scale = 1.0
        } else {
            scale = 2.0
        }
        imageView.doubleTapToZoomWithScale(scale)
    }
    
    // 当前的view添加到父控制上, 或者从父控制器上移除时, 都会调用这个方法
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        // 当前的view添加到父控制器上执行
        if !isWillDisappear {
            addSubview(scrollView)
            addSubview(indexLabel)
            addSubview(saveButton)
            setupImageOfImageViewForIndex(index: currentImageIndex)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RGBColor(0, g: 0, b: 0, alpha: 1)
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
        
        indexLabel.center = CGPoint(x: self.Width * 0.5, y: 35)
        saveButton.frame = CGRect(x: 30, y: self.Height - 70, width: 50, height: 25)
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
        
        UIView.animate(withDuration: TimeInterval(AHPhotoBrowserShowImageDuration), animations: {
            tempImageView.center = self.center
            tempImageView.bounds = CGRect(x: 0, y: 0, width: targetTemp.width, height: targetTemp.height)
        }) { (_) in
            tempImageView.removeFromSuperview()
            
            self.isShowedFistView = true
            self.scrollView.isHidden = false
            self.indexLabel.isHidden = false
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
        if imageView.isLoadedImage { return }
        
        imageView.image = imageFromCache(url: highQualityImageURLForIndex(index: index)) ?? placeholderImageForIndex(index: index)
        currentImageIndex = index
        
        if ToolKit.getNetWorkType() != "Wifi" && onlyWifiDownPic == true { return }
        
        if highQualityImageURLForIndex(index: index) != nil {
            imageView.setImage(url: highQualityImageURLForIndex(index: index), placeholderImage: placeholderImageForIndex(index: index))
        }
        
        // 不要再回调里面设置
        imageView.isLoadedImage = true
    }
    
    fileprivate func imageFromCache(url: URL?) -> UIImage? {
        guard let url = url else { return nil }
        let cacheKey = YYWebImageManager.shared().cacheKey(for: url)
        let image = YYWebImageManager.shared().cache?.getImageForKey(cacheKey)
        
        return image
    }
}

extension AHPhotoBrowser: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int((scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width)

        // 缩放的图片在拖动一定距离后清除缩放
        let margin: CGFloat = 120
        let x: CGFloat = scrollView.contentOffset.x
        if (x - CGFloat(index) * self.Width) > margin || (x - CGFloat(index) * self.Width) < -margin {
            let imageView = scrollView.subviews[index] as! AHBrowserImageView
            if imageView.isScale {
                UIView.animate(withDuration: 0.3, animations: {
                    imageView.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    imageView.eliminateScale()
                })
            }
        }
        if !isWillDisappear {
            indexLabel.text = "\(index + 1)/\(self.imageCount!)"
        }
        setupImageOfImageViewForIndex(index: index)
    }
}
