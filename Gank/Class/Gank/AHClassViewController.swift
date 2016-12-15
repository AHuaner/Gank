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
    
    var type: ClassType!
    
    var isFirstLoad: Bool = false
    
    var currentPage: Int = 1
    
    lazy var loadingView: AHLoadingView = {
        let loadingView = AHLoadingView(frame: self.view.bounds)
        return loadingView
    }()
    
    var datasArray: [AHClassModel] = [AHClassModel]()
    
    lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H - kNavBarHeight), style: UITableViewStyle.plain)
        tabelView.backgroundColor = UIColorMainBG
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.contentInset.top = 35
        tabelView.contentInset.bottom = kBottomBarHeight
        tabelView.separatorStyle = .none
        return tabelView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(AHClassViewController.loadDate), name: NSNotification.Name(rawValue: "AHDisplayViewClickOrScrollDidFinshNote"), object: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        let fpsLabel = FPSLabel(frame: CGRect(x: 0, y: 20, width: 50, height: 30))
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
        tableView.mj_header = header
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(AHClassViewController.loadMoreGank))
    }
    
    // 下拉刷新
    func loadNewGank() {
        // 结束上拉刷新
        self.tableView.mj_footer.endRefreshing()
        AHNewWorkingAgent.loadClassRequest(tpye: self.type, page: self.currentPage, success: { (result) in
            self.loadingView.removeFromSuperview()
            guard let datasArray = result as? [AHClassModel] else {
                return
            }
            self.datasArray = datasArray
            self.tableView.reloadData()
            self.currentPage = 1
            self.tableView.mj_header.endRefreshing()
        }, failure: { (error) in
            AHLog("\(self.title!)----下拉刷新失败-----\(error)")
            SVProgressHUD.showError(withStatus: "加载失败")
            self.tableView.mj_header.endRefreshing()
        })
    }
    
    // 上拉加载更多数据
    func loadMoreGank() {
        // 结束下拉刷新
        self.tableView.mj_header.endRefreshing()
        let currentPage = self.currentPage + 1
        
        AHNewWorkingAgent.loadClassRequest(tpye: self.type, page: currentPage, success: { (result) in
            guard let datasArray = result as? [AHClassModel] else {
                return
            }
            self.datasArray.append(contentsOf: datasArray)
            self.tableView.reloadData()
            self.currentPage = currentPage
            self.tableView.mj_footer.endRefreshing()
        }) { (error) in
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
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
}

extension AHClassViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.mj_footer.isHidden = (datasArray.count == 0);
        return datasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AHClassCell.cellWithTableView(tableView)
        cell.classModel = datasArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = datasArray[indexPath.row]
        return model.cellH
    }
}

extension AHClassViewController: UITableViewDelegate {
    
}

