//
//  AHSearchViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/1/9.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit
import SVProgressHUD

class AHSearchViewController: BaseViewController {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var datasArray: [AHSearchGankModel] = [AHSearchGankModel]()
    
    // 最后一次请求的内容, 防止重复加载
    fileprivate var lastText: String!
    
    fileprivate var recentSearchTitles = [String]()
    
    lazy var recentSearchView: AHSearchListView = {
        let recentSearchView = AHSearchListView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: 0))
        recentSearchView.addTags(titles: self.recentSearchTitles)
        
        recentSearchView.getTitleArrayClouse = { [unowned self] (titles) in
            self.recentSearchTitles = titles
            NSKeyedArchiver.archiveRootObject(self.recentSearchTitles, toFile: "saveRecentSearchTitles".cachesDir())
            AHLog(self.recentSearchTitles)
        }
        
        recentSearchView.searchGankWithTitleClouse = { [unowned self] (text) in
            self.view.endEditing(true)
            self.searchTextField.text = text
            self.loadRequest(WithText: text)
        }
        
        return recentSearchView
    }()
    
    lazy var contentView: UIScrollView = {
        let contentView = UIScrollView(frame: CGRect(x: 0, y: kNavBarHeight, width: kScreen_W, height: kScreen_H - kNavBarHeight))
        let tap = UITapGestureRecognizer(target: self, action: #selector(AHSearchViewController.viewEndEditing))
        contentView.addGestureRecognizer(tap)
        return contentView
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
        // 获取历史搜索
        let saveRecentSearchTitles = NSKeyedUnarchiver.unarchiveObject(withFile: "saveRecentSearchTitles".cachesDir()) as? [String]
        if saveRecentSearchTitles != nil {
            recentSearchTitles = saveRecentSearchTitles!
        }
        
        closeBtn.addTarget(self, action: #selector(AHSearchViewController.popViewController), for: .touchUpInside)
        self.recentSearchView.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        
        searchTextField.delegate = self
        view.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AHSearchCell")
        tableView.tableFooterView = UIView()
        
        contentView.contentSize = CGSize(width: kScreen_W, height: self.recentSearchView.Height)
        view.addSubview(contentView)
        contentView.addSubview(recentSearchView)
        
        recentSearchView.cleanBtn.addTarget(self, action: #selector(AHSearchViewController.cleanBtnAction), for: .touchUpInside)
    }
    
    func popViewController() {
        self.lastText = ""
        
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadRequest(WithText: String) {
        self.lastText = WithText
        SVProgressHUD.show(withStatus: "正在加载中")
        AHNewWorkingAgent.loadSearchRequest(text: WithText, page: 1, success: { (result: Any) in
            if self.lastText != WithText { return }
            SVProgressHUD.dismiss()
            AHLog("成功----\(WithText)")
            guard let datasArray = result as? [AHSearchGankModel] else { return }
            self.tableView.isHidden = false
            self.contentView.isHidden = true
            
            // self.recentSearchTitlesAddTitle(text: WithText)
            
            self.datasArray = datasArray
            self.tableView.reloadData()
        }) { (error: Error) in
            if self.lastText != WithText { return }
            
            // self.recentSearchTitlesAddTitle(text: self.searchTextField.text!)
            AHLog(error)
        }
    }
    
    func cleanBtnAction() {
        AHLog("清除")
    }
    
    func viewEndEditing() {
        self.view.endEditing(true)
    }
    
    func recentSearchTitlesAddTitle(text: String) {
        for title in recentSearchTitles {
            if title == text { return }
        }
        self.recentSearchTitles.insert(text, at: 0)
        self.recentSearchView.addTags(titles: self.recentSearchTitles)
        NSKeyedArchiver.archiveRootObject(self.recentSearchTitles, toFile: "saveRecentSearchTitles".cachesDir())
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            guard case let frame as CGRect = change?[NSKeyValueChangeKey.newKey] else { return }
            contentView.contentSize.height = frame.maxY
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        self.recentSearchView.removeObserver(self, forKeyPath: "frame")
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

extension AHSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        if text.unicodeScalars.count > 0 {
            loadRequest(WithText: text)
            self.recentSearchTitlesAddTitle(text: text)
            self.view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.tableView.isHidden = true
        self.contentView.isHidden = false
    }
}
