//
//  AHMoreCell.swift
//  Gank
//
//  Created by AHuaner on 2017/1/17.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHMoreCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var titLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func cellWithTableView(_ tableview: UITableView) -> AHMoreCell {
        var cell = tableview.dequeueReusableCell(withIdentifier: "AHMoreCell")
        if cell == nil {
            cell = self.viewFromNib() as! AHMoreCell
        }
        return cell as! AHMoreCell
    }
}
