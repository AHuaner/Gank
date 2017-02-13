//
//  AHSearchViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/1/9.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class AHSearchViewController: BaseViewController {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // 模型数组
    fileprivate var datasArray: [AHSearchGankModel] = [AHSearchGankModel]()
    
    // 当前页码
    fileprivate var currentPage: Int = 1
    
    // 最后一次请求的内容, 防止重复加载
    fileprivate var lastText: String!
    
    fileprivate var recentSearchTitles = [String]()
    
    lazy var recentSearchView: AHSearchListView = {
        let recentSearchView = AHSearchListView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: 0))
        recentSearchView.addTags(titles: self.recentSearchTitles)
        
        recentSearchView.getTitleArrayClouse = { [unowned self] (titles) in
            self.recentSearchTitles = titles
            NSKeyedArchiver.archiveRootObject(self.recentSearchTitles, toFile: "saveRecentSearchTitles".cachesDir())
        }
        
        recentSearchView.searchGankWithTitleClouse = { [unowned self] (text, titles) in
            self.view.endEditing(true)
            self.searchTextField.text = text
            self.loadRequest(WithText: text)
            
            self.recentSearchTitles = titles
            NSKeyedArchiver.archiveRootObject(self.recentSearchTitles, toFile: "saveRecentSearchTitles".cachesDir())
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
        setupRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        if (self.navigationController?.viewControllers.count)! > 1 {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    
    fileprivate func setupUI() {
        // 弹出键盘
        searchTextField.becomeFirstResponder()
        
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
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 55
        
        
        contentView.contentSize = CGSize(width: kScreen_W, height: self.recentSearchView.Height)
        view.addSubview(contentView)
        contentView.addSubview(recentSearchView)
        recentSearchView.cleanBtn.addTarget(self, action: #selector(AHSearchViewController.cleanBtnAction), for: .touchUpInside)
    }
    
    // 设置刷新控件
    fileprivate func setupRefresh() {
        let footer =  MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(AHSearchViewController.loadMoreGank))
        footer?.setTitle("上拉加载更多", for: .idle)
        footer?.setTitle("释放立即加载", for: .pulling)
        footer?.setTitle("干货加载中...", for: .refreshing)
        tableView.mj_footer = footer
    }
    
    // 上拉加载更多数据
    func loadMoreGank() {
        let currentPage = self.currentPage + 1
        guard let text = self.searchTextField.text else { return }
        
        AHNewWorkingAgent.loadSearchRequest(text: text, page: currentPage, success: { (result) in
            guard let datas = result as? [AHSearchGankModel] else {
                self.tableView.mj_footer.endRefreshing()
                return
            }
            
            self.datasArray.append(contentsOf: datas)
            self.tableView.reloadData()
            self.currentPage = currentPage
            self.tableView.mj_footer.endRefreshing()
            
        }) { (error) in
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
    func popViewController() {
        self.lastText = ""
        ToolKit.dismissHUD()
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadRequest(WithText text: String) {
        self.lastText = text
        
        ToolKit.show(withStatus: "正在加载中")
        AHNewWorkingAgent.loadSearchRequest(text: text, page: 1, success: { (result: Any) in
            if self.lastText != text { return }
            
            ToolKit.dismissHUD()
            guard let datasArray = result as? [AHSearchGankModel] else { return }
            self.tableView.isHidden = false
            self.contentView.isHidden = true
            
            self.datasArray = datasArray
            self.tableView.reloadData()
        }) { (error: Error) in
            if self.lastText != text { return }
            
            ToolKit.showError(withStatus: "加载失败", style: .dark)
            AHLog(error)
        }
    }
    
    func cleanBtnAction() {
        self.showAlertController(locationVC: self, title: "清除历史记录", message: "", confrimClouse: { (action) in
            self.recentSearchView.removeAllTags()
            self.recentSearchTitles.removeAll()
            NSKeyedArchiver.archiveRootObject(self.recentSearchTitles, toFile: "saveRecentSearchTitles".cachesDir())
        }) {_ in}
    }
    
    func viewEndEditing() {
        self.view.endEditing(true)
    }
    
    func recentSearchTitlesAddTitle(text: String) {
        for title in recentSearchTitles {
            if title == text { return }
        }
        self.recentSearchTitles.insert(text, at: 0)
        self.recentSearchView.addTag(tagTitle: text)
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
        let cell = AHSearchCell.cellWithTableView(tableView)
        let model = datasArray[indexPath.row]
        cell.searchModel = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = datasArray[indexPath.row]
        let webVC = AHHomeWebViewController()
        webVC.urlString = model.url
        webVC.gankModel = model
        self.navigationController?.pushViewController(webVC, animated: true)
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
