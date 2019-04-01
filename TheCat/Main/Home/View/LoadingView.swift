//
//  LoadingView.swift
//  Loading
//
//  Created by huluobo on 2018/11/8.
//  Copyright © 2018 jewelz. All rights reserved.
//

import UIKit
import SwiftlyKit

class CatLoadingView: UIView, LoadingViewType {
    
    var isAnimating: Bool = false
    
    var reloadData: (() -> Void)?
    
    var isError: Bool = false {
        didSet {
            errorView.isHidden = !isError
            activityIndicator.isHidden = isError
            if !isError { activityIndicator.startAnimating() }
        }
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView(style: .whiteLarge)
        act.hidesWhenStopped = true
        return act
    }()
    
    lazy var errorView = UIImageView(image: UIImage(named: "placeholder"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        errorView.center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
    }
    
    func startAnimating() {
        isError = false
        if isAnimating { return }
        alpha = 1
        isAnimating = true
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        isAnimating = false
        
        activityIndicator.stopAnimating()
        
        if isError { return }
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        })
    }
    
    private func setupView() {
        backgroundColor = UIColor.black

        addSubview(activityIndicator)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView(_:)))
        errorView.addGestureRecognizer(tap)
        errorView.isUserInteractionEnabled = true
        addSubview(errorView)
    }
    
    @objc private func tapImageView(_ sender: UIGestureRecognizer) {
        guard sender.state == .ended else { return }
        isError = false
        reloadData?()
    }
    
}

