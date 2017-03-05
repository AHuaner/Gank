//
//  Validate.swift
//  Gank
//
//  Created by AHuaner on 2017/2/8.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

struct Validate {
    //MARK:- 正则匹配手机号
    static func checkMobile(_ mobileNumbel: String) -> Bool {
        /**
         * 手机号码:
         * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
         * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         * 联通号段: 130,131,132,155,156,185,186,145,176,1709
         * 电信号段: 133,153,180,181,189,177,1700
         */
        let MOBIL = "^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)"
        /**
         * 中国移动：China Mobile
         * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         */
        let CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)"
        /**
         * 中国联通：China Unicom
         * 130,131,132,155,156,185,186,145,176,1709
         */
        let CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)"
        /**
         * 中国电信：China Telecom
         * 133,153,180,181,189,177,1700
         */
        let CT = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", MOBIL)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@", CM)
        let regextestcu = NSPredicate(format: "SELF MATCHES %@", CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@", CT)
        if regextestmobile.evaluate(with: mobileNumbel) || regextestcm.evaluate(with: mobileNumbel) || regextestcu.evaluate(with: mobileNumbel) || regextestct.evaluate(with: mobileNumbel) {
            return true
        }
        return false
    }
    
    //MARK:- 正则匹配用户身份证号15或18位
    static func checkUserIdCard(_ idCard: String) -> Bool {
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch:Bool = pred.evaluate(with: idCard)
        return isMatch;
    }
    
    //MARK:- 正则匹配用户密码6-18位数字和字母组合
    static func checkPassword(_ password: String) -> Bool {
        let pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch: Bool = pred.evaluate(with: password)
        return isMatch;
    }
    
    //MARK:- 正则匹配URL
    static func checkURL(_ url: String) -> Bool {
        let pattern = "^[0-9A-Za-z]{1,50}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch: Bool = pred.evaluate(with: url)
        return isMatch;
    }
    
    //MARK:- 正则匹配用户姓名,20位的中文或英文
    static func checkUserName(_ userName: String) -> Bool {
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch: Bool = pred.evaluate(with: userName)
        return isMatch;
    }
    
    //MARK:- 正则匹配用户email
    static func checkEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch: Bool = pred.evaluate(with: email)
        return isMatch;
    }
}
