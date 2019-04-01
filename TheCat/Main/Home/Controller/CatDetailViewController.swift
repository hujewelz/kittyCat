//
//  CatDetailViewController.swift
//  TheCat
//
//  Created by huluobo on 2019/3/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

import UIKit
import SVProgressHUD

class CatDetailViewController: UIViewController {

    @IBOutlet weak var catView: UIImageView!
    @IBOutlet weak var favouriteIcon: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var catImage: Cat.Image
    var rectOfImageView: CGRect
    
    override var prefersStatusBarHidden: Bool { return true }
    
    init(catImage: Cat.Image, rect: CGRect) {
        self.catImage = catImage
        rectOfImageView = rect
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favouriteIcon.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        favouriteIcon.alpha = 0
        catView.setImage(with: catImage.url)
        catView.isUserInteractionEnabled = true
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(_dismiss(_:)))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(saveCatAsFavourite(_:)))
        tap.require(toFail: doubleTap)
        catView.addGestureRecognizer(tap)
//        CatService.catDetail(with: catImage.id) { _ in
//
//        }
    }

    @IBAction private func _dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func saveImage() {
        guard let image = catView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction private func favourite(_ sender: UIButton) {
        if sender.isSelected { return }
        sender.isSelected = !sender.isSelected
        favoriteWithAnimation()
    }
    
    @IBAction private func feedback() {
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "举报", style: .destructive) { _ in
            self.feedbackHandler()
        }
        let action2 = UIAlertAction(title: "减少出现频次", style: .destructive) { _ in
            self.feedbackHandler()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { _ in
            actionsheet.dismiss(animated: true, completion: nil)
        }
        actionsheet.addAction(action1)
        actionsheet.addAction(action2)
        actionsheet.addAction(cancel)
        present(actionsheet, animated: true, completion: nil)
    }
    
    @objc private func saveCatAsFavourite(_ sender: UIGestureRecognizer) {
        guard sender.state == .ended else { return }
        if !favouriteButton.isSelected { favouriteButton.isSelected = true }
        favoriteWithAnimation()
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo info: UnsafeMutableRawPointer?) {
        guard error == nil else {
            SVProgressHUD.showError(withStatus: "保存失败")
            return
        }
        SVProgressHUD.showSuccess(withStatus: "保存成功")
    }
    
    private func favoriteWithAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.favouriteIcon.alpha = 1
            self.favouriteIcon.transform = CGAffineTransform.identity
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.favouriteIcon.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.favouriteIcon.alpha = 0
            })
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.favouriteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.favouriteButton.transform = CGAffineTransform.identity
            })
        }
        
        if favouriteButton.isSelected { return }
        CatService.saveAsFavourite(image: catImage.id) { success in }
    }
    
    private func feedbackHandler() {
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            SVProgressHUD.showSuccess(withStatus: "提交成功")
        }
    }
}

extension CatDetailViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = CatTransitioningAnimator(style: .presented)
        animator.initialRect = rectOfImageView
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = CatTransitioningAnimator(style: .dismissed)
        animator.endRect = rectOfImageView
        return animator
    }
}

final class CatTransitioningAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    enum Style {
        case presented, dismissed
    }
    
    let style: Style
    var initialRect = CGRect.zero
    var endRect = CGRect.zero
    
    init(style: Style) {
        self.style = style
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch style {
        case .presented:
            presentAnimateTransition(using: transitionContext)
        case .dismissed:
            dismissAnimateTransition(using: transitionContext)
        }
    }
    
    private func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let to = transitionContext.viewController(forKey: .to), let detail = to as? CatDetailViewController else { return }
        
        detail.catView.frame = initialRect
        detail.view.backgroundColor = UIColor(white: 0, alpha: 0)
        detail.view.frame = UIScreen.main.bounds
        containerView.addSubview(detail.view)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            detail.view.backgroundColor = UIColor(white: 0, alpha: 1)
            let y = (UIScreen.main.bounds.height - self.initialRect.height) * 0.5
            detail.catView.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: self.initialRect.height)
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func dismissAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let from = transitionContext.viewController(forKey: .from),
            let detail = from as? CatDetailViewController else { return }
        
        detail.view.isHidden = true
        let bg = UIView(frame: UIScreen.main.bounds)
        bg.backgroundColor = UIColor.black
        let imageView = UIImageView(frame: detail.catView.frame)
        imageView.contentMode = .scaleAspectFit
        imageView.image = detail.catView.image
        containerView.addSubview(bg)
        containerView.addSubview(imageView)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            bg.alpha = 0
            imageView.frame = self.endRect
        }) { _ in
            detail.view.removeFromSuperview()
            bg.removeFromSuperview()
            imageView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
