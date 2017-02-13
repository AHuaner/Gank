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
    
    fileprivate var datasArray: [AHSearchGankModel] = [AHSearchGankModel]()
    
    fileprivate lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H), style: .plain)
        tabelView.backgroundColor = UIColorMainBG
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.rowHeight = 95
        tabelView.tableFooterView = UIView()
        return tabelView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.mj_header.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupUI() {
        self.title = "我的收藏"
        view.addSubview(tableView)
        setNavigationBarStyle(BarColor: UIColor.white, backItemColor: .blue)
    }
    
    // 设置刷新控件
    fileprivate func setupRefresh() {
        let header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(AHCollectViewController.loadNewGank))
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.isAutomaticallyChangeAlpha = true
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("干货加载中...", for: .refreshing)
        tableView.mj_header = header
        let footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(AHCollectViewController.loadMoreGank))
        footer?.setTitle("上拉加载更多", for: .idle)
        footer?.setTitle("释放立即加载", for: .pulling)
        footer?.setTitle("干货加载中...", for: .refreshing)
        tableView.mj_footer = footer
    }
    
    func loadNewGank() {
        self.datasArray.removeAll()
        
        let query: BmobQuery = BmobQuery(className: "Collect")
        query.whereKey("userId", equalTo: userInfo?.objectId)
        query.findObjectsInBackground { (array, error) in
            
            self.tableView.mj_header.endRefreshing()
            
            if error != nil { return }
            
            guard let ganksArr = array else { return }
            
            for i in 0..<ganksArr.count {
                let gank = ganksArr[i] as! BmobObject
                let model = AHSearchGankModel(bmob: gank)
                self.datasArray.insert(model, at: 0)
            }
            self.tableView.reloadData()
        }
    }
    
    func loadMoreGank() {
        self.tableView.mj_header.endRefreshing()
    }
}

extension AHCollectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AHCollectCell.cellWithTableView(tableView)
        cell.gankModel = self.datasArray[indexPath.row]
        return cell
    }
}
