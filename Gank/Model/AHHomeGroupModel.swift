//
//  AHHomeGroupModel.swift
//  Gank
//
//  Created by AHuaner on 2016/12/22.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class AHHomeGroupModel: NSObject, NSCoding {
    var groupTitle: String
    var ganks: [AHHomeGankModel]
    
    
    init(dict: JSON, key: String) {
        groupTitle = key
        ganks = dict[key].arrayValue.map({ dict in
            AHHomeGankModel(dict: dict)
        })
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.ganks = aDecoder.decodeObject(forKey: "ganks") as! [AHHomeGankModel]
        self.groupTitle = aDecoder.decodeObject(forKey: "groupTitle") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(ganks, forKey: "ganks")
        aCoder.encode(groupTitle, forKey: "groupTitle")
    }
}

