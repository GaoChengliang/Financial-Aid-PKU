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

enum NetworkErrorType: Error, CustomStringConvertible {

    case networkUnreachable(String) // Timeout or Unreachable
    case networkUnauthenticated(String) // 401 or 403
    case networkServerError(String) // 5XX
    case networkForbiddenAccess(String) // 400 or 404
    case networkWrongParameter(String, Int) // 200 but with errno

    var description: String {
        get {
            switch self {
            case .networkUnreachable(let message):
                return "NetworkUnreachable - \(message)"
            case .networkUnauthenticated(let message):
                return "NetworkUnauthenticated - \(message)"
            case .networkServerError(let message):
                return "NetworkServerError - \(message)"
            case .networkForbiddenAccess(let message):
                return "NetworkForbiddenAccess - \(message)"
            case .networkWrongParameter(let message, let errno):
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
    fileprivate struct Constants {
        static let LoginKey         = "Login"
        static let RegisterKey      = "Register"
        static let VersionKey       = "Version"
        static let FormListKey      = "Form List"
        static let GetUserInfoKey   = "Get User"
        static let EditUserInfoKey  = "Edit User"
        static let PDFKey           = "Get PDF"
        static let ImageListKey     = "Image List"
        static let DeleteImageKey   = "Delete Image"
        static let GetNewsKey       = "Get News"
        static let GetMessagesKey   = "Get Messages"
    }

    // Default network manager, timeout set to 10s
    internal static let Manager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.httpCookieAcceptPolicy = .always
        configuration.httpAdditionalHeaders = [
            "X-Requested-With": "XMLHttpRequest"
        ]
        return Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: nil)
    }()


    /**
     Caching dictionary
     Each network request is served as a key-value pair in the dictionary.
     No duplicate request would be executed until the previosus one (sharing with the same key) finished.
     */
    fileprivate static var PendingOpDict = [String : (Request, NSDate)]()

    /**
     Execute the network request

     - parameter key:      unique string in caching dictionary
     - parameter request:  request (or value) in caching dictionary
     - parameter callback: a block executed when network request finished
     */
    fileprivate class func executeRequestWithKey(_ key: String, request: DataRequest, callback: @escaping NetworkCallbackBlock) {

        // Update the new item in the caching dictionary
        PendingOpDict[key] = (request, NSDate())
        // Executing request
        request.responseJSON {

            let (statusCode, result) = ($0.response?.statusCode ?? 404, $0.result)

            var json: JSON?
            var error: NetworkErrorType?

            // Remove the item the caching dictionary
            PendingOpDict.removeValue(forKey: key)

            // Deal with statusCode and JSON from server

            if result.isSuccess && (statusCode >= 200 && statusCode < 300) {
                let value = JSON(result.value!)
                let errno = value["error"].int ?? 1
                json = value
                if errno > 0 {
                    error = NetworkErrorType.networkWrongParameter("Bad request", errno)
                }
            } else {
                if result.isFailure {
                    error = NetworkErrorType.networkUnreachable("\(result.error)")
                } else {
                    error = NetworkErrorType.networkServerError("Server error")
                }
            }
            // execute the block
            callback(json, error)
        }
    }

    class func existPendingOperation(_ key: String) -> Bool {
        return PendingOpDict[key] != nil
    }
}

extension NetworkManager {

    // Router is a factory for producing network request
    fileprivate enum Router: URLRequestConvertible {

        // Server URL
        static let APIURLString = "https://app.pku.edu.cn/zzzx"

        // Different types of network request
        case login(String, String)
        case register(String, String)
        case formList()
        case getUserInfo()
        case editUserInfo([String: String])
        case getPDF(String, String)
        case getImageList(String)
        case deleteImage(String)
        case getVersion()
        case getNews()
        case getMessages(Int, Int)
        
        func asURLRequest() throws -> URLRequest {
           
            // 1. Set the properties for the request, including URL, HTTP Method, and its parameters
            let (path, method, parameters): (String, Alamofire.HTTPMethod, [String: AnyObject]) = {
                switch self {
                case .login(let userName, let password):
                    let params = ["username": userName, "password": password]
                    return ("/user/login", HTTPMethod.post, params as [String : AnyObject])
                case .register(let userName, let password):
                    let params = ["username": userName, "password": password]
                    return ("/user/register", HTTPMethod.post, params as [String : AnyObject])
                case .formList:
                    return ("/form/list", HTTPMethod.get, [:])
                case .getUserInfo:
                    return ("/user", HTTPMethod.get, [:])
                case .editUserInfo(let params):
                    return ("/user", HTTPMethod.put, params as [String : AnyObject])
                case .getPDF(let formID, let email):
                    let params = ["email": email]
                    return ("/form/\(formID)/pdf", HTTPMethod.post, params as [String : AnyObject])
                case .getImageList(let formID):
                    return ("/form/\(formID)/image", HTTPMethod.get, [:])
                case .deleteImage(let formID):
                    return ("/image/\(formID)", HTTPMethod.delete, [:])
                case .getVersion:
                    return ("/version", HTTPMethod.get, [:])
                case .getNews:
                    return ("/news", HTTPMethod.get, [:])
                case .getMessages(let limit, let skip):
                    let params = ["limit": limit, "skip": skip]
                    return ("/messages", HTTPMethod.get, params as [String : AnyObject])
                }
            }()
            
            // 2. Set URLRequest URL and Method
            let baseURL = try Router.APIURLString.asURL()
            var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
            urlRequest.httpMethod = method.rawValue
            
            // 3. Encode the network request
            if method == HTTPMethod.get {
                return try URLEncoding.default.encode(urlRequest, with: parameters)
            } else {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                return urlRequest
            }
        }
        
    }

    func relativeURL(_ urlString: String) -> URL {
        
        var baseURL: URL!
        
        do {
            baseURL = try Router.APIURLString.asURL()
        
        } catch {
            
        }
        
        return baseURL.appendingPathComponent(urlString)
    }

    func login(_ userName: String, password: String, callback: @escaping NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.LoginKey) else { return }
        let request = NetworkManager.Manager.request(Router.login(userName, password))
        NetworkManager.executeRequestWithKey(Constants.LoginKey, request: request, callback: callback)
    }

    func register(_ userName: String, password: String, callback: @escaping NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.RegisterKey) else { return }
        let request = NetworkManager.Manager.request(Router.register(userName, password))
        NetworkManager.executeRequestWithKey(Constants.RegisterKey, request: request, callback: callback)
    }

    func formList(_ callback: @escaping NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.FormListKey) else { return }
        let request = NetworkManager.Manager.request(Router.formList())
        NetworkManager.executeRequestWithKey(Constants.FormListKey, request: request, callback: callback)
    }

    func getUserInfo(_ callback: @escaping NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.GetUserInfoKey) else { return }
        let request = NetworkManager.Manager.request(Router.getUserInfo())
        NetworkManager.executeRequestWithKey(Constants.GetUserInfoKey, request: request, callback: callback)
    }

    func editUserInfo(_ editInfo: [String: String], callback: @escaping NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.EditUserInfoKey) else { return }
        let request = NetworkManager.Manager.request(Router.editUserInfo(editInfo))
        NetworkManager.executeRequestWithKey(Constants.EditUserInfoKey, request: request, callback: callback)
    }

    func getPDF(_ formID: String, email: String, callback: @escaping NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.PDFKey) else { return }
        let request = NetworkManager.Manager.request(Router.getPDF(formID, email))
        NetworkManager.executeRequestWithKey(Constants.PDFKey, request: request, callback: callback)
    }

    func getImageList(_ formID: String, callback: @escaping NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.ImageListKey) else { return }
        let request = NetworkManager.Manager.request(Router.getImageList(formID))
        NetworkManager.executeRequestWithKey(Constants.ImageListKey, request: request, callback: callback)
    }

    func deleteImage(_ formID: String, callback: @escaping NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.DeleteImageKey) else { return }
        let request = NetworkManager.Manager.request(Router.deleteImage(formID))
        NetworkManager.executeRequestWithKey(Constants.DeleteImageKey, request: request, callback: callback)
    }

    func getVersion(_ callback: @escaping NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.VersionKey) else { return }
        let request = NetworkManager.Manager.request(Router.getVersion())
        NetworkManager.executeRequestWithKey(Constants.VersionKey, request: request, callback: callback)
    }

    func getNews(_ callback: @escaping NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.GetNewsKey) else { return }
        let request = NetworkManager.Manager.request(Router.getNews())
        NetworkManager.executeRequestWithKey(Constants.GetNewsKey, request: request, callback: callback)
    }
    
    func getMessage(_ limit: Int, skip: Int, callback: @escaping NetworkCallbackBlock) {
        guard !NetworkManager.existPendingOperation(Constants.GetMessagesKey) else { return }
        let request = NetworkManager.Manager.request(Router.getMessages(limit, skip))
        NetworkManager.executeRequestWithKey(Constants.GetMessagesKey, request: request, callback: callback)
    }

    func uploadImage(_ formID: Int, imageData: NSData, callback: @escaping (DataResponse<Any>) -> Void) {
        var urlRequest = URLRequest(url: NetworkManager.sharedInstance.relativeURL("/form/\(formID)/image"))
        urlRequest.httpMethod = Alamofire.HTTPMethod.post.rawValue
        let boundaryConstant = "RandomBoundary";     // 分割线
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        var uploadData = Data()
        uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Disposition: form-data; name=\"image\"; filename=\"file.png\"\r\n"
            .data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append(imageData as Data)
        uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        
        do {
            NetworkManager.Manager.upload(uploadData, with: try URLEncoding.default.encode(urlRequest, with: nil)).responseJSON(completionHandler: callback)
        } catch {
            
        }
    }
}
