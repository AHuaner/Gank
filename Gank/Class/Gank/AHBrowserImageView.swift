//
//  AHBrowserImageView.swift
//  
//
//  Created by AHuaner on 2016/12/17.
//
//

import UIKit

class AHBrowserImageView: YYAnimatedImageView {
    
    var totalScale: CGFloat = 1.0
    
    var isScale: Bool {
        return self.totalScale != 1.0
    }
    
    lazy var zoomingImageView: YYAnimatedImageView = {
        let zoomingImageView = YYAnimatedImageView(image: self.image)
        zoomingImageView.contentMode = .scaleAspectFit
        var imageViewH = self.Height
        let imageSize = self.image!.size
        if imageSize.width > 0 {
            imageViewH = self.Width * (imageSize.height / imageSize.width)
        }
        zoomingImageView.bounds = CGRect(x: 0, y: 0, width: self.Width, height: imageViewH)
        zoomingImageView.center = self.zoomingScroolView.center
        return zoomingImageView
    }()
    
    lazy var zoomingScroolView: UIScrollView = {
        let zoomingScroolView = UIScrollView(frame: self.bounds)
        zoomingScroolView.backgroundColor = UIColor.black
        zoomingScroolView.contentSize = self.bounds.size
        return zoomingScroolView
    }()
    
    lazy var waitingView: AHWaitingView = {
        let waitingView = AHWaitingView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        waitingView.tpye = AHWaitingViewType.AHDWaitingViewTypeLoop
        return waitingView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.contentMode = .scaleAspectFit
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(AHBrowserImageView.zoomImage(pinch:)))
        addGestureRecognizer(pinch)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func zoomImage(pinch: UIPinchGestureRecognizer) {
        if self.image == nil { return }
        zoomingScroolView.addSubview(zoomingImageView)
        addSubview(zoomingScroolView)
        
        let scale = pinch.scale
        let temp = self.totalScale + (scale - 1.0)
        
        zoomWithScale(temp)
        pinch.scale = 1.0
    }
    
    fileprivate func zoomWithScale(_ totalScale: CGFloat) {
        
        // 最大缩放2倍,最小0.5倍
        if (self.totalScale < 0.5 && totalScale < self.totalScale) || (self.totalScale > 2.0 && totalScale > self.totalScale) { return }
        
        self.totalScale = totalScale
        zoomingImageView.transform = CGAffineTransform(scaleX: totalScale, y: totalScale)
        
        if totalScale > 1 {
            let contentW = zoomingImageView.Width
            let contentH = max(zoomingImageView.Height, self.Height)
            
            zoomingImageView.center = CGPoint(x: contentW * 0.5, y: contentH * 0.5)
            zoomingScroolView.contentSize = CGSize(width: contentW, height: contentH)
            
            var offset = zoomingScroolView.contentOffset
            offset.x = (contentW - zoomingScroolView.Width) * 0.5
            zoomingScroolView.contentOffset = offset
        } else {
            zoomingScroolView.contentSize = zoomingScroolView.frame.size
            zoomingScroolView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            zoomingImageView.center = zoomingScroolView.center
        }
    }
    
    func doubleTapToZoomWithScale(_ scale: CGFloat) {
        if self.image == nil { return }
        zoomingScroolView.addSubview(zoomingImageView)
        addSubview(zoomingScroolView)

        UIView.animate(withDuration: 0.5, animations: { 
            self.zoomWithScale(scale)
        }) { (_) in
            if scale == 1 {
                self.zoomingScroolView.removeFromSuperview()
            }
        }
    }
    
    func eliminateScale() {
        zoomingScroolView.removeFromSuperview()
        totalScale = 1.0
    }
}
