//
//  AHSearchViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/1/9.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHSearchViewController: BaseViewController {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var datasArray: [AHSearchGankModel] = [AHSearchGankModel]()
    
    // 最后一次请求的内容, 防止重复加载
    fileprivate var lastText: String!
    
    lazy var recentSearchView: AHSearchListView = {
        let recentSearchView = AHSearchListView(frame: CGRect(x: 0, y: kNavBarHeight, width: kScreen_W, height: 0))
        recentSearchView.addTags(titles: ["111111", "11", "1231", "1231231223", "asdfasdfasdfa", "11"]) // ["1231", "1231231223", "asdfasdfasdfa", "11"]
        return recentSearchView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        searchTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.navigationController?.viewControllers.count)! > 1 {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    
    fileprivate func setupUI() {
        searchTextField.addTarget(self, action: #selector(AHSearchViewController.textDidChange(searchTextField:)), for: .editingChanged)
        closeBtn.addTarget(self, action: #selector(AHSearchViewController.popViewController), for: .touchUpInside)
        
        self.view.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AHSearchCell")
        tableView.tableFooterView = UIView()
        
        self.view.addSubview(recentSearchView)
        
        recentSearchView.cleanBtn.addTarget(self, action: #selector(AHSearchViewController.cleanBtnAction), for: .touchUpInside)
    }
    
    func popViewController() {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func textDidChange(searchTextField: UITextField) {
        guard let text = searchTextField.text else { return }
        if text.unicodeScalars.count > 0 {
            loadRequest(WithText: text)
        } else {
            self.lastText = ""
            self.datasArray = [AHSearchGankModel]()
            self.tableView.isHidden = true
            self.tableView.reloadData()
        }
    }
    
    func loadRequest(WithText: String) {
        self.lastText = WithText
        
        AHNewWorkingAgent.loadSearchRequest(text: WithText, page: 1, success: { (result: Any) in
            if self.lastText != WithText { return }
            guard let datasArray = result as? [AHSearchGankModel] else { return }
            self.tableView.isHidden = false
            
            self.datasArray = datasArray
            self.tableView.reloadData()
        }) { (error: Error) in
            
        }
    }
    
    func cleanBtnAction() {
        AHLog("清除")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AHSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AHSearchCell", for: indexPath)
        let model = datasArray[indexPath.row]
        cell.textLabel?.text = model.desc!
        return cell
    }
}
