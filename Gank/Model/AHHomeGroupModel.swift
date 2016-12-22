//
//  AHHomeGroupModel.swift
//  Gank
//
//  Created by AHuaner on 2016/12/22.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class AHHomeGroupModel: NSObject {
    var groupTitle: String
    var ganks: [AHHomeGankModel]
    
    
    init(dict: JSON, key: String) {
        groupTitle = key
        ganks = [AHHomeGankModel]()
        super.init()
        for i in 0..<dict[key].count {
            let gankModel = AHHomeGankModel(dict: dict[key][i])
            ganks.append(gankModel)
        }
    }
}
