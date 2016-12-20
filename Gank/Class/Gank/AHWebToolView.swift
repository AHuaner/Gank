//
//  AHWebToolView.swift
//  Gank
//
//  Created by AHuaner on 2016/12/20.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHWebToolView: UIView {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func webToolView() -> AHWebToolView {
        return AHWebToolView.viewFromNib() as! AHWebToolView
    }
}
