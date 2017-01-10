//
//  AHNewWorkingAgent.swift
//  Gank
//
//  Created by AHuaner on 2016/12/13.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class AHNewWorkingAgent: NSObject {
    
    class func loadClassRequest(tpye: String, page: Int, success: @escaping Success, failure: @escaping Failure) {

        let url = AHConfig.Http_ + "data/\(tpye)/20/\(page)"
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AHNetWorking.requestData(.get, URLString: urlString!, parameters: nil, success: { (result: Any) in
            // 创建一个组队列
            let group = DispatchGroup()
            
            let dict = JSON(result)
            var datas = [AHClassModel]()
    
            let urlconfig = URLSessionConfiguration.default
            urlconfig.timeoutIntervalForRequest = 2
            urlconfig.timeoutIntervalForResource = 2
            
            for i in 0..<dict["results"].count {
                let model = AHClassModel(dict: dict["results"][i])
                
                if let images = model.images, model.images?.count == 1 {
                    let urlString = images[0] + "?imageInfo"
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
                datas.append(model)
            }
            
            // 等组队列执行完, 在主线程回调
            group.notify(queue: DispatchQueue.main, execute: { 
                success(datas)
            })

        }, failure: { (error: Error) in
            failure(error)
        })
    }
    
    class func loadHomeRequest(date: String, success: @escaping Success, failure: @escaping Failure) {
        let url = AHConfig.Http_ + "day/\(date)"
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AHNetWorking.requestData(.get, URLString: urlString!, success: { (result: Any) in
            let dict = JSON(result)
            var datas = [AHHomeGroupModel]()
            
            if dict["category"].count == 0 {
                success(datas)
                return
            }
            
            for i in 0..<dict["category"].count {
                let groupTitle = dict["category"][i].stringValue
                let groupModel = AHHomeGroupModel(dict: dict["results"], key: groupTitle)
                datas.append(groupModel)
            }
            
            success(datas)
        }) { (error: Error) in
            failure(error)
        }
    }
    
    class func loadSearchRequest(text: String, page: Int, success: @escaping Success, failure: @escaping Failure) {
        let url = AHConfig.Http_ + "search/query/\(text)/category/all/count/10/page/\(page)"
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AHNetWorking.requestData(.get, URLString: urlString!, success: { (result: Any) in
            let dict = JSON(result)
            var datas = [AHSearchGankModel]()
            
            for i in 0..<dict["results"].count {
                let model = AHSearchGankModel(dict: dict["results"][i])
                datas.append(model)
            }
            success(datas)
            
        }) { (error: Error) in
            failure(error)
        }
    }
}
