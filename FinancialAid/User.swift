//
//  User.swift
//  FinancialAid
//
//  Created by PengZhao on 16/5/28.
//  Copyright © 2016年 pku. All rights reserved.
//

import Foundation
import MJExtension

class User: NSObject {

    static var sharedInstance = User()

    var ID = ""
    var userName = ""
    var realName = ""
    var gender = ""
    var birthday = ""
    var phone = ""
    var email = ""
}

extension User {
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable: Any]! {
        return [
            "realName" : "realname",
            "gender" : "gender",
            "phone" : "phone",
            "birthday" : "birthday",
            "email" : "email",
            "userName" : "username",
            "ID": "id"
        ]
    }
}
