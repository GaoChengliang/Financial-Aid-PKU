//
//  UserCenter.swift
//  FinancialAid
//
//  Created by PengZhao on 16/5/30.
//  Copyright © 2016年 pku. All rights reserved.
//

import Foundation

class UserCenter: NSObject {

    let userCenter = [
        NSIndexPath(forRow: 0, inSection: 0): [
            "content": [
                User.sharedInstance.userName,
                User.sharedInstance.realName
            ],
            "key": "realname",
            "title": NSLocalizedString("User name", comment: "changing user name")
        ],
        NSIndexPath(forRow: 0, inSection: 1): [
            "content": [
                User.sharedInstance.gender == "unknown" ? "" : User.sharedInstance.gender
            ],
            "key": "gender",
            "title": NSLocalizedString("Gender", comment: "giving gender info")
        ],
        NSIndexPath(forRow: 1, inSection: 1): [
            "content": [
                User.sharedInstance.birthday == "0000-00-00" ? "" : User.sharedInstance.birthday
            ],
            "key": "birthday",
            "title": NSLocalizedString("Birthday", comment: "giving birthday info")
        ],
        NSIndexPath(forRow: 2, inSection: 1): [
            "content": [
                User.sharedInstance.phone
            ],
            "key": "phone",
            "title": NSLocalizedString("Phone number", comment: "changing user's phone")
        ],
        NSIndexPath(forRow: 3, inSection: 1): [
            "content": [
                User.sharedInstance.email
            ],
            "key": "email",
            "title": NSLocalizedString("Email", comment: "changing user's email")
        ]
    ]

    func contents(indexPath: NSIndexPath) -> [String] {
        guard let dictionary = userCenter[indexPath] else { return [] }
        return (dictionary["content"] ?? []) as? [String] ?? []
    }

    func tuples(indexPath: NSIndexPath) -> (title: String, content: [String], key: String) {
        guard let dictionary = userCenter[indexPath] else { return ("", [], "") }
        return (
            dictionary["title"] as? String ?? "",
            dictionary["content"] as? [String] ?? [],
            dictionary["key"] as? String ?? ""
        )
    }
}
