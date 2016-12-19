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

    fileprivate var cacheSize: CGFloat? {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H - kNavBarHeight), style: UITableViewStyle.plain)
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
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateCacheSize()
    }
    
    fileprivate func calculateCacheSize() {
        let cache = YYWebImageManager.shared().cache
        let memorySize = CGFloat(cache!.memoryCache.totalCost)
        let diskSize = CGFloat(cache!.diskCache.totalCost())
        let size = (memorySize + diskSize) / 1000.0 / 1000.0
        cacheSize = size
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AHMineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mineCell", for: indexPath)
        
        cell.textLabel?.text = "清除缓存（已使用\(cacheSize!.format(f: 2))MB)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cache = YYWebImageManager.shared().cache
        cache?.memoryCache.removeAllObjects()
        cache?.diskCache.removeAllObjects()
        cacheSize = 0.0
    }
}
