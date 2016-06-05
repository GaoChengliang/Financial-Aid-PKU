//
//  ShowDeleteImageViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/6/4.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class ShowDeleteImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Delete",
            comment: "delete image"), style: .Done, target: self,
                action: #selector(ShowDeleteImageViewController.deleteAlert))


        scrollView.delegate = self
        imageView.sd_setImageWithURL(NSURL(string: (idImage.imageUrl)))
    }

    private struct Constants {
        static let UnwindToUploadImageIdentifier = "UnwindToUploadImage"
    }

    var idImage: IDImage!

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var imageView: UIImageView!

    func deleteAlert() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("Confirm delete",
            comment: "confirm delete image"), preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Delete",
            comment: "delete image"), style: .Default) {
                action in self.deleteImage()
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel",
            comment: "cancel delete image"), style: .Cancel) {
            action in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func deleteImage() {
        ContentManager.sharedInstance.deleteImage("\(idImage.ID)") {
            (error) in
            if let error = error {
                if case NetworkErrorType.NetworkUnreachable(_) = error {
                    SVProgressHUD.showErrorWithStatus(
                        NSLocalizedString("Network timeout",
                            comment: "network timeout or interruptted")
                    )
                } else if case NetworkErrorType.NetworkWrongParameter(_, let errno) = error {
                    if errno == 301 {
                        SVProgressHUD.showErrorWithStatus(
                            NSLocalizedString("Can not find image",
                                comment: "can not find image")
                        )
                    } else if errno == 302 {
                        SVProgressHUD.showErrorWithStatus(
                            NSLocalizedString(
                                "Privilege error",
                                comment: "this is not your photo")
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
                    NSLocalizedString("Delete image success", comment: "delete image success")
                )
                SDImageCache.sharedImageCache().removeImageForKey(self.idImage.imageUrl, fromDisk: true)
                self.performSegueWithIdentifier(Constants.UnwindToUploadImageIdentifier, sender: self)
            }
        }
    }
}


extension ShowDeleteImageViewController: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
