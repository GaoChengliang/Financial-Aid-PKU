//
//  SVProgressHUD.swift
//  FinancialAid
//
//  Created by PengZhao on 16/1/2.
//  Copyright © 2016年 pku. All rights reserved.
//

import SVProgressHUD

extension SVProgressHUD {

    class func config() {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.darkGray)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 14.0))
        SVProgressHUD.setErrorImage(UIImage(named: "Error"))
        SVProgressHUD.setSuccessImage(UIImage(named: "Success"))
        SVProgressHUD.setRingThickness(5.0)
        SVProgressHUD.setMinimumDismissTimeInterval(2.0)
    }
}
