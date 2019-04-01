//
//  SWTextField.swift
//  XiaoMei
//
//  Created by like on 2017/12/28.
//

import UIKit

public class SWTextField: UITextField {
    
    /// 占位符位置
    public var placeholderRect: CGRect?
    
    /// 文本内容内间距
    public var contentInset: UIEdgeInsets = .zero
    
    ///编辑区域内容内间距, 默认和 文本内容内间距相同
    public var editingContentInset: UIEdgeInsets = .zero
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if placeholderRect != nil {
            return placeholderRect!
        } else {
            return super.placeholderRect(forBounds: bounds)
        }
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(x: bounds.origin.x + contentInset.left, y: bounds.origin.y + contentInset.top, width: bounds.size.width - contentInset.left - contentInset.right, height: bounds.size.height - contentInset.top - contentInset.bottom)
        return rect
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var inset = editingContentInset
        if inset == .zero {
            inset = contentInset
        }
        let rect = CGRect(x: bounds.origin.x + inset.left, y: bounds.origin.y + inset.top, width: bounds.size.width - inset.left - inset.right, height: bounds.size.height - inset.top - inset.bottom)
        return rect
    }
    
}
