//
//  Const.swift
//  SwiftlyKit
//
//  Created by jewelz on 2017/10/26.
//

import Foundation

public class SwiftlyKit {
    public typealias TableViewDelegate = UITableViewDelegate & UITableViewDataSource
    
    public static let shared = SwiftlyKit()
    
    private init() {}
    
    /// Default Navigation Bar Config
    
    public let defaultNaviBarConfig = SwiftlyKitDefaultNaviBarConfig()
    
    /// Default Bar button item Config
    
    public let defaultBarButtonItemConfig = SwiftlyKitDefaultBarButtonItemConfig()

    
    var naviBarConfig: SwiftlyKitNaviBarConfig = SwiftlyKitDefaultNaviBarConfig()
    
    var barButtonItemConfig: SwiftlyKitBarButtonItemConfig = SwiftlyKitDefaultBarButtonItemConfig()
    
    /// The bundle of SwiftlyKit
    public static var bundle: Bundle? {
        let podBundle = Bundle(for: SwiftlyKit.self)
        guard let bundleURL = podBundle.url(forResource: "SwiftlyKit", withExtension: "bundle") else { return nil }
        return Bundle(url: bundleURL)
    }
    
    /// Set custom Navigatio Bar config
    /// - parameter config: the custom config
    
    public func setNaviBarConfig<T: SwiftlyKitNaviBarConfig>(_ config: T) {
        naviBarConfig = config
    }
    
    /// Set custom Bar button item config
    /// - parameter config: the custom config
    
    public func setBarButtonItemConfig<T: SwiftlyKitBarButtonItemConfig>(_ config: T) {
        barButtonItemConfig = config
    }
}


