
import UIKit

public protocol EmptyViewType {}

public extension EmptyViewType where Self: UIView {}

fileprivate let token: String = "EmptyViewTypeSwizzling"
fileprivate var key: Void?

public extension UITableView {
    
    public var emptyView: EmptyViewType? {
        get {
            return objc_getAssociatedObject(self, &key) as? EmptyViewType
        }
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            backgroundView = newValue as? UIView
            backgroundView?.isHidden = true
        }
    }
    
    public static func initialized() {
        // 必须添加 dispatch_once, 防止多次 swizzling, 导致递归调用
        DispatchQueue.once(token: token) {
            exchangeSelector(#selector(UITableView.reloadData), by: #selector(UITableView.swizzling_reloadData))
        }
    }
    
    @objc func swizzling_reloadData() {
        checkEmpty()
        swizzling_reloadData()
    }
    
    func checkEmpty() {
        var isEmpty = true
        defer {
            backgroundView?.isHidden = !isEmpty
        }
        guard let dataSource = dataSource else { return }
        
        let numberOfSections = dataSource.numberOfSections?(in: self) ?? 1
        (0..<numberOfSections).forEach {
            let numberOfRow = dataSource.tableView(self, numberOfRowsInSection: $0)
            if numberOfRow > 0 { isEmpty = false }
        }
    }
}

public extension UICollectionView {
    public var emptyView: EmptyViewType? {
        get {
            return objc_getAssociatedObject(self, &key) as? EmptyViewType
        }
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            backgroundView = newValue as? UIView
            backgroundView?.isHidden = true
        }
    }
    
    public static func initialized() {
        // 必须添加 dispatch_once, 防止多次 swizzling, 导致递归调用
        DispatchQueue.once(token: token) {
            exchangeSelector(#selector(UICollectionView.reloadData), by: #selector(UICollectionView.swizzling_reloadData))
        }
    }
    
    @objc func swizzling_reloadData() {
        checkEmpty()
        swizzling_reloadData()
    }
    
    func checkEmpty() {
        var isEmpty = true
        defer {
            backgroundView?.isHidden = !isEmpty
        }
        guard let dataSource = dataSource else { return }
        
        let numberOfSections = dataSource.numberOfSections?(in: self) ?? 1
        (0..<numberOfSections).forEach {
            let numberOfItems = dataSource.collectionView(self, numberOfItemsInSection: $0)
            if numberOfItems > 0 { isEmpty = false }
        }
    }
}

