//
//  HomeViewController.swift
//  FinancialAid
//
//  Created by PengZhao on 16/6/14.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)

        textView.scrollRectToVisible(CGRect.zero, animated: true)
    }
}
