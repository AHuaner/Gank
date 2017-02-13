//
//  GankModel.swift
//  Gank
//
//  Created by AHuaner on 2017/2/13.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class GankModel: NSObject {
    var id: String?
    var publishedAt: String?
    var desc: String?
    var url: String?
    var user: String?
    var type: String?
    
    override init() {
        super.init()
    }
    
    // 在bmob服务器的唯一标示
    var objectId: String?
    init(bmob: BmobObject) {
        super.init()
        self.id = bmob.object(forKey: "gankId") as? String
        self.desc = bmob.object(forKey: "gankDesc") as? String
        self.publishedAt = bmob.object(forKey: "gankPublishAt") as? String
        self.url = bmob.object(forKey: "gankUrl") as? String
        self.type = bmob.object(forKey: "gankType") as? String
        self.user = bmob.object(forKey: "gankUser") as? String
        self.objectId = bmob.objectId
    }
}
