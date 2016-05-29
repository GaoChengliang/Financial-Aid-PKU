//
//  EditProfileViewController.swift
//  FinancialAid
//
//  Created by PengZhao on 16/5/25.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let barItem =  UIBarButtonItem(title: NSLocalizedString("Save", comment: "save button item"),
                                       style: .Done, target: self,
                                       action: #selector(EditProfileViewController.saveEdit))
        self.navigationItem.rightBarButtonItem = barItem
        textField.delegate = self
        textField.text = value
    }

    var value = ""

    func saveEdit() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
