//
//  AHClassModel.swift
//  Gank
//
//  Created by AHuaner on 2016/12/13.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

let _idKey = "_id"
let descKey = "desc"
let createdAtKey = "createdAt"
let imagesKey = "images"
let urlKey = "url"
let typeKey = "type"
let userKey = "who"

import UIKit
import SwiftyJSON

class AHClassModel: NSObject {
    var id: String?
    
    var createdAt: String?
    
    var desc: String?
    
    var url: String?
    
    var user: String?
    
    var images: [String]?
    
    var type: String?
    
    init(dict: JSON) {
        super.init()
        for (index, subJson) : (String, JSON) in dict {
            switch index {
            case _idKey:
                self.id = subJson.string
            case descKey:
                self.desc = subJson.string
            case createdAtKey:
                self.createdAt = subJson.string
            case urlKey:
                self.url = subJson.string
            case typeKey:
                self.type = subJson.string
            case userKey:
                self.user = subJson.string
            case imagesKey:
                self.images = (subJson.object as AnyObject) as? [String]
            default: break
            }
        }
    }
}
