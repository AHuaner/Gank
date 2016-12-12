//
//  AHTurnChannelViewController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/10.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHTurnChannelViewController: BaseViewController {
    
    var turnChannelClouse: (() -> Void)?
    
    var tagsTitleArray: [String] = [String]()
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        let btnW: CGFloat = 40.0
        let btnH: CGFloat = 35.0
        let margin: CGFloat = 0.0
        let btnF = CGRect(x: kScreen_W - btnW - margin, y: 30, width: btnW, height: btnH)
        closeBtn.setImage(UIImage(named: "close2_button"), for: .normal)
        closeBtn.frame = btnF
        closeBtn.addTarget(self, action: #selector(AHTurnChannelViewController.close), for: .touchUpInside)
        return closeBtn
    }()
    
    lazy var contentView: UIScrollView = {
        let contentView = UIScrollView(frame: self.view.bounds)
        return contentView
    }()
    
    lazy var listView: AHListView = {
        let listView = AHListView(frame: CGRect(x: 0, y: 80, width: kScreen_W, height: 0))
        let titles = ["11", "22", "33", "44", "55", "66", "77", "88", "99", "10", "11", "12", "13", "14", "15", "11", "22", "33", "44", "55", "66", "77", "88", "99", "10", "11", "12", "13", "14", "15"]
        listView.addTags(titles: titles)
        listView.listViewMoveTagClouse = { [unowned self] title in
            self.moreListView.addTag(tagTitle: title)
        }
        return listView
    }()
    
    lazy var moreListView: AHMoreListView = {
        let moreListView = AHMoreListView(frame: CGRect(x: 0, y: self.listView.MaxY, width: kScreen_W, height: 0))
        let titles = ["11", "22", "33", "44", "55", "66", "77", "88", "99", "10", "11", "12", "13", "14", "15", "11", "22", "33", "44", "55", "66", "77", "88", "99", "10", "11", "12", "13", "14", "15"]
        moreListView.addTags(titles: titles)
        moreListView.listViewAddTagClouse = { [unowned self]  title in
            self.listView.addTag(tagTitle: title)
        }
        return moreListView
    }()
    
    override func viewDidLoad() {
        self.listView.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        self.moreListView.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        super.viewDidLoad()
        self.title = "频道"
        view.backgroundColor = UIColorMainBG
        contentView.contentSize = CGSize(width: kScreen_W, height: self.moreListView.Height + self.listView.Height + 80)
        view.addSubview(contentView)
        contentView.addSubview(closeBtn)
        // 先添加moreListView, 再添加listView
        // 确保listView上的btn移动时, 不会被moreListView遮挡
        contentView.addSubview(moreListView)
        contentView.addSubview(listView)
    }
    
    func close() {
        if turnChannelClouse != nil {
            turnChannelClouse!()
        }
        
        self.dismiss(animated: true, completion: {
            
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            let object = object as AnyObject
            if object.isKind(of: AHListView.self) {
                guard case let frame as CGRect = change?[NSKeyValueChangeKey.newKey] else {
                    return
                }
                // 根据AHListView的frame变化更新moreListView的Y
                self.moreListView.Y = frame.maxY
            } else if object.isKind(of: AHMoreListView.self)  {
                // 根据moreListView的frame变化更新contentSize.height
                contentView.contentSize.height = self.moreListView.Height + self.listView.Height + 80
            }
        }
    }
    
    deinit {
        self.listView.removeObserver(self, forKeyPath: "frame")
        self.moreListView.removeObserver(self, forKeyPath: "frame")
    }
}
