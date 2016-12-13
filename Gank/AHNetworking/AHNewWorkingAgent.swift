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

        let url = AHConfig.Http_ + "data/\(tpye.rawValue)/10/\(page)"
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AHLog(url)
        AHNetWorking.requestData(.get, URLString: urlString!, parameters: nil, success: { (result: Any) in
            
            guard let dict = result as? [AnyHashable: AnyObject] else {
                return
            }
            
//            guard let dicts = dict["results"] as? [Dictionary] else {
//                return
//            }
            
//            for dict in dict[] {
//                // let model = JSON(data: dict)
//            }
            success(dict["results"]!)
        }, failure: { (error: Error) in
            failure(error)
        })
    }
}
