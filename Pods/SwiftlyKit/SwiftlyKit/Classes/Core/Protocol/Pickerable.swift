//
//  Pickerable.swift
//  HaircutEdu
//
//  Created by jewelz on 2017/6/7.
//  Copyright © 2017年 service+. All rights reserved.
//

import UIKit

public protocol Pickable: class {
    
    var pickerView: UIPickerView { get }

    var responder: UIView { get }
}

extension Pickable {
    var pickerView: UIPickerView {
        let picker = UIPickerView()
        return picker
    }
}

public class Picker {
    
    public weak var picker: Pickable?
    
    public var datePicker: UIDatePicker?
    
    public var confirmAction: (()->())?
    public var cancelAction: (()->())?
    
    lazy var fextField: UITextField = { [unowned self] in
        let textF = UITextField()
        textF.backgroundColor = UIColor.clear
        if self.datePicker != nil {
            textF.inputView = self.datePicker!
        } else {
            textF.inputView = self.picker?.pickerView
        }
        textF.inputAccessoryView = self.pikerToolBar
        return textF
    }()
        
  
    lazy var pikerToolBar: UIToolbar = {
        let toolBar = UIToolbar(frame:CGRect(x: 0, y: 0, width: ScreenW, height: 49))
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(Picker.cancel))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(Picker.done))
        toolBar.items = [cancel,flexible,done]
        return toolBar
    }()
    
    public init(picker: Pickable, datePicker: UIDatePicker? = nil) {
        self.picker = picker
        self.datePicker = datePicker
        picker.responder.addSubview(fextField)
    }
    
    public func show() {
        //view.addSubview(fextField)
        print(pikerToolBar)
        fextField.becomeFirstResponder()
    }
    
    @objc private func cancel() {
        cancelAction?()
        fextField.resignFirstResponder()
    }
    
    
    
    @objc private func done() {
        confirmAction?()
        fextField.resignFirstResponder()
    }
    
}
