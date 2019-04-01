//
//  String+Extension.swift
//  DogSay
//
//  Created by jewelz on 2017/4/28.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit

public extension String {
    
//    var md5: String {
//        let str = self.cString(using: String.Encoding.utf8)
//        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//
//        CC_MD5(str!, strLen, result)
//
//        let hash = NSMutableString()
//        for i in 0..<digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//
//        result.deallocate(capacity: digestLen)
//
//        return String(format: hash as String)
//    }
    
    public func contentSize(with maxWidth: CGFloat, font: UIFont) -> CGSize {
        
        if self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            return CGSize(width: maxWidth, height: 0)
        }
        
        let attribute: [NSAttributedStringKey: Any] = [.font: font]
        return NSString(string: self).boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], attributes: attribute, context: nil).size
    }
    
    public func size(font: UIFont) -> CGSize {
        let attribute: [NSAttributedStringKey: Any] = [.font: font]
        return NSString(string: self).size(withAttributes: attribute)
    }
    
    public func substring(to end: Int) -> String {
        if self.count <= end {
            return self
        }
        let index = self.index(self.startIndex, offsetBy: end)
        return self.substring(to: index)
    }
    
    public func substring(from begin: Int) -> String {
        if self.count <= begin {
            return self
        }
        let offset = begin - count
        let index = self.index(endIndex, offsetBy: offset)
        return self.substring(from: index)
    }
    
    public var isPhoneNumber: Bool {
        
        let mobile = "^\\d{11}$"
//        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$"
//        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
//        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
//        
//        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
//        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
//        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
//        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
//
//        if ((regextestmobile.evaluate(with: self))
//            || (regextestcm.evaluate(with: self))
//            || (regextestct.evaluate(with: self))
//            || (regextestcu.evaluate(with: self))) {
//            
//            return true
//        }
        let reg = NSPredicate(format: "SELF MATCHES %@",mobile)
        return reg.evaluate(with: self)
        
    }
    
    /// 正则匹配用户密码6-18位数字和字母组合
    public var isPassword: Bool {
        let pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}"
        let regextest = NSPredicate(format: "SELF MATCHES %@",pattern)
        return regextest.evaluate(with: self)
    }
    
    /// 正则匹配用户身份证号15或18位
    public var isIdentifier: Bool {
//        let pattern = "^(\\d{14}|\\d{17})(\\d|[xX])$"
//        let regextest = NSPredicate(format: "SELF MATCHES %@",pattern)
        return self.count == 18 // regextest.evaluate(with: self)
    }
    
    /// 正则匹配价格
    public var isPrice: Bool {
        let pattern = "^(0|[0-9]{0,9})(\\.[0-9]{1,2})?$"
        let regextest = NSPredicate(format: "SELF MATCHES %@",pattern)
        return regextest.evaluate(with: self)
    }
    
    /// 是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字
    public func isValid(minLenth: Int, maxLenth: Int, isContainChinese: Bool) -> Bool {
        let hanzi = isContainChinese ? "\\u4e00-\\u9fa5" : ""
        
        let regex = String(format: "[%@A-Za-z0-9_]{%d,%d}", hanzi, minLenth-1, maxLenth-1)
        let regextest = NSPredicate(format: "SELF MATCHES %@",regex)
        return regextest.evaluate(with: self)
    }
    
    
    public var isAbsoluteEmpty: Bool {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).count == 0
            || self.isEmpty
    }
    
    public func convertToClass() -> (AnyClass?){
        guard   let NameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"]as? String else{
            return  nil
        }
        guard  let trueClassName = NSClassFromString(NameSpace + "." + self)else{
            
            return  nil
        }
        return trueClassName
    }
    
    // 中文转拼音
    public func transformChineseToMandarin() -> String {
            let mutableString = NSMutableString(string: self)
            CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
            CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
            return String(mutableString)
    }
    
}

public enum AttributedStyle {
    
    case foreground(UIColor)
    case background(UIColor)
    case font(UIFont)
    case underline
    case strikeThrough
}

public extension String {
    
    public func strikeThrough() -> NSAttributedString {
        let style =  NSNumber(value: Int8(NSUnderlineStyle.styleSingle.rawValue))
        let attribute = [NSAttributedStringKey.strikethroughStyle: style]
        return NSAttributedString(string: self, attributes: attribute)
    }
    
    public func underline() -> NSAttributedString {
        let style =  NSNumber(value: Int8(NSUnderlineStyle.styleSingle.rawValue))
        let attribute = [NSAttributedStringKey.underlineStyle: style]
        return NSAttributedString(string: self, attributes: attribute)
    }
    
    public func attributed(_ styles: AttributedStyle...) -> NSAttributedString {
        var attribute: [NSAttributedStringKey: Any] = [:]
        for style in styles {
            switch style {
            case .foreground(let color):
                attribute[.foregroundColor] = color
            case .background(let color):
                attribute[.backgroundColor] = color
            case .font(let font):
                attribute[.font] = font
            case .underline:
                let line = NSNumber(value: Int8(NSUnderlineStyle.styleSingle.rawValue))
                attribute[NSAttributedStringKey.underlineStyle] = line
            case .strikeThrough:
                let line = NSNumber(value: Int8(NSUnderlineStyle.styleSingle.rawValue))
                attribute[NSAttributedStringKey.strikethroughStyle] = line
            }
        }
        return NSAttributedString(string: self, attributes: attribute)
    }
}
