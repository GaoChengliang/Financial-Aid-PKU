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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInformation("1600016888", name: "韩梅梅", portrait: "portrait1", gender: "女",
                             birthday: "1996-11-11", phoneNum: "13888888888", email: "hmm@pku.edu.cn")
    }

    var user = User()
    var portrait = ""

    func setupUserInformation(studentID: String, name: String, portrait: String, gender: String,
                              birthday: String, phoneNum: String, email: String) {
        user.userName = studentID
        user.realName = name
        user.gender = gender
        user.birthday = birthday
        user.phone = phoneNum
        user.email = email
        self.portrait = portrait
        tableView.reloadData()
    }

    private struct Constants {
        static let EditGenderSegue = "EditGenderSegue"
        static let EditBirthdaySegue = "EditBirthdaySegue"
        static let EditPhoneSegue = "EditPhoneSegue"
        static let EditEmailSegue = "EditEmailSegue"
        static let SettingSegue = "SettingSegue"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if indexPath.section == 0 {
            if let cell_ = cell as? UserPortraitTableViewCell {
                cell_.name?.text = user.realName
                cell_.portrait?.image = UIImage(named: portrait)
                cell_.studentID?.text = user.userName
                return cell_
            }
        }
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = user.gender
            case 1:
                cell.detailTextLabel?.text = user.birthday
            case 2:
                cell.detailTextLabel?.text = user.phone
            default:
                cell.detailTextLabel?.text = user.email
            }
        }
        return cell
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            editImage()
        case 1:
            if indexPath.row == 0 {
                performSegueWithIdentifier(Constants.EditGenderSegue,
                                           sender: tableView.cellForRowAtIndexPath(indexPath))
            }
            if indexPath.row == 1 {
                performSegueWithIdentifier(Constants.EditBirthdaySegue,
                                           sender: tableView.cellForRowAtIndexPath(indexPath))
            }
            if indexPath.row == 2 {
                performSegueWithIdentifier(Constants.EditPhoneSegue,
                                           sender: tableView.cellForRowAtIndexPath(indexPath))
            }
            if indexPath.row == 3 {
                performSegueWithIdentifier(Constants.EditEmailSegue,
                                           sender: tableView.cellForRowAtIndexPath(indexPath))
            }
        default:
            performSegueWithIdentifier(Constants.SettingSegue,
                                       sender: tableView.cellForRowAtIndexPath(indexPath))
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.EditPhoneSegue:
                if let MVC = segue.destinationViewController as? EditProfileViewController {
                    MVC.title = NSLocalizedString("Phone number", comment: "phone number")
                    MVC.value = user.phone
                }
            case Constants.EditEmailSegue:
                if let MVC = segue.destinationViewController as? EditProfileViewController {
                    MVC.title = NSLocalizedString("Email", comment: "email")
                    MVC.value = user.email
                }
            case Constants.EditGenderSegue:
                if let MVC = segue.destinationViewController as? EditGenderTableViewController {
                    if user.gender == NSLocalizedString("Male", comment: "gender of user is male") {
                        MVC.gender = 0
                    } else {
                        MVC.gender = 1
                    }
                }
            default: break
            }
        }
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
            alert in  alertController.dismissViewControllerAnimated(true, completion: nil)
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
