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
        IndexPath(row: 0, section: 0): [
            "content": [
                User.sharedInstance.userName,
                User.sharedInstance.realName
            ],
            "key": "realname",
            "title": NSLocalizedString("User name", comment: "changing user name")
        ],
        IndexPath(row: 0, section: 1): [
            "content": [
                ({
                        switch User.sharedInstance.gender {
                        case "female":
                                return NSLocalizedString("Female", comment: "gender is female")
                        case "male":
                            return NSLocalizedString("Male", comment: "gender is male")
                        default:
                            return ""
                        }
                    }()
                )

            ],
            "key": "gender",
            "title": NSLocalizedString("Gender", comment: "giving gender info")
        ],
        IndexPath(row: 1, section: 1): [
            "content": [
                User.sharedInstance.birthday == "0000-00-00" ? "" : User.sharedInstance.birthday
            ],
            "key": "birthday",
            "title": NSLocalizedString("Birthday", comment: "giving birthday info")
        ],
        IndexPath(row: 2, section: 1): [
            "content": [
                User.sharedInstance.phone
            ],
            "key": "phone",
            "title": NSLocalizedString("Phone number", comment: "changing user's phone")
        ],
        IndexPath(row: 3, section: 1): [
            "content": [
                User.sharedInstance.email
            ],
            "key": "email",
            "title": NSLocalizedString("Email", comment: "changing user's email")
        ]
    ]

    func contents(_ indexPath: IndexPath) -> [String] {
        guard let dictionary = userCenter[indexPath] else { return [] }
        return (dictionary["content"] ?? []) as? [String] ?? []
    }

    func tuples(_ indexPath: IndexPath) -> (title: String, content: [String], key: String) {
        guard let dictionary = userCenter[indexPath] else { return ("", [], "") }
        return (
            dictionary["title"] as? String ?? "",
            dictionary["content"] as? [String] ?? [],
            dictionary["key"] as? String ?? ""
        )
    }
}
