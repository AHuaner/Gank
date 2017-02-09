//
//  AHSettingViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/2/9.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit
import YYWebImage

class AHSettingViewController: BaseViewController {

    fileprivate var cacheSize: CGFloat? {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var footView: UIButton = {
        let footView = UIButton(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: 50))
        footView.backgroundColor = UIColor.white
        footView.setTitleColor(UIColor.red, for: .normal)
        footView.addTarget(self, action: #selector(AHSettingViewController.logoutORLoginAction), for: .touchUpInside)
        return footView
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H - kNavBarHeight), style: .grouped)
        tabelView.backgroundColor = UIColorMainBG
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.contentInset.bottom = kBottomBarHeight
        tabelView.separatorStyle = .none
        return tabelView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateCacheSize()
        
        if self.userInfo == nil {
            footView.setTitle("登录", for: .normal)
        } else {
            footView.setTitle("退出登录", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupUI() {
        view.addSubview(tableView)
        title = "设置"
        
        setNavigationBarStyle(BarColor: UIColor.white, backItemColor: .blue)
        
        tableView.tableFooterView = footView
    }
    
    fileprivate func calculateCacheSize() {
        let cache = YYWebImageManager.shared().cache
        let memorySize = CGFloat(cache!.memoryCache.totalCost)
        let diskSize = CGFloat(cache!.diskCache.totalCost())
        let size = (memorySize + diskSize) / 1000.0 / 1000.0
        cacheSize = size
    }
    
    func logoutORLoginAction() {
        if userInfo != nil { // 退出登录
            self.showAlertController(locationVC: self, title: "是否退出登录", message: "", confrimClouse: { (_) in
                BmobUser.logout()
                let loginVC = AHLoginViewController()
                self.present(loginVC, animated: true, completion: nil)
            }, cancelClouse: { (_) in
                
            })
        } else {
            let loginVC = AHLoginViewController()
            self.present(loginVC, animated: true, completion: nil)
        }
    }
}

extension AHSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "settingCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "settingCell")
            cell!.accessoryType = .disclosureIndicator
        }
        cell!.textLabel?.text = "清除缓存"
        cell!.detailTextLabel?.text = "\(cacheSize!.format(f: 0))MB"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cache = YYWebImageManager.shared().cache
        cache?.memoryCache.removeAllObjects()
        cache?.diskCache.removeAllObjects()
        cacheSize = 0.0
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == (numberOfSections(in: tableView) - 1) ? 15 : 0.01
    }
}
