//
//  CGFloat.swift
//  iBeaconToy
//
//  Created by PengZhao on 15/12/29.
//  Copyright © 2015年 pku. All rights reserved.
//

import UIKit

extension CGFloat {

    func format(formatter: String) -> String {
        return NSString(format: "%\(formatter)f", self) as String
    }

}
