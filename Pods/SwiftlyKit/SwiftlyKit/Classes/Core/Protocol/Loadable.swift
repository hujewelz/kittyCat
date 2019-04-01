//
//  Loadable.swift
//  SWKit
//
//  Created by huluobo on 2017/11/5.
//

import Foundation
import Hotaru

public protocol LoadingViewType: class {
    
    var isAnimating: Bool { get set }
    
    var isError: Bool { get set }
    
    func startAnimating()
    
    func stopAnimating()
}

public extension LoadingViewType where Self: UIView {
    
    var isError: Bool { return false }
    
    func startAnimating() {
        isAnimating = true
    }
    
    func stopAnimating() {
        isAnimating = false
    }
}

public protocol Loadable: class {
    associatedtype LoadingView: UIView, LoadingViewType
    
    /// The loading view
    var loadingView: LoadingView { get }
    
    /// The presenter
    var presenter: UIView? { get set }
    
    func loadData()
}

var loadingViewKey: Void?
var shouldLoadingKey: Void?

public extension Loadable where Self: UIViewController {
    public var loadingView: DefaultLoadingView {
        if let view = objc_getAssociatedObject(self, &loadingViewKey) as? DefaultLoadingView {
            return view
        } else {
            let view = DefaultLoadingView()
            objc_setAssociatedObject(self, &loadingViewKey, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return view
        }
    }
    
    public var presenter: UIView? {
        get { return self.view }
        set {}
    }
    // TODO: shouldShowLoading 已经成为无用参数, 介于影响较大, 后期有时间再改.
    public func load<T, R>(with resource: Resource<T, R>, shouldShowLoading: Bool = false, completion: ((R?) -> Void)?) {
        if objc_getAssociatedObject(self, &shouldLoadingKey) as? Bool == nil {
            objc_setAssociatedObject(self, &shouldLoadingKey, false, .OBJC_ASSOCIATION_ASSIGN)
            startLoading(autoLoadData: false)
        }
        
        Provider(resource.target).request { response in
            guard let data = response.data,
                let result = resource.parse(data) else {
                    self.loadingView.isError = true
//                    self.loadingView.reloadHandler = {
//                        self.load(with: resource, shouldShowLoading: shouldShowLoading, completion: completion)
//                    }
                    
                    self.stopLoading()
                    return
            }
            
            self.loadingView.isError = false
            self.stopLoading()
            completion?(result)
            }.addToCancelBag()
    }
    
    /// 处理Merge的网络请求
    ///
    /// - Parameter response: response
    /// - Returns: 是否可以继续
    func processLoadingEventsForMergeTarget(response: [Response]) ->Bool {
        for res in response {
            guard res.error == nil else {
                self.loadingView.isError = true
                return false
            }
        }
        self.loadingView.isError = false
        self.stopLoading()
        return true
    }
    
    public func startLoading(autoLoadData: Bool = true) {
        if presenter == nil {
            presenter = view
        }
        
        if !presenter!.subviews.contains(loadingView) {
            presenter!.addSubview(loadingView)
            loadingView.snp.makeConstraints({ make in
                make.edges.equalToSuperview()
            })
        }
        
        loadingView.startAnimating()
        if autoLoadData {
            loadData()
        }
    }
    
    public func stopLoading() {
        loadingView.stopAnimating()
    }
    
    public func loadData() {
        // load you data
    }
}
