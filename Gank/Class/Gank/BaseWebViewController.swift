//
//  BaseWebViewController.swift
//  Gank
//
//  Created by AHuaner on 2016/12/20.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController {
    
    var urlString: String?
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H))
        webView.navigationDelegate = self
        webView.isMultipleTouchEnabled = true
        webView.autoresizesSubviews = true
        webView.scrollView.alwaysBounceVertical = true
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return webView
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColorTextBlue
        progressView.trackTintColor = UIColor.white
        progressView.frame = CGRect(x: 0, y: kNavBarHeight, width: kScreen_W, height: 2)
        progressView.alpha = 0.0
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        loadWithURLString(urlString)
    }
    
    fileprivate func setupUI() {
        view.addSubview(webView)
        view.addSubview(progressView)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.alpha = 1.0
            let animated = CGFloat(webView.estimatedProgress) > CGFloat(self.progressView.progress)
            progressView.setProgress(Float(webView.estimatedProgress), animated: animated)
            
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.5, animations: { 
                    self.progressView.alpha = 0.0
                }, completion: { (_) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    func loadWithURLString(_ urlString: String?) {
        guard let urlString = urlString else { return }
        guard let url = URL(string: urlString) else { return }
        
        self.webView.load(URLRequest(url: url))
    }
}

extension BaseWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) { }
}

