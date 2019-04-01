//
//  MainTabBarController.swift
//  Github
//
//  Created by jewelz on 2017/3/23.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit
import SwiftlyKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVc = HomeViewController()
//
//        let profileVc = ProfileViewController()
        addChildViewController(homeVc, title: "首页", normalImageNamed: "tabbar_icon_home_s", selectedImageNamed: "tabbar_icon_home_s")
//       // addChildViewController(newVc, title: "首页", normalImageNamed: "tabbar_icon_add_s", selectedImageNamed: "tabbar_icon_add_s")
//        addChildViewController(profileVc, title: "我的", normalImageNamed: "tabbar_icon_profile_s", selectedImageNamed: "tabbar_icon_profile_s")
        
//        let tabbar = TabBar()
//        tabbar.addTarget(self, action: #selector(MainTabBarController.presentCenterVc))
//        setValue(tabbar, forKey: "tabBar")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addChildViewController(_ childController: UIViewController, title: String, normalImageNamed imageNamed: String? = nil, selectedImageNamed sImageNamed: String? = nil) {
        //childController.title = title
        childController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        if let imageNamed = imageNamed, let sImageNamed = sImageNamed {
            childController.tabBarItem.image = UIImage(named: imageNamed)
            childController.tabBarItem.selectedImage = UIImage(named: sImageNamed)?.withRenderingMode(.alwaysOriginal)
        }
        
        childController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        childController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .selected)
        
        addChild(BaseNavigationController(rootViewController: childController))
    }
    
    func presentCenterVc() {
        let newVc = MediaPickerViewController()
       // newVc.modalPresentationStyle = .overCurrentContext
//        present(MainNavigationController(rootViewController: newVc), animated: true, completion: nil)
    }
    

}
