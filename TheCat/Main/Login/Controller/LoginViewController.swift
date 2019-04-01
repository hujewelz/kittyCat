//
//  LoginViewController.swift
//  DogSay
//
//  Created by jewelz on 2017/4/30.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import SwiftlyKit

protocol LoginViewControllerDelegate : class {
    func loginViewController(_ vc: LoginViewController, didLoginWithUserID id: String)
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    weak var delegate: LoginViewControllerDelegate?
    
    var isPhoneAvailable = false
    var isVerifyCodeAvailabel = false
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Action

    @IBAction func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines), !text.isEmpty else {
            return
        }
        
        if sender == phoneTextField {
            isPhoneAvailable = text.isPhoneNumber
        } else if sender == verifyCodeTextField {
            isVerifyCodeAvailabel = text.count >= 4
        }
        
        loginButton.isEnabled = isPhoneAvailable && isVerifyCodeAvailabel
    }
    
    // MARK: - Pirvate
    
    @IBAction func login() {
        guard let phone = phoneTextField.text else { return }
        
        var result = ""

        let words = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k"]
        for (i, c) in phone.enumerated() {
            result += words[i] + String(c)
        }
        view.endEditing(true)
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            SVProgressHUD.dismiss()
            self.delegate?.loginViewController(self, didLoginWithUserID: result)
        }
    }
}

extension String {
     static func * (lhs: String, rhs: Int) -> String {
        var result = ""
        for _ in 0..<rhs {
            result += lhs
        }
        return result
    }
}
