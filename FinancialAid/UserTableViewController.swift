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

class UserTableViewController: UITableViewController,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = AppConstant.Me
        self.navigationItem.backBarButtonItem = backItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 1:
            return 4
        default:
            return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("UserPortraitTableViewCell", forIndexPath: indexPath) as! UserPortraitTableViewCell
            cell.portrait.image = UIImage(named: "portrait1")
            cell.name.text = "韩梅梅"
            cell.SID.text = "1700017888"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("UserInformationTableViewCell", forIndexPath: indexPath) as! UserInformationTableViewCell
            switch indexPath.row {
            case 0:
                cell.name.text = "性别"
                cell.value.text = "女"
            case 1:
                cell.name.text = "生日"
                cell.value.text = "1996-11-11"
            case 2:
                cell.name.text = "电话号码"
                cell.value.text = "13888888888"
            default:
                cell.name.text = "邮箱"
                cell.value.text = "hmm@pku.edu.cn"
            }
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
            
        default:
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            performSegueWithIdentifier("SettingSegue", sender: cell)
        }
    }
    
    
    func editImage() {
        let alertController = UIAlertController(title: AppConstant.EditPortrait, message: nil, preferredStyle:UIAlertControllerStyle.ActionSheet)
        let alertActionCamera = UIAlertAction(title: AppConstant.OpenCamera, style: UIAlertActionStyle.Default){
            alert in
            if UIImagePickerController.isSourceTypeAvailable(.Camera){
                let picker = UIImagePickerController()
                picker.sourceType = .Camera
                picker.mediaTypes = [String(kUTTypeImage)]
                picker.delegate = self
                picker.allowsEditing = true
                self.presentViewController(picker, animated: true, completion: nil)
            }
        }
        alertController.addAction(alertActionCamera)
        let alertActionAlbum = UIAlertAction(title: AppConstant.OpenAlbum, style: UIAlertActionStyle.Default){
            alert in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
                let picker = UIImagePickerController()
                picker.sourceType = .PhotoLibrary
                picker.mediaTypes = [String(kUTTypeImage)]
                picker.delegate = self
                picker.allowsEditing = true
                self.presentViewController(picker, animated: true, completion: nil)
            }
        }
        alertController.addAction(alertActionAlbum)
        
        
        let alertActionCancel = UIAlertAction(title: AppConstant.Cancel, style: UIAlertActionStyle.Cancel){
            alert in  alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(alertActionCancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    
    // 打开照片 delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
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
