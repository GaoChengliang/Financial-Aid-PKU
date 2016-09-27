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

    var timer = Timer()
    var url: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: url))
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
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                       selector:
                                                       #selector(FormWebViewController.timerCallback),
                                                       userInfo: nil,
                                                       repeats: true)
    }

    func finishLoad() {
        progressBar.progress = 1.0
        timer.invalidate()
        UIView.animate(withDuration: 0.2, animations: {
            self.progressBar.alpha = 0
        })
    }

}

extension FormWebViewController: UIWebViewDelegate {

    func webViewDidStartLoad(_ webView: UIWebView) {
        startLoad()
    }


    func webViewDidFinishLoad(_ webView: UIWebView) {
        finishLoad()
    }
}
