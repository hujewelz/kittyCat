//
//  Notification.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/6/9.
//  Copyright © 2017年 service+. All rights reserved.
//

import Foundation

// MARK: Notification

public protocol NotificationName {
    var name: String { get }
}

public extension NotificationName where Self: RawRepresentable, Self.RawValue == String {
    var name: String {
        return "\(Self.self).\(rawValue)Notification"
    }
}

public extension NotificationCenter {
    
    static func post(name: NotificationName, object: Any?, userInfo: [AnyHashable: Any]?) {
        NotificationCenter.default.post(name:  NSNotification.Name(name.name), object: object, userInfo: userInfo)
    }
    
    static func addObserver(_ observer: Any, selector: Selector, name: NotificationName?, object: Any?) {
        var notificationName: NSNotification.Name?
        if name != nil {
            notificationName = NSNotification.Name(name!.name)
        }
        NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName, object: object)
    }
}

// MARK: - Example

enum CustomNotificationName: String, NotificationName {
    case discipleCourseBuySuceed
    case fightGroupStateChanged
}

