//
//  DateTool.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/6/3.
//  Copyright © 2017年 service+. All rights reserved.
//

import UIKit


public class DateTool {
    
    public lazy var dateFormate: DateFormatter = {
        let formate = DateFormatter()
        return formate
    }()
    
    public static let shared = DateTool()
    
    //lazy var formate
    
    private init() {
        
    }
    
    public lazy var  serverDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    public lazy var  hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    public lazy var  minuteFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        return formatter
    }()
    
    
    public lazy var decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

public enum DateStyle {
    case dot
    case line
}

public extension String {
    public func toDate(with formateString: String) -> Date {
        let formate = DateTool.shared.dateFormate
        formate.dateFormat = formateString
        guard let date = formate.date(from: self) else {
            return Date()
        }
        return date
    }
}

public extension Int {
    
    public func timeIntervalToTime() -> String {
        let formate = DateTool.shared.dateFormate
        formate.dateFormat = "HH:mm:ss"
        let date = Date(timeIntervalSinceNow: TimeInterval(self))
        return formate.string(from: date)
    }
    
    public func toDateString(with formateString: String = "yyyy-MM-dd") -> String {
        let formate = DateTool.shared.dateFormate
        formate.dateFormat = formateString
        
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        return formate.string(from: date)
    }
    
    public func toDateString(with style: DateStyle) -> String {
        var formateString = "yyyy-MM-dd"
        switch style {
        case .dot:
            formateString = "yyyy.MM.dd"
        case .line:
            formateString = "yyyy-MM-dd"
        }
        
        let formate = DateTool.shared.dateFormate
        formate.dateFormat = formateString
        
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        return formate.string(from: date)
    }
}

public extension Date {
    public func toString(with style: DateStyle) -> String {
        var formateString = "yyyy-MM-dd"
        switch style {
        case .dot:
        formateString = "yyyy.MM.dd"
        case .line:
        formateString = "yyyy-MM-dd"
        }
        
        let formate = DateTool.shared.dateFormate
        formate.dateFormat = formateString
        return formate.string(from: self)
    }

    public func toString(with formateString: String = "yyyy-MM-dd") -> String {
        let formate = DateTool.shared.dateFormate
        formate.dateFormat = formateString
        return formate.string(from: self)
    }
    
    public func serverInterval() -> Int {
        let dateString = toString(with: "yyyy-MM-dd")
        let newDate = dateString.toDate(with: "yyyy-MM-dd")
        return Int(newDate.timeIntervalSince1970)
    }
}
