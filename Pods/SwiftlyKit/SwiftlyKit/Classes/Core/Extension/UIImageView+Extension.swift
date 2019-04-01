//
//  UIImageView+Extension.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/5/26.
//  Copyright © 2017年 service+. All rights reserved.
//

import UIKit

//extension String {
//    func urlFromEduDomain() -> URL?{
//        var urlString: String = ""
//        if !(self.hasPrefix("http")) {
//            urlString = mediaUrlHost.appending(self)
//        }
//        
//        guard let url = URL(string: urlString) else {
//            return nil
//        }
//        
//        return url
//    }
//}
//
//
//extension UIImageView {
//
//    
//    func setImage(with urlString: String?, placeholder: UIImage? = nil, options: KingfisherOptionsInfo? = nil) {
//        
//        guard let urlString = urlString else {
//            self.image = nil
//            return
//        }
//        var urlStr  = urlString
//        if !(urlString.hasPrefix("http")) {
//            urlStr = mediaUrlHost.appending(urlString)
//        }
//        
//        guard let url = URL(string: urlStr) else {
//            self.image = nil
//            return
//        }
//        
//        kf.setImage(with: url, placeholder: placeholder, options: options, progressBlock: nil, completionHandler: nil)
//    }
//    
//}
//
//extension UIButton {
//    
//    func setImage(with urlString: String?, for state: UIControlState = .normal, placeholder: UIImage? = nil, options: KingfisherOptionsInfo? = nil) {
//        
//        guard let urlString = urlString else {
//            self.setImage(nil, for: .normal)
//            return
//        }
//        var urlStr  = urlString
//        if !(urlString.hasPrefix("http")) {
//            urlStr = mediaUrlHost.appending(urlString)
//        }
//        
//        guard let url = URL(string: urlStr) else {
//            self.setImage(nil, for: .normal)
//            return
//        }
//        
////        let urlStr = mediaUrlHost.appending(urlString)
////        guard let url = URL(string: urlStr) else {
////            self.setImage(nil, for: .normal)
////            return
////        }
//        
//        
//        kf.setImage(with: url, for: state, placeholder: placeholder, options: options, progressBlock: nil, completionHandler: nil)
//    }
//
//    func setBackgroundImage(with urlString: String?, for state: UIControlState = .normal, placeholder: UIImage? = nil, options: KingfisherOptionsInfo? = nil) {
//        
//        guard let urlString = urlString else {
//            self.setBackgroundImage(nil, for: .normal)
//            return
//        }
//        var urlStr  = urlString
//        if !(urlString.hasPrefix("http")) {
//            urlStr = mediaUrlHost.appending(urlString)
//        }
//        
//        guard let url = URL(string: urlStr) else {
//             self.setBackgroundImage(nil, for: .normal)
//            return
//        }
//        kf.setBackgroundImage(with: url, for: state, placeholder: placeholder, options: options, progressBlock: nil, completionHandler: nil)
//    }
//}

