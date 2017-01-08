//
//  AHTurnChannelViewController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/10.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHTurnChannelViewController: BaseViewController {
    
    ///
    var turnChannelClouse: ((_ showTags: [String], _ moreTags: [String]) -> Void)?
    
    /// 已显示的tags
    var showTagsArray: [String] = [String]()
    
    /// 未显示的tags
    var moreTagsArray: [String] = [String]()
    
    fileprivate let listViewY: CGFloat = 40
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        let btnW: CGFloat = 35.0
        let btnF = CGRect(x: kScreen_W - btnW, y: 0, width: btnW, height: btnW)
        closeBtn.setImage(UIImage(named: "close2_button"), for: .normal)
        closeBtn.frame = btnF
        closeBtn.addTarget(self, action: #selector(AHTurnChannelViewController.close), for: .touchUpInside)
        return closeBtn
    }()
    
    lazy var titleView: UIView = {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: 35));
        let titleLable = UILabel(frame: titleView.bounds)
        titleLable.text = "频道管理"
        titleLable.textAlignment = .center
        titleLable.font = FontSize(size: 15)
        titleLable.textColor = RGBColor(51, g: 51, b: 51, alpha: 1.0)
        titleView.addSubview(titleLable)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 34, width: kScreen_W, height: 1))
        lineView.backgroundColor = RGBColor(222, g: 222, b: 222, alpha: 1)
        titleView.addSubview(lineView)
        return titleView
    }()
    
    lazy var contentView: UIScrollView = {
        let contentView = UIScrollView(frame: self.view.bounds)
        return contentView
    }()
    
    lazy var listView: AHListView = {
        let listView = AHListView(frame: CGRect(x: 0, y: self.listViewY, width: kScreen_W, height: 0))
        listView.addTags(titles: self.showTagsArray)
        listView.listViewMoveTagClouse = { [unowned self] title in
            self.moreListView.addTag(tagTitle: title)
        }
        return listView
    }()
    
    lazy var moreListView: AHMoreListView = {
        let moreListView = AHMoreListView(frame: CGRect(x: 0, y: self.listView.MaxY, width: kScreen_W, height: 0))
        moreListView.addTags(titles: self.moreTagsArray)
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
        contentView.contentSize = CGSize(width: kScreen_W, height: self.moreListView.Height + self.listView.Height + listViewY)
        view.addSubview(contentView)
        contentView.addSubview(titleView)
        contentView.addSubview(closeBtn)
        // 先添加moreListView, 再添加listView
        // 确保listView上的btn移动时, 不会被moreListView遮挡
        contentView.addSubview(moreListView)
        contentView.addSubview(listView)
    }
    
    func close() {
        if turnChannelClouse != nil {
            turnChannelClouse!(listView.tagTitleArray, moreListView.tagTitleArray)
        }
        
        self.dismiss(animated: true, completion: {})
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
                contentView.contentSize.height = self.moreListView.Height + self.listView.Height + listViewY
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        self.listView.removeObserver(self, forKeyPath: "frame")
        self.moreListView.removeObserver(self, forKeyPath: "frame")
    }
}
