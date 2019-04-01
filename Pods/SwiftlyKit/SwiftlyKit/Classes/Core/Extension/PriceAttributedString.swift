//
//  PriceAttributedString.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/9/21.
//  Copyright © 2017年 service+. All rights reserved.
//

import Foundation

public extension Float {
    public func priceAttributedString(size: CGFloat = 14) -> NSAttributedString {
        let priceString = String(format: "￥%.02f", self)
        let smallFontAttr = [NSAttributedStringKey.font: UIFont.pingFang(.regular, size: size)]
        let mutableAttrStr = NSMutableAttributedString(string: priceString)
        let range = NSRange(location: priceString.count-3, length: 3)
        mutableAttrStr.addAttributes(smallFontAttr, range: range)
        return mutableAttrStr
    }
}

public extension Double {
    public func priceAttributedString(size: CGFloat = 14) -> NSAttributedString {
        let priceString = String(format: "￥%.02f", self)
        let smallFontAttr = [NSAttributedStringKey.font: UIFont.pingFang(.regular, size: size)]
        let mutableAttrStr = NSMutableAttributedString(string: priceString)
        let range = NSRange(location: priceString.count-3, length: 3)
        mutableAttrStr.addAttributes(smallFontAttr, range: range)
        return mutableAttrStr
    }
}
