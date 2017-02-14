//
//  AHNavBar.swift
//  Gank
//
//  Created by AHuaner on 2016/12/22.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHNavBar: UIView {
    
    var title: String? {
        didSet {
            titleLabel.text = title!
        }
    }
    
    var bgAlpha: CGFloat = 0 {
        didSet {
            self.backgroundColor = UIColorMainBlue.withAlphaComponent(bgAlpha)
        }
    }
    
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor.white
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 0, y: 20, width: 150, height: 44)
        titleLabel.CenterX = self.CenterX
        return titleLabel
    }()
    
    lazy var searchView: AHSearchView = {
        let searchView = AHSearchView.searchView()
        return searchView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView(frame: CGRect(x: 0, y: 64, width: kScreen_W, height: 0.5))
        lineView.backgroundColor = UIColorLine
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        addSubview(searchView)
        
        let W: CGFloat = 80
        self.searchView.frame = CGRect(x: kScreen_W - W - 15, y: 27, width: W, height: 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLongStyle() {
        UIView.animate(withDuration: 0.5) { 
            self.searchView.frame = CGRect(x: 15, y: 27, width: kScreen_W - 30, height: 30)
        }
        DispatchQueue.main.asyncAfter(deadline: 0.1) {
            self.searchView.seatchTitle.text = "搜索更多干货"
        }
    }
    
    func showShortStyle() {
        let W: CGFloat = 80
        UIView.animate(withDuration: 0.5) { 
            self.searchView.frame = CGRect(x: kScreen_W - W - 15, y: 27, width: W, height: 30)
            self.searchView.seatchTitle.text = "搜索"
        }
    }
    
}
