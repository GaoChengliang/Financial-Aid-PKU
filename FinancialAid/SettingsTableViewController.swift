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

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 1 {
            let imageCache = SDImageCache.sharedImageCache()
            imageCache.clearMemory()
            imageCache.clearDiskOnCompletion() {
                SVProgressHUD.showSuccessWithStatus(
                    NSLocalizedString("Clear cache success", comment: "clear cache success")
                )
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination
        if dest is LoginViewController {
            ContentManager.Password = nil
        }
    }
}
