//
//  UploadImageCollectionViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/6/4.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import DKImagePickerController
import SwiftyJSON
import SVProgressHUD
import SDWebImage

private let reuseIdentifier = "Cell"

class UploadImageCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImageList()
    }


    var formID = 0
    var idImages = [IDImage]()
    var image: UIImage?

    private struct Constants {
        static let ImageCollectionViewCellIdentifier = "ImageCollectionViewCell"
        static let UploadImageCollectionViewCellIdentifier = "UploadImageCollectionViewCell"
        static let ShowUploadImageSegueIdentifier = "ShowUploadImageSegue"
        static let ShowDeleteImageSegueIdentifier = "ShowDeleteImageSegue"
    }

    func fetchImageList() {
        NetworkManager.sharedInstance.getImageList("\(formID)") {
            (json, err) in
            if err == nil && json != nil {
                let error = json!["error"].intValue
                if error == 201 {
                    SVProgressHUD.showErrorWithStatus(
                        NSLocalizedString("You have not filled the form",
                            comment: "form not filled")
                    )
                } else {
                    if error == 0 {
                        let array = json!["data"].arrayValue
                        for idImage in array {
                            self.idImages.append(IDImage.mj_objectWithKeyValues(idImage.description))
                            self.collectionView?.reloadData()
                        }
                    }
                }
            } else {
                SVProgressHUD.showErrorWithStatus(
                    NSLocalizedString("Network timeout",
                        comment: "network timeout or interruptted")
                )
            }
        }
    }

    @IBAction func unwindToUploadImage(segue: UIStoryboardSegue) {
        idImages.removeAll()
        fetchImageList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        let imageCache = SDImageCache.sharedImageCache()
        imageCache.clearMemory()
        imageCache.clearDisk()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifer = segue.identifier else { return }
        switch segueIdentifer {
        case Constants.ShowDeleteImageSegueIdentifier:
            if let sdvc = segue.destinationViewController as? ShowDeleteImageViewController {
                if let cell = sender as? ImageCollectionViewCell {
                    let index = collectionView?.indexPathForCell(cell)
                    sdvc.idImage = idImages[(index?.item)!]
                }
            }
        case Constants.ShowUploadImageSegueIdentifier:
            if let suvc = segue.destinationViewController as? ShowUploadImageViewController {
                suvc.formID = self.formID
                suvc.image = self.image
            }
        default:
            break
        }
    }
}

extension UploadImageCollectionViewController {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView)
        -> Int {
            return 1
    }


    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return idImages.count + 1
    }

    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.item < idImages.count {
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                Constants.ImageCollectionViewCellIdentifier, forIndexPath: indexPath)
                as? ImageCollectionViewCell {
                cell.imageView.sd_setImageWithURL(NSURL(string:
                    idImages[indexPath.item].imageUrl), placeholderImage: UIImage(named: "Loading"))
                return cell
            }
        }
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            Constants.UploadImageCollectionViewCellIdentifier, forIndexPath: indexPath)
            as? UploadImageCollectionViewCell {
            return cell
        }
        return UICollectionViewCell()
    }
}

extension UploadImageCollectionViewController {
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath
        indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath
        indexPath: NSIndexPath) {
        if indexPath.item < idImages.count {
            self.performSegueWithIdentifier(Constants.ShowDeleteImageSegueIdentifier,
                                            sender: collectionView.cellForItemAtIndexPath(indexPath))
        } else {
            let pickerController = DKImagePickerController()
            pickerController.maxSelectableCount = 1
            pickerController.allowMultipleTypes = false
            pickerController.assetType = .AllPhotos
            pickerController.showsEmptyAlbums = false
            pickerController.autoDownloadWhenAssetIsInCloud = false
            pickerController.showsCancelButton = true
            pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
                for asset in assets {
                    asset.fetchImageWithSize(CGSize(width: 400, height: 800)) {
                        (image: UIImage?, _) in
                            self.image = image
                            self.performSegueWithIdentifier(Constants
                                .ShowUploadImageSegueIdentifier, sender: self)
                    }
                }
            }
            self.presentViewController(pickerController, animated: true) {}
        }
    }
}

extension UploadImageCollectionViewController : UICollectionViewDelegateFlowLayout {

    private struct Constant {
        static let CollectionCellMinimumItemSpacing: CGFloat   = 5.0
        static let CollectionViewTopMarginSpacing: CGFloat     = 10.0
        static let CollectionCellMininumBorder: CGFloat        = 10.0
    }

    func spacingForCollecionViewWidth(width: CGFloat) -> (leftSpacing: CGFloat,
            rightSpacing: CGFloat, interItemSpacing: CGFloat, cellSize: CGFloat) {
        for i in (1...10).reverse() {
            if CGFloat(i) * CGFloat(80) +
                CGFloat(i - 1) * Constant.CollectionCellMinimumItemSpacing +
                CGFloat(2) * Constant.CollectionCellMininumBorder < width {
                let extraSpacing = width - CGFloat(2) * Constant
                        .CollectionCellMininumBorder - CGFloat(i) * CGFloat(80)
                let itemSpacing = floor(extraSpacing / CGFloat(i - 1))
                return (floor(Constant.CollectionCellMininumBorder),
                        floor(Constant.CollectionCellMininumBorder), itemSpacing, CGFloat(80))
            }
        }

        return(floor(Constant.CollectionCellMininumBorder),
               floor(Constant.CollectionCellMininumBorder),
               floor(Constant.CollectionCellMinimumItemSpacing), floor(80))
    }



    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        var inset = UIEdgeInsetsZero
        inset.top = Constant.CollectionViewTopMarginSpacing
        (inset.left, inset.right, _, _) = spacingForCollecionViewWidth(
            collectionView.frame.width)

        return inset
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return spacingForCollecionViewWidth(
            collectionView.frame.width).interItemSpacing
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellSize = spacingForCollecionViewWidth(
            collectionView.frame.width).cellSize
        return  CGSize(width: cellSize, height: cellSize)
    }
}
