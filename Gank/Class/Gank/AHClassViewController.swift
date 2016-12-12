//
//  AHClassViewController.swift
//  Gank
//
//  Created by AHuaner on 2016/12/12.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHClassViewController: BaseViewController {
    
    var type: ClassType!
    
    lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H - kNavBarHeight), style: UITableViewStyle.plain)
        tabelView.backgroundColor = UIColorMainBG
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.contentInset.top = 35
        tabelView.contentInset.bottom = kBottomBarHeight
        return tabelView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        tableView.backgroundColor = UIColor(red: CGFloat(arc4random() % 255 + 1) / 255.0, green: CGFloat(arc4random() % 255 + 1) / 255.0, blue: CGFloat(arc4random() % 255 + 1) / 255.0, alpha: 1)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AHLog(type.rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AHClassViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        
        cell.textLabel?.text = "\(title!)---\(indexPath.row)"
        return cell
    }
}

extension AHClassViewController: UITableViewDelegate {
    
}

