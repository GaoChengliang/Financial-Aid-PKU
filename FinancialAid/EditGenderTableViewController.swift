//
//  EditGenderTableViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/26.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditGenderTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.title = NSLocalizedString("Gender", comment: "gender")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self, action:
            #selector(EditGenderTableViewController.saveEdit))
        gender = User.sharedInstance.gender == "unknown" ? "male" : User.sharedInstance.gender
    }

    var gender = "" {
        didSet {
            tableView.reloadData()
        }
    }
    fileprivate struct Constants {
        static let EditGenderTableViewCellCheckedIdentifier = "EditGenderTableViewCellChecked"
        static let EditGenderTableViewCellUncheckedIdentifier = "EditGenderTableViewCellUnchecked"
        static let unwindSegueIdentifier = "UnwindToUserCenterSegue"
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {

            var cell: UITableViewCell! = nil
            if gender == "male" && (indexPath as NSIndexPath).row == 0 || gender == "female" && (indexPath as NSIndexPath).row == 1 {
                cell = tableView.dequeueReusableCell(
                    withIdentifier: Constants.EditGenderTableViewCellCheckedIdentifier, for: indexPath)
            } else {
                cell = tableView.dequeueReusableCell(
                    withIdentifier: Constants.EditGenderTableViewCellUncheckedIdentifier, for: indexPath)
            }

            if (indexPath as NSIndexPath).row == 0 {
                cell.textLabel?.text = NSLocalizedString("Male", comment: "gender of user is male")
            } else {
                cell.textLabel?.text = NSLocalizedString("Female", comment: "gender of user is female")
            }
            return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 0 {
            gender = "male"
        } else {
            gender = "female"
        }
    }

    func saveEdit() {
        ContentManager.sharedInstance.editUserInfo(["gender": gender]) {
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
