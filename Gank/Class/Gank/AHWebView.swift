//
//  AHWebView.swift
//  Gank
//
//  Created by AHuaner on 2016/12/20.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import WebKit

class AHWebViewController: BaseViewController {
    
    var urlString: String?
    
    var contentOffsetY: CGFloat = -kNavBarHeight
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H))
        webView.navigationDelegate = self
        webView.isMultipleTouchEnabled = true
        webView.autoresizesSubviews = true
        webView.scrollView.alwaysBounceVertical = true
        webView.scrollView.delegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        
        loadWithURLString(urlString)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.scrollView.delegate = nil
    }
    
    func loadWithURLString(_ urlString: String?) {
        guard let urlString = urlString else {
            return
        }
        let url = URL(string: urlString)
        self.webView.load(URLRequest(url: url!))
    }
}

extension AHWebViewController: WKNavigationDelegate {
    
}

extension AHWebViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        contentOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > contentOffsetY { // 向上拖拽
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else { // 向下拖拽
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}
