//
//  UILabel+Extension.swift
//  HaircutEdu
//
//  Created by like on 2017/6/9.
//  Copyright © 2017年 service+. All rights reserved.
//

import Foundation

public extension UILabel{
    public convenience init(font:UIFont, textColor: UIColor = UIColor.black) {
        self.init()
        self.font = font
        self.textColor = textColor
    }
}
