//
//  Text1ViewController.swift
//  AHDisplayViewController
//
//  Created by CoderAhuan on 16/8/31.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class Text1ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: CGFloat(arc4random() % 255 + 1) / 255.0, green: CGFloat(arc4random() % 255 + 1) / 255.0, blue: CGFloat(arc4random() % 255 + 1) / 255.0, alpha: 1)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print(tableView.contentInset.top)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        
        cell.textLabel?.text = "\(title!)---\(indexPath.row)"
        return cell
    }
}

