//
//  User.swift
//  Gank
//
//  Created by AHuaner on 2017/2/16.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

struct User {
    
    static var info = BmobUser.current()
    
    static func logout() {
        BmobUser.logout()
        update()
    }
    
    static func update() {
        info = BmobUser.current()
    }
}
