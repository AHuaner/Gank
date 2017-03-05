//
//  AHNewWork.swift
//  Gank
//
//  Created by AHuaner on 2016/12/13.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import SwiftyJSON

struct AHNewWork: AHNetWorking {
    /// 请求干货页面数据
    static func loadClassRequest(tpye: String, page: Int, success: @escaping Success, failure: @escaping Failure) {
        let url = AHConfig.Http_ + "data/\(tpye)/20/\(page)"
        
        requestData(url, success: { (result: Any) in
            
            // 缓存第一页的数据
            if page == 1 {
                AHGankDAO.cleanCacheGanks(type: tpye)
                let json = result as! JSONObject
                let array = json["results"] as! [JSONObject]
                AHGankDAO.cacheGanks(type: tpye, ganks: array)
            }
            
            let dicts = JSON(result)
            let datas: [AHClassModel]
            
            // 创建一个组队列
            let group = DispatchGroup()
            let urlconfig = URLSessionConfiguration.default
            urlconfig.timeoutIntervalForRequest = 2
            urlconfig.timeoutIntervalForResource = 2
            
            datas = dicts["results"].arrayValue.map({ dict in
                let model = AHClassModel(dict: dict)
                
                if let images = model.images, model.images?.count == 1 {
                    let urlString = images.first! + "?imageInfo"
                    let url = URL(string: urlString)
                    
                    let session = URLSession(configuration: urlconfig)
                    // 当前线程加入组队列
                    group.enter()
                    let tast = session.dataTask(with: url!, completionHandler: { (data: Data?, _, error: Error?) in
                        if let data = data {
                            let json = JSON(data: data)
                            if let width = json["width"].object as? CGFloat {
                                model.imageW = width
                            }
                            if let height = json["height"].object as? CGFloat {
                                model.imageH = height
                            }
                        }
                        // 当前线程离开组队列
                        group.leave()
                    })
                    tast.resume()
                    // 防止内存泄漏
                    session.finishTasksAndInvalidate()
                }
                return model
            })
            
            // 等组队列执行完, 在主线程回调
            group.notify(queue: DispatchQueue.main, execute: { 
                success(datas)
            })

        }, failure: { (error: Error) in
            failure(error)
        })
    }
    
    /// 请求首页数据
    static func loadHomeRequest(date: String, success: @escaping Success, failure: @escaping Failure) {
        let url = AHConfig.Http_ + "day/\(date)"
        
        requestData(url, success: { (result: Any) in
            let dicts = JSON(result)
            var datas = [AHHomeGroupModel]()
            
            for dict in dicts["category"].arrayValue {
                let groupTitle = dict.stringValue
                let groupModel = AHHomeGroupModel(dict: dicts["results"], key: groupTitle)
                datas.append(groupModel)
            }
            
            // 缓存首页数据
            NSKeyedArchiver.archiveRootObject(datas, toFile: "homeGanks".cachesDir())
            
            success(datas)
            
        }) { (error: Error) in
            failure(error)
        }
    }
    
    /// 请求搜索数据
    static func loadSearchRequest(text: String, page: Int, success: @escaping Success, failure: @escaping Failure) {
        let url = AHConfig.Http_ + "search/query/\(text)/category/all/count/20/page/\(page)"
        
        requestData(url, success: { (result: Any) in
            let dicts = JSON(result)
            let datas: [AHSearchGankModel]
            
            datas = dicts["results"].arrayValue.map({ dict in
                AHSearchGankModel(dict: dict)
            })
            
            success(datas)
            
        }) { (error: Error) in
            failure(error)
        }
    }
    
    /// 请求发过干货日期数据
    static func loadDateRequest(success: @escaping Success, failure: @escaping Failure) {
        let url = AHConfig.Http_ + "day/history"
        
        requestData(url, success: { (result: Any) in
            let json = result as! JSONObject
            guard let dateArray = json["results"] else { return }
            success(dateArray)
        }) { (error: Error) in
            failure(error)
        }
    }
}
