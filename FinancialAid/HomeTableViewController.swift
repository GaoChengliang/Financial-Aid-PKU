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

    private struct Constants {
        static let newsCellIdentifier = "NewsCell"
        static let newsTitleCellIdentifier = "NewsTitleCell"
        static let newsDetailSegueIdentifier = "NewsDetailSegue"
        static let bannerNewsDetailSegueIdentifier = "BannerNewsDetailSegue"
    }

    @IBOutlet weak var cycleBanner: SDCycleScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        cycleBanner.delegate = self
        cycleBanner.placeholderImage = UIImage(named: "Loading")
        cycleBanner.backgroundColor = UIColor.whiteColor()
        cycleBanner.bannerImageViewContentMode = .ScaleAspectFit
        cycleBanner.showPageControl = true
        cycleBanner.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleBanner.currentPageDotColor = UIColor.redColor()
        cycleBanner.pageDotColor = UIColor.whiteColor()
        cycleBanner.autoScrollTimeInterval = 4
        getNewsList()
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return listNews.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath)
        -> CGFloat {
        if indexPath.section == 0 {
            return 44
        }
        return 60
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(
                Constants.newsTitleCellIdentifier, forIndexPath: indexPath)
            return cell
        }

        if let cell = tableView.dequeueReusableCellWithIdentifier(
            Constants.newsCellIdentifier, forIndexPath: indexPath) as? NewsTableViewCell {
            let news = listNews[indexPath.row]
            cell.title.text = news.title
            cell.newsImageView.sd_setImageWithURL(NSURL(string: news.imageUrl)!)
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            performSegueWithIdentifier(Constants.newsDetailSegueIdentifier,
                                       sender: tableView.cellForRowAtIndexPath(indexPath))
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifer = segue.identifier else { return }
        switch segueIdentifer {
        case Constants.newsDetailSegueIdentifier:
            if let fwvc = segue.destinationViewController as? FormWebViewController {
                if let cell = sender as? NewsTableViewCell {
                    let indexPath = tableView.indexPathForCell(cell)
                    fwvc.title = listNews[(indexPath?.row)!].title
                    fwvc.url = NSURL(string: listNews[(indexPath?.row)!].url)
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
