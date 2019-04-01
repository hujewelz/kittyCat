//
//  UIButton+Extension.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/7/13.
//  Copyright © 2017年 service+. All rights reserved.
//

import UIKit

public extension UIButton {
    public func centerImageAndTitle(withSpacing spacing: CGFloat = 6) {
    
        let imageSize = imageView?.size ?? .zero
        let titleSize = titleLabel?.size ?? .zero
        
        let totalHeight = imageSize.height + titleSize.height + spacing
        
        imageEdgeInsets = UIEdgeInsets(top: -(totalHeight-imageSize.height), left: 0, bottom: 0, right: -titleSize.width)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(totalHeight-titleSize.height), right: 0)
        
    }
    
    public convenience init(title: String?, image: UIImage? = nil, selectedImage: UIImage? = nil, textColor: UIColor = UIColor.white, backgroundColor: UIColor = UIColor.white, fontSize: CGFloat = 14) {
        self.init(type: .custom)
        self.backgroundColor = backgroundColor
        titleLabel?.font = UIFont.pingFang(.regular, size: fontSize)
        setTitleColor(textColor, for: .normal)
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        setImage(selectedImage, for: .selected)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
    }
}
