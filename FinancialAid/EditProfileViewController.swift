//
//  EditProfileViewController.swift
//  FinancialAid
//
//  Created by PengZhao on 16/5/25.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditProfileViewController: UIViewController {

    var key = ""
    var originalContent: String!

    @IBOutlet weak var textField: UITextField!

    fileprivate struct Constants {
        static let unwindSegueIdentifier = "UnwindToUserCenterSegue"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action:
                                            #selector(EditProfileViewController.saveEdit))
        textField.text = originalContent
    }

    func saveEdit() {
        let content = textField.text ?? ""
        let validator = [
            "phone": String.isPhoneNumber,
            "email": String.isEmail,
            "realname": String.isNonEmpty
        ][key]
        var validate: (String) -> () -> Bool = String.isNonEmpty
        if let validator = validator {
            validate = validator
        }
        if !validate(content)() {
            // shake textfield
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.duration = 0.6
            animation.values = [(-20), (20), (-20), (20), (-10), (10), (-5), (5), (0)]

            textField.layer.add(animation, forKey: "shake")
            return
        }
        ContentManager.sharedInstance.editUserInfo([key: textField.text ?? ""]) {
            if $0 != nil {
                let prompt = NSLocalizedString("Server error occurred",
                                               comment: "network error in saving user info")
                SVProgressHUD.showError(withStatus: prompt)
            } else {
                self.performSegue(withIdentifier: Constants.unwindSegueIdentifier, sender: nil)
            }
        }
    }
}

extension EditProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
