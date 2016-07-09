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
import SDWebImage

class SettingsTableViewController: UITableViewController {

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            let imageCache = SDImageCache.sharedImageCache()
            imageCache.clearMemory()
            imageCache.clearDiskOnCompletion() {
                SVProgressHUD.showSuccessWithStatus(
                    NSLocalizedString("Clear cache success", comment: "clear cache success")
                )
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController
        if dest is LoginViewController {
            ContentManager.Password = nil
        }
    }
}
