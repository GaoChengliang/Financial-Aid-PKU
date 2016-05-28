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

class UserTableViewController: UITableViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    let name = [AppConstants.Gender, AppConstants.Birthday, AppConstants.PhoneNumber, AppConstants.Email]
    let value = ["女", "1996-11-11", "13888888888", "hmm@pku.edu.cn"]

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 1 {
            return 4
        }
        return 1
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("UserPortraitTableViewCell", forIndexPath: indexPath) as! UserPortraitTableViewCell
            cell.portrait.image = UIImage(named: "portrait1")
            cell.name.text = "韩梅梅"
            cell.studentID.text = "1700017888"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("UserInformationTableViewCell", forIndexPath: indexPath)
            let row = indexPath.row
            cell.textLabel?.text = name[row]
            cell.detailTextLabel?.text = value[row]
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingTableViewCell", forIndexPath: indexPath)
            return cell
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        return 44
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            editImage()
        case 1:
            if indexPath.row == 0 {
                performSegueWithIdentifier("EditGenderSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
            }

            if indexPath.row == 1 {
                performSegueWithIdentifier("EditBirthdaySegue", sender: tableView.cellForRowAtIndexPath(indexPath))
            }

            if indexPath.row == 2 || indexPath.row == 3 {
                performSegueWithIdentifier("EditProfileSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
            }

        default:
            performSegueWithIdentifier("SettingSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "EditProfileSegue":
//                let cell = sender as! UserInformationTableViewCell
//                if let indexPath = tableView.indexPathForCell(cell) {
//                    let MVC = segue.destinationViewController as! EditProfileViewController
//                    MVC.title = name[indexPath.row]
//                    MVC.index = indexPath.row
//                    MVC.value = value[indexPath.row]
//                }
                fallthrough
            case "EditGenderSegue":
                let MVC = segue.destinationViewController as! EditGenderTableViewController
                MVC.gender = 1
            default: break
            }
        }
    }


    func editImage() {
        let alertController = UIAlertController(title: AppConstants.EditPortrait, message: nil, preferredStyle:UIAlertControllerStyle.ActionSheet)
        let alertActionCamera = UIAlertAction(title: AppConstants.OpenCamera, style: UIAlertActionStyle.Default) {
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
        let alertActionAlbum = UIAlertAction(title: AppConstants.OpenAlbum, style: UIAlertActionStyle.Default) {
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


        let alertActionCancel = UIAlertAction(title: AppConstants.Cancel, style: UIAlertActionStyle.Cancel) {
            alert in  alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(alertActionCancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }




    // 打开照片 delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
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
