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
    
    var datasArray: [AHClassModel] = [AHClassModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        let fpsLabel = FPSLabel(frame: CGRect(x: 0, y: 20, width: 50, height: 30))
        UIApplication.shared.keyWindow?.addSubview(fpsLabel)
        view.addSubview(tableView)
        
        view.addSubview(loadingView)
        
        tableView.backgroundColor = UIColor(red: CGFloat(arc4random() % 255 + 1) / 255.0, green: CGFloat(arc4random() % 255 + 1) / 255.0, blue: CGFloat(arc4random() % 255 + 1) / 255.0, alpha: 1)
        
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
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
            self.loadingView.removeFromSuperview()
            guard let datasArray = result as? [AHClassModel] else {
                return
            }
            self.datasArray = datasArray
        }, failure: { error in
            AHLog(error)
        })
    }
}

extension AHClassViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AHClassCell.cellWithTableView(tableView)
        cell.classModel = datasArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = datasArray[indexPath.row]
        return model.cellH
    }
}

extension AHClassViewController: UITableViewDelegate {
    
}

