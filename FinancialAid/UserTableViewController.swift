//
//  UserTableViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/25.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import MobileCoreServices
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

    @IBAction func unwindToUserCenter(segue: UIStoryboardSegue) {
        userCenter = UserCenter()
    }
}

extension UserTableViewController: UIActionSheetDelegate {

    @IBAction func editImage() {
        let alertController = UIAlertController(title: NSLocalizedString("Edit portrait", comment:
            "upload portrait of the user"), message: nil, preferredStyle:UIAlertControllerStyle.ActionSheet)
        let alertActionCamera = UIAlertAction(title: NSLocalizedString("Open camera", comment: "open camera"),
                                              style: UIAlertActionStyle.Default) {
            alert in
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                let picker = UIImagePickerController()
                picker.sourceType = .Camera
                picker.mediaTypes = [String(kUTTypeImage)]
                picker.delegate = self
                picker.allowsEditing = true
                self.presentViewController(picker, animated: true, completion: nil)
            }
        }
        alertController.addAction(alertActionCamera)
        let alertActionAlbum = UIAlertAction(title: NSLocalizedString("Open album", comment: "open album"),
                                             style: UIAlertActionStyle.Default) {
            alert in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let picker = UIImagePickerController()
                picker.sourceType = .PhotoLibrary
                picker.mediaTypes = [String(kUTTypeImage)]
                picker.delegate = self
                picker.allowsEditing = true
                self.presentViewController(picker, animated: true, completion: nil)
            }
        }
        alertController.addAction(alertActionAlbum)
        let alertActionCancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel upload"),
                                              style: UIAlertActionStyle.Cancel) {
            alert in alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(alertActionCancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}



extension UserTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {

            let image = pickedImage
            /* while(image.size.height > 200){    // 压缩图片到200以下 100以上
             let newSize = CGSize(width: image.size.width/2, height: image.size.height/2)
             UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
             image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
             image = UIGraphicsGetImageFromCurrentImageContext()
             UIGraphicsEndImageContext()
             }*/
            let _ = UIImageJPEGRepresentation(image, 1)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
