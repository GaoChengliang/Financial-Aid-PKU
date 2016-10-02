//
//  MessageDetailViewController.swift
//  FinancialAid
//
//  Created by 高成良 on 16/10/2.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = message.title
        messageContentTextView.text = message.content
    }
    
    override func viewDidLayoutSubviews() {
        self.messageContentTextView.setContentOffset(CGPoint.zero, animated: false)
    }

    var message: Message!
    
    @IBOutlet weak var messageContentTextView: UITextView!

}
