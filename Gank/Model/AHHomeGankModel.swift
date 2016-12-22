//
//  AHHomeGankModel.swift
//  Gank
//
//  Created by AHuaner on 2016/12/22.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class AHHomeGankModel: NSObject {
    var id: String?
    
    var publishedAt: String?
    
    var desc: String?
    
    var url: String?
    
    var user: String?
    
    var type: String?
    
    init(dict: JSON) {
        super.init()
        for (index, subJson) : (String, JSON) in dict {
            switch index {
            case _idKey:
                self.id = subJson.string
            case descKey:
                self.desc = subJson.string
            case publishedAtKey:
                self.publishedAt = subJson.string
            case urlKey:
                self.url = subJson.string
            case typeKey:
                self.type = subJson.string
            case userKey:
                self.user = subJson.string
            default: break
            }
        }
        
        // 时间处理
//        let time = self.publishedAt! as NSString
//        self.publishedAt = time.substring(to: 10) as String
    }
}
