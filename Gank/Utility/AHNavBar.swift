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
        searchView.frame = CGRect(x: 10, y: 27, width: self.frame.width - 20, height: 30)
        return searchView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView(frame: CGRect(x: 0, y: 64, width: kScreen_W, height: 0.5))
        lineView.backgroundColor = UIColorLine
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColorMainBlue
        addSubview(searchView)
        // addSubview(titleLabel)
        addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
