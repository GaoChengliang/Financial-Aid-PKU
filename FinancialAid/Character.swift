//
//  Character.swift
//  FinancialAid
//
//  Created by PengZhao on 15/12/29.
//  Copyright © 2015年 pku. All rights reserved.
//

import Foundation

extension Character {

    func unicodeScalarCodePoint() -> UInt32 {
        let scalars = String(self).unicodeScalars
        return UInt32(scalars[scalars.startIndex].value)
    }
}
