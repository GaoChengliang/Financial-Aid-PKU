//
//  FormTableViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/17.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import SVProgressHUD

class FormTableViewController: CloudAnimateTableViewController {

    private struct Constants {
        static let cellIdentifier = "FormTableViewCell"
        static let segueIdentifier = "FormOptionSegue"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        retriveFormList()
    }

    func retriveFormList() {
        ContentManager.sharedInstance.formList {
            if $0 != nil {
                SVProgressHUD.showErrorWithStatus(
                    NSLocalizedString("Network timeout",
                        comment: "network timeout or interruptted")
                )
            }
            self.tableView.reloadData()
            self.refreshAnimationDidFinish()
        }
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FormList.sharedInstance.count
    }

    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier,
                       forIndexPath: indexPath) as? FormTableViewCell
            else { return UITableViewCell() }
        let form = FormList.sharedInstance[indexPath.row]
        cell.setupWithName(form.name, startDate: form.startDate, endDate: form.endDate, status: form.status)
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Constants.segueIdentifier,
                                   sender: tableView.cellForRowAtIndexPath(indexPath))
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard
            let fotvc = segue.destinationViewController as? FormOptionTableViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPathForCell(cell)
            else { return }

        fotvc.form = FormList.sharedInstance[indexPath.row]
    }
}

extension FormTableViewController {
    override func refreshAnimationDidStart() {
        super.refreshAnimationDidStart()
        retriveFormList()
    }
}
