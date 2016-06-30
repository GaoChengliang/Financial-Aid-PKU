//
//  HomeTableViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/6/29.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDCycleScrollView
import SDWebImage

class HomeTableViewController: CloudAnimateTableViewController {

    var listNews = [News]()
    var bannerNews = [News]()
    var bannerImageUrls = [String]()
    var bannerTitles = [String]()
    var bannerIndex = 0
    var cycleBanner: SDCycleScrollView!

    private struct Constants {
        static let newsCellIdentifier = "NewsCell"
        static let newsDetailSegueIdentifier = "NewsDetailSegue"
        static let bannerNewsDetailSegueIdentifier = "BannerNewsDetailSegue"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
//        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied {
//            showAlert()
//        }
        let rect = CGRect(x: 0, y: 0, width: tableView.bounds.width,
                          height: (tableView.bounds.width * 0.5625))
        cycleBanner = SDCycleScrollView(frame: rect)
        cycleBanner.delegate = self
        cycleBanner.backgroundColor = UIColor.whiteColor()
        cycleBanner.bannerImageViewContentMode = .ScaleAspectFit
        cycleBanner.showPageControl = true
        cycleBanner.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleBanner.currentPageDotColor = UIColor.redColor()
        cycleBanner.pageDotColor = UIColor.whiteColor()
        cycleBanner.autoScrollTimeInterval = 5
        tableView.tableHeaderView = UIView(frame: rect)
        tableView.tableHeaderView?.addSubview(self.cycleBanner)
        getNewsList()
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

    func getNewsList() {
        NetworkManager.sharedInstance.getNews() {
            (json, error) in
            if error == nil, let json = json {
                self.bannerNews.removeAll()
                self.bannerImageUrls.removeAll()
                self.bannerTitles.removeAll()
                self.listNews.removeAll()
                let newsArray = json["data"].arrayValue
                for news in newsArray {
                    let tempNews = News.mj_objectWithKeyValues(news.description)
                    if tempNews.type == 1 {
                        self.bannerNews.append(tempNews)
                        self.bannerImageUrls.append(tempNews.imageUrl)
                        self.bannerTitles.append(tempNews.title)
                    }
                    if tempNews.type == 2 {
                        self.listNews.append(tempNews)
                        self.tableView.reloadData()
                    }
                }
                self.cycleBanner.imageURLStringsGroup = self.bannerImageUrls
                self.cycleBanner.titlesGroup = self.bannerTitles
                self.tableView.reloadData()
                self.refreshAnimationDidFinish()
            } else {
                self.refreshAnimationDidFinish()
                SVProgressHUD.showErrorWithStatus(
                    NSLocalizedString("Network timeout",
                        comment: "network timeout or interruptted")
                )
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        cycleBanner.clearCache()
        let imageCache = SDImageCache.sharedImageCache()
        imageCache.clearMemory()
        imageCache.clearDisk()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath)
        -> CGFloat {
            return 60
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return listNews.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {

        if let cell = tableView.dequeueReusableCellWithIdentifier(
            Constants.newsCellIdentifier, forIndexPath: indexPath) as? NewsTableViewCell {
            let news = listNews[indexPath.section]
            cell.title.text = news.title
            cell.newsImageView.sd_setImageWithURL(NSURL(string: news.imageUrl)!)
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Constants.newsDetailSegueIdentifier,
                                    sender: tableView.cellForRowAtIndexPath(indexPath))

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifer = segue.identifier else { return }
        switch segueIdentifer {
        case Constants.newsDetailSegueIdentifier:
            if let fwvc = segue.destinationViewController as? FormWebViewController {
                if let cell = sender as? NewsTableViewCell {
                    let indexPath = tableView.indexPathForCell(cell)
                    fwvc.title = listNews[(indexPath?.section)!].title
                    fwvc.url = NSURL(string: listNews[(indexPath?.section)!].url)
                }
            }
        case Constants.bannerNewsDetailSegueIdentifier:
            if let fwvc = segue.destinationViewController as? FormWebViewController {
                fwvc.title = bannerTitles[bannerIndex]
                fwvc.url = NSURL(string: bannerNews[bannerIndex].url)
            }
        default:
            break
        }
    }
}

extension HomeTableViewController {
    override func refreshAnimationDidStart() {
        super.refreshAnimationDidStart()
        getNewsList()
    }
}

extension HomeTableViewController: SDCycleScrollViewDelegate {
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        bannerIndex = index
        performSegueWithIdentifier(Constants.bannerNewsDetailSegueIdentifier, sender: self)
    }
}
