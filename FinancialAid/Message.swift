//
//  Message.swift
//  FinancialAid
//
//  Created by 高成良 on 16/9/30.
//  Copyright © 2016年 pku. All rights reserved.
//

import Foundation
import MJExtension

class Message: NSObject {
    var ID: Int = 0
    var title = ""
    var content = ""
    var createdTime = Date()
    var updatedTime = Date()
}

extension Message {
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable: Any]! {
        return [
            "ID" : "id",
            "title" : "title",
            "content" : "content",
            "createdTime" : "created_at",
            "updatedTime" : "updated_at",
        ]
    }
    
    override func mj_newValue(fromOldValue oldValue: Any!, property: MJProperty!) -> Any! {
        switch property.name {
        case "createdTime":
            fallthrough
        case "updatedTime":
            let timeString: String! = (oldValue as AnyObject).description
            let formatter = DateFormatter.inputFormatter()
            return formatter.date(from: timeString) as AnyObject!
        case "ID":
            fallthrough
        case "title":
            fallthrough
        case "content":
            fallthrough
        default:
            return oldValue
        }
    }

}


