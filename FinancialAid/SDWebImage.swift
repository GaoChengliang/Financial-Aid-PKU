//
//  SDWebImage.swift
//  FinancialAid
//
//  Created by PengZhao on 16/1/19.
//  Copyright © 2016年 pku. All rights reserved.
//

import SDWebImage

extension SDWebImageManager {

    class func config() {
        SDWebImageManager
            .shared()
            .imageDownloader
            .setValue("", forHTTPHeaderField: "x-access-token")
    }
}
