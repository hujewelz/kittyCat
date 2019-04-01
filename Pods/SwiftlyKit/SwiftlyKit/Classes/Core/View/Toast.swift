//
//  Toast.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/8/31.
//  Copyright © 2017年 service+. All rights reserved.
//

import UIKit

/// info: 显示内容到 KeyWindow上
public func toast(info: String) {
    Toast.show(info: info)
}

@objc public class Toast: NSObject {
    
    @objc public class func show(info: String) {
        Toast.shared.show(info: info)
    }
    
    // 实例
    static let shared = Toast()
    // 默认字体
    fileprivate var font = UIFont.pingFang(.regular, size: 13)
    // toast 和 window 水平边距
    fileprivate let windowMarginH: CGFloat = 36
    // 内容 和 toast 水平边距
    fileprivate let marginH: CGFloat = 12
    // 内容 和 toast 垂直边距
    fileprivate let marginV: CGFloat = 10
    
    override init() {
        super.init()
        setupView()
    }
    
    private func setupView() {
        toast.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: marginV, left: marginH, bottom: marginV, right: marginH))
        }
    }
    
    // MARK: Util
     @objc private func show(info: String) {
        messageLabel.text = info
        
        guard let window =  UIApplication.shared.keyWindow else { return }
        if window.subviews.contains(toast) { return }
        let maxWidth = ScreenW - windowMarginH * 2 - marginH * 2
        let size = info.contentSize(with: maxWidth, font: self.font)
        let toastSize = CGSize(width: ceil(size.width) + marginH * 2, height: ceil(size.height) + marginV * 2)
        toast.bounds = CGRect(origin: .zero, size: toastSize)
        toast.center = UIApplication.shared.keyWindow!.center
        
        UIApplication.shared.keyWindow?.addSubview(toast)
        toast.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.25, animations: {
            self.toast.alpha = 1
            self.toast.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (finished) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.dismiss()
            })
        }
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.toast.alpha = 0
            self.toast.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }) { (finished) in
            self.toast.removeFromSuperview()
        }
    }
    
    // MRAK: Lazy
    // 背景
    private lazy var toast: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.65)
        view.alpha = 0
        view.cornerRadius = 5
        return view
    }()
    // 内容标签
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = self.font
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
}
