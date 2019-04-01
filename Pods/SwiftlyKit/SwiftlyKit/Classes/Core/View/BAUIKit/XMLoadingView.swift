
import Foundation
import SnapKit

// SWKit && BAUIKit
public class XMLoadingView: DefaultLoadingView {
    
    public var reloadHandler: (() -> Void)?
    
    public init() {
        let images = Array(1...8).flatMap{ UIImage.bundleImage(named: "loading\($0)") }
        super.init(animationImages: images, duration: 1)
        update()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func update() {
        backgroundColor = UIColor(hexValue: 0xF8F7FC)
        errorView = myErrorView
        addSubview(errorView!)
        errorView?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-64)
        })
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reloadData)))
    }
    
    @objc private func reloadData() {
        reloadHandler?()
    }
    
    lazy var myErrorView: UIView = {
        let view = UIView()
        
        let noInternetImage = UIImageView(image: UIImage.bundleImage(named: "nodata_internet_icon"))
        view.addSubview(noInternetImage)
        noInternetImage.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        let noInternetText = UILabel(font: UIFont.pingFang(.medium, size: 16), textColor: UIColor(hexValue: 0x878794))
        noInternetText.text = "您与世界失去了联系"
        view.addSubview(noInternetText)
        noInternetText.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(noInternetImage).offset(-6)
        }
        
        let reloadTipText = UILabel(font: UIFont.pingFang(.regular, size: 14), textColor: UIColor(hexValue: 0xa9a9b8))
        reloadTipText.text = "点击空白刷新"
        
        view.addSubview(reloadTipText)
        reloadTipText.snp.makeConstraints { (make) in
            make.top.equalTo(noInternetImage.snp.bottom)
            make.bottom.centerX.equalToSuperview()
        }
        return view
    }()
}
