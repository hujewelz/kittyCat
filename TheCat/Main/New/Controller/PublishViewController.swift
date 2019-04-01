//
//  PublishViewController.swift
//  DogSay
//
//  Created by jewelz on 2017/5/4.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import SwiftlyKit

class PublishViewController: UIViewController {
    
//    lazy var textView: PlaceTextView = {
//        let textV = PlaceTextView()
//        textV.font = UIFont.systemFont(ofSize: 15)
//        textV.placeholder = "发表内容..."
//        textV.textColor = TextBlack
//        return textV
//    }()
//
//    var image: UIImage!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = UIColor.white
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(PublishViewController.cancelButtonClicked))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(PublishViewController.confirmButtonClicked))
//        
//        view.addSubview(textView)
//        textView.snp.makeConstraints { make in
//            make.left.right.top.equalTo(view)
//            make.height.equalTo(200)
//        }
//    }
//
//    func cancelButtonClicked() {
//        AppDelegate.delegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
//
//    }
//    
//    func confirmButtonClicked() {
//        
//        self.textView.resignFirstResponder()
//        
//        let data = UIImagePNGRepresentation(image)
//        
//        let param: [String : Any] = ["accessToken": UserDefaults.User.accessToken.stringValue!]
//        
//        OSSUploader.upload(data!, params: param, fileName: "test.png", type: .image) { success, result in
//            if !success {
//                return
//            }
//            
//            let data = JSON(parseJSON: result!)
//            
//            print(data)
//            
//            let params: [String : Any] = [
//                "id": data["data", "id"].stringValue,
//                "accesstoken": UserDefaults.User.accessToken.stringValue!,
//                "desc": self.textView.text
//            ]
//            
//            print("params: \(params)")
//            
//            APIServer.fetch(API.creationsNew(params)) { (json, err) in
//                
//                guard let json = json else {
//                    return
//                }
//                
//                if JSON(json)["code"].intValue != 1 {
//                    SVProgressHUD.showInfo(withStatus: JSON(json)["msg"].stringValue)
//                    return
//                }
//                
//                AppDelegate.delegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
//                
//            }
//            
//        }
//        
//    }
//    
//    func publish() {
//        
//        let data = UIImagePNGRepresentation(image)
//        
//        let param: [String : Any] = [
//            "accessToken": UserDefaults.User.accessToken.stringValue!,
//            "desc": textView.text
//        ]
//        
//        OSSUploader.upload(data!, params: param, fileName: "test.png", type: .image) { success in
//            
//        }
//    }

}
