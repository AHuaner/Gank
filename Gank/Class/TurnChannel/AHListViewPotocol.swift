//
//  AHListViewPotocol.swift
//  Gank
//
//  Created by AHuaner on 2017/2/27.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

protocol AHListViewPotocol {
    /// 存放ListView上所有的btn的标题
    var tagTitleArray: [String] { get set }
    
    /// 存放所有的btn
    var tagArray: [AHTagBtn] { get set }
    
    /// 一共有多少列
    var listCols: Int { get }
    
    /// 间距
    var margin: CGFloat { get }
    
    /// 整体的高度
    var listViewH: CGFloat { get }
}

extension AHListViewPotocol where Self: UIView {
    var listCols: Int {
        return 4
    }
    
    var margin: CGFloat {
        return 10.0
    }
    
    var listViewH: CGFloat {
        return (tagArray.count <= 0 ? 30.0 : ((tagArray.last?.MaxY)! + margin))
    }
    
    /// 返回手指移动到的按钮
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
    
    /// 跟新按钮的tag
    func updateTag() {
        for (i, btn) in tagArray.enumerated() {
            btn.tag = i
        }
    }
    
    /// 更新以后按钮frame
    func updateLaterTagButtonFrame(laterIndex: Int) {
        for i in laterIndex..<tagArray.count {
            updateTagBtnFrame(btn: tagArray[i])
        }
    }
    
    /// 更新之前按钮frame
    func updateBeforeTagButtonFrame(beforeIndex: Int) {
        for i in 0..<beforeIndex {
            updateTagBtnFrame(btn: tagArray[i])
        }
    }
    
    /// 更新对应的frame
    func updateTagBtnFrame(btn: AHTagBtn) {
        let index = btn.tag
        let col = index % listCols
        let row = index / listCols
        let btnW = (self.Width - CGFloat(listCols + 1) * margin) / CGFloat(listCols)
        let btnH = btnW * 0.55
        let btnX = margin + CGFloat(col) * (btnW + margin)
        let btnY = 30 + margin + CGFloat(row) * (btnH + margin)
        btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
    }
}
