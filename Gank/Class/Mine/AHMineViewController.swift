//
//  AHMineViewController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/8.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import YYWebImage

class AHMineViewController: BaseViewController {
    
    fileprivate lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H - kNavBarHeight), style: .grouped)
        tabelView.backgroundColor = UIColorMainBG
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.contentInset.bottom = kBottomBarHeight
        tabelView.separatorStyle = .none
        tabelView.register(UITableViewCell.self, forCellReuseIdentifier: "mineCell")
        return tabelView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    
//        let query = BmobUser.query()!
//        query.getObjectInBackground(withId: "f5577d068f") { (bmobObject, error) in
//            let user = bmobObject as! BmobUser
//            AHLog(user)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupUI() {
        view.addSubview(tableView)
        
        setNavigationBarStyle(BarColor: UIColor.white, backItemColor: .blue)
        
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置", style: .plain, target: self, action: #selector(AHMineViewController.settingAction))
    }
    
    func settingAction() {
        let settingVC = AHSettingViewController()
        settingVC.logoutClouse = {
            let loginVC = AHLoginViewController()
            let nav = UINavigationController.init(rootViewController: loginVC)
            self.present(nav, animated: true, completion: nil)
        }
        settingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
}

extension AHMineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if userInfo == nil { // 未登录
                let cell = AHNoLoginCell.cellWithTableView(tableView)
                cell.selectionStyle = .none
                return cell
            } else { // 已登录
                let cell = AHUserCell.cellWithTableView(tableView)
                cell.accessoryType = .disclosureIndicator
                cell.userInfo = self.userInfo
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mineCell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "我的收藏"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if userInfo == nil {
                let loginVC = AHLoginViewController()
                let nav = UINavigationController(rootViewController: loginVC)
                present(nav, animated: true, completion: nil)
            } else {
                let vc = BaseViewController()
                vc.title = "编辑个人主页"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return userInfo == nil ? 90 : 90
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 15
        default:
            return 15
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
