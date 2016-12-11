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
    
    lazy var listView: AHListView = {
        let listView = AHListView(frame: CGRect(x: 0, y: 80, width: kScreen_W, height: 0))
        listView.addTags(titles: self.tagsTitleArray)
        listView.listViewMoveTagClouse = { [unowned self] title in
            self.moreListView.addTag(tagTitle: title)
        }
        return listView
    }()
    
    lazy var moreListView: AHMoreListView = {
        let moreListView = AHMoreListView(frame: CGRect(x: 0, y: self.listView.MaxY, width: kScreen_W, height: 0))
        moreListView.addTags(titles: self.tagsTitleArray)
        moreListView.listViewAddTagClouse = { [unowned self]  title in
            self.listView.addTag(tagTitle: title)
        }
        return moreListView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "频道"
        view.backgroundColor = UIColorMainBG
        view.addSubview(closeBtn)
        // 先添加moreListView, 再添加listView
        // 确保listView上的btn移动时, 不会被moreListView遮挡
        view.addSubview(moreListView)
        view.addSubview(listView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func close() {
        if turnChannelClouse != nil {
            turnChannelClouse!()
        }
        
        self.dismiss(animated: true, completion: {
            
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIView.animate(withDuration: 0.25, animations: {
           self.moreListView.Y = self.listView.MaxY
        })
    }
}
