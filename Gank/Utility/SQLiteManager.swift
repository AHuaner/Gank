//
//  SQLiteManager.swift
//  Gank
//
//  Created by AHuaner on 2017/1/18.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit
import FMDB

class SQLiteManager: NSObject {
    
    private static let manager: SQLiteManager = SQLiteManager()
    
    /// 单粒
    class func shareManager() -> SQLiteManager {
        return manager
    }
    
    var dbQueue: FMDatabaseQueue?
    
    /// 打开数据库
    func openDB(DBName: String) {
        
        let path = DBName.docDir()
        AHLog(path)
        
        // 创建数据库对象
        dbQueue = FMDatabaseQueue(path: path)
    }
    
    /// 创建表
    func creatTable(tableName: String) {
        let sql = "CREATE TABLE IF NOT EXISTS T_\(tableName)( \n" +
            "gankId TEXT PRIMARY KEY, \n" +
            "gankText TEXT, \n" +
            "userId TEXT, \n" +
            "createDate TEXT NOT NULL DEFAULT (datetime('now', 'localtime')) \n" +
        "); \n"
        
        dbQueue!.inDatabase { (db) -> Void in
            db!.executeUpdate(sql, withArgumentsIn: nil)
        }
    }
}
