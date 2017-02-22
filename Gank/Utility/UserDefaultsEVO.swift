//
//  UserDefaultsEVO.swift
//  UserDefaultsEVO
//
//  Created by CoderAhuan on 2017/2/22.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import Foundation

// MARK: UserDefault通用字段
extension UserDefaults {
    enum AHData: String, UserDefaultSettable {
        case mobilePhoneNumber                  /// 上一次登录的手机号
        case lastDate                           /// 首页缓存数据的日期
    }
}

public protocol UserDefaultSettable {
    var uniqueKey: String { get }
}

public extension UserDefaultSettable where Self: RawRepresentable, Self.RawValue == String {
    public var uniqueKey: String {
        return "\(Self.self).\(rawValue)"
    }
    
    public func store(value: Any?){
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    public var storedValue: Any? {
        return UserDefaults.standard.value(forKey: uniqueKey)
    }
    public var storedString: String? {
        return storedValue as? String
    }
    
    public func store(url: URL?) {
        UserDefaults.standard.set(url, forKey: uniqueKey)
    }
    public var storedURL: URL? {
        return UserDefaults.standard.url(forKey: uniqueKey)
    }
    
    public func store(value: Bool) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    public var storedBool: Bool {
        return UserDefaults.standard.bool(forKey: uniqueKey)
    }
    
    public func store(value: Int) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    public var storedInt: Int {
        return UserDefaults.standard.integer(forKey: uniqueKey)
    }
    
    public func store(value: Double) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    public var storedDouble: Double {
        return UserDefaults.standard.double(forKey: uniqueKey)
    }
    
    public func store(value: Float) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    public var storedFloat: Float {
        return UserDefaults.standard.float(forKey: uniqueKey)
    }
    
    /// removed object from standard userdefaults
    public func removed() {
        UserDefaults.standard.removeObject(forKey: uniqueKey)
    }

}
