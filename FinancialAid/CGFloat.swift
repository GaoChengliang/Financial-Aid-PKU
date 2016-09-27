//
//  CGFloat.swift
//  FinancialAid
//
//  Created by PengZhao on 15/12/29.
//  Copyright © 2015年 pku. All rights reserved.
//

import UIKit

extension CGFloat {

    func format(_ formatter: String) -> String {
        return NSString(format: "%\(formatter)f" as NSString, self) as String
    }

}
