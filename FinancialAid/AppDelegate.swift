//
//  AppDelegate.swift
//  FinancialAid
//
//  Created by PengZhao on 16/5/17.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication,
         didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
            -> Bool {
        // Override point for customization after application launch.
        CocoaLumberjack.config()

        return true
    }
}
