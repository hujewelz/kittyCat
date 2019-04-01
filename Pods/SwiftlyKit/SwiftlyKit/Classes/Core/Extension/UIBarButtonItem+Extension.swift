//
//  UIBarButtonItem+Extension.swift
//  DogSay
//
//  Created by jewelz on 2017/4/28.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    
    public convenience init(left image: UIImage?, highlighted: UIImage?, target: Any?, action: Selector?) {
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        button.setImage(image, for: .normal)
        button.setImage(highlighted, for: .highlighted)
        button.contentHorizontalAlignment = .left
        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        self.init(customView: button)
        
    }
    
    public convenience init(right image: UIImage?, highlighted: UIImage?, target: Any?, action: Selector?) {
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        button.setImage(image, for: .normal)
        button.setImage(highlighted, for: .highlighted)
        button.contentHorizontalAlignment = .right
        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        self.init(customView: button)
        
    }
    
}
