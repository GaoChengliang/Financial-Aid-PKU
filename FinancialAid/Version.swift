//
//  Version.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/6/28.
//  Copyright © 2016年 pku. All rights reserved.
//

import Foundation
import MJExtension

class Version: NSObject {

    static var sharedInstance = Version()

    var currentVersion = 0
    var minVersion = 0
    var url = ""
}

extension Version {
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable: Any]! {
        return [
            "currentVersion" : "version",
            "minVersion" : "min",
            "url" : "url"
        ]
    }
}
