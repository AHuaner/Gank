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
        AHNetWorking.requestData(.get, URLString: urlString!, parameters: nil, success: { (result: Any) in
            let dict = JSON(result)
            var datas = [AHClassModel]()
            for i in 0..<dict["results"].count {
                let model = AHClassModel(dict: dict["results"][i])
                datas.append(model)
            }
            success(datas)
        }, failure: { (error: Error) in
            failure(error)
        })
    }
}
