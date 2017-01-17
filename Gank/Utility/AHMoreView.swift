//
//  AHMoreView.swift
//  Gank
//
//  Created by AHuaner on 2017/1/17.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHMoreView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewdidSelectClouse: ((IndexPath) -> Void)?
    
    fileprivate var titles = ["收藏", "分享", "Safari打开"]
    fileprivate var images = ["icon_collect", "icon_share", "icon_safari"];
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.autoresizingMask = UIViewAutoresizing()
        self.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColorFromRGB("606060")
        tableView.separatorStyle = .none
    }
    
    class func moreView() -> AHMoreView {
        return self.viewFromNib() as! AHMoreView
    }
}

extension AHMoreView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let clouse = tableViewdidSelectClouse else { return }
        clouse(indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AHMoreCell.cellWithTableView(tableView)
        cell.iconView.image = UIImage(named: images[indexPath.row])
        cell.titLabel.text = titles[indexPath.row]
        return cell
    }
}
