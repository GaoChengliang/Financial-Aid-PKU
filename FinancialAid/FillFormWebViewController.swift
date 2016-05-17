//
//  FillFormWebViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/17.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class FillFormWebViewController: UIViewController, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.baidu.com")!))
    }

    @IBOutlet weak var webView: UIWebView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
