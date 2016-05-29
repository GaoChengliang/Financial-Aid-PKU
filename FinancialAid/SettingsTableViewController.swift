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

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController
        if dest is LoginViewController {
            ContentManager.Password = nil
        }
    }
}
