//
//  AHGankDAO.swift
//  Gank
//
//  Created by AHuaner on 2017/1/18.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

struct AHGankDAO {
    /// 缓存干货数据
    static func cacheGanks(type: String, ganks: [JSONObject]) {
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
    
    /// 从数据库中加载缓存数据
    static func loadCacheGanks(type: String, finished: @escaping ([JSONObject]) -> ()) {
        let sql = "SELECT * FROM T_\(type) "
        SQLiteManager.shareManager().dbQueue?.inDatabase({ (db) in
            var ganks = [JSONObject]()
            if let res = db?.executeQuery(sql, withArgumentsIn: nil) {
                while res.next() {
                    guard let gankText = res.string(forColumn: "gankText") else { return }
                    let data = gankText.data(using: String.Encoding.utf8)!
                    
                    let dict = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! JSONObject
                    ganks.append(dict)
                }
                finished(ganks)
            }
            finished(ganks)
        })
    }
    
    /// 清空对应的表
    static func cleanCacheGanks(type: String) {
        let sql = "DELETE FROM T_\(type)"
        SQLiteManager.shareManager().dbQueue?.inDatabase({ (db) -> Void in
            db?.executeUpdate(sql, withArgumentsIn: nil)
        })
    }
}
