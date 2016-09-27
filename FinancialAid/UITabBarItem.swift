//
//  UITabbarItem.swift
//  FinancialAid
//
//  Created by PengZhao on 16/1/19.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

extension UITabBarItem {

    class func config() {
        UITabBarItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName:
                UIColor(red: 244.0 / 255.0,
                        green: 67.0 / 255.0,
                        blue: 54.0 / 255.0,
                        alpha: 1.0)
        ], for: .selected)
    }
}
