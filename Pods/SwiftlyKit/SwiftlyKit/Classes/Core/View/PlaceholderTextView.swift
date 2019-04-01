//
//  PlaceholderTextView.swift
//  DogSay
//
//  Created by jewelz on 2017/5/4.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit

public class PlaceholderTextView: UITextView {

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PlaceholderTextView.textDidChange), name: Notification.Name.UITextViewTextDidChange, object: nil)
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(PlaceholderTextView.textDidChange), name: Notification.Name.UITextViewTextDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
  @IBInspectable public var placeholder: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var placeholderColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var text: String! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func draw(_ rect: CGRect) {
        
        guard let placeholder = placeholder else {
            return
        }
        
        if hasText {
            return
        }
        
        
        var attribute = [NSAttributedStringKey: Any]()
        attribute[.foregroundColor] = placeholderColor ?? UIColor(red: 206/255, green: 210/255, blue: 219/255, alpha: 1)
        
        if font != nil {
            attribute[.font] = font!
        }
        
        let rect = CGRect(x: textContainerInset
            .left + contentInset.left + 3, y: textContainerInset.top + contentInset.left, width: bounds.size.width, height: bounds.size.height)
        NSString(string: placeholder).draw(in: rect, withAttributes: attribute)
        
    }
    
    @objc func textDidChange() {
        setNeedsDisplay()
    }
    
}
