//
//  FormWebViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/19.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class FormWebViewController: UIViewController {

    @IBOutlet weak var progressBar: ProgressView!
    @IBOutlet weak var webView: UIWebView!

    var timer = NSTimer()
    var url: NSURL? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        print(url)
        webView.loadRequest(NSURLRequest(URL: url!))
    }

    func timerCallback() {
        guard progressBar.progress < 0.9 else { return }
        progressBar.progress += 0.15
    }

    func startLoad() {
        guard progressBar.progress == 0 else { return }
        progressBar.progress = 0
        progressBar.alpha = 1.0
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self,
                                                       selector:
                                                       #selector(FormWebViewController.timerCallback),
                                                       userInfo: nil,
                                                       repeats: true)
    }

    func finishLoad() {
        progressBar.progress = 1.0
        timer.invalidate()
        UIView.animateWithDuration(0.2) {
            self.progressBar.alpha = 0
        }
    }

}

extension FormWebViewController: UIWebViewDelegate {

    func webViewDidStartLoad(webView: UIWebView) {
        startLoad()
    }


    func webViewDidFinishLoad(webView: UIWebView) {
        finishLoad()
    }
}
