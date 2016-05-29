//
//  NSDateFormatter.swift
//  FinancialAid
//
//  Created by PengZhao on 16/1/19.
//  Copyright © 2016年 pku. All rights reserved.
//

import Foundation

extension NSDateFormatter {

    class func defaultFormatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.locale = NSCalendar.currentCalendar().locale
        formatter.dateFormat = "yyyy-MM-dd HH"
        return formatter
    }
}
