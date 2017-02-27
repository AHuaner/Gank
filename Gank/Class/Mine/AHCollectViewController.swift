//
//  AHCollectViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/2/13.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit
import MJRefresh

class AHCollectViewController: BaseViewController {
    
    // MARK: - property
    fileprivate var datasArray: [GankModel] = [GankModel]()
    
    // 分页限制
    fileprivate var limitCount: Int = 10
    
    // 当前页码
    fileprivate var currentPage: Int = 1
    
    // MARK: - control
    fileprivate lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H), style: .grouped)
        tabelView.backgroundColor = UIColorMainBG
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.rowHeight = 100
        tabelView.tableFooterView = UIView()
        return tabelView
    }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        self.setupRefresh()
        
        // 检验用户是否在其他设备登录
        ToolKit.checkUserLoginedWithOtherDevice(noLogin: { })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        setNavigationBarStyle(BarColor: UIColor.white, backItemColor: .blue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavigationBarStyle(BarColor: UIColorMainBlue, backItemColor: .white)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.mj_header.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - event && methods
    fileprivate func setupUI() {
        self.title = "我的收藏"
        view.addSubview(tableView)
        setNavigationBarStyle(BarColor: UIColor.white, backItemColor: .blue)
    }
    
    // 设置刷新控件
    fileprivate func setupRefresh() {
        let header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadNewGank))
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.isAutomaticallyChangeAlpha = true
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("正在加载", for: .refreshing)
        tableView.mj_header = header
        let footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreGank))
        footer?.setTitle("上拉加载更多", for: .idle)
        footer?.setTitle("释放立即加载", for: .pulling)
        footer?.setTitle("正在加载", for: .refreshing)
        tableView.mj_footer = footer
    }
    
    // 下拉刷新
    func loadNewGank() {
        self.datasArray.removeAll()
        
        let query: BmobQuery = BmobQuery(className: "Collect")
        query.order(byDescending: "createdAt")
        query.limit = limitCount
        query.whereKey("userId", equalTo: User.info?.objectId)
        
        query.findObjectsInBackground { (array, error) in
            
            self.tableView.mj_header.endRefreshing()
            
            // 加载失败
            if error != nil { return }
            guard let ganksArr = array else { return }
            
            // 加载成功
            self.currentPage = 1
            
            self.datasArray = ganksArr.map({ gank in
                GankModel(bmob: gank as! BmobObject)
            })
            self.tableView.reloadData()
        }
    }
    
    // 上拉加载更多
    func loadMoreGank() {
        let query: BmobQuery = BmobQuery(className: "Collect")
        query.order(byDescending: "createdAt")
        query.limit = limitCount
        query.skip = currentPage * limitCount
        query.whereKey("userId", equalTo: User.info?.objectId)
        
        query.findObjectsInBackground { (array, error) in
            
            self.tableView.mj_footer.endRefreshing()
            
            // 加载失败
            if error != nil { return }
            guard let ganksArr = array else { return }
            
            // 加载成功
            self.currentPage = self.currentPage + 1
            
            let newDatas = ganksArr.map({ gank in
                GankModel(bmob: gank as! BmobObject)
            })
            
            self.datasArray.append(contentsOf: newDatas)
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AHCollectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellFromNib() as AHCollectCell
        cell.gankModel = self.datasArray[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = self.datasArray[indexPath.row]
        let vc = AHHomeWebViewController()
        vc.urlString = model.url
        vc.gankModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        ToolKit.show(withStatus: "正在取消收藏")
        
        let model = self.datasArray[indexPath.row]
        let gank: BmobObject = BmobObject(outDataWithClassName: "Collect", objectId: model.objectId)
        gank.deleteInBackground { (isSuccessful, error) in
            if isSuccessful { // 删除成功
                ToolKit.dismissHUD()
                
                self.datasArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                AHLog(error!)
                ToolKit.showError(withStatus: "取消收藏失败")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
