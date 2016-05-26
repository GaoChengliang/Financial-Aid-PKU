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
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        navigationItem.backBarButtonItem = {
            let backButtonItem = UIBarButtonItem()
            backButtonItem.title = AppConstant.Catalog
            return backButtonItem
        }()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        retriveFormList()
    }

    func retriveFormList() {
        formList = [
            Form(name: "excel 1", startDate: NSDate(), endDate: NSDate()),
            Form(name: "excel 2", startDate: NSDate(), endDate: NSDate()),
            Form(name: "excel 3", startDate: NSDate(), endDate: NSDate())
        ]
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier,
                       forIndexPath: indexPath) as? FormTableViewCell
            else { return UITableViewCell() }
        let form = formList[indexPath.row]
        cell.setupWithName(form.name, startDate: form.startDate, endDate: form.endDate)
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("FormOptionSegue",
                                   sender: tableView.cellForRowAtIndexPath(indexPath))
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "FormOptionSegue":
                let cell = sender as! UITableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    let MVC = segue.destinationViewController as! FormOptionTableViewController
                    MVC.title = "表格\(indexPath.row)"
                }
            default: break
            }
        }
    }
}

extension FormTableViewController {
    override func animationDidStart() {
        retriveFormList()
    }
}
