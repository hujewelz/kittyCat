//
//  SwiftlyKitConfig.swift
//  SwiftlyKit
//
//  Created by jewelz on 2017/10/27.
//

import Foundation

public class SwiftlyKitDefaultNaviBarConfig {
    
}

extension SwiftlyKitDefaultNaviBarConfig: SwiftlyKitNaviBarConfig {}

public class SwiftlyKitDefaultBarButtonItemConfig {}

extension SwiftlyKitDefaultBarButtonItemConfig: SwiftlyKitBarButtonItemConfig {}


public protocol SwiftlyKitNaviBarConfig {
    
    var tintColor: UIColor { get }
    
    var barTintColor: UIColor? { get }
    
    var titleTextAttributes: [NSAttributedStringKey: Any]? { get }
    
    var backgroundImage: UIImage? { get }
    
    var shadowImage: UIImage? { get }
    
    var backButtonItemNormalImage: UIImage? { get }
    
    var backButtonItemHighlightedImage: UIImage? { get }
    
     var isTranslucent: Bool { get }
}

public extension SwiftlyKitNaviBarConfig {
    var tintColor: UIColor {
        return UIColor(hexValue: 0x3d4343)
    }
    
    var barTintColor: UIColor? { return nil }
    
    var titleTextAttributes: [NSAttributedStringKey: Any]? {
        return [.font: UIFont.systemFont(ofSize: 17)]
    }
    
    var backgroundImage: UIImage? { return nil }
    
    var shadowImage: UIImage? { return nil }
    
    var backButtonItemNormalImage: UIImage? { return nil }
    
    var backButtonItemHighlightedImage: UIImage? { return nil }
    
    var isTranslucent: Bool { return true }
}

public protocol SwiftlyKitBarButtonItemConfig {
    var normaTextAttributes: [NSAttributedStringKey: Any]? { get }
    
    var highlightedTextAttributes: [NSAttributedStringKey: Any]? { get }
    
    var disableTextAttributes: [NSAttributedStringKey: Any]? { get }
}

public extension SwiftlyKitBarButtonItemConfig {
    var normaTextAttributes: [NSAttributedStringKey: Any]? {
        return [.font: UIFont.systemFont(ofSize: 15)]
    }
    
    var highlightedTextAttributes: [NSAttributedStringKey: Any]? {
        return [.font: UIFont.systemFont(ofSize: 15)]
    }
    
    var disableTextAttributes: [NSAttributedStringKey: Any]? {
        return [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor(hexValue: 0xced2db)]
    }
}
