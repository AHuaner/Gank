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
    
    var isLoad: Bool = false
    
    lazy var loadingView: AHLoadingView = {
        let loadingView = AHLoadingView(frame: self.view.bounds)
        return loadingView
    }()
    
    lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H - kNavBarHeight), style: UITableViewStyle.plain)
        tabelView.backgroundColor = UIColorMainBG
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.contentInset.top = 35
        tabelView.contentInset.bottom = kBottomBarHeight
        return tabelView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AHClassViewController.loadDate), name: NSNotification.Name(rawValue: "AHDisplayViewClickOrScrollDidFinshNote"), object: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        view.addSubview(loadingView)
        
        tableView.backgroundColor = UIColor(red: CGFloat(arc4random() % 255 + 1) / 255.0, green: CGFloat(arc4random() % 255 + 1) / 255.0, blue: CGFloat(arc4random() % 255 + 1) / 255.0, alpha: 1)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
    }
    
    func loadDate() {
        if isLoad { return }
        isLoad = true
        sendRequest()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func sendRequest () {
        AHNewWorkingAgent.loadClassRequest(tpye: self.type, page: 1, success: { result in
            AHLog(result)
            self.loadingView.removeFromSuperview()
            
        }, failure: { error in
            AHLog(error)
        })
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

