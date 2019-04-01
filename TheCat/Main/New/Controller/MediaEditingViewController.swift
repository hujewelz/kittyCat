//
//  MediaEditingViewController.swift
//  DogSay
//
//  Created by jewelz on 2017/5/3.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit
import SnapKit
import Photos
import SwiftlyKit

class ProgressView: UIView {
    private let Duration: CFTimeInterval = 3
    private let LineWidth: CGFloat = 3
    private var CircleWidth: CGFloat = 100
    
    private lazy var loadingLayer: CAShapeLayer = { [unowned self] in
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = CGRect(x: 0, y: 0, width: self.CircleWidth, height: self.CircleWidth)
        print(self.layer.position)
        shapeLayer.position = self.layer.position//CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.lineWidth = self.LineWidth
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 0
        return shapeLayer
    }()
    
    private lazy var circlePath: UIBezierPath = {
        let center = CGPoint(x: self.CircleWidth / 2 , y: self.CircleWidth / 2)
        let radius = self.CircleWidth / 2 - self.LineWidth
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat(Float.pi/2), endAngle: CGFloat(1.5 * Float.pi), clockwise: true)
        return path
    }()
    
    var percent: CGFloat = 0 {
        
        didSet {
            print(percent)
            loadingLayer.strokeEnd = percent
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        
        layer.addSublayer(loadingLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CircleWidth = min(min(frame.width, frame.height), 100)
        loadingLayer.bounds = CGRect(x: 0, y: 0, width: CircleWidth, height: CircleWidth)
        loadingLayer.position = self.layer.position//CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        loadingLayer.path = circlePath.cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MediaEditingViewController: UIViewController {
    
    var asset: PHAsset!
    
    private var imageView: UIImageView!
    
    private var progressView: ProgressView!
    
    private var imageRequestID: PHImageRequestID?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(MediaEditingViewController.confirmButtonClicked))
        
        setupView()
        getPhoto(in: asset)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let id = imageRequestID {
            PHImageManager.default().cancelImageRequest(id)
        }

    }

    private func setupView() {
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(imageView.superview!)
           // make.top.equalTo(64)
            //make.height.equalTo(imageView.superview!).multipliedBy(0.45)
        }
        
        progressView = ProgressView()
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(progressView.superview!)
        }
        
        print(view.subviews)
        
    }
    
    @objc func confirmButtonClicked() {
        
        let vc = PublishViewController()
//        vc.image = imageView.image!
//        present(MainNavigationController(rootViewController: vc), animated: false, completion: nil)
    }

    private func getPhoto(in asset: PHAsset) {
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        options.deliveryMode = .opportunistic
        options.progressHandler = { percent, _, _, info in
        
            DispatchQueue.main.sync {
                self.progressView.isHidden = percent >= 1.0
                self.progressView.percent = CGFloat(percent)
            }
        
        }

        let targetSize = CGSize(width: asset.pixelWidth*2, height:asset.pixelHeight*2)

        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .default, options: options, resultHandler: { image, info in
           
            guard  let image = image, let info = info else { return }
            print("image: \(image)\ninof: \(info)")
            self.imageRequestID = info["PHImageResultRequestIDKey"] as! PHImageRequestID?
//            if (info["PHImageResultIsDegradedKey"] as? Bool)! && self.imageView.image != nil {
//                return
//            }
            
            self.imageView.image = image
            self.progressView.isHidden = true
            
        })
        
        
    }

    

}
