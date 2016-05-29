//
//  EditGenderTableViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/26.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class EditGenderTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.title = NSLocalizedString("Gender", comment: "gender")
    }

    var gender = 0 {
        didSet {
            tableView.reloadData()
        }
    }

    private struct Constants {
        static let EditGenderTableViewCellChecked = "EditGenderTableViewCellChecked"
        static let EditGenderTableViewCellUnchecked = "EditGenderTableViewCellUnchecked"
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {

        var cell: UITableViewCell! = nil

        if indexPath.row == gender {
            cell = tableView.dequeueReusableCellWithIdentifier(Constants.EditGenderTableViewCellChecked,
                                                               forIndexPath: indexPath)
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(Constants.EditGenderTableViewCellUnchecked,
                                                               forIndexPath: indexPath)
        }
        if indexPath.row == 0 {
            cell.textLabel?.text = NSLocalizedString("Male", comment: "gender of user is male")
        } else {
            cell.textLabel?.text = NSLocalizedString("Female", comment: "gender of user is female")
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        gender = indexPath.row
    }
}
