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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    fileprivate struct Constants {
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
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func uploadImage() {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                SVProgressHUD.show()
                NetworkManager.sharedInstance.uploadImage(self.formID, imageData: imageData as NSData) {
                    res in
                    if res.result.isSuccess {
                        let json = JSON(res.result.value!)
                        let error = json["error"].intValue
                        if error == 0 {
                            SVProgressHUD.showSuccess(
                                withStatus: NSLocalizedString("Upload image success",
                                            comment: "upload image success")
                            )
                            self.performSegue(withIdentifier: Constants
                                .UnwindToUploadImageIdentifier, sender: self)
                        } else if error == 201 {
                            SVProgressHUD.showError(
                                withStatus: NSLocalizedString("You have not filled the form",
                                                   comment: "form not filled")
                            )
                        } else {
                            SVProgressHUD.showError(
                                withStatus: NSLocalizedString("Server error occurred",
                                    comment: "unknown error")
                            )
                        }
                    } else {
                        SVProgressHUD.showError(
                            withStatus: NSLocalizedString("Network timeout",
                                           comment: "network timeout or interruptted")
                        )
                    }
                }
            }
        }
    }
}

extension ShowUploadImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
