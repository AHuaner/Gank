//
//  AHClassViewController.swift
//  Gank
//
//  Created by AHuaner on 2016/12/12.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class AHClassViewController: BaseViewController {
    
    var type: String!
    
    var isFirstLoad: Bool = false
    
    fileprivate var currentPage: Int = 1
    
    // 最后一次请求的页码, 防止重复加载
    fileprivate var lastPage: Int?
    
    fileprivate lazy var loadingView: AHLoadingView = {
        let loadingView = AHLoadingView(frame: self.view.bounds)
        return loadingView
    }()
    
    fileprivate var datasArray: [AHClassModel] = [AHClassModel]()
    
    fileprivate lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H - kNavBarHeight), style: UITableViewStyle.plain)
        tabelView.backgroundColor = UIColorMainBG
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.contentInset.top = 35
        tabelView.contentInset.bottom = kBottomBarHeight
        tabelView.separatorStyle = .none
        return tabelView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupRefresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupUI() {
        // 添加fps测试
        let fpsLabel = FPSLabel(frame: CGRect(x: kScreen_W - 50, y: 20, width: 50, height: 30))
        UIApplication.shared.keyWindow?.addSubview(fpsLabel)
        
        view.addSubview(tableView)
        
        tableView.backgroundColor = UIColorMainBG
        
        tableView.addSubview(loadingView)
    }
    
    // 设置刷新控件
    fileprivate func setupRefresh() {
        let header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(AHClassViewController.loadNewGank))
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.isAutomaticallyChangeAlpha = true
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("干货加载中...", for: .refreshing)
        tableView.mj_header = header
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(AHClassViewController.loadMoreGank))
    }
    
    // 下拉刷新
    func loadNewGank() {
        // 结束上拉刷新
        self.tableView.mj_footer.endRefreshing()
        // 当前加载的页码
        let currentPage: Int = 1
        // 更新最后一次请求的页码
        self.lastPage = currentPage
        AHNewWorkingAgent.loadClassRequest(tpye: self.type, page: currentPage, success: { (result) in
            if self.lastPage != currentPage { return }
            
            self.loadingView.removeFromSuperview()
            guard let datasArray = result as? [AHClassModel] else {
                self.tableView.mj_header.endRefreshing()
                return
            }
            self.datasArray = datasArray
            self.tableView.reloadData()
            self.currentPage = currentPage
            self.tableView.mj_header.endRefreshing()
            
        }, failure: { (error) in
            if self.lastPage != currentPage { return }
            
            AHLog("\(self.title!)----下拉刷新失败-----\(error)")
            self.tableView.mj_header.endRefreshing()
        })
    }
    
    // 上拉加载更多数据
    func loadMoreGank() {
        // 结束下拉刷新
        self.tableView.mj_header.endRefreshing()
        // 当前加载的页码
        let currentPage = self.currentPage + 1
        // 更新最后一次请求的页码
        self.lastPage = currentPage
        AHNewWorkingAgent.loadClassRequest(tpye: self.type, page: currentPage, success: { (result) in
            if self.lastPage != currentPage { return }
            
            guard let datasArray = result as? [AHClassModel] else {
                self.tableView.mj_footer.endRefreshing()
                return
            }

            self.datasArray.append(contentsOf: datasArray)
            self.tableView.reloadData()
            self.currentPage = currentPage
            self.tableView.mj_footer.endRefreshing()
            
        }) { (error) in
            if self.lastPage != currentPage { return }
            
            AHLog("\(self.title!)----上拉加载失败-----\(error)")
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
    func firstLoadDate() {
        if isFirstLoad { return }
        self.isFirstLoad = true
        self.tableView.mj_header.beginRefreshing()
        AHLog("\(self.title!)-----第一次加载")
    }
    
}

extension AHClassViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.mj_footer.isHidden = (datasArray.count == 0);
        return datasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AHClassCell.cellWithTableView(tableView)
        cell.classModel = datasArray[indexPath.row]
        cell.indexPath = indexPath
        
        cell.moreButtonClickedClouse = { [unowned self] (indexPath: IndexPath) in
            let model = self.datasArray[indexPath.row]
            model.isOpen = !model.isOpen
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = datasArray[indexPath.row]
        return model.cellH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = datasArray[indexPath.row]
        
        let webView = AHClassWebViewController()
        webView.urlString = model.url
        webView.classModel = model
        webView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webView, animated: true)
    }
}


