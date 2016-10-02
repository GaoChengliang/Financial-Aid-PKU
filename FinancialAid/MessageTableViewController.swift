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
    
    var allowLoadData = false
    var existPage = true
    
    var isAnimationStop = true
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentPage = 0
        getMessageList(0)
    }
    
    func getMessageList(_ page: Int) {
        
        allowLoadData = false
        
        if page == 0 {
            messages.removeAll()
            tableView.reloadData()
        }
        
        NetworkManager.sharedInstance.getMessage(messageNumEveryPage, skip: page * messageNumEveryPage) {
            (json, error) in
            if error == nil, let json = json {
            
                let messageArray = json["data"].arrayValue
                for message in messageArray {
                    self.messages.append(Message.mj_object(withKeyValues: message.description))
                }
                
                if messageArray.count < self.messageNumEveryPage {
                    self.existPage = false
                }
                
                if messageArray.count != 0 {
                    self.currentPage += 1
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
            
            self.allowLoadData = true
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
            
            if (allowLoadData && existPage && indexPath.section == self.messages.count - 1)
            {
                tableView.tableFooterView = pagingSpinner
                getMessageList(currentPage + 1)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.messageDetailSegueIdentifier, sender: tableView.cellForRow(at: indexPath))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifer = segue.identifier else { return }
        switch segueIdentifer {
        case Constants.messageDetailSegueIdentifier:
            if let mdvc = segue.destination as? MessageDetailViewController {
                if let cell = sender as? MessageTableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    mdvc.message = messages[((indexPath as NSIndexPath?)?.section)!]
                }
            }

        default:
            break
        }
    }
}

extension MessageTableViewController {
    
    override func refreshAnimationDidStart() {
        
        super.refreshAnimationDidStart()
        isAnimationStop = false
    
        if allowLoadData {
            currentPage = 0
            getMessageList(0)
            existPage = true
            
        } else {
            
            self.refreshAnimationDidFinish()
        }
    }
    
    override func refreshAnimationDidFinish() {
        
        if !isAnimationStop {
            
            super.refreshAnimationDidFinish()
            isAnimationStop = true
        }
    }
}
