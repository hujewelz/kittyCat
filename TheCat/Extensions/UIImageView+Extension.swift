//
//  UIImageView+Extension.swift
//  TheCat
//
//  Created by huluobo on 2019/3/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlStr: String?) {
        guard let urlStr = urlStr, let url = URL(string: urlStr) else { return }
        self.kf.setImage(with: url)
    }
}
