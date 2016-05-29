//
//  LoginViewModel.swift
//  FinancialAid
//
//  Created by PengZhao on 15/12/28.
//  Copyright © 2015年 pku. All rights reserved.
//

import UIKit

enum LoginStatus: CustomStringConvertible, BooleanType {

    case Login, Register

    var description: String {
        switch self {
        case .Login:
            return NSLocalizedString("Login", comment: "login")
        case .Register:
            return NSLocalizedString("Register", comment: "register")
        }
    }

    var boolValue: Bool {
        switch self {
        case .Login:
            return true
        case .Register:
            return false
        }
    }
}

enum LoginErrorType: ErrorType {
    case FieldEmpty(Int)
    case FieldInvalid(Int)
    case DataInconsistencyError
    case UnknownError
}

prefix func ! (status: LoginStatus) -> LoginStatus {
    switch status {
    case .Login:
        return .Register
    case .Register:
        return .Login
    }
}

typealias TextFieldSetupTuple = (cellID: String,
                                placeholder: String,
                                content: String,
                                isSecure: Bool,
                                keyboardType: UIKeyboardType)

struct Login {

    private let cellIDs = ["Text", "Text"]

    private let placeholders = [
        NSLocalizedString("Please input your name", comment: "user's name"),
        NSLocalizedString("Please input your password", comment: "password")
    ]

    private let contents = [
        LoginStatus.Register: ["", ""],
        LoginStatus.Login: [ContentManager.UserName, ContentManager.Password]
    ]

    private let isSecure = [
        false, true
    ]

    private let keyboardTypes = [
        UIKeyboardType.Default, UIKeyboardType.Default
    ]

    private let validators = [
        String.isStudentNo,
        String.isNonEmpty
    ]

    var count: Int {
        get {
            return cellIDs.count
        }
    }

    subscript(status: LoginStatus, indexPath: NSIndexPath) -> TextFieldSetupTuple {
        let row = indexPath.row
        let cellID = cellIDs[row]
        let placeholder = placeholders[row]
        let content = contents[status]?[row] ?? ""
        let secure = isSecure[row]
        let keyboardType = keyboardTypes[row]
        return (cellID, placeholder, content, secure, keyboardType)
    }

    func validate(results: [String]) throws -> [String] {
        guard results.count == validators.count else { throw LoginErrorType.DataInconsistencyError }
        return try zip(results, validators).enumerate().map {
            (index: Int, tuple: (string: String, validator: String -> () -> Bool)) in
            let content = tuple.string
                               .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if content.isEmpty {
                throw LoginErrorType.FieldEmpty(index)
            }
            if !tuple.validator(content)() {
                throw LoginErrorType.FieldInvalid(index)
            }
            return content
        }
    }
}
