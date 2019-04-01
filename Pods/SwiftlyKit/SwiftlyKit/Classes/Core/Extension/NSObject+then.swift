//
//  NSObject+then.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/7/19.
//  Copyright © 2017年 service+. All rights reserved.
//

import Foundation

public protocol Then {}

public extension Then where Self: AnyObject {
    
    func then(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: Then {}
