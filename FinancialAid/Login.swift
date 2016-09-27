//
//  LoginViewModel.swift
//  FinancialAid
//
//  Created by PengZhao on 15/12/28.
//  Copyright © 2015年 pku. All rights reserved.
//

import UIKit

enum LoginStatus: CustomStringConvertible {

    case login, register

    var description: String {
        switch self {
        case .login:
            return NSLocalizedString("Login", comment: "login")
        case .register:
            return NSLocalizedString("Register", comment: "register")
        }
    }

    var boolValue: Bool {
        switch self {
        case .login:
            return true
        case .register:
            return false
        }
    }
}

enum LoginErrorType: Error {
    case fieldEmpty(Int)
    case fieldInvalid(Int)
    case dataInconsistencyError
    case unknownError
}

prefix func ! (status: LoginStatus) -> LoginStatus {
    switch status {
    case .login:
        return .register
    case .register:
        return .login
    }
}

typealias TextFieldSetupTuple = (cellID: String,
                                placeholder: String,
                                content: String,
                                isSecure: Bool,
                                keyboardType: UIKeyboardType)

struct Login {

    fileprivate let cellIDs = ["Text", "Text"]

    fileprivate let placeholders = [
        NSLocalizedString("Please input your SID", comment: "user's SID"),
        NSLocalizedString("Default password is birthday", comment: "default password")
    ]

    fileprivate let contents = [
        LoginStatus.register: ["", ""],
        LoginStatus.login: [ContentManager.UserName, ContentManager.Password]
    ]

    fileprivate let isSecure = [
        false, true
    ]

    fileprivate let keyboardTypes = [
        UIKeyboardType.default, UIKeyboardType.default
    ]

    fileprivate let validators = [
        String.isStudentNo,
        String.isNonEmpty
    ]

    var count: Int {
        get {
            return cellIDs.count
        }
    }

    subscript(status: LoginStatus, indexPath: IndexPath) -> TextFieldSetupTuple {
        let row = (indexPath as NSIndexPath).row
        let cellID = cellIDs[row]
        let placeholder = placeholders[row]
        let content = contents[status]?[row] ?? ""
        let secure = isSecure[row]
        let keyboardType = keyboardTypes[row]
        return (cellID, placeholder, content, secure, keyboardType)
    }

    func validate(_ results: [String]) throws -> [String] {
        guard results.count == validators.count else { throw LoginErrorType.dataInconsistencyError }
        return try zip(results, validators).enumerated().map {
            (index: Int, tuple: (string: String, validator: (String) -> () -> Bool)) in
            let content = tuple.string
                               .trimmingCharacters(in: CharacterSet.whitespaces)
            if content.isEmpty {
                throw LoginErrorType.fieldEmpty(index)
            }
            if !tuple.validator(content)() {
                throw LoginErrorType.fieldInvalid(index)
            }
            return content
        }
    }
}
