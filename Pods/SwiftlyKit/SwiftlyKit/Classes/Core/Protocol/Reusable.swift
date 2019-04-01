//
//  Reusable.swift
//  DogSay
//
//  Created by jewelz on 2017/4/28.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit

public protocol Reusable: class {
    
    static var reuseIdentifier: String { get }
    
    static var nib: UINib? { get }
}

public extension Reusable where Self: UIView {
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    public static var nib: UINib? {
        guard let bundlePath = bundlePath() else {
            return nil
        }
        
        let description = String(describing: self)
        let path = bundlePath + "/" + description + ".nib"
        guard FileManager.default.fileExists(atPath: path) else {
            return nil
        }
        
        let nib = UINib(nibName: description, bundle: Bundle(path: bundlePath))
        return nib
    }
    
    private static func bundlePath() -> String? {
        let bundle = Bundle(for: self)
        guard let resourcePath = bundle.resourcePath else {
            return nil
        }
        
        let components = resourcePath.components(separatedBy: ["/", "."])
        if components.last == "framework" {
            return resourcePath + "/" + components[components.count-2] + ".bundle"
        }
        else {
            return resourcePath
        }
    }

}

public extension UITableView {
    
    public func dequeueReusableCell<T: Reusable>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    public func dequeueReusableHeaderFooterView<T: Reusable>() -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T
    }
    
    public func registerCell<T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    public func registerClass<T: Reusable>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    public func registerNib<T: Reusable>(_: T.Type) {
        register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    
    public func registerReusableHeaderFooterView<T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        } else {
            register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }

    
    public func registerReusableHeaderFooterViewClass<T: Reusable>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    public func registerReusableHeaderFooterViewNib<T: Reusable>(_: T.Type) {
        register(T.nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

   
    
   
}

public extension UICollectionView {
    
    public func dequeueReusableCell<T: Reusable>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    public func dequeueReusableHeader<T: Reusable>(for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    public func dequeueReusableFooter<T: Reusable>(for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    public func registerReusableSectionHeader<T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
        } else {
            register(T.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
        }
    }

    
    public func registerReusableSectionFooter<T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier)
        } else {
            register(T.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    public func registerClass<T: Reusable>(_: T.Type) {
        
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    public func registerNib<T: Reusable>(_: T.Type) {
        
        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    public func registerCell<T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        } else {
            register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }
    
}
