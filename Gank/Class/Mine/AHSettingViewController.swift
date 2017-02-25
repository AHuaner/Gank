//
//  AHSettingViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/2/9.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit
import YYWebImage

// 仅Wi-Fi网络下载图片
var onlyWifiDownPic = true

class AHSettingViewController: BaseViewController {
    
    // MARK: - property
    var logoutClouse: (() -> Void)?
    
    fileprivate var cacheSize: CGFloat? {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate var titlesArray = [["修改密码"], ["仅Wi-Fi网络下载图片", "清除缓存"], ["给个好评", "关于我们"]]
    
    fileprivate var unLoginTitlesArray = [["仅Wi-Fi网络下载图片", "清除缓存"], ["给个好评", "关于我们"]]
    
    // MARK: - control
    fileprivate lazy var footView: UIButton = {
        let footView = UIButton(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: 44))
        footView.backgroundColor = UIColor.white
        footView.setTitleColor(UIColor.red, for: .normal)
        footView.addTarget(self, action: #selector(logoutORLoginAction), for: .touchUpInside)
        return footView
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H - kNavBarHeight), style: .grouped)
        tabelView.backgroundColor = UIColorMainBG
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.contentInset.bottom = kBottomBarHeight
        return tabelView
    }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calculateCacheSize()
        
        UIApplication.shared.statusBarStyle = .default
        
        if User.info == nil {
            footView.setTitle("登录", for: .normal)
        } else {
            footView.setTitle("退出登录", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - event && methods
    fileprivate func setupUI() {
        view.addSubview(tableView)
        title = "设置"
        tableView.tableFooterView = footView
        setNavigationBarStyle(BarColor: UIColor.white, backItemColor: .blue)
    }
    
    fileprivate func calculateCacheSize() {
        let cache = YYWebImageManager.shared().cache
        let memorySize = CGFloat(cache!.memoryCache.totalCost)
        let diskSize = CGFloat(cache!.diskCache.totalCost())
        let size = (memorySize + diskSize) / 1000.0 / 1000.0
        cacheSize = size
    }
    
    func logoutORLoginAction() {
        if User.info != nil { // 退出登录
            self.showAlertController(locationVC: self, title: "是否退出登录", message: "", confrimClouse: { (_) in
                User.logout()
                if self.logoutClouse != nil { self.logoutClouse!() }
                self.navigationController!.popViewController(animated: false)
            }, cancelClouse: { (_) in })
            
        } else {
            if self.logoutClouse != nil { self.logoutClouse!() }
            self.navigationController!.popViewController(animated: false)
        }
    }
    
    // 账户与安全
    fileprivate func pushAccountSafeController() {
        ToolKit.checkUserLoginedWithOtherDevice { 
            let vc = AHAccountSafeViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // 仅Wi-Fi网络下载图片
    func wiFiNetwork() {
        onlyWifiDownPic = !onlyWifiDownPic
    }
    
    // 清理缓存
    fileprivate func cleanCache() {        
        self.showAlertController(locationVC: self, title: Bundle.appName, message: "确定清除缓存的数据和图片?", confrimClouse: { (_) in
            let cache = YYWebImageManager.shared().cache
            cache?.memoryCache.removeAllObjects()
            cache?.diskCache.removeAllObjects()
            self.cacheSize = 0.0
        }) { (_) in }
    }
    
    // 分享应用
    fileprivate func evaluateApp() {
        ToolKit.showInfo(withStatus: "该功能未实现")
    }
    
    // 关于我们
    fileprivate func pushAboutUsController() {
        ToolKit.showInfo(withStatus: "该功能未实现")
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AHSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return (User.info == nil) ? unLoginTitlesArray.count : titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (User.info == nil) ? unLoginTitlesArray[section].count : titlesArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 未登录
        if User.info == nil {
            switch (indexPath.section, indexPath.row) {
            case (0, 0): // 仅Wi-Fi网络下载图片
                let cell = cellForSwitch()
                cell.textLabel?.text = unLoginTitlesArray[indexPath.section][indexPath.row]
                return cell
            case (0, 1): // 清除缓存
                let cell = cellForValue1()
                cell.textLabel?.text = unLoginTitlesArray[indexPath.section][indexPath.row]
                cell.detailTextLabel?.text = "\(cacheSize!.format(f: 0))MB"
                return cell
            case (1, 0), (1, 1): // 给个好评 && 关于我们
                let cell = cellForValue1()
                cell.textLabel?.text = unLoginTitlesArray[indexPath.section][indexPath.row]
                return cell
            default:
                return cellForValue1()
            }
        }

        // 已登录
        switch (indexPath.section, indexPath.row) {
        case (0, 0): // 账户与安全
            let cell = cellForValue1()
            cell.textLabel?.text = titlesArray[indexPath.section][indexPath.row]
            return cell
        case (1, 0): // 仅Wi-Fi网络下载图片
            let cell = cellForSwitch()
            cell.textLabel?.text = titlesArray[indexPath.section][indexPath.row]
            return cell
        case (1, 1): // 清除缓存
            let cell = cellForValue1()
            cell.textLabel?.text = titlesArray[indexPath.section][indexPath.row]
            cell.detailTextLabel?.text = "\(cacheSize!.format(f: 0))MB"
            return cell
        case (2, 0), (2, 1): // 给个好评 && 关于我们
            let cell = cellForValue1()
            cell.textLabel?.text = titlesArray[indexPath.section][indexPath.row]
            return cell
        default:
            return cellForValue1()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 未登录
        if User.info == nil {
            switch (indexPath.section, indexPath.row) {
            case (0, 1): // 清除缓存
                cleanCache()
            case (1, 0): // 给个好评
                evaluateApp()
            case (1, 1): // 关于我们
                pushAboutUsController()
            default:
                break
            }
            return
        }
        
        // 已登录
        switch (indexPath.section, indexPath.row) {
        case (0, 0): // 账户与安全
            pushAccountSafeController()
        case (1, 1): // 清除缓存
            cleanCache()
        case (2, 0): // 给个好评
            evaluateApp()
        case (2, 1): // 关于我们
            pushAboutUsController()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == (numberOfSections(in: tableView) - 1) ? 15 : 0.01
    }
    
    fileprivate func cellForValue1() -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "settingValue1Cell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "settingValue1Cell")
            cell!.accessoryType = .disclosureIndicator
            cell!.textLabel?.textColor = UIColorTextGray
        }
        return cell!
    }
    
    fileprivate func cellForSwitch() -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "settingSwitchCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "settingSwitchCell")
            let switchView = UISwitch()
            switchView.setOn(onlyWifiDownPic, animated: false)
            switchView.addTarget(self, action: #selector(wiFiNetwork), for: .valueChanged)
            cell!.selectionStyle = .none
            cell!.accessoryView = switchView
            cell!.textLabel?.textColor = UIColorTextGray
        }
        return cell!
    }
    
}
