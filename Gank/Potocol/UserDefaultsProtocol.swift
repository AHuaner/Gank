//
//  UserDefaultsProtocol.swift
//  Gank
//
//  Created by AHuaner on 2017/2/26.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

// MARK: - 命名空间生成唯一Key
protocol KeyNamespaceable {
    static func namespaced<T: RawRepresentable>(_ key: T) -> String
}

extension KeyNamespaceable {
    static func namespaced<T: RawRepresentable>(_ key: T) -> String {
        return String(describing: self) + ".\(key.rawValue)"
    }
}

// MARK: - StringDefaultSettable
protocol StringDefaultSettable: KeyNamespaceable {
    associatedtype StringKey: RawRepresentable
}

extension StringDefaultSettable where StringKey.RawValue == String {
    static func set(_ value: String, forKey key: StringKey) {
        UserDefaults.standard.set(value, forKey: namespaced(key))
    }
    
    static func string(forKey key: StringKey) -> String? {
        return UserDefaults.standard.string(forKey: namespaced(key))
    }
}

// MARK: - BoolDefaultSettable
protocol BoolDefaultSettable: KeyNamespaceable {
    associatedtype BoolKey: RawRepresentable
}

extension BoolDefaultSettable where BoolKey.RawValue == String {
    static func set(_ value: Bool, forKey key: BoolKey) {
        UserDefaults.standard.set(value, forKey: namespaced(key))
    }
    
    static func bool(forKey key: BoolKey) -> Bool {
        return UserDefaults.standard.bool(forKey: namespaced(key))
    }
}

// MARK: - IntDefaultSettable
protocol IntDefaultSettable: KeyNamespaceable {
    associatedtype IntKey: RawRepresentable
}

extension IntDefaultSettable where IntKey.RawValue == String {
    static func set(_ value: Int, forKey key: IntKey) {
        UserDefaults.standard.set(value, forKey: namespaced(key))
    }
    
    static func integer(forKey key: IntKey) -> Int {
        return UserDefaults.standard.integer(forKey: namespaced(key))
    }
}

// MARK: - UrlDefaultSettable
protocol UrlDefaultSettable: KeyNamespaceable {
    associatedtype UrlKey: RawRepresentable
}

extension UrlDefaultSettable where UrlKey.RawValue == String {
    static func set(_ value: URL?, forKey key: UrlKey) {
        UserDefaults.standard.set(value, forKey: namespaced(key))
    }
    
    static func url(forKey key: UrlKey) -> URL? {
        return UserDefaults.standard.url(forKey: namespaced(key))
    }
}
