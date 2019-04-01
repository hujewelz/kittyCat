//
//  Coordinator.swift
//  OnlineDesign
//
//  Created by huluobo on 2018/10/18.
//

import UIKit

public protocol Coordinator: class {
    func start()
}

public class AbstractCoordinator: NSObject, Coordinator {
    
    public var childCoordinators: [Coordinator] {
        return _childCoordinators
    }
        
    private var _childCoordinators: [Coordinator] = []
    
    override init() {
        guard type(of: self) != AbstractCoordinator.self else {
            fatalError("AbstractCoordinator instances cannot be created. Use subclasses instead")
        }
    }
    
    public func start() { }
    
    func add(childCoordinator: Coordinator) {
        remove(childCoordinator: childCoordinator)
        _childCoordinators.append(childCoordinator)
    }
    
    func remove(childCoordinator: Coordinator) {
        _childCoordinators = _childCoordinators.filter { $0 !== childCoordinator }
    }

}

private var coordinatorKey: Void?

public extension UIViewController {
    public var coordinator: Coordinator? {
        get {
            return objc_getAssociatedObject(self, &coordinatorKey) as? Coordinator
        }
        set {
            guard let coordinator = newValue else {
                return
            }
            objc_setAssociatedObject(self, &coordinatorKey, coordinator, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
