//
//  AHCollectCell.swift
//  Gank
//
//  Created by AHuaner on 2017/2/13.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHCollectCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var classBtn: UIButton!
    
    var gankModel: GankModel! {
        didSet {
            contentLabel.text = gankModel.desc
            userBtn.setTitle(gankModel.user, for: .normal)
            timeBtn.setTitle(gankModel.publishedAt, for: .normal)
            classBtn.setTitle(gankModel.type, for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        timeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        classBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        userBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension AHCollectCell: ViewNameReusable {}
