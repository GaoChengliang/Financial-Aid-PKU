//
//  File.swift
//  FinancialAid
//
//  Created by PengZhao on 16/5/25.
//  Copyright © 2016年 pku. All rights reserved.
//

import Foundation

struct Form {
    var name: String
    var startDate: NSDate
    var endDate: NSDate

    init() {
        name = ""
        startDate = NSDate()
        endDate = NSDate()
    }

    init(name: String, startDate: NSDate, endDate: NSDate) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
    }
}
