//
//  AHSearchCell.swift
//  Gank
//
//  Created by AHuaner on 2017/1/15.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHSearchCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var searchModel: AHSearchGankModel! {
        didSet {
            descLabel.text = searchModel.desc!
            typeLabel.text = searchModel.type!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func cellWithTableView(_ tableview: UITableView) -> AHSearchCell {
        var cell = tableview.dequeueReusableCell(withIdentifier: "AHSearchCell")
        if cell == nil {
            cell = self.viewFromNib() as! AHSearchCell
        }
        return cell as! AHSearchCell
    }
}
