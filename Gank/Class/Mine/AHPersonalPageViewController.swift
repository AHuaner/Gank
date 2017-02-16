//
//  AHPersonalPageViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/2/16.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHPersonalPageViewController: BaseViewController {
    
    fileprivate lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H - kNavBarHeight), style: .grouped)
        tabelView.backgroundColor = UIColorMainBG
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.contentInset.bottom = kBottomBarHeight
        return tabelView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    fileprivate func setupUI() {
        title = "编辑个人主页"
        setNavigationBarStyle(BarColor: UIColor.white, backItemColor: .blue)
        
        view.addSubview(tableView)
    }
    
}

extension AHPersonalPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellForValue1()
        cell.textLabel?.text = "昵称"
        cell.detailTextLabel?.text = User.info?.object(forKey: "nickName") as? String
        return cell
    }
    
    fileprivate func cellForValue1() -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "personalCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "personalCell")
            cell!.accessoryType = .disclosureIndicator
            cell!.textLabel?.textColor = UIColorTextBlock
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = AHUpdateNickViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
