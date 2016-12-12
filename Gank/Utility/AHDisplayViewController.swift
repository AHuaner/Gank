//
//  AHDisplayViewController.swift
//  AHDisplayViewController
//
//  Created by CoderAhuan on 16/8/31.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

let ReusecellID = "ReusecellID"
/// 顶部标题的间距
let margin: CGFloat = 20.0

class AHDisplayViewController: BaseViewController {
    
    /// 整体内容View的宽度
    fileprivate var contentViewW: CGFloat = kScreen_W
    
    /// 顶部标题的间距
    fileprivate var titleMargin: CGFloat = 0.0
    
    /// 被选中的顶部标题
    fileprivate var selectedBtn: UIButton?
    
    /// 上一次contentScrollView的偏移量
    fileprivate var lastOffsetX: CGFloat = 0.0
    
    /// 是否点击了顶部按钮
    fileprivate var isTitleClick: Bool = false
    
    /// 标题滚动视图的高度
    fileprivate var titleScrollViewH: CGFloat = 35
    
    /// 顶部标题的字体
    fileprivate var titleFont: UIFont = UIFont.systemFont(ofSize: 13)
    
    /// 标题滚动视图的颜色
    fileprivate var titleScrollViewColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.95)
    
    /// 顶部标题Normal状态下的颜色
    fileprivate var titleBtnNorColor: UIColor = UIColor.gray
    
    /// 顶部标题Disable状态下的颜色
    fileprivate var titleBtnSelColor: UIColor = UIColor.red
    
    /// 下标的高度
    fileprivate var underLineH: CGFloat = 2.0
    
    /// 下标的颜色
    fileprivate var underLineColor: UIColor = UIColor.red
    
    /// 是否显示下标
    fileprivate var isShowUnderLine: Bool = true
    
    /// 是否显示蒙版
    fileprivate var isShowCoverView: Bool = false
    
    /// 蒙版的颜色
    fileprivate var coverViewColor: UIColor = UIColor(red: 215 / 255.0, green: 215 / 255.0, blue: 215 / 255.0, alpha: 0.65)
    
    /// 蒙版的圆角半径
    fileprivate var coverViewCornerRadius: CGFloat = 0.0
    
    /// 添加标题按钮的宽度
    fileprivate var addTitleButtonWidth: CGFloat = 40.0
    
    /// contentView是否加载
    fileprivate var isShow: Bool = false
    
    // MARK: - lazy
    
    /// 整体内容View 包含标题内容和滚动视图
    fileprivate lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1)
        
        if contentView.frame.size.height == 0.0 {
            contentView.frame = CGRect(x: 0, y: kNavBarHeight, width: self.contentViewW, height: kScreen_H - kNavBarHeight)
        }
        self.view.addSubview(contentView)
        return contentView
    }()
    
    /// 标题滚动视图
    fileprivate lazy var titleScrollView: UIScrollView = {
        let titleScrollView = UIScrollView()
        titleScrollView.scrollsToTop = false
        titleScrollView.backgroundColor = self.titleScrollViewColor
        titleScrollView.showsHorizontalScrollIndicator = false
        titleScrollView.frame = CGRect(x: 0, y: 0, width: self.contentView.Width, height: self.titleScrollViewH)
        return titleScrollView
    }()
    
    /// 添加标题滚动视图中标题的按钮
    lazy var addTitleButton: UIButton = {
        let addTitleButton = UIButton()
        addTitleButton.setImage(UIImage(named: "add_button_normal"), for: .normal)
        addTitleButton.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.9)
        return addTitleButton
    }()

    /// 内容滚动视图
    lazy var contentScrollView: UICollectionView = {
        let layout = AHFlowLayout()
        
        let contentScrollView = UICollectionView(frame: self.contentView.bounds, collectionViewLayout: layout)
        
        // 设置内容滚动视图
        contentScrollView.isPagingEnabled = true;
        contentScrollView.showsHorizontalScrollIndicator = false;
        contentScrollView.bounces = false;
        contentScrollView.delegate = self;
        contentScrollView.dataSource = self;
        contentScrollView.scrollsToTop = false;
        // 注册cell
        contentScrollView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ReusecellID)
        
        contentScrollView.backgroundColor = self.view.backgroundColor;
        
        return contentScrollView
    }()

    /// 下标
    fileprivate lazy var underLine: UIView = {
        let underLine = UIView()
        underLine.backgroundColor = self.underLineColor
//        self.titleScrollView.addSubview(underLine)
        return underLine
    }()
    
    /// 蒙版
    fileprivate lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.coverViewColor
//        self.titleScrollView.insertSubview(coverView, at: 0)
        return coverView
    }()
    
    /// 存放所有标题数组
    fileprivate lazy var titleButtons: [UIButton] = {
        var titleLabels = [UIButton]()
        return titleLabels
    }()
    
    /// 存放所有标题的宽度
    fileprivate lazy var titleWidths: [CGFloat] = {
        var titleWidths = [CGFloat]()
        return titleWidths
    }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray;
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isShow == false {
            setupTitleWidth()
            setupAllTitle()
            isShow = true
        }
    }

}

// MARK: - port methods
extension AHDisplayViewController {
    
    func setupContentViewFrame(_ setClosure: (_ contentView: inout UIView) -> Void) {
        setClosure(&self.contentView)
        contentViewW = contentView.Width
    }
    
    /** 设置顶部标题样式 */
    func setupTitleEffect(_ setClosure: (_ titleScrollViewColor: inout UIColor, _ titleBtnNorColor: inout UIColor, _ titleBtnSelColor: inout UIColor, _ titleFont: inout UIFont, _ titleScrollViewH: inout CGFloat) -> Void) {
        
        setClosure(&titleScrollViewColor, &titleBtnNorColor, &titleBtnSelColor, &titleFont, &titleScrollViewH)
    }
    
    /** 设置下标的样式 */
    func setupUnderLineEffect(_ setClosure: (_ isShowUnderLine: inout Bool, _ underLineColor: inout UIColor, _ underLineH: inout CGFloat) -> Void) {
        setClosure(&isShowUnderLine, &underLineColor, &underLineH)
    }
    
    /** 设置蒙版的样式 */
    func setupCoverViewEffect(_ setClosure: (_ isShowCoverView: inout Bool, _ coverViewColor: inout UIColor, _ coverViewCornerRadius: inout CGFloat) -> Void) {
        setClosure(&isShowCoverView, &coverViewColor, &coverViewCornerRadius)
    }
}

// MARK: - private methods
extension AHDisplayViewController {
    /** 计算标题滚动视图的总宽度, 和每个小标题的宽度 */
    func setupTitleWidth() {
        titleWidths.removeAll()
        let count = childViewControllers.count
        var totalWidth: CGFloat = 0
        for childVc in childViewControllers {
            
            guard let titleText: NSString = childVc.title as NSString? else {
                return
            }
            
            let titleBounds = titleText.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : titleFont], context: nil)
            
            titleWidths.append(titleBounds.size.width)
            totalWidth += titleBounds.size.width
        }
        
        let RealtotalWidth = totalWidth + CGFloat(count) * margin + (addTitleButton.isHidden ? 0 : addTitleButtonWidth)
        
        if RealtotalWidth > contentViewW {
            self.titleMargin = margin
            self.titleScrollView.isScrollEnabled = true
            return
        }
        
        let titleMargin = (contentViewW - totalWidth - (addTitleButton.isHidden ? 0 : addTitleButtonWidth)) / CGFloat(count + 1)
        self.titleMargin = titleMargin < margin ? margin: titleMargin
        self.titleScrollView.isScrollEnabled = false
    }
    
    /** 设置标题滚动视图中的所有标题 */
    func setupAllTitle() {
        titleButtons.removeAll()
        titleScrollView.subviews.forEach({ subview in
            subview.removeFromSuperview()
        })
        let count = childViewControllers.count
        var BtnX: CGFloat = 0.0
        let BtnY: CGFloat = 0.0
        var BtnW: CGFloat = 0.0
        let BtnH: CGFloat = isShowUnderLine ? titleScrollViewH - underLineH : titleScrollViewH
        for i in 0 ..< count {
            let vc = childViewControllers[i]
            let btn = UIButton()
            btn.tag = i
            btn.titleLabel?.font = titleFont
            btn.setTitleColor(titleBtnNorColor, for: UIControlState())
            btn.setTitleColor(titleBtnSelColor, for: .disabled)
            btn.setTitle(vc.title, for: UIControlState())
            btn.addTarget(self, action: #selector(AHDisplayViewController.titleLabelClick(_:)), for: .touchUpInside)
            
            if let lastBtn = titleButtons.last {
                BtnX = titleMargin + lastBtn.MaxX
            } else {
                BtnX = titleMargin
            }
            
            BtnW = titleWidths[i]
            btn.frame = CGRect(x: BtnX, y: BtnY, width: BtnW, height: BtnH)
            
            titleScrollView.addSubview(btn)
            titleButtons.append(btn)
            
            if i == 0 {
                titleLabelClick(btn)
            }
        }
        
        guard let lastBtn = titleButtons.last else {
            return
        }
        
        titleScrollView.contentSize = CGSize(width: lastBtn.MaxX + titleMargin + (addTitleButton.isHidden ? 0 : addTitleButtonWidth), height: 0)
        contentScrollView.contentSize = CGSize(width: contentViewW * CGFloat(count), height: 0)
        
        contentView.addSubview(contentScrollView)
        contentView.insertSubview(titleScrollView, aboveSubview: contentScrollView)
        contentView.insertSubview(addTitleButton, aboveSubview: titleScrollView)
        
        titleScrollView.insertSubview(coverView, at: 0)
        titleScrollView.insertSubview(underLine, at: 0)
        
        addTitleButton.frame = CGRect(x: self.contentViewW - addTitleButtonWidth, y: 0, width: addTitleButtonWidth, height: self.titleScrollViewH)
    }
    
    fileprivate func setupSelectButton(_ selbtn: UIButton) {
        selectedBtn?.isEnabled = true
        selectedBtn = selbtn
        selbtn.isEnabled = false
        
        // 设置下标, 可选
        if isShowUnderLine {
            setupUnderLine(selbtn)
        }
        
        // 设置蒙版, 可选
        if isShowCoverView {
            setupCoverView(selbtn)
        }
        
        // 移动标题滚动条
        perform(#selector(self.setupSelectedBtnToCenter(_:)), with: selbtn, afterDelay: 0.15)
        
        // 取出对应控制器发出通知
        let vc = self.childViewControllers[selbtn.tag];
        
        if vc.isKind(of: AHClassViewController.self) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AHDisplayViewClickOrScrollDidFinshNote"), object: vc)
        }
        
    }
    
    /** 设置标题居中 */
    func setupSelectedBtnToCenter(_ selbtn: UIButton) {
        if titleScrollView.isScrollEnabled == false {
            return
        }
        // 设置标题滚动区域的偏移量
        var offsetX = selbtn.CenterX - contentViewW * 0.5
        
        if offsetX < 0 {
            offsetX = 0
        }
        
        // 计算最大的标题视图滚动区域
        var maxOffsetX = titleScrollView.contentSize.width - contentViewW
        
        if maxOffsetX < 0 {
            maxOffsetX = 0
        }
        
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        
        // 滚动区域
        titleScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    fileprivate func setupUnderLine(_ selbtn: UIButton) {
        underLine.Height = underLineH
        underLine.Y = selbtn.MaxY
        
        // 开始的时候不用动画
        if underLine.X == 0 {
            underLine.Width = selbtn.Width
            underLine.CenterX = selbtn.CenterX
            return
        }
        
        // 点击的时候需要动画
        UIView.animate(withDuration: 0.15, animations: {
            self.underLine.Width = selbtn.Width
            self.underLine.CenterX = selbtn.CenterX
        })
    }
    
    fileprivate func setupCoverView(_ selbtn: UIButton) {
        coverView.Height = selbtn.Height * 0.75
        coverView.CenterY = selbtn.CenterY
        
        // 没有设置蒙版的圆角半径, 默认为高度的0.45
        if coverViewCornerRadius == 0.0 {
            coverView.layer.cornerRadius = coverView.Height * 0.45
        }
        
        // 开始的时候不用动画
        if coverView.X == 0 {
            coverView.Width = selbtn.Width + 10
            coverView.CenterX = selbtn.CenterX
            return
        }
        
        // 点击的时候需要动画
        UIView.animate(withDuration: 0.15, animations: {
            self.coverView.Width = selbtn.Width + 10
            self.coverView.CenterX = selbtn.CenterX
        })
    }
    
    /** 设置下标的偏移 */
    fileprivate func setupUnderLineOffset(_ offsetX: CGFloat, rightBtn: UIButton, leftBtn: UIButton) {
        // 获取两个标题中心点距离
        let centerDelta = rightBtn.X - leftBtn.X;
        
        // 标题宽度差值
        let rightBtnW = titleWidths[rightBtn.tag]
        let leftBtnW = titleWidths[leftBtn.tag]
        let widthDelta = rightBtnW - leftBtnW
        
        // 获取移动距离
        let offsetDelta = offsetX - lastOffsetX;
        
        // 计算当前下标偏移量
        let underLineTransformX = offsetDelta * centerDelta / contentViewW;
        
        // 宽度递增偏移量
        let underLineWidth = offsetDelta * widthDelta / contentViewW;
        
        underLine.Width += underLineWidth;
        underLine.X += underLineTransformX;
    }
    
    /** 设置蒙版的偏移 */
    fileprivate func setupCoverViewOffset(_ offsetX: CGFloat, rightBtn: UIButton, leftBtn: UIButton) {
        // 获取两个标题中心点距离
        let centerDelta = rightBtn.X - leftBtn.X;
        
        // 标题宽度差值
        let rightBtnW = titleWidths[rightBtn.tag]
        let leftBtnW = titleWidths[leftBtn.tag]
        let widthDelta = rightBtnW - leftBtnW
        
        // 获取移动距离
        let offsetDelta = offsetX - lastOffsetX;
        
        // 计算当前蒙版偏移量
        let coverViewTransformX = offsetDelta * centerDelta / contentViewW;
        
        // 宽度递增偏移量
        let coverViewWidth = offsetDelta * widthDelta / contentViewW;
        
        coverView.Width += coverViewWidth;
        coverView.X += coverViewTransformX;
    }
}

// MARK: - event response
extension AHDisplayViewController {
    /** 标题按钮点击 */
    func titleLabelClick(_ selbtn: UIButton) {
        isTitleClick = true
        
        // 设置被点击标题的按钮
        setupSelectButton(selbtn)
        
        let index = selbtn.tag
        let offsetX = CGFloat(index) * contentViewW
        contentScrollView.contentOffset = CGPoint(x: offsetX, y: 0)
        
        // 记录上一次偏移量
        lastOffsetX = offsetX
        
        isTitleClick = false
    }
}


// MARK: - UIScrollViewDelegate
extension AHDisplayViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    // 滑动scrollView调用这个方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: NSInteger =  NSInteger(scrollView.contentOffset.x / scrollView.Width)
        setupSelectButton(titleButtons[index])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 如果是点击顶部标题激发的滚动, 不需要设置
        if isTitleClick == true {
            return
        }
        
        // 偏移量
        let offsetX = scrollView.contentOffset.x
        
        // 左边的角标, 按钮
        let leftIndex = NSInteger(offsetX / contentViewW)
        let leftBtn = titleButtons[leftIndex]
        
        // 右边的角标, 按钮
        let rightIndex = leftIndex + 1
        if rightIndex >= titleButtons.count {
            return
        }
        let rightBtn = titleButtons[rightIndex]
        
        // 设置下标的偏移量
        if isShowUnderLine {
            setupUnderLineOffset(offsetX, rightBtn: rightBtn, leftBtn: leftBtn)
        }
        
        // 设置蒙版的偏移量
        if isShowCoverView {
            setupCoverViewOffset(offsetX, rightBtn: rightBtn, leftBtn: leftBtn)
            
        }
        
        // 记录上一次偏移量
        lastOffsetX = offsetX
    }
}

// MARK: - UICollectionViewDataSource
extension AHDisplayViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusecellID, for: indexPath)
        cell.contentView.subviews.forEach({ subview in
            subview.removeFromSuperview()
        })
        
        let willShowVc = childViewControllers[indexPath.item]
        willShowVc.view.frame = CGRect(x: 0, y: 0, width: contentView.Width, height: contentView.Height)
        cell.contentView.addSubview(willShowVc.view)
        
        return cell
    }
}

class AHFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        minimumInteritemSpacing = 0;
        
        minimumLineSpacing = 0;
        
        self.itemSize = self.collectionView!.bounds.size;
        
        self.scrollDirection = UICollectionViewScrollDirection.horizontal;
    }
}
