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

    fileprivate struct Constants {
        static let newsCellIdentifier = "NewsCell"
        static let newsDetailSegueIdentifier = "NewsDetailSegue"
        static let bannerNewsDetailSegueIdentifier = "BannerNewsDetailSegue"
        static let messageSegueIdentifier = "MessageSegue"
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
        cycleBanner.backgroundColor = UIColor.white
        cycleBanner.bannerImageViewContentMode = .scaleAspectFill
        cycleBanner.showPageControl = true
        cycleBanner.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleBanner.currentPageDotColor = UIColor(red: 148.0/255.0,
                                                  green: 7.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        cycleBanner.pageDotColor = UIColor.white
        cycleBanner.autoScrollTimeInterval = 5
        tableView.tableHeaderView = UIView(frame: rect)
        tableView.tableHeaderView?.addSubview(self.cycleBanner)
        getNewsList()
    }

    @IBAction func messageList(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.messageSegueIdentifier, sender: self)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Open location",
            comment: "request open location"), message: "", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Set",
            comment: "go to set"), style: .default) {
                action in
                if let setURL = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(setURL)
                }
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel",
            comment: "cancel set"), style: .cancel) {
                action in
                alert.dismiss(animated: true, completion: nil)
        }

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
                    let tempNews: News! = News.mj_object(withKeyValues: news.description)
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
                SVProgressHUD.showError(
                    withStatus: NSLocalizedString("Network timeout",
                        comment: "network timeout or interruptted")
                )
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        cycleBanner.clearCache()
        let imageCache: SDImageCache! = SDImageCache.shared()
        imageCache.clearMemory()
        imageCache.clearDisk()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
        -> CGFloat {
            return 60
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return listNews.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.newsCellIdentifier, for: indexPath) as? NewsTableViewCell {
            let news = listNews[(indexPath as NSIndexPath).section]
            cell.title.text = news.title
            cell.newsImageView.sd_setImage(with: URL(string: news.imageUrl)!)
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.newsDetailSegueIdentifier,
                                    sender: tableView.cellForRow(at: indexPath))

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifer = segue.identifier else { return }
        switch segueIdentifer {
        case Constants.newsDetailSegueIdentifier:
            if let fwvc = segue.destination as? FormWebViewController {
                if let cell = sender as? NewsTableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    fwvc.title = listNews[((indexPath as NSIndexPath?)?.section)!].title
                    fwvc.url = URL(string: listNews[((indexPath as NSIndexPath?)?.section)!].url)
                }
            }
        case Constants.bannerNewsDetailSegueIdentifier:
            if let fwvc = segue.destination as? FormWebViewController {
                fwvc.title = bannerTitles[bannerIndex]
                fwvc.url = URL(string: bannerNews[bannerIndex].url)
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
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        bannerIndex = index
        performSegue(withIdentifier: Constants.bannerNewsDetailSegueIdentifier, sender: self)
    }
}
