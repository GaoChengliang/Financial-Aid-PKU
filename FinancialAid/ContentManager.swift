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
                self.saveUser(json["data"].description, userName: userName, password: password)
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
                self.saveUser(json["data"].description, userName: userName, password: password)
            } else {
                DDLogInfo("Register failed \(userName): \(error)")
            }

            dispatch_async(dispatch_get_main_queue(), {
                block?(error: error)
            })
        }
    }

    func formList(block: ((error: NetworkErrorType?) -> Void)?) {
        NetworkManager.sharedInstance.formList() {
            (json, error) in

            if error == nil, let json = json {
                DDLogInfo("Querying form list success")
                FormList.sharedInstance.formList = NSArray(array:
                    Form.mj_objectArrayWithKeyValuesArray(json["data"].description)
                ) as? [Form] ?? []
            } else {
                DDLogInfo("Querying form list failed: \(error)")
            }

            dispatch_async(dispatch_get_main_queue()) {
                block?(error: error)
            }
        }
    }

    func editUserInfo(editInfo: [String: String], block: ((error: NetworkErrorType?) -> Void)?) {
        NetworkManager.sharedInstance.editUserInfo(editInfo) {
            (json, error) in

            if error == nil, let json = json {
                DDLogInfo("Edit user info success")
                User.sharedInstance = User.mj_objectWithKeyValues(json["data"].description)
            } else {
                DDLogInfo("Edit user info failed: \(error)")
            }

            dispatch_async(dispatch_get_main_queue()) {
                block?(error: error)
            }
        }
    }

    func getPDF(formID: String, email: String, block: ((error: NetworkErrorType?) -> Void)?) {
        NetworkManager.sharedInstance.getPDF(formID, email: email) {
            (json, error) in

            if error == nil && json != nil {
                DDLogInfo("Send PDF success")
            } else {
                DDLogInfo("Send PDF failed: \(error)")
            }

            dispatch_async(dispatch_get_main_queue()) {
                block?(error: error)
            }
        }
    }

    func saveUser(json: String, userName: String, password: String) {
        User.sharedInstance = User.mj_objectWithKeyValues(json)
        ContentManager.UserName = User.sharedInstance.userName
        ContentManager.Password = password
    }
}
