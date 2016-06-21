//
//  EditPwdViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/6/21.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditPwdViewController: UIViewController {

    @IBOutlet weak var oldPwd: UITextField!
    @IBOutlet weak var newPwd: UITextField!
    @IBOutlet weak var newPwdCheck: UITextField!

    private struct Constants {
        static let segueIdentifier = "UnwindToLoginSegue"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        oldPwd.delegate = self
        oldPwd.returnKeyType = UIReturnKeyType.Continue
        oldPwd.enablesReturnKeyAutomatically  = true
        oldPwd.tag = 101

        newPwd.delegate = self
        newPwd.returnKeyType = UIReturnKeyType.Continue
        newPwd.enablesReturnKeyAutomatically  = true
        newPwd.tag = 202

        newPwdCheck.delegate = self
        newPwdCheck.returnKeyType = UIReturnKeyType.Done
        newPwdCheck.enablesReturnKeyAutomatically  = true
        newPwdCheck.tag = 303
    }



    @IBAction func editPwd(sender: UIBarButtonItem) {
        let newPwdCheckStr = newPwdCheck.text ?? ""

        if let oldPwdStr = oldPwd.text, newPwdStr = newPwd.text {
            if oldPwdStr.isNonEmpty() && newPwdStr.isNonEmpty() {
                if newPwdStr != newPwdCheckStr {
                    SVProgressHUD.showErrorWithStatus(
                        NSLocalizedString("Check new password error",
                            comment: "Two new passwords is not same")
                    )
                    return
                }
                if oldPwdStr != ContentManager.Password {
                    SVProgressHUD.showErrorWithStatus(
                        NSLocalizedString("Check old password error",
                            comment: "old password is wrong")
                    )
                    return
                }

                ContentManager.sharedInstance.editUserInfo(["password": newPwdStr]) {
                    if $0 != nil {
                        SVProgressHUD.showErrorWithStatus(
                            NSLocalizedString("Server error occurred",
                                comment: "network error in editing password")
                        )
                    } else {
                        SVProgressHUD.showSuccessWithStatus(
                            NSLocalizedString("Edit password success",
                                comment: "edit password success")
                        )

                        ContentManager.Password = nil
                        self.performSegueWithIdentifier(Constants.segueIdentifier, sender: self)
                    }
                }

            } else {
                SVProgressHUD.showErrorWithStatus(
                    NSLocalizedString("Input empty error",
                        comment: "input content is empty")
                )
            }
        }
    }

}

extension EditPwdViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 101 {
            newPwd.becomeFirstResponder()
            return true
        }
        if textField.tag == 202 {
            newPwdCheck.becomeFirstResponder()
            return true
        }

        textField.resignFirstResponder()
        return true
    }
}
