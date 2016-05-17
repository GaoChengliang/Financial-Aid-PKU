//
//  NetworkManager.swift
//  SmartClass
//
//  Created by PengZhao on 15/7/16.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

import Alamofire
import SwiftyJSON

/// NetworkCallbackBlock consists the data and an optional network error type for block execution
typealias NetworkCallbackBlock = (JSON?, NetworkErrorType?) -> Void

enum NetworkErrorType: ErrorType, CustomStringConvertible {
    
    case NetworkUnreachable(String) // Timeout or Unreachable
    case NetworkUnauthenticated(String) // 401 or 403
    case NetworkServerError(String) // 5XX
    case NetworkForbiddenAccess(String) // 400 or 404
    case NetworkWrongParameter(String) // 422
    
    var description: String {
        get {
            switch self {
            case .NetworkUnreachable(let message):
                return "NetworkUnreachable - \(message)"
            case .NetworkUnauthenticated(let message):
                return "NetworkUnauthenticated - \(message)"
            case .NetworkServerError(let message):
                return "NetworkServerError - \(message)"
            case .NetworkForbiddenAccess(let message):
                return "NetworkForbiddenAccess - \(message)"
            case .NetworkWrongParameter(let message):
                return "NetworkWrongParameter - \(message)"
            }
        }
    }
}
class NetworkManager: NSObject {
    
    // MARK: Singleton
    static let sharedInstance = NetworkManager()

    /**
     *  Unique key for each network request for caching each request
     */
    private struct Constants {
        static let BadRequestStatusCode = 400
        static let UnauthorizedStatusCode = 401
        static let ForbiddenStatusCode = 403
        static let NotFoundStatusCode = 404

        static let LoginKey         = "Login"
        static let RegisterKey      = "Register"
        static let CourseListKey    = "Course List"
        static let SigninInfoKey    = "Signin Info"
        static let SigninEnableKey  = "Signin Enable"
        static let SigninDisableKey = "Signin Disable"
        static let UpdateUUIDKey    = "Update UUID"
        static let SigninRecordKey  = "Signin Record"
        static let QuizListKey      = "Quiz List"
        static let QuizSummaryKey   = "Quiz Summary"
    }
    
    // Default network manager, timeout set to 10s
    private static let Manager: Alamofire.Manager = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 10.0
        return Alamofire.Manager(configuration: configuration, serverTrustPolicyManager: nil)
    }()
    
    /**
     Caching dictionary
     Each network request is served as a key-value pair in the dictionary. No duplicate request would be executed until the previosus one (sharing with the same key) finished.
     */
    private static var PendingOpDict = [String : (Request, NSDate)]()
    
    /**
     Execute the network request
     
     - parameter key:      unique string in caching dictionary
     - parameter request:  request (or value) in caching dictionary
     - parameter callback: a block executed when network request finished
     */
    private class func executeRequestWithKey(key: String, request: Request, callback: NetworkCallbackBlock) {
        
        // Update the new item in the caching dictionary
        PendingOpDict[key] = (request, NSDate())
        // Executing request
        request.responseJSON {
            
            let (statusCode, result) = ($0.response?.statusCode ?? 404, $0.result)
            
            var json: JSON?
            var error: NetworkErrorType?
            
            // Remove the item the caching dictionary
            PendingOpDict.removeValueForKey(key)
            
            // Deal with statusCode and JSON from server
            if result.isSuccess && (statusCode >= 200 && statusCode < 300) {
                json = JSON(result.value!)
            } else {
                if result.isFailure {
                    error = NetworkErrorType.NetworkUnreachable("\(result.error)")
                } else if let value = result.value {
                    // Retrieve error message, pls refer to 'API.md' for details
                    let message = JSON(value)["message"].stringValue
                    
                    if statusCode == Constants.ForbiddenStatusCode || statusCode == Constants.UnauthorizedStatusCode {
                        error = NetworkErrorType.NetworkUnauthenticated(message ?? "Unauthenticated access")
                    } else if statusCode == Constants.BadRequestStatusCode || statusCode == Constants.NotFoundStatusCode {
                        error = NetworkErrorType.NetworkForbiddenAccess(message ?? "Bad request")
                    } else if case(400..<500) = statusCode {
                        error = NetworkErrorType.NetworkWrongParameter(message ?? "Wrong parameters")
                    } else if case(500...505) = statusCode {
                        error = NetworkErrorType.NetworkServerError(message ?? "Server error")
                    }
                }
            }
            // execute the block
            callback(json, error)
        }
    }
    
    class func existPendingOperation(key: String) -> Bool {
        return PendingOpDict[key] != nil
    }
}
//
//extension NetworkManager {
//    
//    // Router is a factory for producing network request
//    private enum Router: URLRequestConvertible {
//        
//        // Server URL
//        static let APIURLString = "http://smartclass.zakelly.com:3000"
//        static let ImageURLString = "http://162.105.146.125:3000/image"
//        
//        // Different types of network request
//        case Login(String, String)
//        case Register(String, String, String)
//        case CourseList(String, String)
//        case SigninInfo(String, String, String)
//        case SigninEnable(String, String, String, String)
//        case SigninDisable(String, String, String, String)
//        case UpdateUUID(String, String, String, String)
//        case SigninRecord(String, String, String)
//        case QuizList(String, String, String)
//        case QuizSummaryKey(String, String, String, String)
//        
//        var URLRequest: NSMutableURLRequest {
//            
//            // 1. Set the properties for the request, including URL, HTTP Method, and its parameters
//            var (path, method, parameters): (String, Alamofire.Method, [String: AnyObject]) = {
//                switch self {
//                case .Login(let name, let password):
//                    let params = ["name": name, "password": password]
//                    return ("/user/login", Method.POST, params)
//                case .Register(let name, let realName, let password):
//                    let params = ["name": name, "realName": realName, "password": password]
//                    return ("/user/register", Method.POST, params)
//                case .CourseList(let ID, let token):
//                    let params = ["_id": ID, "token": token]
//                    return ("/user/me/course", Method.GET, params)
//                case .SigninInfo(let ID, let token, let courseID):
//                    let params = ["_id": ID, "token": token]
//                    return ("/course/\(courseID)", Method.GET, params)
//                case .SigninEnable(let ID, let token, let courseID, let uuid):
//                    let params = ["_id": ID, "token": token, "uuid": uuid]
//                    return ("/course/\(courseID)/signin", Method.POST, params)
//                case .SigninDisable(let ID, let token, let courseID, _):
//                    let params = ["_id": ID, "token": token]
//                    return ("/course/\(courseID)/signin/last/disable", Method.POST, params)
//                case .UpdateUUID(let ID, let token, let courseID, let uuidString):
//                    let params = ["_id": ID, "token": token, "uuid": uuidString]
//                    return ("/course/\(courseID)/signin/last", Method.PUT, params)
//                case .SigninRecord(let ID, let token, let courseID):
//                    let params = ["_id": ID, "token": token, "course_id": courseID]
//                    return ("/private/sign/class", Method.GET, params)
//                case .QuizList(let ID, let token, let courseID):
//                    let params = ["_id": ID, "token": token, "course_id": courseID]
//                    return ("/api/quiz/list", Method.GET, params)
//                case .QuizSummaryKey(let ID, let token, let courseID, let quizID):
//                    let params = ["_id": ID, "token": token, "course_id": courseID, "quiz_id": quizID]
//                    return ("/private/answer/quiz/info", Method.GET, params)
//                }
//            }()
//            
//            // 2. Add HTTP headers
//            let URLRequest: NSMutableURLRequest = {
//                (inout parameters: [String: AnyObject]) in
//                let URL = NSURL(string: Router.APIURLString)!
//                let request = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
//                
//                let buildVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
//                request.setValue("\(buildVersion)", forHTTPHeaderField: "x-build-version")
//                
//                request.setValue(parameters["token"] as? String, forHTTPHeaderField: "x-access-token")
//                parameters.removeValueForKey("token")
//                
//                request.HTTPMethod = method.rawValue
//                return request
//            }(&parameters)
//            
//            // 3. Encode the network request
//            if method == Method.GET {
//                return ParameterEncoding.URL.encode(URLRequest, parameters: parameters).0
//            } else {
//                return ParameterEncoding.JSON.encode(URLRequest, parameters: parameters).0
//            }
//        }
//    }
//    
//    /** 4. From now on, each network access only require three lines of code
//        *   4.0 Make sure there is no pending network operations
//        *   4.1 Retrieve the network request
//        *   4.2 Execute the request
//    */
//
//    func login(name: String, password: String, callback: NetworkCallbackBlock) {
//        guard !NetworkManager.existPendingOperation(Constants.LoginKey) else {return}
//        let request = NetworkManager.Manager.request(Router.Login(name, password))
//        NetworkManager.executeRequestWithKey(Constants.LoginKey, request: request, callback: callback)
//    }
//    
//    func register(name: String, realName: String, password: String, callback: NetworkCallbackBlock) {
//        guard !NetworkManager.existPendingOperation(Constants.RegisterKey) else {return}
//        let request = NetworkManager.Manager.request(Router.Register(name, realName, password))
//        NetworkManager.executeRequestWithKey(Constants.RegisterKey, request: request, callback: callback)
//    }
//    
//    func courseList(userID: String, token: String, callback: NetworkCallbackBlock) {
//        guard !NetworkManager.existPendingOperation(Constants.CourseListKey) else {return}
//        let request = NetworkManager.Manager.request(Router.CourseList(userID, token))
//        NetworkManager.executeRequestWithKey(Constants.CourseListKey, request: request, callback: callback)
//    }
//    
//    func signinInfo(userID: String, token: String, courseID: String, callback: NetworkCallbackBlock) {
//        guard !NetworkManager.existPendingOperation(Constants.SigninInfoKey) else {return}
//        let request = NetworkManager.Manager.request(Router.SigninInfo(userID, token, courseID))
//        NetworkManager.executeRequestWithKey(Constants.SigninInfoKey, request: request, callback: callback)
//    }
//    
//    func signinEnable(userID: String, token: String, courseID: String, uuid: String, callback: NetworkCallbackBlock) {
//        guard !NetworkManager.existPendingOperation(Constants.SigninEnableKey) else {return}
//        let request = NetworkManager.Manager.request(Router.SigninEnable(userID, token, courseID, uuid))
//        NetworkManager.executeRequestWithKey(Constants.SigninEnableKey, request: request, callback: callback)
//    }
//    
//    func signinDisable(userID: String, token: String, courseID: String, signinID: String, callback: NetworkCallbackBlock) {
//        guard !NetworkManager.existPendingOperation(Constants.SigninDisableKey) else {return}
//        let request = NetworkManager.Manager.request(Router.SigninDisable(userID, token, courseID, signinID))
//        NetworkManager.executeRequestWithKey(Constants.SigninDisableKey, request: request, callback: callback)
//    }
//    
//    func updateUUID(userID: String, token: String, courseID: String, uuidString: String, callback: NetworkCallbackBlock) {
//        guard !NetworkManager.existPendingOperation(Constants.UpdateUUIDKey) else {return}
//        let request = NetworkManager.Manager.request(Router.UpdateUUID(userID, token, courseID, uuidString))
//        NetworkManager.executeRequestWithKey(Constants.UpdateUUIDKey, request: request, callback: callback)
//    }
//    
//    func signinRecord(userID: String, token: String, courseID: String, callback: NetworkCallbackBlock) {
//        guard !NetworkManager.existPendingOperation(Constants.SigninRecordKey) else {return}
//        let request = NetworkManager.Manager.request(Router.SigninRecord(userID, token, courseID))
//        NetworkManager.executeRequestWithKey(Constants.SigninRecordKey, request: request, callback: callback)
//    }
//    
//    func quizList(userID: String, token: String, courseID: String, callback: NetworkCallbackBlock) {
//        guard !NetworkManager.existPendingOperation(Constants.QuizListKey) else {return}
//        let request = NetworkManager.Manager.request(Router.QuizList(userID, token, courseID))
//        NetworkManager.executeRequestWithKey(Constants.QuizListKey, request: request, callback: callback)
//    }
//    
//    func quizSummary(userID: String, token: String, courseID: String, quizID: String, callback: NetworkCallbackBlock) {
//        guard !NetworkManager.existPendingOperation(Constants.QuizSummaryKey) else {return}
//        let request = NetworkManager.Manager.request(Router.QuizSummaryKey(userID, token, courseID, quizID))
//        NetworkManager.executeRequestWithKey(Constants.QuizSummaryKey, request: request, callback: callback)
//    }
//    
//    func imageURL(imageName: String) -> NSURL? {
//        return NSURL(string: Router.ImageURLString)?.URLByAppendingPathComponent(imageName)
//    }
//
//}