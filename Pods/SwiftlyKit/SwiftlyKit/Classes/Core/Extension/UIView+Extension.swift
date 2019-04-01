//
//  UIView+Extension.swift
//  DogSay
//
//  Created by jewelz on 2017/4/28.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit

public extension UIView {
    
    public var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            let tmp = frame
            frame = CGRect(x: newValue, y: tmp.origin.y, width: tmp.size.width, height: tmp.size.height)
        }
    }
    
    public var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            let tmp = frame
            frame = CGRect(x: tmp.origin.x, y: newValue, width: tmp.size.width, height: tmp.size.height)
        }
    }
    
    public var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            let tmp = frame
            frame = CGRect(x: tmp.origin.x, y: tmp.origin.y, width: tmp.size.width, height: newValue)
        }
    }
    
    public var size: CGSize {
        get {
            return frame.size
        }
        set {
            let tmp = frame
            frame = CGRect(x: tmp.origin.x, y: tmp.origin.y, width: newValue.width, height: newValue.height)
        }
    }
    
    public var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            let tmp = frame
            frame = CGRect(x: tmp.origin.x, y: tmp.origin.y, width: newValue, height: tmp.size.height)
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            
            layer.borderWidth = newValue
            
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
        
    }
    /// 设置视图的圆角 corners: 圆角的位置
    public func roundCorner(_ radius: CGFloat, with corners: UIRectCorner = .allCorners) {
        let radii = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: radii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}

public extension UIView {
    
    public enum ShadowDirection: Int {
        case up, down
    }
    
    @IBInspectable public var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: layer.shadowColor ?? UIColor.black.cgColor)
        }
        set {
            if newValue != nil {
                layer.shadowColor = newValue!.cgColor
                layer.shadowOpacity = 0.04
                layer.shadowRadius = 2
                layer.shadowOffset = CGSize(width: 0, height: -2)
            }
        }
    }
    
    public var shadowDirection: ShadowDirection {
        get {
            return layer.shadowOffset.height < 0 ? .up : .down
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.04
            layer.shadowRadius = 2
            let height = newValue == .up ? -2 : 2
            layer.shadowOffset = CGSize(width: 0, height: height)
        }
    }
    
    @IBInspectable public var shadowHeight: CGFloat {
        get {
            return layer.shadowOffset.height
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.04
            layer.shadowRadius = 2
            layer.shadowOffset = CGSize(width: 0, height: newValue)
        }
    }
    
}
