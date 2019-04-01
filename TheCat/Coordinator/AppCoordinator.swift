//
//  AppCoordinator.swift
//  TheCat
//
//  Created by huluobo on 2019/3/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftlyKit

struct CatNavigationBarConfig : SwiftlyKitNaviBarConfig {
    var titleTextAttributes: [NSAttributedString.Key: Any]? {
        return [.font: UIFont.systemFont(ofSize: 16)]
    }
}

final class AppCoordinator : Coordinator {
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        setupUI()
        if AccountManager.shared.id == nil {
            let loginVC = LoginViewController()
            loginVC.delegate = self
            loginVC.coordinator = self
            window.rootViewController = loginVC
        } else {
            let rootVC = RootViewController()
            window.rootViewController = BaseNavigationController(rootViewController: rootVC)
        }
        window.makeKeyAndVisible()
    }
    
    private func setupUI() {
        SwiftlyKit.shared.setNaviBarConfig(CatNavigationBarConfig())
        SVProgressHUD.setDefaultStyle(.dark)
    }
}

extension AppCoordinator : LoginViewControllerDelegate {
    func loginViewController(_ vc: LoginViewController, didLoginWithUserID id: String) {
        AccountManager.shared.id = id
        let coordinator = HomeCoordinator(window: window)
        coordinator.start()
    }
    
    
}

extension AppCoordinator : HomeViewControllerDelegate {
    func homeViewControllerDidPresentProfileVC(_ vc: HomeViewController) {
        let coordinator = ProfileCoordinator(vc: vc.navigationController!)
        coordinator.start()
    }
}

final class HomeCoordinator : Coordinator {
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let rootVC = RootViewController()
        window.rootViewController = BaseNavigationController(rootViewController: rootVC)
    }
}

final class ProfileCoordinator : Coordinator {
    var viewController: UIViewController
    
    init(vc: UIViewController) {
        viewController = vc
    }
    
    func start() {
        let vc = ProfileViewController()
        viewController.present(BaseNavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
}
