//
//  NSObject+Swizzling.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/6/15.
//  Copyright © 2017年 service+. All rights reserved.
//

import Foundation

public extension NSObject {
    
    public static func exchangeSelector(_ original: Selector, by newSelector: Selector) {
        
        guard let originalMethod = class_getInstanceMethod(self, original),
            let newMethod = class_getInstanceMethod(self, newSelector)else { return }
        
        
        //先尝试給源SEL添加IMP，这里是为了避免源SEL没有实现IMP的情况
        let didAddMethod = class_addMethod(self, original, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))
        
        // 添加成功：说明源SEL没有实现IMP，将源SEL的IMP替换到交换SEL的IMP
        if didAddMethod {
            class_replaceMethod(self, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            
        } else { //添加失败：说明源SEL已经有IMP，直接将两个SEL的IMP交换即可
            method_exchangeImplementations(originalMethod, newMethod)
        }
    }
    
}
