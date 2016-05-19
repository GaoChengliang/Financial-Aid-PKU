//
//  FormOptionTableViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/19.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class FormOptionTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = nil
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCellWithIdentifier("FormGuideTableViewCell", forIndexPath: indexPath)
        }
        
        if indexPath.row == 1{
            cell = tableView.dequeueReusableCellWithIdentifier("FormFillTableViewCell", forIndexPath: indexPath)
        }
        
        if indexPath.row == 2{
            cell = tableView.dequeueReusableCellWithIdentifier("PDFTableViewCell", forIndexPath: indexPath)
        }
        
        if indexPath.row == 3{
            cell = tableView.dequeueReusableCellWithIdentifier("UploadImageTableViewCell", forIndexPath: indexPath)
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "FormGuideSegue":
                let MVC = segue.destinationViewController as! FormWebViewController
                MVC.option = 0
                
            case "FormFillSegue":
                let MVC = segue.destinationViewController as! FormWebViewController
                MVC.option = 1

            default: break
            }
        }
    }

}
