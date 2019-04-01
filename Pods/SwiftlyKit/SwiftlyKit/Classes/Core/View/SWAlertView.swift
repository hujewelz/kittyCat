//
//  SWAlertView.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/7/4.
//  Copyright © 2017年 service+. All rights reserved.
//

import UIKit
import SnapKit

@objc public protocol SWAlertViewDelegate: NSObjectProtocol {
    
    @objc optional func alertView(_ alertView: SWAlertView, clickedButtonAt buttonIndex: Int)
    
    @objc optional func alertViewCancel(_ alertView: SWAlertView)
    
}

public enum SWAlertViewStyle : Int {
    
    case `default`
    
    case secureTextInput
    
    case plainTextInput
    
    case checkBox
}

public class SWAlertView: UIView {
    
    // MARK: Private Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexValue: 0x39364d)
        label.font = UIFont.pingFang(.regular, size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexValue: 0x878794)
        label.font = UIFont.pingFang(.regular, size: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 1
       // button.backgroundColor = UIColor.white
        button.setBackgroundImage(UIImage.image(with: UIColor.white), for: .normal)
        button.setBackgroundImage(UIImage.image(with: UIColor.groupTableViewBackground), for: .highlighted)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor(hexValue: 0x55cffe), for: .normal)
        button.titleLabel?.font = UIFont.pingFang(.regular, size: 16)
        button.addTarget(self, action: #selector(SWAlertView.buttonClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var otherButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 2
       // button.backgroundColor = UIColor.white
        button.setBackgroundImage(UIImage.image(with: UIColor.white), for: .normal)
        button.setBackgroundImage(UIImage.image(with: UIColor.groupTableViewBackground), for: .highlighted)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor(hexValue: 0x55cffe), for: .normal)
        button.titleLabel?.font = UIFont.pingFang(.regular, size: 16)
        button.addTarget(self, action: #selector(SWAlertView.buttonClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var textField: UITextField = {
        let textF = UITextField()
        textF.textColor = UIColor(hex: "#3D434D")
        textF.font = UIFont.pingFang(.regular, size: 15)
        textF.textAlignment = .center
        textF.addTarget(self, action: #selector(SWAlertView.textFieldDidEditingChange(_:)), for: .editingChanged)
        return textF
    }()
    
    lazy var checkBox: UIButton = {
        let checkButton = UIButton(type: .custom)
        checkButton.setTitle("下次不在提醒", for: .normal)
        checkButton.setTitleColor(UIColor(r: 141, g: 151, b: 166), for: .normal)
        checkButton.setImage(#imageLiteral(resourceName: "common_radio_normal"), for: .normal)
        checkButton.setImage(#imageLiteral(resourceName: "common_radio_select"), for: .selected)
        checkButton.titleLabel?.font = UIFont.pingFang(.regular, size: 12)
        checkButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        checkButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
        checkButton.addTarget(self, action: #selector(SWAlertView.checkBoxDidChicked(_:)), for: .touchUpInside)
        return checkButton
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var maskBg: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.65
        return view
    }()
    
    private lazy var buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 221, g: 226, b: 235)
        return view
    }()
    
    private var title: String?
    private var message: String?
    
    private var cancelButtonTitle: String?
    private var otherButtonTitle: String?
    
    private var blueSeparator: UIView?
    
    // MARK: Public Properties
    public weak var delegate: SWAlertViewDelegate?
    
    public var shouldAutoDismissBeforeButtonClicked = true
    
    /// Tint color for other button.
    public var barTintColor: UIColor? {
        didSet{
            guard let barTintColor = barTintColor else { return  }
            if otherButtonTitle == nil {
                cancelButton.setTitleColor(barTintColor, for: .normal)
            } else {
                otherButton.setTitleColor(barTintColor, for: .normal)
            }
        }
    }
    
    
    public var isChecked: Bool {
        return checkBox.isSelected
    }
    
    public var alertViewStyle: SWAlertViewStyle = .default {
        didSet {
            switch alertViewStyle {
            case .default:
                return
            case .plainTextInput:
                textField.isSecureTextEntry = false
            case .secureTextInput:
                textField.isSecureTextEntry = true
            case .checkBox:
                break
            }
            //UIAlertView
            updateView()
        }
    }
    
    public var buttonClicked: ((Int) -> Void)?
    
    public init(title: String?, message: String?, delegate: SWAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitle: String?) {
        self.title = title
        self.message = message
        self.cancelButtonTitle = cancelButtonTitle
        self.otherButtonTitle = otherButtonTitle
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SWAlertView.keyboardWillChangeFrame(_:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    public convenience init(title: String?, message: String?, delegate: SWAlertViewDelegate?, cancelButtonTitle: String?) {
        self.init(title: title, message: message, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func show() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        if window.subviews.contains(self) {
            return
        }
        window.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.containerView.transform = CGAffineTransform.identity
            self.alpha = 1
        }) { _ in
            if self.alertViewStyle != .default { self.textField.becomeFirstResponder() }
        }
    }
    
    public func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    public func textField(at textFieldIndex: Int) -> UITextField? {
        return textField
    }
    
    public func setButtonTintColor(_ color: UIColor, at index: Int) {
        if index == 0 {
            cancelButton.setTitleColor(color, for: .normal)
        } else {
            otherButton.setTitleColor(barTintColor, for: .normal)
        }
    }
    
    // MARK: Action
    
    @objc private func buttonClicked(_ sender: UIButton) {
        
        if buttonClicked != nil {
            buttonClicked!(sender.tag - 1)
            if shouldAutoDismissBeforeButtonClicked {
                dismiss()
            }
            return
        }
        
        if sender.tag == 1 && delegate != nil {
            if delegate!.responds(to: #selector(delegate?.alertViewCancel(_:))) {
                self.delegate?.alertViewCancel?(self)
                return
            }
        }
        
        delegate?.alertView?(self, clickedButtonAt: sender.tag - 1)
        if shouldAutoDismissBeforeButtonClicked {
            dismiss()
        }
        
    }
    
    @objc private func textFieldDidEditingChange(_ textField: UITextField) {
        blueSeparator?.backgroundColor = textField.text!.isAbsoluteEmpty
            ? UIColor(r: 221, g: 226, b: 235)
            : UIColor(hex:"#3089DB")
    }
    
    @objc private func keyboardWillChangeFrame(_ sender: Notification) {
        guard let keyboardRect = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let offsetY = keyboardRect.origin.y - (containerView.y + containerView.height)
        
        UIView.animate(withDuration: 0.25) {
            if offsetY < 0 {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: offsetY-10)
            } else {
                self.containerView.transform = CGAffineTransform.identity
            }
        }
    }
    
    // MARK: Private
    
    private func updateView() {
        if alertViewStyle == .default {
            if containerView.subviews.contains(messageLabel) { return }
            let pStyle = NSMutableParagraphStyle()
            pStyle.lineSpacing = 4
            pStyle.alignment = .center
            messageLabel.attributedText = NSAttributedString(
                string: message ?? "",
            attributes: [NSAttributedStringKey.paragraphStyle: pStyle])
            containerView.addSubview(messageLabel)
            messageLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.left.equalTo(24)
                make.right.equalTo(-24)
                make.bottom.equalTo(buttonView.snp.top).offset(-15)
            }
            
            if alertViewStyle != .checkBox { return }
            
            if containerView.subviews.contains(checkBox) { return }
            containerView.addSubview(checkBox)
            checkBox.snp.makeConstraints({ make in
                make.left.equalTo(18)
                make.height.equalTo(20)
                make.top.equalTo(messageLabel.snp.bottom).offset(10)
                make.bottom.equalTo(buttonView.snp.top).offset(-10)
            })
            
            return
        }
        
        if alertViewStyle == .checkBox {
            if containerView.subviews.contains(checkBox) { return }
            
            messageLabel.snp.updateConstraints{ make in
                make.bottom.equalTo(buttonView.snp.top).offset(-50)
            }
            
            containerView.addSubview(checkBox)
            checkBox.snp.makeConstraints({ make in
                make.left.equalTo(18)
                make.height.equalTo(20)
               // make.top.equalTo(messageLabel.snp.bottom).offset(10)
                make.bottom.equalTo(buttonView.snp.top).offset(-15)
            })
            
            return
        }
        
        messageLabel.isHidden = alertViewStyle != .default
        if containerView.subviews.contains(textField) {
            return
        }
        containerView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(28)
            make.bottom.equalTo(buttonView.snp.top).offset(-20)
        }
        
        blueSeparator = UIView()
        blueSeparator!.backgroundColor = UIColor(r: 221, g: 226, b: 235)
        containerView.addSubview(blueSeparator!)
        blueSeparator!.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(1)
            make.top.equalTo(textField.snp.bottom).offset(4)
        }
    }
    
    private func setupView() {
        alpha = 0
        backgroundColor = UIColor.clear
        
        addSubview(maskBg)
        maskBg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(47)
        }
        containerView.transform =  CGAffineTransform(scaleX: 0, y: 0)
        
        // layout button
        let separator = UIView()
        separator.backgroundColor = UIColor(r: 221, g: 226, b: 235)
        containerView.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalTo(-50)
        }
        
        containerView.addSubview(buttonView)
        buttonView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        if cancelButtonTitle != nil {
            cancelButton.setTitle(cancelButtonTitle, for: .normal)
        }
        buttonView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            if otherButtonTitle == nil {
                make.right.equalToSuperview()
            } else {
                make.width.equalToSuperview().dividedBy(2).offset(0.5)
            }
        }
        
        if otherButtonTitle != nil {
            otherButton.setTitle(otherButtonTitle, for: .normal)
            var titleColor = UIColor(hexValue: 0x878794)
            if barTintColor != nil {
                titleColor = barTintColor!
            }
            cancelButton.setTitleColor(titleColor, for: .normal)
            buttonView.addSubview(otherButton)
            otherButton.snp.makeConstraints { make in
                make.right.top.bottom.equalToSuperview()
                make.left.equalTo(cancelButton.snp.right).offset(0.5)
            }
        }
        
        // layout label
        titleLabel.text = title
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        updateView()
    }
    
    @objc private func checkBoxDidChicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
//        UserDefaults.Alert.didShowedCheckBox.set(sender.isSelected)
    }
}
