//
//  MessageTableViewController.swift
//  FinancialAid
//
//  Created by 高成良 on 16/10/1.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import SVProgressHUD

class MessageTableViewController: CloudAnimateTableViewController {
    
    var messages = [Message]()
    var currentPage = 0
    let messageNumEveryPage = 10
    
    var pagingSpinner: UIActivityIndicatorView!
    
    fileprivate struct Constants {
        static let messageCellIdentifier = "MessageCell"
        static let messageDetailSegueIdentifier = "MessageDetailSegue"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("My Message",
                                       comment: "my message list")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = CGFloat(48)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        pagingSpinner.startAnimating()
        pagingSpinner.frame = CGRect(x: 0, y: 0, width: 320, height: 44)
        getMessageList(currentPage)
    }
    
    func getMessageList(_ currentPage: Int) {
        NetworkManager.sharedInstance.getMessage(messageNumEveryPage, skip: currentPage * messageNumEveryPage) {
            (json, error) in
            if error == nil, let json = json {
            
                let messageArray = json["data"].arrayValue
                for message in messageArray {
                    self.messages.append(Message.mj_object(withKeyValues: message.description))
                }
                
                self.tableView.reloadData()
                self.tableView.tableFooterView = UIView(frame: CGRect.zero)
                self.refreshAnimationDidFinish()
                
            } else {
                self.tableView.tableFooterView = UIView(frame: CGRect.zero)
                self.refreshAnimationDidFinish()
                SVProgressHUD.showError(
                    withStatus: NSLocalizedString("Network timeout",
                                                  comment: "network timeout or interruptted")
                )
            }
        }
    }


    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.messageCellIdentifier, for: indexPath) as? MessageTableViewCell {
            let message = messages[(indexPath as NSIndexPath).section]
            cell.setupWithTitle(message.title, createdTime: message.createdTime)
            return cell
        }
        return UITableViewCell()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MessageTableViewController {
    override func refreshAnimationDidStart() {
        super.refreshAnimationDidStart()
        messages.removeAll()
        currentPage = 0
        getMessageList(currentPage)
    }
}
