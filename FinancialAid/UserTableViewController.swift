//
//  UserTableViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/25.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import MobileCoreServices
import DKImagePickerController
import SVProgressHUD

class UserTableViewController: UITableViewController {

    var userCenter = UserCenter() {
        didSet {
            tableView.reloadData()
        }
    }

    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        let contents = userCenter.contents(indexPath)
        if indexPath.section == 0 {
            guard let userCell = cell as? UserPortraitTableViewCell else { return cell }
            userCell.setupWith(contents[0], realName: contents[1])
        } else if indexPath.section == 1 {
            cell.detailTextLabel?.text = contents[0]
        }
        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPathForCell(cell)
        else { return }

        let dest = segue.destinationViewController
        let tuple = userCenter.tuples(indexPath)
        if let epvc = dest as? EditProfileViewController {
            epvc.title = tuple.title
            epvc.key = tuple.key
            epvc.originalContent = tuple.content.last
        }
    }

    @IBAction func editImage() {
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = 1
        pickerController.allowMultipleTypes = false
        pickerController.assetType = .AllPhotos
        pickerController.showsEmptyAlbums = false
        pickerController.autoDownloadWhenAssetIsInCloud = false
        pickerController.showsCancelButton = true
//        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
//            for asset in assets {
//
//            }
//        }
        self.presentViewController(pickerController, animated: true) {}
    }

    @IBAction func unwindToUserCenter(segue: UIStoryboardSegue) {
        userCenter = UserCenter()
    }
}
