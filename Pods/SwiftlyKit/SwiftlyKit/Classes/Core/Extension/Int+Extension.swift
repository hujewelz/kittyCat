//
//  Int+Extension.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/9/19.
//  Copyright © 2017年 service+. All rights reserved.
//

import Foundation

public extension Int {
    func toChineseNumber() -> String {
        if self > 100 {
            return "\(self)"
        }
        if self <= 0 {
            return "0"
        }
        let chineseNumber = ["一", "二", "三", "四", "五", "六", "七", "八", "九"]
        if self < 10 {
            return "\(chineseNumber[self-1])"
        }
        let ten = self / 10
        let n = self % 10
        
        if ten == 1 && n == 0 {
            return "十"
        }
        if ten == 1 && n != 0 {
            return "十\(chineseNumber[n-1])"
        }
        if n == 0 {
            return "\(chineseNumber[ten-1])十"
        }
        return "\(chineseNumber[ten-1])十\(chineseNumber[n-1])"
   }
////
////    func time() -> String {
////        var second = self % 60
////        var minute = self / 60
////        var hour = 0
////
////        if self < 60 {
////            return "\(second)秒"
////        }
////        else if self >= 3600 {
////            hour = self / 3600
////            if self % 3600 == 0 { return "\(hour)小时" }
////            if second == 0 {
////
////            }
////            return ""
////        } else {
////            if self % 60 == 0 { return "\(minute)分钟"}
////            return "\(minute)分\(second)秒"
////        }
//        
//    }
}
