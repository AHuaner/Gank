//
//  AHListView.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/10.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHListView: UIView {
    
    /// 存放所有的btn
    lazy var tagArray: [AHTagBtn] = {
        let tagArray = [AHTagBtn]()
        return tagArray
    }()
    
    /// 一共有多少列
    let listCols: Int = 4
    
    let margin: CGFloat = 15.0
    
    var moveFinalRect: CGRect?
    
    var oriCenter: CGPoint?
    
    /// 整体的高度
    var ListViewH: CGFloat {
        get {
            return tagArray.count <= 0 ? 0.0 : ((tagArray.last?.MaxY)! + margin)
        }
    }
    
    func addTag(tagTitle: String) {
        let tagBtn = AHTagBtn()
        tagBtn.tag = tagArray.count
        tagBtn.setTitle(tagTitle, for: .normal)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(AHListView.panAction(pan:)))
        tagBtn.addGestureRecognizer(pan)
        addSubview(tagBtn)
        tagArray.append(tagBtn)
        
        updateTagBtnFrame(btn: tagBtn)
        
        // 更新自己的frame
        UIView.animate(withDuration: 0.25, animations: {
            self.Height = self.ListViewH
        })
    }
    
    func addTags(titles: [String]) {
        for title in titles {
            addTag(tagTitle: title)
        }
    }
    
    func panAction(pan: UIPanGestureRecognizer) {
        // 获取偏移量
        let transPoint = pan.translation(in: self)
        
        let tagBtn = pan.view as! AHTagBtn
        
        if pan.state == .began {
            oriCenter = tagBtn.center
            UIView.animate(withDuration: 0.25, animations: {
                tagBtn.alpha = 0.9
            })
            // addSubview(tagBtn)
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
                for i in 0..<tagArray.count {
                    let btn = tagArray[i]
                    btn.tag = i
                }
                
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
                if (self.moveFinalRect?.size.width)! <= CGFloat(0.0) {
                    tagBtn.center = self.oriCenter!
                } else {
                    tagBtn.frame = self.moveFinalRect!
                }
            }, completion: { (_) in
                self.moveFinalRect = CGRect.zero
            })
        }
        
        // 手势复位
        pan.setTranslation(CGPoint.zero, in: self)
    }
    
    func getBtnCenterInButtons(curBtn: AHTagBtn) -> AHTagBtn? {
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
    
    // 更新以后按钮
    func updateLaterTagButtonFrame(laterIndex: Int) {
        for i in laterIndex..<tagArray.count {
            updateTagBtnFrame(btn: tagArray[i])
        }
    }
    
    // 更新之前按钮
    func updateBeforeTagButtonFrame(beforeIndex: Int) {
        for i in 0..<beforeIndex {
            updateTagBtnFrame(btn: tagArray[i])
        }
    }
    
    // 更新对应的frame
    fileprivate func updateTagBtnFrame(btn: AHTagBtn) {
        let index = btn.tag
        let col = index % listCols
        let row = index / listCols
        let btnW = Width / CGFloat(listCols + 1)
        let btnH = btnW * 0.6
        let btnX = margin + CGFloat(col) * (btnW + margin)
        let btnY = margin + CGFloat(row) * (btnH + margin)
        btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
    }
}
