
import UIKit
import MJRefresh

//public class XMRefreshHeader: MJRefreshHeader {
//    
//    
//    override public func prepare() {
//        super.prepare()
//        self.mj_h = 64
//        addSubview(animationView)
//    }
//    
//    override public func placeSubviews() {
//        super.placeSubviews()
//        animationView.center = CGPoint(x: mj_w/2, y: mj_h/2)
//        animationView.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
//    }
//    
//    override public var state: MJRefreshState {
//        didSet {
//            switch state {
//            case .refreshing:
//                animationView.startAnimating()
//            default:
//                animationView.stopAnimating()
//            }
//        }
//        
//    }
//    override public var pullingPercent: CGFloat {
//        didSet{
//            if oldValue == 1 && pullingPercent <= 0 {
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.animationView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//                })
//            } else {
//                let scale = min(1, pullingPercent)
//                animationView.transform = CGAffineTransform(scaleX: scale, y: scale)
//            }
//        }
//    }
//    
//    lazy var animationView: UIImageView = {
//        let imageview = UIImageView(image: UIImage.bundleImage(named: "pull_loading1"))
//        
//        let images = Array(1...8).compactMap{ UIImage.bundleImage(named: "pull_loading\($0)") }
//        imageview.sizeToFit()
//        imageview.animationImages = images
//        imageview.animationDuration = 0.3
//        imageview.animationRepeatCount = Int.max
//        return imageview
//    }()
//    
//    
//}
