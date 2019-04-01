//
//  ThumbnailCell.swift
//  DogSay
//
//  Created by jewelz on 2017/4/29.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit
import SnapKit
import SwiftlyKit

class ThumbnailCell: UICollectionViewCell, Reusable {
    
    var representedAssetIdentifier: String!
    
    var isPickerThumbnail = false
    
    lazy var thumanail: UIImageView = {
        let imageVeiw = UIImageView()
        imageVeiw.contentMode = .scaleAspectFill
        imageVeiw.clipsToBounds = true
//        imageVeiw.image = #imageLiteral(resourceName: "cat")
        imageVeiw.backgroundColor = UIColor.groupTableViewBackground
        return imageVeiw
    }()
    
    private lazy var blackMask: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.6)
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            if isPickerThumbnail {
                blackMask.isHidden = !isSelected
                UIView.animate(withDuration: 0.25) {
                    self.blackMask.alpha = 1
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(thumanail)
        thumanail.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(self)
        }
        
        addSubview(blackMask)
        blackMask.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
