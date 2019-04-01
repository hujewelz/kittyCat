//
//  HEBaseNavigationController.swift
//  HaircutEdu
//
//  Created by huluobobo on 10/26/2017.
//  Copyright (c) 2017 huluobobo. All rights reserved.
//

import UIKit

fileprivate let DefaultAlpha: CGFloat = 0.6
fileprivate let TargetTranslateScale: CGFloat = 0.75

@objc public protocol CustomNavigationBack   {
    @objc func naviBack()
}

open class BaseNavigationController: UINavigationController {
    
    @IBInspectable public var isScreenEdgePanGestureEnable: Bool = true
    
    fileprivate lazy var screenshotImageView = UIImageView()
    fileprivate lazy var cover = UIView()
    
    fileprivate lazy var screenshots: [UIImage] = []
    
    fileprivate var panGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    
    override open var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: SwiftlyKit.bundle)
    }
    
    public init(rootViewController: UIViewController, isScreenEdgePanGestureEnable: Bool = false) {
        self.isScreenEdgePanGestureEnable = isScreenEdgePanGestureEnable
        super.init(rootViewController: rootViewController)
        
        panGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(BaseNavigationController.panGestureHandler(_:)))
        panGestureRecognizer?.isEnabled = isScreenEdgePanGestureEnable
        if isScreenEdgePanGestureEnable {
            interactivePopGestureRecognizer?.delegate = nil
        } else {
            interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        if panGestureRecognizer == nil {
            panGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(BaseNavigationController.panGestureHandler(_:)))
        }
        
        panGestureRecognizer?.edges = .left
        panGestureRecognizer?.isEnabled = isScreenEdgePanGestureEnable
        if isScreenEdgePanGestureEnable {
            interactivePopGestureRecognizer?.delegate = nil
        } else {
            interactivePopGestureRecognizer?.delegate = self
        }
        if panGestureRecognizer != nil {
            view.addGestureRecognizer(panGestureRecognizer!)
        }
        
        screenshotImageView.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH)
        cover.frame = screenshotImageView.bounds
        cover.backgroundColor = UIColor.black
        
        navigationBar.tintColor = SwiftlyKit.shared.naviBarConfig.tintColor
        navigationBar.barTintColor = SwiftlyKit.shared.naviBarConfig.barTintColor
        navigationBar.setBackgroundImage(SwiftlyKit.shared.naviBarConfig.backgroundImage, for: UIBarMetrics.default)
        navigationBar.shadowImage = SwiftlyKit.shared.naviBarConfig.shadowImage
        navigationBar.titleTextAttributes = SwiftlyKit.shared.naviBarConfig.titleTextAttributes
        navigationBar.isTranslucent = SwiftlyKit.shared.naviBarConfig.isTranslucent
        
        
        UIBarButtonItem.appearance().setTitleTextAttributes(SwiftlyKit.shared.barButtonItemConfig.normaTextAttributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(SwiftlyKit.shared.barButtonItemConfig.highlightedTextAttributes, for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes(SwiftlyKit.shared.barButtonItemConfig.disableTextAttributes, for: .disabled)
    }
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            var backNormalImage = SwiftlyKit.shared.naviBarConfig.backButtonItemNormalImage
            if backNormalImage == nil {
                backNormalImage = UIImage.bundleImage(named: "go_back_normal")
            }
            var backHImage = SwiftlyKit.shared.naviBarConfig.backButtonItemHighlightedImage
            if backHImage == nil {
                backHImage = backNormalImage
            }
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(left: backNormalImage, highlighted: backHImage, target: self, action: #selector(BaseNavigationController.navBack))
        }
        if viewControllers.count >= 1 && isScreenEdgePanGestureEnable {
            screenshot()
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override open func popViewController(animated: Bool) -> UIViewController? {
        let _ = screenshots.popLast()
        return super.popViewController(animated: animated)
    }
    
    override open func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        for VC in viewControllers {
            if VC == viewController { break }
            let _ = screenshots.popLast()
        }
        return super.popToViewController(viewController, animated: animated)
    }
    
    override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
        screenshots.removeAll()
        return super.popToRootViewController(animated: animated)
    }
    
    @objc private func panGestureHandler(_ sender: UIPanGestureRecognizer) {
        if !isScreenEdgePanGestureEnable { return }
        if viewControllers.count <= 1 { return }
        switch sender.state {
        case .began:
            dragBegin()
        case .ended, .cancelled:
            dragEnd()
        case .changed:
            drayChanged(sender)
        default:
            break
        }
    }
    
    private func dragBegin() {
        view.window?.insertSubview(screenshotImageView, at: 0)
        view.window?.insertSubview(cover, aboveSubview: screenshotImageView)
        
        screenshotImageView.image = screenshots.last
    }
    
    private func dragEnd() {
        let translateX = view.transform.tx;
        let width = view.frame.size.width
        
        if translateX <= ScreenW * 0.5 {
            // 如果手指移动的距离还不到屏幕的一半,往左边挪 (弹回)
            UIView.animate(withDuration: 0.25, animations: {
                self.view.transform = CGAffineTransform.identity
                self.screenshotImageView.transform = CGAffineTransform(translationX: -ScreenW, y: 0)
                self.cover.alpha = 0
            }, completion: { fihished in
                self.screenshotImageView.removeFromSuperview()
                self.cover.removeFromSuperview()
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.transform = CGAffineTransform(translationX: width, y: 0)
                self.screenshotImageView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.cover.alpha = 0
            }, completion: { fihished in
                self.view.transform = CGAffineTransform.identity
                self.screenshotImageView.removeFromSuperview()
                self.cover.removeFromSuperview()
                let _ = self.popViewController(animated: false)
            })
        }
    }
    
    private func drayChanged(_ gestureRecognizer: UIPanGestureRecognizer) {
        let offsetX = gestureRecognizer.translation(in: view).x
        
        if offsetX > 0 {
            self.view.transform = CGAffineTransform(translationX: offsetX, y: 0)
        }
        
        // 计算目前手指拖动位移占屏幕总的宽高的比例,当这个比例达到3/4时, 就让imageview完全显示，遮盖完全消失
        let currentTranslateScaleX = offsetX / view.frame.size.width;
        if offsetX < ScreenW {
            screenshotImageView.transform = CGAffineTransform(translationX: (offsetX - ScreenW) * 0.6, y: 0)
        }
        
        // 让遮盖透明度改变,直到减为0,让遮罩完全透明,默认的比例-(当前平衡比例/目标平衡比例)*默认的比例
        let alpha = DefaultAlpha - (currentTranslateScaleX / TargetTranslateScale) * DefaultAlpha
        cover.alpha = alpha
        
    }
    
    private func screenshot() {
        guard let beyondVC = view.window?.rootViewController else { return }
        let size = beyondVC.view.frame.size
        let rect = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH)
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        beyondVC.view.drawHierarchy(in: rect, afterScreenUpdates: false)
        if let snapshot = UIGraphicsGetImageFromCurrentImageContext() {
            screenshots.append(snapshot)
        }
        
        UIGraphicsEndImageContext()
    }
    
    @objc func navBack() {
        
        topViewController?.view.endEditing(true)
        
        guard let topVc = topViewController as? CustomNavigationBack else {
            let _ = popViewController(animated: true)
            return
        }
        
        topVc.naviBack()
    }
    
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

