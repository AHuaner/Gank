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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AHSearchCell")
        tableView.tableFooterView = UIView()
    }
    
    func popViewController() {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func textDidChange(searchTextField: UITextField) {
        guard let text = searchTextField.text else { return }
        if text.unicodeScalars.count > 0 {
            AHLog(text)
            loadRequest(WithText: text)
        } else {
            self.datasArray = [AHSearchGankModel]()
            self.tableView.reloadData()
        }
    }
    
    func loadRequest(WithText: String) {
        self.lastText = WithText
        
        AHNewWorkingAgent.loadSearchRequest(text: WithText, page: 1, success: { (result: Any) in
            if self.lastText != WithText { return }
            guard let datasArray = result as? [AHSearchGankModel] else { return }
            self.datasArray = datasArray
            self.tableView.reloadData()
        }) { (error: Error) in
            
        }
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
