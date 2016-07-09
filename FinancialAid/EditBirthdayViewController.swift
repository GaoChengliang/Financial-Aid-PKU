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
        if let date = User.sharedInstance.birthday == "0000-00-00" ? NSDate()
            : NSDateFormatter.outputFormatter().dateFromString(User.sharedInstance.birthday) {
            datePicker.setDate(date, animated: false)
        }
    }

    private struct Constants {
        static let unwindSegueIdentifier = "UnwindToUserCenterSegue"
    }

    @IBOutlet weak var datePicker: UIDatePicker!

    @IBAction func save(sender: UIButton) {
        ContentManager.sharedInstance.editUserInfo(["birthday":
            NSDateFormatter.outputFormatter().stringFromDate(datePicker.date)]) {
            if $0 != nil {
                let prompt = NSLocalizedString("Server error occurred",
                                               comment: "network error in saving user info")
                SVProgressHUD.showErrorWithStatus(prompt)
            } else {
                self.performSegueWithIdentifier(Constants.unwindSegueIdentifier, sender: nil)
            }
        }
    }

    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
