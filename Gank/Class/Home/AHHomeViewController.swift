//
//  AHHomeViewController.swift
//  Gank
//
//  Created by AHuaner on 2016/12/22.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHHomeViewController: BaseViewController {

    // MARK: - property
    fileprivate var datasArray: [AHHomeGroupModel] = [AHHomeGroupModel]()
    
    fileprivate var lastSelectedIndex: Int = 0
    
    fileprivate var lastDate: String = UserConfig.string(forKey: .lastDate) ?? ""
    
    
    // MARK: - control
    fileprivate lazy var headerView: AHHomeHeaderView = {
        let headerView = AHHomeHeaderView.headerView()
        headerView.frame = CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H * 0.55)
        return headerView
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H), style: UITableViewStyle.grouped)
        tabelView.backgroundColor = UIColor.white
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.contentInset.bottom = kBottomBarHeight
        tabelView.separatorStyle = .none
        tabelView.register(UITableViewCell.self, forCellReuseIdentifier: "homecell")
        tabelView.tableHeaderView = self.headerView
        return tabelView
    }()
    
    fileprivate lazy var navBar: AHNavBar = {
        let navBar = AHNavBar(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: 64))
        navBar.searchView.locationVC = self
        return navBar
    }()
    
    fileprivate lazy var loadingView: AHLoadingView = {
        let loadingView = AHLoadingView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H - kBottomBarHeight))
        return loadingView
    }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        loadGankFromCache()
        
        sendRequest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.navigationController?.viewControllers.count)! > 1 {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - event && methods
    fileprivate func setupUI() {
        view.addSubview(tableView)
        view.addSubview(navBar)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(tabBarSelector), name: NSNotification.Name.AHTabBarDidSelectNotification, object: nil)
    }
    
    fileprivate func sendRequest() {
        // 获取发过干货的日期
        AHNewWork.agent.loadDateRequest(success: { (result: Any) in
            guard let dateArray = result as? [String] else { return }
            guard let newestDate = dateArray.first else { return }
            
            let date = newestDate.replacingOccurrences(of: "-", with: "/")
            
            if self.lastDate == date {
                self.loadGankFromCache()
                return
            }
            
            self.loadGanks(WithDate: date)
            
        }) { (error: Error) in
            AHLog(error)
            self.loadGankFromCache()
        }
    }
    
    // 请求首页数据
    fileprivate func loadGanks(WithDate date: String) {
        AHNewWork.agent.loadHomeRequest(date: date, success: { (result: Any) in
            guard let datasArray = result as? [AHHomeGroupModel] else { return }
            self.loadingView.isHidden = true
            
            self.lastDate = date
            // UserDefaults.AHData.lastDate.store(value: date)
            UserConfig.set(date, forKey: .lastDate)
            
            self.datasArray = datasArray
            self.setupHeaderView()
            self.tableView.reloadData()
        }) { (error: Error) in
            self.loadGankFromCache()
        }
    }
    
    // 读取缓存的首页数据
    fileprivate func loadGankFromCache() {
        guard let datas = NSKeyedUnarchiver.unarchiveObject(withFile: "homeGanks".cachesDir()) as? [AHHomeGroupModel] else {
            view.addSubview(loadingView)
            return
        }
        self.datasArray = datas
        self.setupHeaderView()
        if datas.count == 0 {
            view.addSubview(loadingView)
            return
        }
        self.tableView.reloadData()
    }
    
    fileprivate func setupHeaderView() {
        var newData = [AHHomeGroupModel]()
        
        for data in datasArray {
            if data.groupTitle == "福利" {
                guard let urlString = data.ganks.first?.url else { return }
                let url = urlString + "?/0/w/\(kScreen_H * 0.55)/h/\(kScreen_W)"
                headerView.imageView.yy_imageURL = URL(string: url)
                continue
            }
            newData.append(data)
        }
        datasArray = newData
    }
    
    func tabBarSelector() {
        if self.lastSelectedIndex == self.tabBarController!.selectedIndex && self.view.isShowingOnKeyWindow() {
            var offset = self.tableView.contentOffset
            offset.y = -self.tableView.contentInset.top;
            self.tableView.setContentOffset(offset, animated: true)
        }
        self.lastSelectedIndex = self.tabBarController!.selectedIndex
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AHHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasArray[section].ganks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellFromNib() as AHHomeCell
        cell.gankModel = datasArray[indexPath.section].ganks[indexPath.row]
        cell.indexPath = indexPath
        
        cell.moreButtonClickedClouse = { [unowned self] (indexPath: IndexPath) in
            let model = self.datasArray[indexPath.section].ganks[indexPath.row]
            model.isOpen = !model.isOpen
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = datasArray[indexPath.section].ganks[indexPath.row]
        return model.cellH
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSection = AHHeaderSectionView.headerSectionView()
        headerSection.groupModel = datasArray[section]
        return headerSection
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = datasArray[indexPath.section].ganks[indexPath.row]
        
        let webView = AHHomeWebViewController()
        webView.urlString = model.url
        webView.gankModel = model
        webView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webView, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension AHHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let alpha = offsetY / (kScreen_H * 0.55 - kNavBarHeight)
        
        if offsetY > 0 {
            navBar.bgAlpha = alpha
            if offsetY >= kScreen_H * 0.55 - kNavBarHeight {
                self.navBar.showLongStyle()
            }
        } else {
            navBar.bgAlpha = 0.001
            self.navBar.showShortStyle()
        }
    }
}
