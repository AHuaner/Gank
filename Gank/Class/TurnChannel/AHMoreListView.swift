//
//  AHMoreListView.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/11.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHMoreListView: UIView, AHListViewPotocol {
    
    // MARK: - property
    var listViewAddTagClouse: ((String) -> Void)?
    
    /// 存放所有的btn
    var tagArray: [AHTagBtn] = [AHTagBtn]()
    
    /// 存放MoreListView上所有的btn的标题
    var tagTitleArray: [String] = [String]()
    
    // MARK: - control
    fileprivate lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.frame = CGRect(x: 0, y: 0, width: kScreen_W, height: 30)
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 0, width: kScreen_W - 10, height: 30)
        label.text = "点击添加更多频道"
        label.textAlignment = .left
        label.textColor = UIColorTextBlock
        label.font = UIFont.systemFont(ofSize: 14)
        infoView.addSubview(label)
        // infoView.backgroundColor = RGBColor(220.0, g: 220.0, b: 220.0, alpha: 1)
        return infoView
    }()
    
    // MARK: - method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        addSubview(infoView)
    }
}

// MARK: - prot methods
extension AHMoreListView {
    /// 添加标签
    func addTag(tagTitle: String) {
        
        let tagBtn = AHTagBtn()
        tagBtn.tag = tagArray.count
        tagBtn.setTitle(tagTitle, for: .normal)
        tagBtn.addTarget(self, action: #selector(addMoreTag(btn:)), for: .touchUpInside)
        
        addSubview(tagBtn)
        tagArray.append(tagBtn)
        tagTitleArray.append(tagBtn.titleLabel!.text!)
        
        updateTagBtnFrame(btn: tagBtn)
        
        // 更新自己的frame
        UIView.animate(withDuration: 0.25, animations: {
            self.Height = self.listViewH
        })
        
    }
    
    /// 添加多个标签
    func addTags(titles: [String]) {
        for title in titles {
            addTag(tagTitle: title)
        }
    }
    
    /// 删除标签
    func deleteTags(btn: AHTagBtn) {
        btn.removeFromSuperview()
        
        tagArray.remove(at: btn.tag)
        
        tagTitleArray.remove(at: btn.tag)
        
        updateTag()
        
        // 跟新后面按钮的frame
        UIView.animate(withDuration: 0.25, animations: {
            self.updateLaterTagButtonFrame(laterIndex: btn.tag)
        })
        
        // 更新自己的frame
        UIView.animate(withDuration: 0.25, animations: {
            self.Height = self.listViewH
        })
    }
}

// MARK: - event response
extension AHMoreListView {
    func addMoreTag(btn: AHTagBtn) {
        deleteTags(btn: btn)
        guard let title = btn.titleLabel?.text else {
            return
        }

        if listViewAddTagClouse != nil {
            listViewAddTagClouse!(title)
        }
    }
}
