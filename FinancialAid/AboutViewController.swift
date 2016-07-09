//
//  HomeViewController.swift
//  FinancialAid
//
//  Created by PengZhao on 16/6/14.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import CoreLocation

class AboutViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewDidLayoutSubviews() {
        self.textView.setContentOffset(CGPoint.zero, animated: false)
    }
}
