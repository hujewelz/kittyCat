//
//  UITextField+Extension.swift
//  HaircutEdu
//
//  Created by like on 2017/5/26.
//  Copyright © 2017年 service+. All rights reserved.
//

import Foundation

public extension UITextField {
    
    @IBInspectable public var placeHolderColor: UIColor {
        get{
            return attributedPlaceholder?.value(forKey: NSAttributedStringKey.foregroundColor.rawValue) as! UIColor
        }
        set{
            let str = NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor: newValue])
            attributedPlaceholder = str
        }
    }
}
