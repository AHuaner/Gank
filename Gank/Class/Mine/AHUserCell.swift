//
//  AHUserCell.swift
//  Gank
//
//  Created by AHuaner on 2017/2/9.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHUserCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    
    var userInfo: BmobUser! {
        didSet {
            nickName.text = userInfo.object(forKey: "nickName") as? String
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func cellWithTableView(_ tableview: UITableView) -> AHUserCell {
        var cell = tableview.dequeueReusableCell(withIdentifier: "AHUserCell")
        if cell == nil {
            cell = self.viewFromNib() as! AHUserCell
        }
        return cell as! AHUserCell
    }
}
