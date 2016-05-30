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
    case NetworkWrongParameter(String, Int) // 200 but with errno

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
            case .NetworkWrongParameter(let message, let errno):
                return "NetworkWrongParameter - \(message) \(errno)"
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
        static let LoginKey         = "Login"
        static let RegisterKey      = "Register"
        static let FormListKey      = "Form List"
        static let EditUserInfoKey  = "Edit User"
        static let PDFKey           = "Get PDF"
    }

    // Default network manager, timeout set to 10s
    private static let Manager: Alamofire.Manager = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 10.0
        configuration.HTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        configuration.HTTPCookieAcceptPolicy = .Always
        return Alamofire.Manager(configuration: configuration, serverTrustPolicyManager: nil)
    }()

    /**
     Caching dictionary
     Each network request is served as a key-value pair in the dictionary.
     No duplicate request would be executed until the previosus one (sharing with the same key) finished.
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
                let value = JSON(result.value!)
                let errno = value["error"].int ?? 1
                json = value
                if errno > 0 {
                    error = NetworkErrorType.NetworkWrongParameter("Bad request", errno)
                }
            } else {
                if result.isFailure {
                    error = NetworkErrorType.NetworkUnreachable("\(result.error)")
                } else {
                    error = NetworkErrorType.NetworkServerError("Server error")
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

extension NetworkManager {

    // Router is a factory for producing network request
    private enum Router: URLRequestConvertible {

        // Server URL
        static let APIURLString = "http://zzzx.zakelly.com"

        // Different types of network request
        case Login(String, String)
        case Register(String, String)
        case FormList()
        case EditUserInfo([String: String])
        case GetPDF(String, String)

        var URLRequest: NSMutableURLRequest {

            // 1. Set the properties for the request, including URL, HTTP Method, and its parameters
            let (path, method, parameters): (String, Alamofire.Method, [String: AnyObject]) = {
                switch self {
                case .Login(let userName, let password):
                    let params = ["username": userName, "password": password]
                    return ("/user/login", Method.POST, params)
                case .Register(let userName, let password):
                    let params = ["username": userName, "password": password]
                    return ("/user/register", Method.POST, params)
                case .FormList:
                    return ("/form/list", Method.GET, [:])
                case .EditUserInfo(let params):
                    return ("/user", Method.PUT, params)
                case .GetPDF(let formID, let email):
                    let params = ["email": email]
                    return ("/form/\(formID)/pdf", Method.POST, params)
                }
            }()

            let URLRequest: NSMutableURLRequest = {
                let URL = NSURL(string: Router.APIURLString)!
                let request = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
                request.HTTPMethod = method.rawValue
                return request
            }()

            // 3. Encode the network request
            if method == Method.GET {
                return ParameterEncoding.URL.encode(URLRequest, parameters: parameters).0
            } else {
                return ParameterEncoding.JSON.encode(URLRequest, parameters: parameters).0
            }
        }
    }

    func relativeURL(urlString: String) -> NSURL {
        let baseURL = NSURL(string: Router.APIURLString)!
        return baseURL.URLByAppendingPathComponent(urlString)
    }

    func login(userName: String, password: String, callback: NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.LoginKey) else { return }
        let request = NetworkManager.Manager.request(Router.Login(userName, password))
        NetworkManager.executeRequestWithKey(Constants.LoginKey, request: request, callback: callback)
    }

    func register(userName: String, password: String, callback: NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.RegisterKey) else { return }
        let request = NetworkManager.Manager.request(Router.Register(userName, password))
        NetworkManager.executeRequestWithKey(Constants.RegisterKey, request: request, callback: callback)
    }

    func formList(callback: NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.FormListKey) else { return }
        let request = NetworkManager.Manager.request(Router.FormList())
        NetworkManager.executeRequestWithKey(Constants.FormListKey, request: request, callback: callback)
    }

    func editUserInfo(editInfo: [String: String], callback: NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.EditUserInfoKey) else { return }
        let request = NetworkManager.Manager.request(Router.EditUserInfo(editInfo))
        NetworkManager.executeRequestWithKey(Constants.EditUserInfoKey, request: request, callback: callback)
    }

    func getPDF(formID: String, email: String, callback: NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.PDFKey) else { return }
        let request = NetworkManager.Manager.request(Router.GetPDF(formID, email))
        NetworkManager.executeRequestWithKey(Constants.PDFKey, request: request, callback: callback)
    }
}
