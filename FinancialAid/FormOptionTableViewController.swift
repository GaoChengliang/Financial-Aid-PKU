//
//  FormOptionTableViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/19.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        if !enable {
            cell.textLabel?.textColor = .lightGrayColor()
            cell.accessoryType = .None
        } else {
            cell.textLabel?.textColor = .blackColor()
            cell.accessoryType = .DisclosureIndicator
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == NSIndexPath(forRow: 1, inSection: 0) {
            ContentManager.sharedInstance.getPDF("\(form.ID)", email: User.sharedInstance.email) {
                (error) in
                if let error = error {
                    if case NetworkErrorType.NetworkUnreachable(_) = error {
                        SVProgressHUD.showErrorWithStatus(
                            NSLocalizedString("Network timeout",
                                comment: "network timeout or interruptted")
                        )
                    } else if case NetworkErrorType.NetworkWrongParameter(_, let errno) = error {
                        if errno == 201 {
                            SVProgressHUD.showErrorWithStatus(
                                NSLocalizedString("You have not filled the form",
                                    comment: "form not filled")
                            )
                        } else if errno == 203 {
                            SVProgressHUD.showErrorWithStatus(
                                NSLocalizedString(
                                    "Email address is not valid, please update in personal center",
                                    comment: "email address is not valid")
                            )
                        } else {
                            SVProgressHUD.showErrorWithStatus(
                                NSLocalizedString("Server error occurred",
                                    comment: "unknown error")
                            )
                        }
                    }
                } else {
                    SVProgressHUD.showSuccessWithStatus(
                        NSLocalizedString("The PDF is sent to your email address", comment: "Get PDF success")
                    )
                }
            }
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
            fwvc.url = NetworkManager.sharedInstance.relativeURL(form.helpPath)
        case Constants.FillFormSegueIdentifier:
            fwvc.title = NSLocalizedString("Fill form", comment: "fill the form")
            fwvc.url = NetworkManager.sharedInstance.relativeURL(form.fillPath)
        default:
            break
        }
    }

}
