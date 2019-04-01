//
//  UITabBar+badge.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/8/15.
//  Copyright © 2017年 service+. All rights reserved.
//

import UIKit

public extension UITabBar {
    
    public func showBadgeValue(_ value: Int, at index: Int) {
        removeBadge(at: index)
        if value <= 0 { return }
        
        var total = 3
        if let tabBarVc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            total = tabBarVc.viewControllers?.count ?? 3
        }
        
        let label = UILabel()
        label.text = "\(value)"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.backgroundColor = UIColor(r: 253, g: 118, b: 68)
        label.cornerRadius = 8
        label.tag = 999 + index
        
        let itemW: CGFloat = frame.width / CGFloat(total)
        let x = ceil(itemW * CGFloat(index)) - itemW / 2.0 + 4
        label.frame = CGRect(x: x, y: 2, width: 16, height: 16)
        addSubview(label)
    }
    
    public func showBadge(at index: Int) {
        removeBadge(at: index)
        
        var total = 3
        if let tabBarVc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            total = tabBarVc.viewControllers?.count ?? 3
        }
        
        let view = UIView()
        view.backgroundColor = UIColor.red_fd7644
        view.cornerRadius = 4
        view.tag = 999 + index
        
        let itemW: CGFloat = frame.width / CGFloat(total)
        let x = ceil(itemW * CGFloat(index)) - itemW / 2.0 + 6
        view.frame = CGRect(x: x, y: 3, width: 8, height: 8)
        addSubview(view)
    }
    
    public func removeBadge(at index: Int) {
        for view in subviews where view.tag == 999 + index {
            view.removeFromSuperview()
        }
    }
}

//extension UITabBarItem {
//    func showBadgeValue(_ value: Int) {
//        removeBadge()
//        if value <= 0 { return }
//
//        let label = UILabel()
//        label.text = "\(value)"
//        label.textColor = UIColor.white
//        label.font = UIFont.systemFont(ofSize: 13)
//        label.textAlignment = .center
//        label.backgroundColor = UIColor(r: 253, g: 118, b: 68)
//        label.cornerRadius = 8
//        label.tag = 999
//
//        let percentX: CGFloat = (CGFloat(index) + 0.6) / 3.0
//        let x = ceil(percentX * frame.width)
//        label.frame = CGRect(x: 8, y: 8, width: 16, height: 16)
//        addSubview(label)
//    }
//
//    func removeBadge() {
//        for view in subviews where view.tag == 999 {
//            view.removeFromSuperview()
//        }
//    }
//}

