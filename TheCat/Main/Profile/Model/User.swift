//
//  User.swift
//  DogSay
//
//  Created by jewelz on 2017/4/29.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    
    var id: String?
}

final class AccountManager {
    static let shared = AccountManager()
    
    private init() {}
    
    var id: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "Cat.userid")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "Cat.userid")
        }
    }
}
