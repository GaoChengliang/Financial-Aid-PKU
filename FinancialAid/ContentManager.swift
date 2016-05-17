//
//  ContentManager.swift
//  SmartClass
//
//  Created by PengZhao on 15/7/16.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

import KeychainAccess
import SwiftyJSON

class ContentManager: NSObject {
    
    // MARK: Singleton
    static let sharedInstance = ContentManager()
    
    // MARK: Key chain
    private static let keychain: Keychain = {
        let bundle = NSBundle.mainBundle()
        let bundleIdentifier = bundle.bundleIdentifier!
        return Keychain(service: bundleIdentifier)
    }()
    
    // UserName, UserID, Token, and Password can identify an unique user
    static var UserName: String? {
        get {
            return try? keychain.getString("name") ?? ""
        }
        set {
            setKeyChainItem(newValue, forKey: "name")
        }
    }
    
    static var UserID: String? {
        get {
            return try? keychain.getString("_id") ?? ""
        }
        set {
            setKeyChainItem(newValue, forKey: "_id")
        }
    }
    
    static var Token: String? {
        get {
            return try? keychain.getString("token") ?? ""
        }
        set {
            setKeyChainItem(newValue, forKey: "token")
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
    
    /**
     Note: iOS 9 Security.framework bug! We need to first remove and then set the item instead of 
     update the existing item in the key chain.
     */
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
    
    /**
     Each method correspond to some kinds of data retrieval operation.
     Basically, we first ask NetworkManager to require data from network, however it fails, we 
     will query the local database, and the callback block will be executed.
     */
//    func login(name: String, password: String, block: ((error: NetworkErrorType?) -> Void)?) {
//        NetworkManager.sharedInstance.login(name, password: password) {
//            (json, error) in
//            
//            if error == nil, let json = json {
//                DDLogInfo("Login success")
//                
//                self.saveConfidential(name, userID: json["_id"].stringValue, token: json["token"].stringValue, password: password)
//            } else {
//                DDLogInfo("Login failed: \(error)")
//            }
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                block?(error: error)
//            }
//        }
//    }
//    
//    func register(name: String, realName: String, password: String, block: ((error: NetworkErrorType?) -> Void)?) {
//        NetworkManager.sharedInstance.register(name, realName: realName, password: password) {
//            (json, error) in
//            
//            if error == nil, let json = json {
//                DDLogInfo("Register success")
//                self.saveConfidential(name, userID: json["_id"].stringValue, token: json["token"].stringValue, password: password)
//            } else {
//                DDLogInfo("Register failed: \(error)")
//            }
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                block?(error: error)
//            }
//        }
//    }
//
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
//    
//    func signinInfo(courseID: String, block: ((uuid: String?, enable: Bool?, total: Int,
//        user: Int, signinID: String?, error: NetworkErrorType?) -> Void)?) {
//            NetworkManager.sharedInstance.signinInfo(ContentManager.UserID ?? "", token: ContentManager.Token ?? "", courseID: courseID) {
//                (json, error) in
//                
//                dispatch_async(dispatch_get_main_queue()) {
//                    if error == nil, let json = json {
//                        DDLogInfo("Querying sign info success")
//                        let json = json["signIn"]
//                        let total = json["total"].intValue
//                        let user = json["self"].int ?? 0
//                        let enable = json["enable"].boolValue
//                        
//                        let uuid = json["last", "uuid"].string ?? ""
//                        let signinID = json["last", "_id"].string
//                        
//                        block?(uuid: uuid, enable: enable,
//                            total: total, user: user,
//                            signinID: signinID, error: error)
//                    } else {
//                        DDLogInfo("Querying sign info failed: \(error)")
//                        block?(uuid: nil, enable: nil, total: 0, user: 0, signinID: nil, error: error)
//                    }
//                }
//            }
//            
//    }
//    
//    func signinEnable(courseID: String, uuid: String, block: ((signinID: String?, error: NetworkErrorType?) -> Void)?) {
//        NetworkManager.sharedInstance.signinEnable(ContentManager.UserID ?? "", token: ContentManager.Token ?? "", courseID: courseID, uuid: uuid) {
//            (json, error) in
//            
//            var signinID: String?
//            if error == nil, let json = json {
//                DDLogInfo("Signin enable success")
//                signinID = json["_id"].string
//            } else {
//                DDLogInfo("Signin enable failed: \(error)")
//            }
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                block?(signinID: signinID, error: error)
//            }
//        }
//    }
//    
//    func signinDisable(courseID: String, signinID: String, block: ((error: NetworkErrorType?) -> Void)?) {
//        NetworkManager.sharedInstance.signinDisable(ContentManager.UserID ?? "", token: ContentManager.Token ?? "", courseID: courseID, signinID: signinID) {
//            (json, error) in
//            
//            if error == nil {
//                DDLogInfo("Signin disable success")
//                
//            } else {
//                DDLogInfo("Signin disable failed: \(error)")
//            }
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                block?(error: error)
//            }
//        }
//    }
//    
//    func updateUUID(courseID: String, uuidString: String, block: ((error: NetworkErrorType?) -> Void)?) {
//        NetworkManager.sharedInstance.updateUUID(ContentManager.UserID ?? "", token: ContentManager.Token ?? "", courseID: courseID, uuidString: uuidString) {
//            (json, error) in
//            
//            if error == nil {
//                DDLogInfo("Update UUID success")
//                
//            } else {
//                DDLogInfo("Update UUID failed: \(error)")
//            }
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                block?(error: error)
//            }
//        }
//    }
//    
//    func signinRecord(courseID: String, block: ((signinRecords: [SigninRecord], error: NetworkErrorType?) -> Void)?) {
//        NetworkManager.sharedInstance.signinRecord(ContentManager.UserID ?? "", token: ContentManager.Token ?? "", courseID: courseID) {
//            (json, error) in
//            
//            var records = [SigninRecord]()
//            if error == nil, let json = json {
//                DDLogInfo("Signin record success")
//                
//                let total = CGFloat(json["total"].intValue)
//                for j in json["signins"].arrayValue {
//                    var date = NSDate(timeIntervalSince1970: j["to"].doubleValue / 1000)
//                    date = NSDateFormatter.defaultFormatter().dateFromString(
//                        NSDateFormatter.defaultFormatter().stringFromDate(date)
//                        )!
//                    
//                    records.append(SigninRecord(to: date, percentage: CGFloat(j["total"].intValue) / total))
//                }
//                records.sortInPlace {$0.to.laterDate($1.to) == $0.to}
//            } else {
//                DDLogInfo("Signin record failed: \(error)")
//            }
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                block?(signinRecords: records, error: error)
//            }
//        }
//    }
//    
//    func quizList(courseID: String, block: ((error: NetworkErrorType?) -> Void)?) {
//        NetworkManager.sharedInstance.quizList(ContentManager.UserID ?? "", token: ContentManager.Token ?? "", courseID: courseID) {
//            (json, error) in
//            
//            if error == nil, let json = json {
//                DDLogInfo("Querying quiz list success")
//                
//                let predicate = NSPredicate(format: "courseID = %@", courseID)
//                CoreDataManager.sharedInstance.deleteQuizWithinPredicate(predicate)
//                
//                let _ = Quiz.convertWithJSONArray(json["quizzes"].arrayValue)
//            } else {
//                DDLogInfo("Querying quiz list failed: \(error)")
//            }
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                block?(error: error)
//            }
//        }
//    }
//    
//    func quizSummary(courseID: String, quizID: String, block: ((score: [Int: Int], error: NetworkErrorType?) -> Void)?) {
//        NetworkManager.sharedInstance.quizSummary(ContentManager.UserID ?? "", token: ContentManager.Token ?? "", courseID: courseID, quizID: quizID) {
//            (json, error) in
//            
//            var score = [Int: Int]()
//            if error == nil, let json = json {
//                DDLogInfo("Querying quiz summary success")
//                for j in json["answers"].arrayValue {
//                    let cnt = (score[j["total"].intValue] ?? 0) + 1
//                    score[j["total"].intValue] = cnt
//                }
//            } else {
//                DDLogInfo("Querying quiz summary failed: \(error)")
//            }
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                block?(score: score, error: error)
//            }
//        }
//    }
    
    func truncateData() {
        clearConfidential()
//        CoreDataManager.sharedInstance.truncateData()
    }
    
    private func saveConfidential(name: String, userID: String, token: String, password: String) {
        if let id = ContentManager.UserID where id != userID {
            truncateData()
        }
        ContentManager.UserName = name
        ContentManager.UserID = userID
        ContentManager.Token = token
        ContentManager.Password = password
    }
    
    private func clearConfidential() {
        ContentManager.UserName = nil
        ContentManager.UserID = nil
        ContentManager.Token = nil
        ContentManager.Password = nil
    }
}
