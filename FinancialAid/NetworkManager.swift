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
                json = JSON(result.value!)
            } else {
                if result.isFailure {
                    error = NetworkErrorType.NetworkUnreachable("\(result.error)")
                } else if let value = result.value {
                    // Retrieve error message, pls refer to 'API.md' for details
                    let message = JSON(value)["message"].stringValue

                    if statusCode == Constants.ForbiddenStatusCode ||
                       statusCode == Constants.UnauthorizedStatusCode {
                        error = NetworkErrorType.NetworkUnauthenticated(message ?? "Unauthenticated access")
                    } else if statusCode == Constants.BadRequestStatusCode ||
                              statusCode == Constants.NotFoundStatusCode {
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

extension NetworkManager {

    // Router is a factory for producing network request
    private enum Router: URLRequestConvertible {

        // Server URL
        static let APIURLString = "http://zzzx.zakelly.com"

        // Different types of network request
        case Login(String, String)
        case Register(String, String)

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
}
