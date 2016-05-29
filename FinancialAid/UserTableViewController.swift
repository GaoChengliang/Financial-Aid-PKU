//
//  UserTableViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/25.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON
import SVProgressHUD

class UserTableViewController: UITableViewController {

    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if indexPath.section == 0 {
            guard let userCell = cell as? UserPortraitTableViewCell else { return cell }
            userCell.setupWith(User.sharedInstance.userName, realName: User.sharedInstance.realName)
        } else if indexPath.section == 1 {
            var gender = User.sharedInstance.gender
            gender = gender == "unknown" ? "" : gender
            var birthday = User.sharedInstance.birthday
            birthday = birthday == "0000-00-00" ? "" : birthday
            cell.detailTextLabel?.text = [
                gender,
                birthday,
                User.sharedInstance.phone,
                User.sharedInstance.email
            ][indexPath.row]
        }
        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            editImage()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let identifier = segue.identifier {
//            switch identifier {
//            case Constants.EditPhoneSegue:
//                if let MVC = segue.destinationViewController as? EditProfileViewController {
//                    MVC.title = NSLocalizedString("Phone number", comment: "phone number")
//                    MVC.value = user.phone
//                }
//            case Constants.EditEmailSegue:
//                if let MVC = segue.destinationViewController as? EditProfileViewController {
//                    MVC.title = NSLocalizedString("Email", comment: "email")
//                    MVC.value = user.email
//                }
//            case Constants.EditGenderSegue:
//                if let MVC = segue.destinationViewController as? EditGenderTableViewController {
//                    if user.gender == NSLocalizedString("Male", comment: "gender of user is male") {
//                        MVC.gender = 0
//                    } else {
//                        MVC.gender = 1
//                    }
//                }
//            default: break
//            }
//        }
    }
}



extension UserTableViewController: UIActionSheetDelegate {

    func editImage() {
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
