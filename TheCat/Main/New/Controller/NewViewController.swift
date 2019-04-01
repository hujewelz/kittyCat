//
//  NewViewController.swift
//  DogSay
//
//  Created by jewelz on 2017/4/28.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit
import SwiftlyKit
import SVProgressHUD

class NewViewController: UIViewController {

    var leftButtonClicked: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upload Cat"

        navigationItem.leftBarButtonItem = UIBarButtonItem(left: UIImage(named: "nav_back"),
                                                           highlighted: UIImage(named: "nav_back"),
                                                           target: self,
                                                           action: #selector(_leftButtonClicked))
        
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(right: UIImage(named: "button_add"),
//                                                           highlighted: UIImage(named: "button_add"),
//                                                           target: self,
//                                                           action: #selector(tackPhoto))
        
        
    }
    
    @IBAction private func pickImage(_ sender: UIButton) {
        
        let action = {
            let vc = BaseNavigationController(rootViewController: MediaPickerViewController())
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        if UserDefaults.standard.bool(forKey: "cat.protocol.showed") { action() }
        else { showAlert(handler: action) }
    }
    
    @objc func _leftButtonClicked() {
        leftButtonClicked?()
    }

    @IBAction private func tackPhoto() {
        let action = {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            self.navigationController?.present(picker, animated: true, completion: nil)
        }
        if UserDefaults.standard.bool(forKey: "cat.protocol.showed") { action() }
        else { showAlert(handler: action) }
    }
    
    private func showAlert(handler: @escaping () -> Void) {
        let alert = UIAlertController(title: "提示", message: "如果您继续，就表示愿意保持互联网内容的干净，不上传裸露、色情等令人反感的内容", preferredStyle: .alert)
        let action = UIAlertAction(title: "继续", style: .default) { _ in
            UserDefaults.standard.set(true, forKey: "cat.protocol.showed")
            UserDefaults.standard.synchronize()
            handler()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension NewViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        var data = img.jpegData(compressionQuality: 1)
        if data == nil {
            data = img.pngData()
        }
        guard let _data = data else { return }
//        DispatchQueue.main.async {
            SVProgressHUD.show()
//        }
        Uploader.upload(data: _data) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    SVProgressHUD.showSuccess(withStatus: "上传成功")
                case .failure(_):
                    SVProgressHUD.showError(withStatus: "Did not contain a Cat")
                }
            }
        }
    }
}
