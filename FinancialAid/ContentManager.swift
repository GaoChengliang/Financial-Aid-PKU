//
//  ContentManager.swift
//  SmartClass
//
//  Created by PengZhao on 15/7/16.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

import CocoaLumberjack
import KeychainAccess
import MJExtension
import SwiftyJSON

class ContentManager: NSObject {

    // MARK: Singleton
    static let sharedInstance = ContentManager()

    // MARK: Key chain
    private static let keychain: Keychain = {
        let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier!
        return Keychain(service: bundleIdentifier)
    }()

    // UserName and Password can identify an unique user
    static var UserName: String? {
        get {
            return try? keychain.getString("name") ?? ""
        }
        set {
            setKeyChainItem(newValue, forKey: "name")
        }
    }

    static var Password: String? {
        get {
            return try? keychain.getString("password") ?? ""
        }
        set {
            setKeyChainItem(newValue, forKey: "password")
        }
    }

    private class func setKeyChainItem(item: String?, forKey key: String) {
        do {
            try keychain.remove(key) // Dealing with iOS 9 Security.framework bug!
            if let string = item {
                try keychain.set(string, key: key)
            }
        } catch let error {
            print("Key chain save error: \(error)")
        }
    }

    func login(userName: String, password: String, block: ((error: NetworkErrorType?) -> Void)?) {
        NetworkManager.sharedInstance.login(userName, password: password) {
            (json, error) in

            if error == nil, let json = json {
                DDLogInfo("Login success \(userName)")
                print(json["data"].description)

            } else {
                DDLogInfo("Login failed \(userName): \(error)")
            }

            dispatch_async(dispatch_get_main_queue(), {
                block?(error: error)
            })
        }
    }

    func register(userName: String, password: String, block: ((error: NetworkErrorType?) -> Void)?) {
        NetworkManager.sharedInstance.register(userName, password: password) {
            (json, error) in

            if error == nil, let json = json {
                DDLogInfo("Register success \(userName)")
                print(json["data"].string)

            } else {
                DDLogInfo("Register failed \(userName): \(error)")
            }

            dispatch_async(dispatch_get_main_queue(), {
                block?(error: error)
            })
        }
    }

//    func courseList(block: ((error: NetworkErrorType?) -> Void)?) {
//        NetworkManager.sharedInstance.courseList(ContentManager.UserID ?? "",
//            token: ContentManager.Token ?? "") {
//            (json, error) in
//
//            if error == nil, let json = json {
//                DDLogInfo("Querying course list success")
//
//                CoreDataManager.sharedInstance.deleteAllCourses()
//                let _ = Course.convertWithJSONArray(json["courses"].arrayValue)
//            } else {
//                DDLogInfo("Querying course list failed: \(error)")
//            }
//
//            dispatch_async(dispatch_get_main_queue()) {
//                block?(error: error)
//            }
//        }
//    }


}
