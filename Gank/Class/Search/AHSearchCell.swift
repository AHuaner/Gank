//
//  AHSearchCell.swift
//  Gank
//
//  Created by AHuaner on 2017/1/15.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHSearchCell: UITableViewCell {

    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var classBtn: UIButton!
    
    var searchModel: AHSearchGankModel! {
        didSet {
            descLabel.text = searchModel.desc!
            timeBtn.setTitle(searchModel.publishedAt!, for: .normal)
            classBtn.setTitle(searchModel.type!, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutMargins = .zero
        timeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        classBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
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
