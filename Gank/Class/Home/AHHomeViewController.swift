//
//  AHHomeViewController.swift
//  Gank
//
//  Created by AHuaner on 2016/12/22.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHHomeViewController: BaseViewController {

    fileprivate var datasArray: [AHHomeGroupModel] = [AHHomeGroupModel]()
    
    fileprivate var lastSelectedIndex: Int = 0
    
    lazy var headerView: AHHomeHeaderView = {
        let headerView = AHHomeHeaderView.headerView()
        headerView.frame = CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H * 0.55)
        return headerView
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H), style: UITableViewStyle.grouped)
        tabelView.backgroundColor = UIColorMainBG
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.contentInset.bottom = kBottomBarHeight
        tabelView.separatorStyle = .none
        tabelView.register(UITableViewCell.self, forCellReuseIdentifier: "homecell")
        tabelView.tableHeaderView = self.headerView
        return tabelView
    }()
    
    lazy var navBar: AHNavBar = {
        let navBar = AHNavBar(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: 64))
        navBar.searchView.locationVC = self
        return navBar
    }()
    
    fileprivate var curDateString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        calculateDate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
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
    
    fileprivate func setupUI() {
        view.addSubview(tableView)
        view.addSubview(navBar)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(AHHomeViewController.tabBarSelector), name: NSNotification.Name(rawValue: "TabBarDidSelectNotification"), object: nil)
    }
    
    fileprivate func calculateDate() {
        curDateString = Date().toString(WithFormat: "YYYY/MM/dd")
    }
    
    fileprivate func sendRequest() {
        if datasArray.count != 0 { return }
        
        AHNewWorkingAgent.loadHomeRequest(date: curDateString, success: { (result: Any) in
            guard let datasArray = result as? [AHHomeGroupModel] else { return }
            self.datasArray = datasArray
            self.setupHeaderView(date: self.curDateString)
            self.tableView.reloadData()
        }) { (error: Error) in
            // 读取缓存的首页数据
            guard let datas = NSKeyedUnarchiver.unarchiveObject(withFile: "homeGanks".cachesDir()) as? [AHHomeGroupModel] else { return }
            self.datasArray = datas
            self.setupHeaderView(date: self.curDateString)
            self.tableView.reloadData()
        }
    }
    
    fileprivate func setupHeaderView(date: String) {
        
        var newData = [AHHomeGroupModel]()
        
        for data in datasArray {
            if data.groupTitle == "福利" {
                guard let urlString = data.ganks.first?.url else { return }
                let url = urlString + "?/0/w/\(kScreen_H * 0.55)/h/\(kScreen_W)"
                headerView.imageView.yy_imageURL = URL(string: url)
                headerView.timeLabel.text = date
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AHHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasArray[section].ganks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AHHomeCell.cellWithTableView(tableView)
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

extension AHHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        let offsetY = scrollView.contentOffset.y
        let alpha = offsetY / (kScreen_H * 0.55 - kNavBarHeight)
        
        if offsetY >= 0 {
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
