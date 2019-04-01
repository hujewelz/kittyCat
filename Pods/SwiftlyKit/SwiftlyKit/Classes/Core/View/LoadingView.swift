//
//  LoadingView.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/6/2.
//  Copyright © 2017年 service+. All rights reserved.
//

import UIKit
import SnapKit

open class DefaultLoadingView: UIView, LoadingViewType {

    public var isAnimating: Bool = false
    
    public var isError: Bool = false {
        didSet {
            errorView?.isHidden = !isError
            if !isError {
                let isShow = imageView.animationImages != nil || imageView.image != nil
                imageView.isHidden = !isShow
                activityIndicator.isHidden = !imageView.isHidden
            } else {
                imageView.isHidden = isError
                activityIndicator.isHidden = isError
            }
        }
    }
    
    public lazy var activityIndicator: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        act.hidesWhenStopped = true
        return act
    }()
    
    public lazy var imageView: UIImageView = {
        let imageV = UIImageView()
        imageV.isHidden = true
        return imageV
    }()
    
    open var errorView: UIView?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public init(with image: UIImage?) {
        super.init(frame: ScreenRect)
        imageView.image = image
        imageView.isHidden = image == nil
        activityIndicator.isHidden = !imageView.isHidden
        setupView()
    }
    
    public init(animationImages: [UIImage]?, duration: TimeInterval) {
        super.init(frame: ScreenRect)
        imageView.animationImages = animationImages
        imageView.animationRepeatCount = Int.max
        imageView.animationDuration = duration
        imageView.isHidden = animationImages == nil
        activityIndicator.isHidden = !imageView.isHidden
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func startAnimating() {
        isError = false
        if isAnimating {
            return
        }
        alpha = 1
        isAnimating = true
        if !imageView.isHidden, !imageView.isAnimating {
            imageView.startAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
    
    open func stopAnimating() {
        if !isAnimating {
            return
        }
        isAnimating = false
        if !imageView.isHidden, imageView.isAnimating {
            imageView.stopAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        if isError { return }
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        })
    }
    
    private func setupView() {
        backgroundColor = UIColor.white
        
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        guard let errorView = errorView else {
            return
        }
        
        addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            //make.width.height.equalTo(100)
        }
    }

}


