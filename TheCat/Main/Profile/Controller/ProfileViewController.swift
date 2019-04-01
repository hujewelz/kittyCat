//
//  ProfileViewController.swift
//  TheCat
//
//  Created by huluobo on 2019/3/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
