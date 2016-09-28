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

    fileprivate struct Constants {
        static let cellIdentifier = "FormTableViewCell"
        static let segueIdentifier = "FormOptionSegue"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        retriveFormList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retriveFormList()
    }

    func retriveFormList() {
        ContentManager.sharedInstance.formList {
            if $0 != nil {
                SVProgressHUD.showError(
                    withStatus: NSLocalizedString("Network timeout",
                        comment: "network timeout or interruptted")
                )
            }
            self.tableView.reloadData()
            self.refreshAnimationDidFinish()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return FormList.sharedInstance.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier,
                       for: indexPath) as? FormTableViewCell
            else { return UITableViewCell() }
        let form = FormList.sharedInstance[(indexPath as NSIndexPath).section]
        cell.setupWithName(form.name, startDate: form.startDate, endDate: form.endDate, status: form.status)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.segueIdentifier,
                                   sender: tableView.cellForRow(at: indexPath))
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let fotvc = segue.destination as? FormOptionTableViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell)
            else { return }
        fotvc.form = FormList.sharedInstance[(indexPath as NSIndexPath).section]
    }
}

extension FormTableViewController {
    override func refreshAnimationDidStart() {
        super.refreshAnimationDidStart()
        retriveFormList()
    }
}
