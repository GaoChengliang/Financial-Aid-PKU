//
//  EditBirthdayViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/26.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditBirthdayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let date = User.sharedInstance.birthday == "0000-00-00" ? Date()
            : DateFormatter.outputFormatter().date(from: User.sharedInstance.birthday) {
            datePicker.setDate(date, animated: false)
        }
    }

    fileprivate struct Constants {
        static let unwindSegueIdentifier = "UnwindToUserCenterSegue"
    }

    @IBOutlet weak var datePicker: UIDatePicker!

    @IBAction func save(_ sender: UIButton) {
        ContentManager.sharedInstance.editUserInfo(["birthday":
            DateFormatter.outputFormatter().string(from: datePicker.date)]) {
            if $0 != nil {
                let prompt = NSLocalizedString("Server error occurred",
                                               comment: "network error in saving user info")
                SVProgressHUD.showError(withStatus: prompt)
            } else {
                self.performSegue(withIdentifier: Constants.unwindSegueIdentifier, sender: nil)
            }
        }
    }

    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
