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
    
    var isLoad: Bool = false
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(AHClassViewController.loadDate), name: NSNotification.Name(rawValue: "AHDisplayViewClickOrScrollDidFinshNote"), object: self)
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
        let header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(AHClassViewController.loadNewTopic))
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.isAutomaticallyChangeAlpha = true
        tableView.mj_header = header
    }
    
    func loadNewTopic() {
        AHNewWorkingAgent.loadClassRequest(tpye: self.type, page: self.currentPage, success: { result in
            self.loadingView.removeFromSuperview()
            guard let datasArray = result as? [AHClassModel] else {
                return
            }
            self.datasArray = datasArray
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.currentPage = 1
        }, failure: { error in
            AHLog(error)
            SVProgressHUD.showError(withStatus: "加载失败")
            self.tableView.mj_header.endRefreshing()
        })
    }
    
    func loadDate() {
        if isLoad { return }
        isLoad = true
        loadNewTopic()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AHClassViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

