//
//  UITabbarItem.swift
//  FinancialAid
//
//  Created by PengZhao on 16/1/19.
//  Copyright © 2016年 pku. All rights reserved.
//

import ChameleonFramework

extension UITabBarItem {

    class func config() {
        UITabBarItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName : UIColor.flatWatermelonColor()
        ], forState: .Selected)
    }
}
