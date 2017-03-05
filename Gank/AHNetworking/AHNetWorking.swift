//
//  AHNetWorking.swift
//  Gank
//
//  Created by AHuaner on 2016/12/13.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import Alamofire

typealias Success = (Any) -> Void
typealias Failure = (Error) -> Void

protocol AHNetWorking {
    
}

extension AHNetWorking {
    static func requestData(_ url: String, method: HTTPMethod = .get, parameters: JSONObject? = nil, success: @escaping Success, failure: @escaping Failure) {
        
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        Alamofire.request(urlString, method: method, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    success(result)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    static func cancelAllRequest() {
        Alamofire.SessionManager().session.getAllTasks { (tasks) -> Void in
            tasks.forEach({ $0.cancel() })
        }
    }
}
