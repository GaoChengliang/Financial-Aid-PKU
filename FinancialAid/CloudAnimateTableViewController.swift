//
//  CloudAnimateTableViewController.swift
//  FinancialAid
//
//  Created by PengZhao on 15/8/27.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

protocol RefreshAnimation : class {
    func refreshAnimationDidStart()
    func refreshAnimationDidFinish()
}

class CloudAnimateTableViewController: UITableViewController {

    var cloudRefresh: RefreshContents!
    var isAnimating = false
    var alpha: CGFloat = 0.0 {
        didSet {
            cloudRefresh.background.alpha = alpha
            cloudRefresh.refreshingImageView.alpha = alpha
            cloudRefresh.spot.alpha = 1.0 - alpha
        }
    }
    var titleForEmptyData: String {
        get {
            return NSLocalizedString("Network failure, please pull to refresh.",
                                     comment: "title for empty data set")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.tintColor = UIColor.clearColor()
            refreshControl.backgroundColor = UIColor.clearColor()
            cloudRefresh = RefreshContents(frame: refreshControl.bounds)
            refreshControl.addSubview(cloudRefresh)
            tableView.addSubview(refreshControl)
            return refreshControl
        }()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }

    override func viewDidDisappear(animated: Bool) {
        resetAnimiation()

        super.viewDidDisappear(animated)
    }

    func animateRefreshStep1() {
        isAnimating = true

        cloudRefresh.background.image = UIImage(named: "CloudBackground")
        cloudRefresh.refreshingImageView.image = UIImage(named: "Refresh")
        UIView.animateWithDuration(0.3, animations: { self.alpha = 1.0 }) {
            [weak self] in
            if $0 {
                self?.refreshAnimationDidStart()
            }
        }
    }

    func animateRefreshStep2() {
        cloudRefresh.background.image = UIImage(named: "Tick")
        UIView.animateWithDuration(0.6, animations: {
            self.cloudRefresh.background.alpha = 1.0
        }) { [weak self] in
            if $0 {
                self?.resetAnimiation()
            }
        }
    }

    func resetAnimiation() {
        cloudRefresh.refreshingImageView.layer.removeAnimationForKey("rotate")
        refreshControl?.endRefreshing()
        isAnimating = false
        alpha = 0
    }
}


extension CloudAnimateTableViewController: RefreshAnimation {

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        // Get the current size of the refresh controller
        var refreshBounds = refreshControl!.bounds

        // Distance the table has been pulled >= 0
        let pullDistance = max(0.0, -refreshControl!.frame.origin.y)

        // Calculate the pull ratio, between 0.0-1.0
        let pullRatio = min(max(pullDistance, 0.0), 100.0) / 50.0
        let scaleRatio = 1 + pullRatio

        // Set the encompassing view's frames
        refreshBounds.size.height = pullDistance

        cloudRefresh.spot.transform = CGAffineTransformMakeScale(scaleRatio, scaleRatio)
        cloudRefresh.frame = refreshBounds

        // If we're refreshing and the animation is not playing, then play the animation
        let refreshing = refreshControl?.refreshing ?? false
        if refreshing && !isAnimating {
            animateRefreshStep1()
        }
    }

    func refreshAnimationDidStart() {
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.toValue = M_PI * 2
        rotate.duration  = 0.9
        rotate.cumulative = true
        rotate.repeatCount = 1e7

        cloudRefresh.refreshingImageView.layer.addAnimation(rotate, forKey: "rotate")
    }

    func refreshAnimationDidFinish() {
        if !isAnimating {
            return
        }
        UIView.animateWithDuration(0.1, delay: 0.3, options: .CurveLinear, animations: {
            self.cloudRefresh.background.alpha = 0
            self.cloudRefresh.refreshingImageView.alpha = 0
        }) {
            [weak self] in
            if $0 {
                self?.animateRefreshStep2()
            }
        }

    }
}

extension CloudAnimateTableViewController: DZNEmptyDataSetSource {

    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "EmptyDataSetBackground")
    }

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0),
            NSForegroundColorAttributeName:
                UIColor(red: 225.0 / 255.0,
                        green: 225.0 / 255.0,
                        blue: 236.0 / 255.0,
                        alpha: 1.0)
        ]
        return NSAttributedString(string: titleForEmptyData, attributes: attributes)
    }
}

extension CloudAnimateTableViewController: DZNEmptyDataSetDelegate {

    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }

    func emptyDataSetShouldAllowTouch(scrollView: UIScrollView!) -> Bool {
        return false
    }
}
