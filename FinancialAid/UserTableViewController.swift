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

    func retrieveUser() {
        ContentManager.sharedInstance.getUserInfo {
            if $0 == nil {
                self.userCenter = UserCenter()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveUser()
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let contents = userCenter.contents(indexPath)
        if (indexPath as NSIndexPath).section == 0 {
            guard let userCell = cell as? UserPortraitTableViewCell else { return cell }
            userCell.setupWith(contents[0], realName: contents[1])
        } else if (indexPath as NSIndexPath).section == 1 {
            cell.detailTextLabel?.text = contents[0]
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell)
        else { return }

        let dest = segue.destination
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
        pickerController.didSelectAssets = {
            assets in
            for asset in assets {
                asset.fetchImageWithSize(CGSize(width: 400, height: 800)) {
                    (image: UIImage?, _) in

                }
            }
        }
        //self.presentViewController(pickerController, animated: true) {}
    }

    @IBAction func unwindToUserCenter(_ segue: UIStoryboardSegue) {
        userCenter = UserCenter()
    }
}
