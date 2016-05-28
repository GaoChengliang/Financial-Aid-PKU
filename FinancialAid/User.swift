//
//  User.swift
//  FinancialAid
//
//  Created by PengZhao on 16/5/28.
//  Copyright © 2016年 pku. All rights reserved.
//

import Foundation

class User {
    static let sharedInstance = User()

    var userName = ""
    var password = ""
    var realname = ""
    var gender = ""
    var birthday = ""
    var phone = ""
    var email = ""
}
