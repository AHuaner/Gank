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
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H), style: UITableViewStyle.plain)
        tabelView.backgroundColor = UIColorMainBG
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.contentInset.bottom = kBottomBarHeight
        tabelView.separatorStyle = .none
        tabelView.register(UITableViewCell.self, forCellReuseIdentifier: "homecell")
        return tabelView
    }()
    
    fileprivate var curDateString: String = ""
    fileprivate var yesDateString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        calculateDate()
        
        sendRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupUI() {
        view.addSubview(tableView)
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
            guard let datasArray = result as? [AHHomeGroupModel] else {
                return
            }
            
            // 还没有当日数据, 请求昨日数据
            if datasArray.count == 0 {
                AHNewWorkingAgent.loadHomeRequest(date: self.yesDateString, success: { (result: Any) in
                    guard let datasArray = result as? [AHHomeGroupModel] else {
                        return
                    }
                    self.datasArray = datasArray
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
}
