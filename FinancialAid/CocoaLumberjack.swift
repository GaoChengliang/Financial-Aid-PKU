//
//  Log.swift
//  SmartClass
//
//  Created by PengZhao on 15/8/28.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

import Foundation
import CocoaLumberjack

/// Logging related functions
class CocoaLumberjack: NSObject {

    /**
     Setup the config of logging related functions
     */
    static func config() {
        setenv("XcodeColors", "YES", 0)

        DDLog.add(DDASLLogger.sharedInstance())   // Apple system logs
        // Xcode terminal loger in different color
        DDTTYLogger.sharedInstance().colorsEnabled = true
        DDTTYLogger.sharedInstance()
            .setForegroundColor(UIColor.red,
                                backgroundColor: nil,
                                for: .error)
        DDTTYLogger.sharedInstance()
            .setForegroundColor(UIColor.orange,
                                backgroundColor: nil,
                                for: .warning)
        
        DDTTYLogger.sharedInstance()
            .setForegroundColor(
                UIColor.green,
                backgroundColor: nil,
                for: .debug)
        DDTTYLogger.sharedInstance()
            .setForegroundColor(
                UIColor.blue,
                backgroundColor: nil,
                for: .verbose)
        DDTTYLogger.sharedInstance()
            .setForegroundColor(
                UIColor.red,
                backgroundColor: nil,
                for: .info)
        
        DDLog.add(DDTTYLogger.sharedInstance())

        // File logger
        let fileLogger: DDFileLogger! = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }

}
