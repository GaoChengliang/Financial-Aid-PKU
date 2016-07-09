//
//  ShowImageViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/31.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class ShowUploadImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    private struct Constants {
        static let UnwindToUploadImageIdentifier = "UnwindToUploadImage"
    }

    var image: UIImage?
    var formID = 0
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = image
        }
    }
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func uploadImage() {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                SVProgressHUD.show()
                NetworkManager.sharedInstance.uploadImage(self.formID, imageData: imageData) {
                    res in
                    if res.result.isSuccess {
                        let json = JSON(res.result.value!)
                        let error = json["error"].intValue
                        if error == 0 {
                            SVProgressHUD.showSuccessWithStatus(
                                        NSLocalizedString("Upload image success",
                                            comment: "upload image success")
                            )
                            self.performSegueWithIdentifier(Constants
                                .UnwindToUploadImageIdentifier, sender: self)
                        } else if error == 201 {
                            SVProgressHUD.showErrorWithStatus(
                                               NSLocalizedString("You have not filled the form",
                                                   comment: "form not filled")
                            )
                        } else {
                            SVProgressHUD.showErrorWithStatus(
                                NSLocalizedString("Server error occurred",
                                    comment: "unknown error")
                            )
                        }
                    } else {
                        SVProgressHUD.showErrorWithStatus(
                                        NSLocalizedString("Network timeout",
                                           comment: "network timeout or interruptted")
                        )
                    }
                }
            }
        }
    }
}

extension ShowUploadImageViewController: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
