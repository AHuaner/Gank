//
//  AHGankDAO.swift
//  Gank
//
//  Created by AHuaner on 2017/1/18.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHGankDAO: NSObject {
    /// 缓存微博数据
    class func cacheStatuses(type: String, ganks: [[String: Any]]) {
        
        let userId = "AHuaner"
        
        SQLiteManager.shareManager().dbQueue?.inTransaction({ (db, rollback) -> Void in
            
            for dict in ganks {
                let gankId = dict["_id"] as! String
                // JSON -> 二进制 -> 字符串
                let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
                let gankText = String(data: data, encoding: String.Encoding.utf8)!
                
                let sql = "INSERT INTO T_\(type) (gankId, gankText, userId) VALUES ('\(gankId)', '\(gankText)', '\(userId)')"
                
                do {
                    try db?.executeUpdate(sql, values: nil)
                } catch {
                    print("error")
                }
            }
        })
    }

}
