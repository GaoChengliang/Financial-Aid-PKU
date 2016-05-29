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
        title = form.name
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if indexPath.row == 0 {
            performSegueWithIdentifier("FormFillSegue", sender: cell)
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let fwvc = segue.destinationViewController as? FormWebViewController else { return }
        guard let segueIdentifer = segue.identifier else { return }
        switch segueIdentifer {
        case Constants.HelpSegueIdentifier:
            fwvc.title = NSLocalizedString("Tips", comment: "tips for filling the form")
        case Constants.FillFormSegueIdentifier:
            fwvc.title = NSLocalizedString("Fill form", comment: "fill the form")
        default:
            break
        }
    }

}
