//
//  UIColor+Extension.swift
//  DogSay
//
//  Created by jewelz on 2017/4/28.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit

extension UIColor {
    /*黑色文字
     hex: #3D434C
     rgb: 61, 67, 77
     */
    class var textBlack: UIColor {
        return UIColor(r: 61, g: 67, b: 77)
    }
    /* 提示黑色文字
     hex: #4A4144
     rgb: 74, 65, 68
     */
    class var tipTextBlack: UIColor {
        return UIColor(hexValue: 0x4A4144)
    }
    /*黑灰色文字
     hex: #515866
     rgb: 81, 88, 102
     */
    class var blackGray: UIColor {
        return UIColor(hexValue: 0x515866)
    }
    /*灰色文字
     hex: #8D97A6
     rgb: 141, 151, 166
     */
    class var textGray: UIColor {
        return UIColor(hexValue: 0x8D97A6)
    }
    /*副标题黑色文字
     hex: #666666
     rgb: 102, 102, 102
     */
    class var subTitleGray: UIColor {
        return UIColor(hexValue: 0x666666)
    }
    /*蓝色按钮 normal
     rgb: 48, 144, 255
     */
    static let buttonBlue = UIColor(r: 48, g: 144, b: 255)
    static let buttonNormalBlueText = UIColor(r: 48, g: 144, b: 255)
    static let buttonNormalBlackText = UIColor(r: 81, g: 88, b: 102)
    
    /// 灰色按钮
    static let buttonDisable = UIColor(r: 206, g: 210, b: 219)
    
    
    class var buttonBlueHelighted: UIColor {
        return UIColor(hexValue: 0x3089DB)
    }
    /*灰色
     hex: #CED2DB
     rgb: 206, 210, 219
     */
    class var ced2dbGray: UIColor {
        return UIColor(hexValue: 0xCED2DB)
    }
    /*背景色
     hex: #F2F4F8
     rgb: 242, 244, 248
     */
    class var backGroundGray: UIColor {
        return UIColor(hexValue: 0xF2F4F8)
    }
    /*分割线颜色
     hex: #DDE2EB
     rgb: 221, 226, 235
     */
    class var separatorColor: UIColor {
        return UIColor(hexValue: 0xDDE2EB)
    }
    
    /* 文字颜色
     hex: #FD7644
     rgb: 253, 118, 68
     */
    class var textRed: UIColor {
        return UIColor(hexValue: 0xFD7644)
    }
    
    /*模板背景灰
     hex: F7F9FC
     rgb: 247, 249, 252
     */
    class var templateGray: UIColor {
        return UIColor(hexValue: 0xF7F9FC)
    }
    
    // 蓝色线颜色
    static let blueLine = UIColor(r: 48, g: 144, b: 255)
    
    // 灰色线颜色
    static let grayLine = UIColor(r: 221, g: 225, b: 235)
    
    // 红色警示
    static let errorRed = UIColor(r: 217, g: 54, b: 54)
    
    static let blue_3090ff = UIColor(r: 48, g: 144, b: 255)
    static let blue_2277dd = UIColor(r: 34, g: 119, b: 221)
    static let blue_78b1e9 = UIColor(r: 120, g: 177, b: 233)
    static let red_ff3030 = UIColor(r: 255, g: 48, b: 48)
    static let red_fd7644 = UIColor(r: 253, g: 118, b: 68)
    static let gray_8d97a6 = UIColor(r: 141, g: 151, b: 166)
    static let gray_ced2db = UIColor(r: 206, g: 210, b: 219)
    static let placeholderColor = UIColor(hexValue: 0xCED2DB)

}

public extension UIColor {
    
    public convenience init(hexValue: Int, alpha: CGFloat = 1) {
        self.init(red  : CGFloat(((hexValue & 0xff0000) >> 16)) / 255.0,
                  green: CGFloat(((hexValue & 0xff00) >> 8))    / 255.0,
                  blue : CGFloat(( hexValue & 0xff))            / 255.0,
                  alpha: alpha)
    }
    
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    public convenience init?(hex: String) {
        
        var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            let index = cString.index(cString.startIndex, offsetBy:1)
            cString = cString.substring(from: index)
        }
        
        if (cString.characters.count != 6) {
            return nil
        }
        
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = cString.substring(to: rIndex)
        let otherString = cString.substring(from: rIndex)
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = otherString.substring(to: gIndex)
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = cString.substring(from: bIndex)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    
}

