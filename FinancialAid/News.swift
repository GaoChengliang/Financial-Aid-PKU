//
//  News.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/6/29.
//  Copyright © 2016年 pku. All rights reserved.
//

import Foundation
import MJExtension

class News: NSObject {
    var id = 0
    var title = ""
    var url = ""
    var imageUrl = ""
    var type = 0
}

extension News {
    override static func mj_replacedKeyFromPropertyName() -> [NSObject : AnyObject]! {
        return [
            "id" : "id",
            "title" : "title",
            "url" : "url",
            "imageUrl" : "image",
            "type" : "type",
        ]
    }
}
