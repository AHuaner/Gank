//
//  AHClassViewController.swift
//  Gank
//
//  Created by AHuaner on 2016/12/12.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON

class AHClassViewController: BaseViewController {
    
    // MARK: - property
    var type: String!
    
    // 是否第一次加载
    var isFirstLoad: Bool = false
    
    // 当前页码
    fileprivate var currentPage: Int = 1
    
    // 最后一次请求的页码, 防止重复加载
    fileprivate var lastPage: Int?
    
    fileprivate var lastSelectedIndex: Int = 1
    
    fileprivate var datasArray: [AHClassModel] = [AHClassModel]()
    
    // MARK: - control
    fileprivate lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H - kNavBarHeight - kBottomBarHeight), style: UITableViewStyle.plain)
        tabelView.backgroundColor = UIColorMainBG
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.contentInset.top = 35
        tabelView.separatorStyle = .none
        return tabelView
    }()
    
    fileprivate lazy var loadingView: AHLoadingView = {
        let loadingView = AHLoadingView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H - kBottomBarHeight))
        return loadingView
    }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupRefresh()
        
        // 从数据库加载
        loadDataFromSQLite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - event && methods
    fileprivate func setupUI() {
        // 添加fps测试
        let fpsLabel = FPSLabel(frame: CGRect(x: kScreen_W - 100, y: 0, width: 30, height: 20))
        UIApplication.shared.keyWindow?.addSubview(fpsLabel)
        
        view.addSubview(tableView)
        
        view.addSubview(loadingView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AHClassViewController.tabBarSelector), name: NSNotification.Name(rawValue: "TabBarDidSelectNotification"), object: nil)
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
        let footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(AHClassViewController.loadMoreGank))
        footer?.setTitle("上拉加载更多", for: .idle)
        footer?.setTitle("释放立即加载", for: .pulling)
        footer?.setTitle("干货加载中...", for: .refreshing)
        tableView.mj_footer = footer
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
        // 延迟刷新
        DispatchQueue.main.asyncAfter(deadline: 0.2, execute: {
            if self.datasArray.count > 0 { self.loadingView.removeFromSuperview() }
            self.tableView.reloadData()
        })
        
        if isFirstLoad { return }
        self.isFirstLoad = true
        self.tableView.mj_header.beginRefreshing()
        AHLog("\(self.title!)-----第一次加载")
    }
    
    // 从数据库加载
    fileprivate func loadDataFromSQLite() {
        AHGankDAO.loadCacheGanks(type: self.type) { (result) in
            let dict = JSON(result)
            var datas = [AHClassModel]()
            
            if dict.count <= 0 { return }
            
            // 创建一个组队列
            let group = DispatchGroup()
            let urlconfig = URLSessionConfiguration.default
            urlconfig.timeoutIntervalForRequest = 2
            urlconfig.timeoutIntervalForResource = 2
            
            for i in 0..<dict.count {
                let model = AHClassModel(dict: dict[i])
                
                if let images = model.images, model.images?.count == 1 {
                    let urlString = images[0] + "?imageInfo"
                    let url = URL(string: urlString)
                    
                    let session = URLSession(configuration: urlconfig)
                    // 当前线程加入组队列
                    group.enter()
                    let tast = session.dataTask(with: url!, completionHandler: { (data: Data?, _, error: Error?) in
                        if let data = data {
                            let json = JSON(data: data)
                            if let width = json["width"].object as? CGFloat {
                                model.imageW = width
                            }
                            if let height = json["height"].object as? CGFloat {
                                model.imageH = height
                            }
                        }
                        // 当前线程离开组队列
                        group.leave()
                    })
                    tast.resume()
                    // 防止内存泄漏
                    session.finishTasksAndInvalidate()
                }
                datas.append(model)
            }
            
            // 等组队列执行完, 在主线程回调
            group.notify(queue: DispatchQueue.main, execute: {
                self.datasArray = datas
            })
        }
    }
    
    func tabBarSelector() {
        if self.lastSelectedIndex == self.tabBarController!.selectedIndex && self.view.isShowingOnKeyWindow() {
            self.tableView.mj_header.beginRefreshing()
        }
        self.lastSelectedIndex = self.tabBarController!.selectedIndex
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 获取cell的frame, 坐标转换
        let cell = tableView.cellForRow(at: indexPath)!
        let rect = self.navigationController!.view.convert(cell.frame, from: cell.superview)
        
        if let gankVC = self.navigationController?.topViewController as? AHGankViewController {
            gankVC.popRect = rect
        }
        
        self.tabBarController?.tabBar.isHidden = true
        
        let model = datasArray[indexPath.row]
        let webView = AHClassWebViewController()
        webView.urlString = model.url
        webView.gankModel = model
        
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(webView, animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension AHClassViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AHPushTransition()
    }
}
