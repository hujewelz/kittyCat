//
//  Data+Extension.swift
//  DogSay
//
//  Created by jewelz on 2017/5/1.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit

public extension Date {
    public func timeAgo() -> String {
        
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            return "刚刚"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute)分钟前"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour)小时前"
        } else if secondsAgo < week {
            return "\(secondsAgo / day)天前"
        }
        
        return "\(secondsAgo / week)周前"
    }
    
}
