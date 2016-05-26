//
//  SettingsTableViewController.swift
//  FinancialAid
//
//  Created by PengZhao on 16/5/17.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import MobileCoreServices
import SVProgressHUD

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = nil
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("ChangePwdTableViewCell", forIndexPath: indexPath)
        }
        if indexPath.section == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("LogoutTableViewCell", forIndexPath: indexPath)
        }
        return cell
    }

}
