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
import AVOSCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var siren: Siren!

    func application(_ application: UIApplication,
         didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
            -> Bool {

        sleep(2)

        UIApplication.shared.setMinimumBackgroundFetchInterval(
            UIApplicationBackgroundFetchIntervalMinimum)

        // Override point for customization after application launch.
        CocoaLumberjack.config()
        SVProgressHUD.config()
        UITabBarItem.config()
//        LocationCellularManager.sharedInstance.getLocationCellular(nil)
        guard
            let userName = ContentManager.UserName, !userName.isEmpty,
            let password = ContentManager.Password, !password.isEmpty,
            let viewController = UIStoryboard.initViewControllerWithIdentifier(
                AppConstants.LoginViewControllerIdentifier
            ) as? LoginViewController else { return true }

        viewController.shouldAutoLogin = true
        window?.rootViewController = viewController

        setSiren()

        setAVOSCloud()

        UIApplication.shared.registerUserNotificationSettings(
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))

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

    func application(_ application: UIApplication,
                     didRegister notificationSettings: UIUserNotificationSettings) {
        UIApplication.shared.registerForRemoteNotifications()
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let currentInstallation: AVInstallation! = AVInstallation.current()
        currentInstallation.setDeviceTokenFrom(deviceToken)
        currentInstallation.saveInBackground()
    }

    func setAVOSCloud() {
        AVOSCloud.setApplicationId("PwegrNKdHfruoACosS41mbJx-gzGzoHsz", clientKey: "H5o09ExYrpbnGyPf7WbG8ELI")
        AVOSCloud.registerForRemoteNotification()
    }

    func setSiren() {
        siren = Siren.sharedInstance
        siren.majorUpdateAlertType = .force
        siren.minorUpdateAlertType = .skip
        siren.checkVersion(checkType: .immediately)
    }
}
