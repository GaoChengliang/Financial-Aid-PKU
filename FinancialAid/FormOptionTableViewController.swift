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
        let enables = [form.isStepFill, form.isStepPdf, form.isStepUpload]
        let enable = enables[indexPath.row]
        cell.userInteractionEnabled = enable
        // MARK: change color
        if !enable {
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
            fwvc.url = NetworkManager.sharedInstance.relativeURL(form.helpPath)
        case Constants.FillFormSegueIdentifier:
            fwvc.title = NSLocalizedString("Fill form", comment: "fill the form")
            fwvc.url = NetworkManager.sharedInstance.relativeURL(form.fillPath)
        default:
            break
        }
    }

}
