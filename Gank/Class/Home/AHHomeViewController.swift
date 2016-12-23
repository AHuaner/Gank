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
    
    fileprivate lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H), style: UITableViewStyle.grouped)
        tabelView.backgroundColor = UIColorMainBG
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.contentInset.bottom = kBottomBarHeight
        tabelView.separatorStyle = .none
        tabelView.register(UITableViewCell.self, forCellReuseIdentifier: "homecell")
        let headerView = AHHomeHeaderView.headerView()
        headerView.frame = CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H * 0.5)
        tabelView.tableHeaderView = headerView
        return tabelView
    }()
    
    lazy var navBar: AHNavBar = {
        let navBar = AHNavBar(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: 64))
        navBar.title = "最新干货"
        navBar.alpha = 0.001
        return navBar
    }()
    
    fileprivate var curDateString: String = ""
    fileprivate var yesDateString: String = ""
    
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
    }
    
    fileprivate func calculateDate() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        curDateString = dateFormatter.string(from: currentDate)
        
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)
        yesDateString = dateFormatter.string(from: yesterdayDate!)
    }
    
    fileprivate func sendRequest() {
        AHNewWorkingAgent.loadHomeRequest(date: curDateString, success: { (result: Any) in
            guard let datasArray = result as? [AHHomeGroupModel] else { return }
            
            // 还没有当日数据, 请求昨日数据
            if datasArray.count == 0 {
                AHNewWorkingAgent.loadHomeRequest(date: self.yesDateString, success: { (result: Any) in
                    guard let datasArray = result as? [AHHomeGroupModel] else {
                        return
                    }
                    self.datasArray = datasArray
                    self.tableView.reloadData()
                }) { (error: Error) in
                    AHLog(error)
                }
            }
            
            self.datasArray = datasArray
            self.tableView.reloadData()
        }) { (error: Error) in
            AHLog(error)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "homecell", for: indexPath)
        let gankModel = datasArray[indexPath.section].ganks[indexPath.row]
        cell.textLabel?.text = gankModel.desc!
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSection = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: 30))
        headerSection.backgroundColor = UIColorMainBG
        return headerSection
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = datasArray[indexPath.section].ganks[indexPath.row]
        
        let webView = AHClassWebViewController()
        webView.urlString = model.url
        webView.homeGankModel = model
        webView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webView, animated: true)
    }
}

extension AHHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            let alpha = scrollView.contentOffset.y / (kScreen_H * 0.5 - 64.0)
            navBar.alpha = alpha
        } else {
            navBar.alpha = 0.001
        }
    }
}
