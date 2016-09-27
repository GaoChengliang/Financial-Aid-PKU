//
//  IDImage.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/6/4.
//  Copyright © 2016年 pku. All rights reserved.
//

import Foundation
import MJExtension

class IDImage: NSObject {

    var ID = ""
    var imageUrl = ""
    var thumbnailUrl = ""
}

extension IDImage {
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable: Any]! {
        return [
            "ID" : "id",
            "imageUrl" : "url",
            "thumbnailUrl" : "thumbnail",
        ]
    }
}
