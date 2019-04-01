//
//  UIFont+Extension.swift
//  HaircutEdu
//
//  Created by like on 2017/5/22.
//  Copyright © 2017年 胡不归是大虾. All rights reserved.
//

import Foundation

public extension UIFont {
    class func untNavigationBarTitleZhFont() -> UIFont? {
        return UIFont(name: "PingFangSC-Medium", size: 36.0)
    }
    
   public enum Blod {
        case regular
        case medium
        case light
        case semibold
        case thin
    }
    
    public class func pingFang(_ blod: UIFont.Blod, size: CGFloat) -> UIFont {
        var font: UIFont?
        switch blod {
        case .regular:
            font = UIFont(name: "PingFangSC-Regular", size: size)
        case .medium:
            font = UIFont(name: "PingFangSC-Medium", size: size)
        case .light:
            font = UIFont(name: "PingFangSC-Light", size: size)
        case .semibold:
            font = UIFont(name: "PingFangSC-Semibold", size: size)
        case .thin:
            font = UIFont(name: "PingFangSC-Thin", size: size)
        }
        
        guard let result = font else {
            return UIFont.systemFont(ofSize: size)
        }
        
        return result
    }
}
