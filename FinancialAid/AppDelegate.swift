//
//  AppDelegate.swift
//  FinancialAid
//
//  Created by PengZhao on 16/5/17.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication,
         didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
            -> Bool {
        // Override point for customization after application launch.
        CocoaLumberjack.config()
        SVProgressHUD.config()
        UITabBarItem.config()

        guard
            let userName = ContentManager.UserName where !userName.isEmpty,
            let password = ContentManager.Password where !password.isEmpty,
            let viewController = UIStoryboard.initViewControllerWithIdentifier(
                AppConstants.LoginViewControllerIdentifier
            ) as? LoginViewController else { return true }

        viewController.shouldAutoLogin = true
        window?.rootViewController = viewController
        return true
    }
}
