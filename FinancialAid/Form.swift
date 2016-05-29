//
//  File.swift
//  FinancialAid
//
//  Created by PengZhao on 16/5/25.
//  Copyright © 2016年 pku. All rights reserved.
//

import Foundation
import MJExtension

class Form: NSObject {
    var ID: Int = 0
    var name = ""
    var active = false
    var isStepHelp = false
    var isStepFill = false
    var isStepPdf = false
    var isStepUpload = false
    var startDate = NSDate()
    var endDate = NSDate()
    var helpPath = ""
    var fillPath = ""
}

extension Form {
    override static func mj_replacedKeyFromPropertyName() -> [NSObject : AnyObject]! {
        return [
            "ID": "id",
            "name": "name",
            "active": "active",
            "isStepHelp": "is_step_help",
            "isStepFill": "is_step_fill",
            "isStepPdf": "is_step_pdf",
            "isStepUpload": "is_step_upload",
            "startDate": "start_at",
            "endDate": "end_at",
            "helpPath": "help_path",
            "fillPath": "fill_path"
        ]
    }

    override func mj_newValueFromOldValue(oldValue: AnyObject!, property: MJProperty!) -> AnyObject! {
        switch property.name {
        case "active":
            fallthrough
        case "isStepHelp":
            fallthrough
        case "isStepFill":
            fallthrough
        case "isStepPdf":
            fallthrough
        case "isStepUpload":
            return NSNumber(long: oldValue as? Int ?? 0).boolValue
        case "startDate":
            fallthrough
        case "endDate":
            let dateString = "\(oldValue)"
            let formatter = NSDateFormatter.inputFormatter()
            return formatter.dateFromString(dateString)
        case "helpPath":
            fallthrough
        case "fillPath":
            fallthrough
        case "ID":
            fallthrough
        case "name":
            fallthrough
        default:
            return oldValue
        }
    }
}

class FormList: NSObject {

    static var sharedInstance = FormList()

    var formList = [Form]()
    var count: Int {
        return formList.count
    }

    subscript(index: Int) -> Form {
        get {
            return formList[index]
        }
    }
}
