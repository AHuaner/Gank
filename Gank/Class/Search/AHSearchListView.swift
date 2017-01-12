//
//  AHSearchListView.swift
//  Gank
//
//  Created by AHuaner on 2017/1/12.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHSearchListView: UIView {
    
    /// 存放ListView上所有的btn的标题
    lazy var tagTitleArray: [String] = {
        let tagTitleArray = [String]()
        return tagTitleArray
    }()
    
    var getTitleArrayClouse: (([String]) -> Void)?
    
    var searchGankWithTitleClouse: ((String) -> Void)?
    
    /// 存放所有的btn
    fileprivate lazy var tagArray: [AHSeatchTagBtn] = {
        let tagArray = [AHSeatchTagBtn]()
        return tagArray
    }()
    
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
    
        tagArray.append(tagBtn)
        
        tagTitleArray.append(tagBtn.titleLabel!.text!)
        
        updateTagBtnFrame(btn: tagBtn)
        
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
        
        // 跟新后面按钮的frame
        UIView.animate(withDuration: 0.25, animations: {
            self.updateLaterTagButtonFrame(laterIndex: btn.tag)
        })
        
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
        for btn in tagArray {
            btn.removeFromSuperview()
        }
        tagTitleArray.removeAll()
        tagArray.removeAll()
        
        for title in titles {
            addTag(tagTitle: title)
        }
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
                searchGankWithTitleClouse!(btn.titleLabel!.text!)
            }
            return
        }
        
        if image.size == CGSize.zero  {
            if searchGankWithTitleClouse != nil {
                searchGankWithTitleClouse!(btn.titleLabel!.text!)
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
    fileprivate func updateTagBtnFrame(btn: AHSeatchTagBtn) {
        let preIndex = btn.tag - 1
        var preBtn: AHSeatchTagBtn? = nil
        
        if preIndex >= 0 {
            preBtn = self.tagArray[preIndex]
        }
        
        setupTagButtonCurrentFrame(curBtn: btn, preBtn: preBtn)
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
        
        btnW = titleW + 2 * 8
        btnH = titleH + 2 * 8
        
        let rightWidth = self.Width - btnX
        
        if rightWidth - margin < btnW {
            btnX = margin
            btnY = preBtn!.frame.maxY + margin
        }
        curBtn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
    }
}
