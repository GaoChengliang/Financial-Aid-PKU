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

    func setupWithPlaceholder(_ placeholder: String,
                              content: String,
                              isSecure: Bool,
                              AndKeyboardType keyboardType: UIKeyboardType) {

        textField.text = content
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        textField.clearsOnBeginEditing = isSecure
        textField.clearButtonMode = isSecure ? .whileEditing : .never
        textField.keyboardType = keyboardType
    }
}

extension TextFieldCell: UITextFieldDelegate {

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
