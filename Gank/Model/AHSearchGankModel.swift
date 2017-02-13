//
//  AHSearchGankModel.swift
//  Gank
//
//  Created by AHuaner on 2017/1/10.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class AHSearchGankModel: NSObject {
    var id: String?
    var desc: String?
    var publishedAt: String?
    var type: String?
    var url: String?
    var who: String?
    
    init(dict: JSON) {
        super.init()
        for (index, subJson) : (String, JSON) in dict {
            switch index {
            case "ganhuo_id":
                self.id = subJson.string
            case "desc":
                self.desc = subJson.string
            case "publishedAt":
                self.publishedAt = subJson.string
            case "url":
                self.url = subJson.string
            case "type":
                self.type = subJson.string
            case "who":
                self.who = subJson.string
            default: break
            }
        }
        // 时间处理
        let time = self.publishedAt! as NSString
        self.publishedAt = time.substring(to: 10) as String
    }
    
    init(bmob: BmobObject) {
        super.init()
        self.id = bmob.object(forKey: "gankId") as? String
        self.desc = bmob.object(forKey: "gankDesc") as? String
        self.publishedAt = bmob.object(forKey: "gankPublishAt") as? String
        self.url = bmob.object(forKey: "gankUrl") as? String
        self.type = bmob.object(forKey: "gankType") as? String
        self.who = bmob.object(forKey: "gankUser") as? String
    }
}
