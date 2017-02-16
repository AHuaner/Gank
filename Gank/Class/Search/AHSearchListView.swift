//
//  AHSearchListView.swift
//  Gank
//
//  Created by AHuaner on 2017/1/12.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHSearchListView: UIView {
    
    // MARK: - property
    /// 存放ListView上所有的btn的标题
    var tagTitleArray: [String] = [String]()
    
    var getTitleArrayClouse: (([String]) -> Void)?
    
    var searchGankWithTitleClouse: ((String, [String]) -> Void)?
    
    /// 存放所有的btn
    fileprivate var tagArray: [AHSeatchTagBtn] = [AHSeatchTagBtn]()
    
    fileprivate var moveFinalRect: CGRect = CGRect.zero
    
    fileprivate var oriCenter: CGPoint = CGPoint.zero
    
    fileprivate let margin: CGFloat = 10.0
    
    fileprivate let topMargin: CGFloat = 30
    
    /// 整体的高度
    fileprivate var ListViewH: CGFloat {
        get {
            return (tagArray.count <= 0 ? 30.0 : ((tagArray.last?.MaxY)! + margin))
        }
    }
    
    // MARK: - control
    fileprivate lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.X = self.margin
        infoLabel.CenterY = self.topMargin / 3
        infoLabel.font = FontSize(size: 13)
        infoLabel.textColor = UIColor.black
        infoLabel.text = "历史搜索"
        infoLabel.sizeToFit()
        return infoLabel
    }()
    
    lazy var cleanBtn: UIButton = {
        let cleanBtn = UIButton()
        cleanBtn.setImage(UIImage(named: "icon_clean"), for: .normal)
        cleanBtn.frame.size = CGSize(width: 20, height: 20)
        cleanBtn.X = self.Width - self.margin - cleanBtn.Width
        cleanBtn.CenterY = self.infoLabel.CenterY
        
        return cleanBtn
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
        self.isHidden = true
        self.addSubview(infoLabel)
        self.addSubview(cleanBtn)
    }
}

// MARK: - prot methods
extension AHSearchListView {
    /// 添加标签
    func addTag(tagTitle: String) {
        self.isHidden = false
        
        let tagBtn = AHSeatchTagBtn()
        tagBtn.tag = tagArray.count
        tagBtn.setTitle(tagTitle, for: .normal)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(AHListView.longPressAction(longPress:)))
        tagBtn.addGestureRecognizer(longPress)
        
        tagBtn.addTarget(self, action: #selector(AHSearchListView.tagBtnClick(btn:)), for: .touchUpInside)
    
        tagArray.insert(tagBtn, at: 0)
        
        tagTitleArray.insert(tagBtn.titleLabel!.text!, at: 0)
        
        updateTag()
        
        // 更新所有按钮的frame
        updateAllTagButtonsFrame(laterIndex: tagBtn.tag)
        
        // 更新自己的frame
        self.Height = self.ListViewH
        self.addSubview(tagBtn)
    }
    
    /// 删除标签
    func deleteTags(btn: AHSeatchTagBtn) {
        btn.removeFromSuperview()
        
        tagArray.remove(at: btn.tag)
        
        tagTitleArray.remove(at: btn.tag)
        
        updateTag()
        
        // 更新所有按钮的frame
        updateAllTagButtonsFrame(laterIndex: btn.tag)
        
        // 更新自己的frame
        UIView.animate(withDuration: 0.25, animations: {
            if self.tagArray.count == 0 {
                self.Height = 0
                self.isHidden = true
            } else {
                self.Height = self.ListViewH
            }
        })
    }
    
    /// 添加多个标签
    func addTags(titles: [String]) {
        // 倒序插入
        for i in 0..<titles.count {
            addTag(tagTitle: titles[titles.count - i - 1])
        }
    }
    
    /// 删除所有便签
    func removeAllTags() {
        tagArray.removeAll()
        tagTitleArray.removeAll()
        self.isHidden = true
    }
}

// MARK: - event response
extension AHSearchListView {
    func longPressAction(longPress: UILongPressGestureRecognizer) {
        let point = longPress.location(in: self)
        
        let index = getFocusBtnIndex(point: point)
        
        if longPress.state == .began {
            startEditModel(index: index)
        }
    }
    
    func tagBtnClick(btn: AHSeatchTagBtn) {
        guard let image =  btn.imageView?.image else {
            if searchGankWithTitleClouse != nil {
                deleteTags(btn: btn)
                addTag(tagTitle: btn.titleLabel!.text!)
                searchGankWithTitleClouse!(btn.titleLabel!.text!, tagTitleArray)
            }
            return
        }
        
        if image.size == CGSize.zero  {
            if searchGankWithTitleClouse != nil {
                deleteTags(btn: btn)
                addTag(tagTitle: btn.titleLabel!.text!)
                searchGankWithTitleClouse!(btn.titleLabel!.text!, tagTitleArray)
            }
        } else {
            deleteTagBtn(btn: btn)
        }
    }
    
    func deleteTagBtn(btn: AHSeatchTagBtn) {
        deleteTags(btn: btn)
        if getTitleArrayClouse != nil {
            getTitleArrayClouse!(tagTitleArray)
        }
    }
}

// MARK: - private methods
extension AHSearchListView {
    /// 开启编辑模式
    fileprivate func startEditModel(index: Int) {
        for btn in self.tagArray {
            if btn.tag == index {
                btn.setImage(UIImage(named: "close_button"), for: .normal)
            } else {
                btn.setImage(UIImage(), for: .normal)
            }
        }
    }
    
    fileprivate func getFocusBtnIndex(point: CGPoint) -> Int {
        var index: Int = 0
        for btn in tagArray {
            if btn.frame.contains(point) {
                index = btn.tag
                break
            }
        }
        return index
    }
    
    // 跟新按钮的tag
    fileprivate func updateTag() {
        for i in 0..<tagArray.count {
            let btn = tagArray[i]
            btn.tag = i
        }
    }
    
    // 更新以后按钮frame
    fileprivate func updateAllTagButtonsFrame(laterIndex: Int) {
        for i in laterIndex..<tagArray.count {
            var preBtn: AHSeatchTagBtn? = nil
            if i - 1 >= 0 {
                preBtn = tagArray[i - 1]
            }
            setupTagButtonCurrentFrame(curBtn: tagArray[i], preBtn: preBtn)
        }
    }
    
    func setupTagButtonCurrentFrame(curBtn: AHSeatchTagBtn, preBtn: AHSeatchTagBtn?) {
        var btnX: CGFloat = 0
        var btnY: CGFloat = 0
        var btnW: CGFloat = 0
        var btnH: CGFloat = 0
        
        if let preBtn = preBtn {
            btnX = preBtn.frame.maxX + margin
            btnY = preBtn.Y
        } else {
            btnX = margin
            btnY = margin + topMargin
        }
        
        let text = curBtn.titleLabel!.text! as NSString
        let titleW = text.size(attributes: [NSFontAttributeName : FontSize(size: 12)]).width
        let titleH = text.size(attributes: [NSFontAttributeName : FontSize(size: 12)]).height
        
        btnH = titleH + 2 * curBtn.margin
        btnW = (titleW + 2 * curBtn.margin) > (kScreen_W - 2 * margin) ? (kScreen_W - 2 * margin) : (titleW + 2 * curBtn.margin)
        
        let rightWidth = self.Width - btnX
        
        if rightWidth - margin < btnW {
            if let preBtn = preBtn {
                btnX = margin
                btnY = preBtn.frame.maxY + margin
            } else {
                btnX = margin
                btnY = margin + topMargin
            }
        }
        curBtn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
    }
}
