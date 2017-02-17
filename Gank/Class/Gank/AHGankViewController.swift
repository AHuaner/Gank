//
//  AHGankViewController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/8.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

let ConfigDict: [AnyHashable: Any] = ["福利" : "福利",
                                "Android": "Android",
                                "iOS" : "iOS",
                                "视频" : "休息视频",
                                "拓展资源" : "拓展资源",
                                "前端" : "前端",
                                "干货" : "all",
                                "推荐" : "瞎推荐",
                                "App" : "App"]

class AHGankViewController: AHDisplayViewController {
    
    // MARK: - property
    /// 已显示的tags
    fileprivate var showTagsArray: [String] = [String]()
    
    /// 未显示的tags
    fileprivate var moreTagsArray: [String] = [String]()
    
    /// 转场代理
    fileprivate lazy var turnVCTransitionManager: AHTurnVCTransitionManager = {
        let manager = AHTurnVCTransitionManager()
        
        let y: CGFloat = 64
        let x: CGFloat = 0
        let width: CGFloat = kScreen_W
        let height: CGFloat = kScreen_H - y
        manager.presentFrame = CGRect(x: x, y: y, width: width, height: height)
        return manager
    }()
    
    var popRect: CGRect = CGRect.zero
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题滚动框样式
        setupTitleEffect { (titleScrollViewColor, titleBtnNorColor, titleBtnSelColor, titleFont, titleScrollViewH) in
            titleBtnNorColor = UIColorTextLightGray
            titleBtnSelColor = UIColorTextBlue
            titleFont = FontSize(size: 14)
        }
        
        // 设置下滑指示线样式
        setupUnderLineEffect { (isShowUnderLine, underLineColor, underLineH) in
            underLineColor = UIColorTextBlue
        }
        
        // 设置导航栏颜色
        UIApplication.shared.statusBarStyle = .lightContent
        
        // 模拟从服务器获取频道列表
        showTagsArray = ["干货", "iOS", "前端", "Android", "拓展资源", "视频"]
        moreTagsArray = ["福利", "App", "推荐"]
        
        // 从本地读取频道列表
        let saveShowTagsArray = NSKeyedUnarchiver.unarchiveObject(withFile: "saveShowTagsArray".cachesDir()) as? [String]
        if saveShowTagsArray != nil {
            showTagsArray = saveShowTagsArray!
        }
        
        let saveMoreTagsArray = NSKeyedUnarchiver.unarchiveObject(withFile: "saveMoreTagsArray".cachesDir()) as? [String]
        if saveMoreTagsArray != nil {
            moreTagsArray = saveMoreTagsArray!
        }
        
        setupChildVCs(titles: showTagsArray)
        
        addTitleButton.addTarget(self, action: #selector(AHGankViewController.addTitleButtonClick(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AHGankViewController.changeStatusBar), name: NSNotification.Name(rawValue: "changeStatusBarNotifica"), object: nil)
        
        setupSqlite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - event && methods
    // 初始化数据库
    fileprivate func setupSqlite() {
        for key in showTagsArray {
            let name = ConfigDict[key] as! String
            SQLiteManager.shareManager().creatTable(tableName: name)
        }
        
        for key in moreTagsArray {
            let name = ConfigDict[key] as! String
            SQLiteManager.shareManager().creatTable(tableName: name)
        }
    }
    
    func addTitleButtonClick(_ btn: UIButton) {
        let turnVC = AHTurnChannelViewController()
        turnVC.showTagsArray = showTagsArray
        turnVC.moreTagsArray = moreTagsArray
        
        turnVC.turnChannelClouse = { [unowned self]  showTags, moreTags in
            if self.showTagsArray == showTags {
                return
            }
            
            for childVC in self.childViewControllers {
                childVC.removeFromParentViewController()
            }
            
            self.setupChildVCs(titles: showTags)
            AHLog(showTags)
            // 更新未显示的tags
            self.moreTagsArray = moreTags
            NSKeyedArchiver.archiveRootObject(moreTags, toFile: "saveMoreTagsArray".cachesDir())
            
            self.setupTitleWidth()
            self.setupAllTitle()
            self.contentScrollView.reloadData()
        }
        
        // 自定义转场动画
        turnVC.transitioningDelegate = turnVCTransitionManager
        turnVC.modalPresentationStyle = UIModalPresentationStyle.custom
        present(turnVC, animated: true, completion: nil)
    }
    
    // 显示\隐藏导航栏
    func changeStatusBar() {
        UIApplication.shared.isStatusBarHidden = !UIApplication.shared.isStatusBarHidden
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    fileprivate func setupChildVCs(titles: [String]) {
        showTagsArray.removeAll()
        for title in titles {
            let classVC = AHClassViewController()
            classVC.title = title
            classVC.type = ConfigDict[title] as! String
            addChildViewController(classVC);
            // 更新以显示的tags
            showTagsArray.append(title)
        }
        NSKeyedArchiver.archiveRootObject(showTagsArray, toFile: "saveShowTagsArray".cachesDir())
    }
    
}
