//
//  ProfileHeader.swift
//  DogSay
//
//  Created by jewelz on 2017/4/29.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit
import SwiftlyKit

class ProfileHeader: UICollectionReusableView, Reusable {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var headerTaped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configView(with user: User?) {
        guard let user = user else {
            return
        }
//        nameLabel.text = user.nickname
//        avatarView.setImage(with: user.avatar, placeholder: #imageLiteral(resourceName: "avatar_default"))
    }
    
    @IBAction func buttonClicked() {
        guard let headerTaped = headerTaped else {
            return
        }
        headerTaped()
    }
}
