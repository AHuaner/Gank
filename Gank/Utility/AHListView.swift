//
//  AHListView.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/10.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHListView: UIView {
    
    /// 存放所有的btn的标题
    lazy var tagTitleArray: [String] = {
        let tagTitleArray = [String]()
        return tagTitleArray
    }()
    
    var listViewMoveTagClouse: ((String) -> Void)?
    
    /// 存放所有的btn
    fileprivate lazy var tagArray: [AHTagBtn] = {
        let tagArray = [AHTagBtn]()
        return tagArray
    }()
    
    fileprivate lazy var infoButton: UIButton = {
        let infoButton = UIButton()
        infoButton.titleLabel?.textAlignment = .left
        infoButton.setTitle("切换频道", for: .normal)
        infoButton.setTitle("拖动排序", for: .selected)
        infoButton.setTitleColor(UIColorTextGray, for: .normal)
        infoButton.frame = CGRect(x: 5, y: 0, width: 60, height: 35)
        infoButton.titleLabel?.font = FontSize(size: 13)
        return infoButton
    }()
    
    fileprivate lazy var completeBtn: UIButton = {
        let completeBtn = UIButton()
        completeBtn.titleLabel?.textAlignment = .right
        completeBtn.setTitle("编辑", for: .normal)
        completeBtn.setTitle("完成", for: .selected)
        completeBtn.setTitleColor(UIColorTextGray, for: .normal)
        completeBtn.setTitleColor(UIColorTextBlue, for: .selected)
        completeBtn.frame = CGRect(x: kScreen_W - 40.0 - 5.0, y: 0, width: 40.0, height: 35)
        completeBtn.titleLabel?.font = FontSize(size: 13)
        completeBtn.addTarget(self, action: #selector(AHListView.completeAction(btn:)), for: .touchUpInside)
        return completeBtn
    }()
    
    /// 一共有多少列
    fileprivate let listCols: Int = 4
    
    fileprivate let margin: CGFloat = 10.0
    
    fileprivate var moveFinalRect: CGRect = CGRect.zero
    
    fileprivate var oriCenter: CGPoint = CGPoint.zero
    
    /// 编辑模式
    fileprivate var isEditModel: Bool = false
    
    /// 整体的高度
    fileprivate var ListViewH: CGFloat {
        get {
            return (tagArray.count <= 0 ? 30.0 : ((tagArray.last?.MaxY)! + margin))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        addSubview(infoButton)
        addSubview(completeBtn)
    }
}

// MARK: - prot methods
extension AHListView {
    /// 添加标签
    func addTag(tagTitle: String) {
        let tagBtn = AHTagBtn()
        tagBtn.tag = tagArray.count
        tagBtn.setTitle(tagTitle, for: .normal)
        if isEditModel {
            tagBtn.setImage(UIImage(named: "close2_button"), for: .normal)
        }
        tagBtn.alpha = 0
        tagBtn.addTarget(self, action: #selector(AHListView.deleteBtnAction(btn:)), for: .touchUpInside)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(AHListView.longPressAction(longPress:)))
        tagBtn.addGestureRecognizer(longPress)
        
        tagArray.append(tagBtn)
        

        updateTagBtnFrame(btn: tagBtn)
        
        // 更新自己的frame
        UIView.animate(withDuration: 0.25, animations: {
            self.Height = self.ListViewH
        }, completion: { (_) in // 动画完成以后再添加tagBtn
            self.addSubview(tagBtn)
            UIView.animate(withDuration: 0.15, animations: { 
                tagBtn.alpha = 1.0
            })
        })
    }
    
    /// 删除标签
    func deleteTags(btn: AHTagBtn) {
        btn.removeFromSuperview()
        
        tagArray.remove(at: btn.tag)
        
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
    
    /// 添加多个标签
    func addTags(titles: [String]) {
        for title in titles {
            addTag(tagTitle: title)
        }
    }
}

// MARK: - event response
extension AHListView {
    func longPressAction(longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            startEditModel()
        }
    }
    
    func panAction(pan: UIPanGestureRecognizer) {
        // 获取偏移量
        let transPoint = pan.translation(in: self)
        
        let tagBtn = pan.view as! AHTagBtn
        
        if pan.state == .began {
            oriCenter = tagBtn.center
            UIView.animate(withDuration: 0.25, animations: {
                tagBtn.alpha = 0.8
            })
            // 把当前的tagBtn置于view的最上层
            // 不会被后面的tagBtn遮挡
            addSubview(tagBtn)
        }
        
        tagBtn.center.x += transPoint.x
        tagBtn.center.y += transPoint.y
        
        // 改变
        if pan.state == .changed {
            // 获取当前按钮中心点在哪个按钮上
            let otherBtn = getBtnCenterInButtons(curBtn: tagBtn)
            
            // 插入到当前按钮的位置
            if let otherBtn = otherBtn {
                // 获取插入位置的按钮角标
                let index = otherBtn.tag
                
                // 获取当前按钮角标
                let curIndex = tagBtn.tag;
                
                moveFinalRect = otherBtn.frame;
                
                // 移除之前的按钮,插入到新的位置
                tagArray.remove(at: tagBtn.tag)
                tagArray.insert(tagBtn, at: index)
                
                // 更新tag
                updateTag()
                
                if curIndex > index { // 往前插
                    // 更新之后标签frame
                    UIView.animate(withDuration: 0.25, animations: {
                        self.updateLaterTagButtonFrame(laterIndex: index + 1)
                    })
                } else { // 往后插
                    // 更新之前标签frame
                    UIView.animate(withDuration: 0.25, animations: {
                        self.updateBeforeTagButtonFrame(beforeIndex: index)
                    })
                }
            }
        }
        
        // 结束
        if pan.state == .ended {
            UIView.animate(withDuration: 0.25, animations: {
                tagBtn.alpha = 1.0
                if self.moveFinalRect.size.width <= CGFloat(0.0) {
                    tagBtn.center = self.oriCenter
                } else {
                    tagBtn.frame = self.moveFinalRect
                }
            }, completion: { (_) in
                self.moveFinalRect = CGRect.zero
            })
        }
        // 手势复位
        pan.setTranslation(CGPoint.zero, in: self)
    }
    
    func deleteBtnAction(btn: AHTagBtn) {
        if !isEditModel {
            return
        }
        guard let title = btn.titleLabel?.text else {
            return
        }
        
        deleteTags(btn: btn)
        if listViewMoveTagClouse != nil {
            listViewMoveTagClouse!(title)
        }
    }
    
    func completeAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        infoButton.isSelected = !infoButton.isSelected
        if btn.isSelected { // 进入编辑模式
            startEditModel()
        } else { // 退出编辑模式
            completeChange()
        }
    }

}

// MARK: - private methods
extension AHListView {
    // 编辑完成
    fileprivate func completeChange() {
        // 退出编辑模式
        isEditModel = false
        tagTitleArray.removeAll()
        for btn in tagArray {
            btn.setImage(UIImage(), for: .normal)
            tagTitleArray.append(btn.titleLabel!.text!)
            // 移除每个tag的拖拽手势
            if let pan = btn.gestureRecognizers?.last  {
                if pan.isKind(of: UIPanGestureRecognizer.self) {
                    btn.removeGestureRecognizer(pan)
                }
            }
        }
    }
    
    /// 开启编辑模式
    fileprivate func startEditModel() {
        isEditModel = true
        for btn in tagArray {
            btn.setImage(UIImage(named: "close2_button"), for: .normal)
            // 给每个tag添加拖拽手势
            let pan = UIPanGestureRecognizer(target: self, action: #selector(AHListView.panAction(pan:)))
            btn.addGestureRecognizer(pan)
        }
        completeBtn.isSelected = true
        infoButton.isSelected = true
    }
    
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
        let btnH = btnW * 0.45
        let btnX = margin + CGFloat(col) * (btnW + margin)
        let btnY = 30 + margin + CGFloat(row) * (btnH + margin)
        btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
    }
}
