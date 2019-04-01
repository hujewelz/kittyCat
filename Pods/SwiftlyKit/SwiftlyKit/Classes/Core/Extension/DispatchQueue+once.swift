//
//  DispatchQueue+once.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/6/15.
//  Copyright © 2017年 service+. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once(token: String, execute: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        
        if _onceTracker.contains(token) { return }
        
        _onceTracker.append(token)
        execute()
    }

}
