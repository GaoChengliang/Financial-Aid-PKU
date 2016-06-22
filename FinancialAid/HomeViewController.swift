//
//  HomeViewController.swift
//  FinancialAid
//
//  Created by PengZhao on 16/6/14.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)

        textView.scrollRectToVisible(CGRect.zero, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Request location
//        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied {
//            showAlert()
//        }
    }

    func showAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Open location",
            comment: "request open location"), message: "", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Set",
            comment: "go to set"), style: .Default) {
                action in
                if let setURL = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(setURL)
                }
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel",
            comment: "cancel set"), style: .Cancel) {
                action in
                alert.dismissViewControllerAnimated(true, completion: nil)
        }

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
