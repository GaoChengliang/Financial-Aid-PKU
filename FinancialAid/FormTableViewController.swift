//
//  FormTableViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/17.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class FormTableViewController: CloudAnimateTableViewController {

    var formList = [Form]() {
        didSet {
            tableView.reloadData()
        }
    }

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
//        NetworkManager.sharedInstance.
        formList.append(Form())
        refreshAnimationDidFinish()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formList.count
    }

    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier,
                       forIndexPath: indexPath) as? FormTableViewCell
            else { return UITableViewCell() }
        let form = formList[indexPath.row]
        cell.setupWithName(form.name, startDate: form.startDate, endDate: form.endDate)
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

        fotvc.form = formList[indexPath.row]
    }
}

extension FormTableViewController {
    override func refreshAnimationDidStart() {
        super.refreshAnimationDidStart()
        retriveFormList()
    }
}
