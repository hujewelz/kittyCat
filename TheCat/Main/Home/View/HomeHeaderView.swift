//
//  HomeHeaderView.swift
//  TheCat
//
//  Created by huluobo on 2019/3/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {

    var headerDidTaped: (() -> Void)?
    
    class var fromNib: HomeHeaderView {
        return Bundle.main.loadNibNamed("HomeHeaderView", owner: nil, options: nil)?.first as! HomeHeaderView
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        headerDidTaped?()
    }
    
}
