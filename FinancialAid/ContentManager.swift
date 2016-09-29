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
    fileprivate static let keychain: Keychain = {
        let bundleIdentifier = Bundle.main.bundleIdentifier!
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

    fileprivate class func setKeyChainItem(_ item: String?, forKey key: String) {
        do {
            try keychain.remove(key) // Dealing with iOS 9 Security.framework bug!
            if let string = item {
                try keychain.set(string, key: key)
            }
        } catch let error {
            DDLogInfo("Key chain save error: \(error)")
        }
    }

    func login(_ userName: String, password: String, block: ((_ error: NetworkErrorType?) -> Void)?) {
        NetworkManager.sharedInstance.login(userName, password: password) {
            (json, error) in

            if error == nil, let json = json {
                DDLogInfo("Login success \(userName)")
                self.saveUser(json["data"].description, userName: userName, password: password)
            } else {
                DDLogInfo("Login failed \(userName): \(error)")
            }
            
            DispatchQueue.main.async(execute: {
                block?(error)
            })
        }
    }

    func register(_ userName: String, password: String, block: ((_ error: NetworkErrorType?) -> Void)?) {
        NetworkManager.sharedInstance.register(userName, password: password) {
            (json, error) in

            if error == nil, let json = json {
                DDLogInfo("Register success \(userName)")
                self.saveUser(json["data"].description, userName: userName, password: password)
            } else {
                DDLogInfo("Register failed \(userName): \(error)")
            }

            DispatchQueue.main.async(execute: {
                block?(error)
            })
        }
    }

    func formList(_ block: ((_ error: NetworkErrorType?) -> Void)?) {
        NetworkManager.sharedInstance.formList() {
            (json, error) in

            if error == nil, let json = json {
                DDLogInfo("Querying form list success")
                FormList.sharedInstance.formList = NSArray(array:
                    Form.mj_objectArray(withKeyValuesArray: json["data"].description)
                ) as? [Form] ?? []
            } else {
                DDLogInfo("Querying form list failed: \(error)")
            }

            DispatchQueue.main.async(execute: {
                block?(error)
            })
        }
    }

    func getUserInfo(_ block: ((_ error: NetworkErrorType?) -> Void)?) {
        NetworkManager.sharedInstance.getUserInfo {
            (json, error) in

            if error == nil, let json = json {
                DDLogInfo("Get user information success")
                User.sharedInstance = User.mj_object(withKeyValues: json["data"].description)
            } else {
                DDLogInfo("Get user information failed: \(error)")
            }

            DispatchQueue.main.async(execute: {
                block?(error)
            })
        }
    }

    func editUserInfo(_ editInfo: [String: String], block: ((_ error: NetworkErrorType?) -> Void)?) {
        NetworkManager.sharedInstance.editUserInfo(editInfo) {
            (json, error) in

            if error == nil, let json = json {
                DDLogInfo("Edit user info success")
                User.sharedInstance = User.mj_object(withKeyValues: json["data"].description)
            } else {
                DDLogInfo("Edit user info failed: \(error)")
            }

            DispatchQueue.main.async(execute: {
                block?(error)
            })
        }
    }

    func getPDF(_ formID: String, email: String, block: ((_ error: NetworkErrorType?) -> Void)?) {
        NetworkManager.sharedInstance.getPDF(formID, email: email) {
            (json, error) in

            if error == nil && json != nil {
                DDLogInfo("Send PDF success")
            } else {
                DDLogInfo("Send PDF failed: \(error)")
            }

            DispatchQueue.main.async(execute: {
                block?(error)
            })
        }
    }

    func deleteImage(_ formID: String, block: ((_ error: NetworkErrorType?) -> Void)?) {
        NetworkManager.sharedInstance.deleteImage(formID) {
            (json, error) in

            if error == nil && json != nil {
                DDLogInfo("Delete Image success")
            } else {
                DDLogInfo("Delete Image failed: \(error)")
            }

            DispatchQueue.main.async(execute: {
                block?(error)
            })
        }
    }

    func getVersion(_ block: ((_ error: NetworkErrorType?) -> Void)?) {
        NetworkManager.sharedInstance.getVersion {
            (json, error) in

            if error == nil, let json = json {
                DDLogInfo("Get version information success")
                Version.sharedInstance = Version.mj_object(withKeyValues: json["data"]["ios"].description)
            } else {
                DDLogInfo("Get version information failed: \(error)")
            }

            DispatchQueue.main.async(execute: {
                block?(error)
            })
        }
    }

    func saveUser(_ json: String, userName: String, password: String) {
        User.sharedInstance = User.mj_object(withKeyValues: json)
        ContentManager.UserName = User.sharedInstance.userName
        ContentManager.Password = password
    }
}
