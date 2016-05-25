//
//  FormWebViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/19.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class FormWebViewController: UIViewController, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titles[option]
        progressView.progress = 0
        webView.delegate = self
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.baidu.com")!))
    }

    func webViewDidStartLoad(webView: UIWebView) {
        startLoad()
    }


    func webViewDidFinishLoad(webView: UIWebView) {
        finishLoad()
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        finishLoad()
    }



    var option = 0
    var titles = [AppConstant.TitleFormFillGuide, AppConstant.TitleFormFill]
    var loadFlag = false
    var myTimer: NSTimer = NSTimer()

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!

    func timerCallback() {
        if loadFlag {
            if progressView.progress >= 1 {
                progressView.hidden = true
                myTimer.invalidate()
            } else {
                progressView.progress += 0.1
            }
        } else {
            progressView.progress += 0.05
            if progressView.progress >= 0.90 {
                progressView.progress = 0.90
            }
        }
    }

    func startLoad() {
        loadFlag = false
        progressView.hidden = false
        progressView.progress = 0
        myTimer.invalidate()
        myTimer = NSTimer.scheduledTimerWithTimeInterval(0.01667, target: self, selector: #selector(FormWebViewController.timerCallback), userInfo: nil, repeats: true)
    }

    func finishLoad() {
        loadFlag = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
