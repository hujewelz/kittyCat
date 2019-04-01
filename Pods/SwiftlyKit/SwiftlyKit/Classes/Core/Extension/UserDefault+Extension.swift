//
//  UserDefault+Extension.swift
//  DogSay
//
//  Created by jewelz on 2017/4/30.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit

extension UserDefaults {
    
}

public protocol UserDefaultSettable {
    var uniqueKey: String { get }
}

extension UserDefaultSettable where Self: RawRepresentable, Self.RawValue == String {
    
    public var uniqueKey: String {
        return "\(Self.self).\(rawValue)"
    }
    
    public func set(_ value: Any?) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    
    public func set(_ value: Int) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    
    public func set(_ value: Double) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    
    public func set(_ value: String) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    
    public func set(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    
    public var value: Any? {
        return UserDefaults.standard.value(forKey: uniqueKey)
    }
    
    public var integerValue: Int {
        return UserDefaults.standard.integer(forKey: uniqueKey)
    }
    
    public var doubleValue: Double {
        return UserDefaults.standard.double(forKey: uniqueKey)
    }
    
    public var stringValue: String? {
        return UserDefaults.standard.string(forKey: uniqueKey)
    }
    
    public var boolValue: Bool {
        return UserDefaults.standard.bool(forKey: uniqueKey)
    }

    public func remove() {
        UserDefaults.standard.removeObject(forKey: uniqueKey)
    }

    
}

