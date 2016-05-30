//
//  String.swift
//  FinancialAid
//
//  Created by PengZhao on 15/12/29.
//  Copyright © 2015年 pku. All rights reserved.
//

import Foundation

extension String {

    func matchRegex(pattern: String) -> Bool {
        guard
            let searchResults = rangeOfString(pattern, options: .RegularExpressionSearch)
        else { return false }

        return searchResults.startIndex == startIndex && searchResults.count == characters.count
    }

    func isStudentNo() -> Bool {
        return matchRegex("\\d{10}")
    }

    func isEmail() -> Bool {
        return matchRegex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    }

    func isPhoneNumber() -> Bool {
        return matchRegex("\\d{11}")
    }

    func isNonEmpty() -> Bool {
        return !(self as NSString)
            .stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceCharacterSet()
            ).isEmpty
    }
}
