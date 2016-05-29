//
//  NSDateFormatter.swift
//  FinancialAid
//
//  Created by PengZhao on 16/1/19.
//  Copyright © 2016年 pku. All rights reserved.
//

import Foundation

extension NSDateFormatter {

    class func outputFormatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.locale = NSCalendar.currentCalendar().locale
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }
    class func inputFormatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }
}
