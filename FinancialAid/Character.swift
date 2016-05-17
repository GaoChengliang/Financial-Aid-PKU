//
//  Character.swift
//  iBeaconToy
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

    func isEmoji() -> Bool {
        if Character(UnicodeScalar(0x1d000)) <= self &&
           Character(UnicodeScalar(0x1f77f)) >= self {
            return true
        }
        if Character(UnicodeScalar(0x2100)) <= self &&
           Character(UnicodeScalar(0x26ff)) >= self {
            return true
        }
        return false
    }

}
