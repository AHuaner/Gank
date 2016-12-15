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
    
    class func loadClassRequest(tpye: ClassType, page: Int, success: @escaping Success, failure: @escaping Failure) {

        let url = AHConfig.Http_ + "data/\(tpye.rawValue)/20/\(page)"
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AHNetWorking.requestData(.get, URLString: urlString!, parameters: nil, success: { (result: Any) in
            // 创建一个组队列
            let group = DispatchGroup()
            
            let dict = JSON(result)
            var datas = [AHClassModel]()
    
            for i in 0..<dict["results"].count {
                let model = AHClassModel(dict: dict["results"][i])
                
                if let images = model.images, model.images?.count == 1 {
                    let urlString = images[0] + "?imageInfo"
                    let url = URL(string: urlString)
                    let urlconfig = URLSessionConfiguration.default
                    urlconfig.timeoutIntervalForRequest = 2
                    urlconfig.timeoutIntervalForResource = 2
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
//                     当前线程加入组队列
//                    group.enter()
//                    let session = URLSession.shared
//                    let tast = session.dataTask(with: url!, completionHandler: { (data: Data?, _, error: Error?) in
//                        if let data = data {
//                            let json = JSON(data: data)
//                            if let width = json["width"].object as? CGFloat {
//                                model.imageW = width
//                            }
//                            if let height = json["height"].object as? CGFloat {
//                                model.imageH = height
//                            }
//                        }
//                        // 当前线程离开组队列
//                        group.leave()
//                    })
//                    tast.resume()
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
}
