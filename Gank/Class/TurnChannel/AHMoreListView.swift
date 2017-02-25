//
//  AHMoreListView.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/11.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHMoreListView: UIView {
    
    // MARK: - property
    var listViewAddTagClouse: ((String) -> Void)?
    
    /// 存放所有的btn
    fileprivate var tagArray: [AHTagBtn] = [AHTagBtn]()
    
    /// 存放MoreListView上所有的btn的标题
    var tagTitleArray: [String] = [String]()
    
    /// 一共有多少列
    fileprivate let listCols: Int = 4
    
    fileprivate let margin: CGFloat = 10.0
    
    /// 整体的高度
    fileprivate var ListViewH: CGFloat {
        get {
            return (tagArray.count <= 0 ? 30.0 : ((tagArray.last?.MaxY)! + margin))
        }
    }
    
    // MARK: - control
    fileprivate lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.frame = CGRect(x: 0, y: 0, width: kScreen_W, height: 30)
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 0, width: kScreen_W - 10, height: 30)
        label.text = "点击添加更多频道"
        label.textAlignment = .left
        label.textColor = UIColorTextBlock
        label.font = FontSize(size: 14)
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
            self.Height = self.ListViewH
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
            self.Height = self.ListViewH
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

// MARK: - private methods
extension AHMoreListView {
    fileprivate func getBtnCenterInButtons(curBtn: AHTagBtn) -> AHTagBtn? {
        for btn in tagArray {
            if curBtn == btn {
                continue
            }
            if btn.frame.contains(curBtn.center) {
                return btn
            }
        }
        return nil
    }
    
    // 跟新按钮的tag
    fileprivate func updateTag() {
        for i in 0..<tagArray.count {
            let btn = tagArray[i]
            btn.tag = i
        }
    }
    
    // 更新以后按钮frame
    fileprivate func updateLaterTagButtonFrame(laterIndex: Int) {
        for i in laterIndex..<tagArray.count {
            updateTagBtnFrame(btn: tagArray[i])
        }
    }
    
    // 更新之前按钮frame
    fileprivate func updateBeforeTagButtonFrame(beforeIndex: Int) {
        for i in 0..<beforeIndex {
            updateTagBtnFrame(btn: tagArray[i])
        }
    }
    
    // 更新对应的frame
    fileprivate func updateTagBtnFrame(btn: AHTagBtn) {
        let index = btn.tag
        let col = index % listCols
        let row = index / listCols
        let btnW = (Width - 5 * margin) / CGFloat(listCols)
        let btnH = btnW * 0.55
        let btnX = margin + CGFloat(col) * (btnW + margin)
        let btnY = 30 + margin + CGFloat(row) * (btnH + margin)
        btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
    }
}

