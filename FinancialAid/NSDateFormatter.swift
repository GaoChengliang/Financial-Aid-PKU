//
//  NSDateFormatter.swift
//  FinancialAid
//
//  Created by PengZhao on 16/1/19.
//  Copyright © 2016年 pku. All rights reserved.
//

import Foundation

extension DateFormatter {

    class func outputFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Calendar.current.locale
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    class func outputTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Calendar.current.locale
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    class func inputFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }
}
