//
//  SVProgressHUD.swift
//  iBeaconToy
//
//  Created by PengZhao on 16/1/2.
//  Copyright © 2016年 pku. All rights reserved.
//

import SVProgressHUD

extension SVProgressHUD {

    class func config() {
        SVProgressHUD.setDefaultMaskType(.Black)
//        SVProgressHUD.setDefaultStyle(.Custom)
        SVProgressHUD.setBackgroundColor(UIColor.flatWhiteColor())
        SVProgressHUD.setForegroundColor(UIColor.flatGrayColorDark().darkenByPercentage(0.3))
        SVProgressHUD.setFont(UIFont.systemFontOfSize(14.0))
        SVProgressHUD.setErrorImage(UIImage(named: "Error"))
        SVProgressHUD.setSuccessImage(UIImage(named: "Success"))
        SVProgressHUD.setRingThickness(5.0)
    }
}
