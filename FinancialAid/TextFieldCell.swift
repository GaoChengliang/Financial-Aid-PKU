//
//  TextFieldCell.swift
//  FinancialAid
//
//  Created by PengZhao on 16/1/2.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }

    var content: String {
        return textField.text ?? ""
    }
}

extension TextFieldCell {

    func setupWithPlaceholder(placeholder: String,
                              content: String,
                              isSecure: Bool,
                              AndKeyboardType keyboardType: UIKeyboardType) {

        textField.text = content
        textField.placeholder = placeholder
        textField.secureTextEntry = isSecure
        textField.clearsOnBeginEditing = isSecure
        textField.clearButtonMode = isSecure ? .WhileEditing : .Never
        textField.keyboardType = keyboardType
    }
}

extension TextFieldCell: UITextFieldDelegate {

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
