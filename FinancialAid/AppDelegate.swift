//
//  AppDelegate.swift
//  FinancialAid
//
//  Created by PengZhao on 16/5/17.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import SVProgressHUD
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var siren: Siren!

    func application(application: UIApplication,
         didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
            -> Bool {
        sleep(1)
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(
            UIApplicationBackgroundFetchIntervalMinimum)

        // Override point for customization after application launch.
        CocoaLumberjack.config()
        SVProgressHUD.config()
        UITabBarItem.config()
//        LocationCellularManager.sharedInstance.getLocationCellular(nil)
        guard
            let userName = ContentManager.UserName where !userName.isEmpty,
            let password = ContentManager.Password where !password.isEmpty,
            let viewController = UIStoryboard.initViewControllerWithIdentifier(
                AppConstants.LoginViewControllerIdentifier
            ) as? LoginViewController else { return true }

        viewController.shouldAutoLogin = true
        window?.rootViewController = viewController
        setSiren()
        return true
    }

//    func applicationDidEnterBackground(application: UIApplication) {
//        LocationCellularManager.sharedInstance.stopGetLocationCellular()
//    }
//
//    func applicationWillEnterForeground(application: UIApplication) {
//        LocationCellularManager.sharedInstance.getLocationCellular(nil)
//    }


//    func application(application: UIApplication, performFetchWithCompletionHandler
//        completionHandler: (UIBackgroundFetchResult) -> Void) {
//        LocationCellularManager.sharedInstance.getLocationCellular {
//            completionHandler(.NewData)
//        }
//    }

    func setSiren() {
        siren = Siren.sharedInstance
        siren.majorUpdateAlertType = .Force
        siren.minorUpdateAlertType = .Skip
        siren.checkVersion(.Immediately)
    }
}
