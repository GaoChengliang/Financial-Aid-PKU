//
//  FormOptionTableViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/19.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class FormOptionTableViewController: UITableViewController {

    // Inited from prepare for segue
    var form: Form!

    private struct Constants {
        static let HelpSegueIdentifier = "FormGuideSegue"
        static let FillFormSegueIdentifier = "FormFillSegue"
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        title = form.name
        if form.isStepHelp {
            let barItem = UIBarButtonItem(image: UIImage(named: "FillFormGuide"),
                                          style: .Done, target: self,
                                          action: #selector(FormOptionTableViewController.formHelp))
            self.navigationItem.rightBarButtonItem = barItem
        }

    }

    func formHelp() {
        performSegueWithIdentifier(Constants.HelpSegueIdentifier, sender: self)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if indexPath.row == 0 && !form.isStepFill {
            cell.userInteractionEnabled = false
            cell.accessoryType = .None
        }
        if indexPath.row == 1 && !form.isStepPdf {
            cell.userInteractionEnabled = false
            cell.accessoryType = .None
        }
        if indexPath.row == 2 && !form.isStepUpload {
            cell.userInteractionEnabled = false
            cell.accessoryType = .None
        }
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let fwvc = segue.destinationViewController as? FormWebViewController else { return }
        guard let segueIdentifer = segue.identifier else { return }
        switch segueIdentifer {
        case Constants.HelpSegueIdentifier:
            fwvc.title = NSLocalizedString("Tips", comment: "tips for filling the form")
            fwvc.url = NSURL(string: form.helpPath)
        case Constants.FillFormSegueIdentifier:
            fwvc.title = NSLocalizedString("Fill form", comment: "fill the form")
            fwvc.url = NSURL(string: form.fillPath)
        default:
            break
        }
    }

}
